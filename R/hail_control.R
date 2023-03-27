#' initialize hail
#' @import basilisk
#' @note hail object may be passed around
#' @return python reference to hail module
#' @examples
#' hc <- hail_init_simple()
#' hc
#' @export
hail_init_simple = function() {
 proc = basilisk::basiliskStart(bsklenv, testload="hail") # avoid package-specific import
 #on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function() {
     hl = reticulate::import("hail") 
     lk = try(hl$init(idempotent=TRUE))
     if (inherits(lk, "try-error")) {
        message("could not initialize ... already initialized?")
        }
     if (length(names(hl))==0) stop("invalid hail module, you may need to reboot...")
     hl
   })
}

#' stop hail
#' @param hl a hail object produced by hail_init()
#' @return result of stop() method for Hail module
#' @examples
#' hail_stop
#' @export
hail_stop = function(hl) hl$stop()

#init(sc=None, app_name=None, master=None, local='local[*]', log=None, quiet=False, append=False, min_block_size=0, branching_factor=50, tmp_dir=None, default_reference='GRCh37', idempotent=False, global_seed=None, spark_conf=None, skip_logging_configuration=False, local_tmpdir=None, _optimizer_iterations=None, *, backend=None, driver_cores=None, driver_memory=None, worker_cores=None, worker_memory=None, gcs_requester_pays_configuration: Union[str, Tuple[str, List[str]], NoneType] = None)

#    >>> hl.init(
#    ...     gcs_requester_pays_configuration=('my-project', ['bucket_of_fish', 'bucket_of_eels'])
#    ... )  # doctest: +SKIP
    



#' initialize hail, using more options
#' @param quiet logical(1) defaults to FALSE
#' @param min_block_size integer(1) defaults to 0L 
#' @param branching_factor integer(1) defaults to 50L
#' @param default_reference character(1) defaults to "GRCh37", for compatibility with earlier `hail_init`
#' @param global_seed integer(1) defaults to 1234L 
#' @param log character(1) target folder for logging, defaults to tempfile()
#' @param spark_conf list, defaults to NULL
#' @param gcs_requester_pays_configuration list, defaults to NULL
#' @note hail object may be passed around.  See hail documentation for details on all args.
#' @return python reference to hail module
#' @examples
#' proj = Sys.getenv("GOOGLE_PROJECT")
#' buck = Sys.getenv("GCS_BUCKET")
#' if (nchar(buck)>0) {
#'   # conf = list(proj, c(buck)) doesn't seem to generate tuple[str,Sequence[str]]
#'   hl <- hail_init()   #gcs_requester_pays_configuration=conf)
#'   hl$default_reference()
#' }  
#' @export
hail_init = function(quiet=FALSE, min_block_size=0L, branching_factor=50L,
   default_reference="GRCh37", global_seed=1234L, log = tempfile(), spark_conf=NULL,
   gcs_requester_pays_configuration = NULL) {
 proc = basilisk::basiliskStart(bsklenv, testload="hail") # avoid package-specific import
 #on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function(quiet, min_block_size, branching_factor,
		default_reference, global_seed, log, spark_conf, gcs_requester_pays_configuration) {
     hl = reticulate::import("hail") 
     lk = try(hl$init(idempotent=TRUE, quiet=quiet, min_block_size=min_block_size,
               branching_factor=branching_factor, default_reference=default_reference,
               global_seed=global_seed, log=log, gcs_requester_pays_configuration=
                  gcs_requester_pays_configuration))
     if (inherits(lk, "try-error")) {
        message("could not initialize ... already initialized?")
        }
     hl
   }, quiet=quiet, min_block_size=min_block_size, branching_factor=branching_factor,
        default_reference=default_reference, global_seed=global_seed, log=log,
         spark_conf=spark_conf, gcs_requester_pays_configuration=
         gcs_requester_pays_configuration  )
}

#' bare interface to hail using reticulate
#' @importFrom reticulate import
#' @note `/home/jupyter/.local/share/r-miniconda/envs/r-reticulate/bin/pip3 install...` is 
#' used to ensure that reticulate's python ecosystem is what we want
#' @return python reference to hail module
#' @examples
#' # assumes terra
#' if (nchar(Sys.getenv("WORKSPACE_NAMESPACE"))>0) {
#'   hl = bare_hail()
#'   hl$init(idempotent=TRUE, spark_conf=list(
#'       'spark.hadoop.fs.gs.requester.pays.mode'= 'CUSTOM',
#'       'spark.hadoop.fs.gs.requester.pays.buckets'= 'ukb-diverse-pops-public',
#'       'spark.hadoop.fs.gs.requester.pays.project.id'= Sys.getenv("GOOGLE_PROJECT")))
#'   hl$read_matrix_table('gs://ukb-diverse-pops-public/sumstats_release/results_full.mt')$describe()
#'   \dontrun{
#'   # this is supposed to get us some LD data but xx.shape fails, issue filed
#'     hli = reticulate::import("hail.linalg")
#'     upa = reticulate::import("ukbb_pan_ancestry")
#'     xx = hli$BlockMatrix$read(upa$get_ld_matrix_path('AFR'))
#'    }
#'   }
#' @export
bare_hail = function() {
  reticulate::import("hail")
}
