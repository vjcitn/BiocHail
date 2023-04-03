#' Open Storage Network path to a zip of hail MatrixTable with some 1kg data for the Hail.is GWAS tutorial
#' @return character(1) URL to zip
#' @examples
#' osn_1kg_path()
#' @export
osn_1kg_path = function() "https://bir190004-bucket01.mghp.osn.xsede.org/BiocHailData/1kg.zip"

#' interface to 1kg import
#' @import utils
#' @import BiocFileCache
#' @param hl hail object 
#' @param retrieve_import_write logical(1) if TRUE, use hl.utils.get_1kg to retrieve data, otherwise acquire
#' a previously written zip file, either from a cache, or, if no file found in cache, from web, followed by caching
#' @param path_1kg_zip character(1) path to zip of MatrixTable, defaults to `osn_1kg_path()`.
#' @param folder character(1) destination of 1kg.mt as retrieved using hl.utils.get_1kg, import_vcf, write
#' @param cache a BiocFileCache-type cache
#' @note overwrite is permitted in the import_vcf.write event
#' @return "hail.matrixtable.MatrixTable" instance
#' @examples
#' hl <- hail_init()
#' mt <- get_1kg(hl)
#' mt
#' mt$rows()$select()$show(5L) # must use integer
#' annopath = path_1kg_annotations()
#' tab = hl$import_table(annopath, impute=TRUE)$key_by("Sample")
#' tab$describe()
#' tab$show(width=100L)
#' @export
get_1kg = function(hl, retrieve_import_write=FALSE, path_1kg_zip=osn_1kg_path(), folder=tempdir(), cache=BiocFileCache::BiocFileCache()) {
 proc = basilisk::basiliskStart(bsklenv, testload="hail") # avoid package-specific import
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function(hl, folder) {
     if (retrieve_import_write) {
       hl$utils$get_1kg(folder)
       hl$import_vcf(paste0(folder, '/1kg.vcf.bgz'))$write(paste0(folder, '/1kg.mt'), overwrite=TRUE)
       }
     else {
#       zf = system.file("extdata/1kg.zip", package="BiocHail")
       qout = bfcquery(cache, "hail_tut_mt_zip")
       if (nrow(qout)==0) {  # download and populate cache
          dl = try(bfcadd(cache, fpath=path_1kg_zip,
                    rname="hail_tut_mt_zip", rtype="web", action="copy",
                    download=TRUE))
          if (inherits(dl, "try-error")) stop("no hail_tut_mt in cache and cannot populate with download, try another method.")
          qout = bfcquery(cache, "hail_tut_mt")
          stopifnot(nrow(qout)==1L)
          }
       utils::unzip(cache[[qout$rid]], exdir=folder)
       }
     mt = hl$read_matrix_table(paste0(folder, '/1kg.mt'))
     mt
   }, hl=hl, folder=folder)
}

#' generate path to installed annotations file
#' @note .txt file retrieved from extraction on `https://storage.googleapis.com/hail-1kg/tutorial_data.tar`
#' @return character(1) path to annotations
#' @examples
#' path_1kg_annotations()
#' @export
path_1kg_annotations = function() {
  system.file("extdata/1kg_annotations.txt", package="BiocHail")
}
