#' initialize ukbb
#' @import basilisk
#' @note ukbb module may be passed around
#' @return python module reference
#' @examples
#' ukbb <- ukbb_init()
#' names(ukbb)
#' @export
ukbb_init <- function() {
  proc <- basilisk::basiliskStart(bsklenv, testload = "hail") # avoid package-specific import
  # on.exit(basilisk::basiliskStop(proc))
  basilisk::basiliskRun(proc, function() {
    ukbb <- reticulate::import("ukbb_pan_ancestry")
    ukbb
  })
}
