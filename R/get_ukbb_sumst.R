#' Open Storage Network path to a zip of hail MatrixTable with a small subset of UKBB summary statistics as of 12/25/2022
#' @return character(1) path to zip
#' @examples
#' osn_ukbb_sumst10k_path()
#' @export
osn_ukbb_sumst10k_path <- function() "https://bir190004-bucket01.mghp.osn.xsede.org/BiocUKBBData/ukbb_sumst_10kloc.zip"

#' interface to a small subset of UKBB summary stats in MatrixTable format
#' @import utils
#' @import BiocFileCache
#' @param hl hail object
#' @param folder character(1) destination of 1kg.mt as retrieved using hl.utils.get_1kg, import_vcf, write
#' @param cache a BiocFileCache-type cache
#' @param timeout.ukbb numeric(1) defaults to 3600 for timeout setting in `options()`; option value is reset on exit
#' @return "hail.matrixtable.MatrixTable" instance
#' @note The loci were selected using a .000345% random sample
#' of over 28 million loci recorded in the UKBB pan-ancestry
#' record.  The sample is made available a) to assess some issues with data volume (the full
#' resource is about 12.78 TB according to [this doc](https://pan-dev.ukbb.broadinstitute.org/docs/hail-format/index.html), and b) to provide full information on the scope of phenotypes and populations available.
#' @note This function will unzip 5GB of MatrixTable data.  It may be desirable to cache the
#' unzipped image to a persistent location.  If this has been done and the environment variable
#' `HAIL_UKBB_SUMSTAT_10K_PATH` has been set to this location, this function will use
#' the MatrixTable content found there.
#' @examples
#' hl <- hail_init()
#' ss <- get_ukbb_sumstat_10kloci_mt(hl)
#' # consider saving the unzipped image and recaching
#' ss$count()
#' @export
get_ukbb_sumstat_10kloci_mt <- function(hl, folder = tempdir(), cache = BiocFileCache::BiocFileCache(), timeout.ukbb = 3600) {
  proc <- basilisk::basiliskStart(bsklenv, testload = "hail") # avoid package-specific import
  on.exit(basilisk::basiliskStop(proc))
  basilisk::basiliskRun(proc, function(hl, folder) {
    #
    # check for local archive and use it if available
    #
    lklocal <- Sys.getenv("HAIL_UKBB_SUMSTAT_10K_PATH")
    if (nchar(lklocal) > 0) {
      stopifnot(basename(lklocal)=="ukbb_sumstat_10k_loci.mt") # the cached zip must have been uncached here
      #
      # prepare for long download
      #
      return(hl$read_matrix_table(lklocal))
    }
    ot <- options()$timeout
    on.exit(options(timeout = ot))
    options(timeout = timeout.ukbb)
    #
    # check cache for zip, populate if not present
    #
    qout <- bfcquery(cache, "ukbb_sumst_10kloc.zip")
    if (nrow(qout) == 0) { # download and populate cache
      dl <- try(bfcadd(cache,
        fpath = osn_ukbb_sumst10k_path(),
        rname = "ukbb_sumst_10kloc.zip", rtype = "web", action = "copy",
        download = TRUE
      ))
      if (inherits(dl, "try-error")) stop("no ukbb_sumst in cache and cannot populate with download, try another method.")
      qout <- bfcquery(cache, "ukbb_sumst_10kloc.zip")
      stopifnot(nrow(qout) == 1L)
    }
    #
    # unzip to folder
    #
    utils::unzip(cache[[qout$rid]], exdir = folder)
    mt <- hl$read_matrix_table(paste0(folder, "/ukbb_sumstat_10k_loci.mt"))
    mt
  }, hl = hl, folder = folder)
}
