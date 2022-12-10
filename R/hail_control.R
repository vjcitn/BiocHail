#' initialize hail
#' @note hail object may be passed around
#' @examples
#' hc <- hail_init()
#' hc
#' @export
hail_init = function() {
 proc = basilisk::basiliskStart(bsklenv, testload="hail") # avoid package-specific import
 #on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function() {
     hl = reticulate::import("hail") 
     lk = try(hl$init(idempotent=TRUE))
     if (inherits(lk, "try-error")) {
        message("could not initialize ... already initialized?")
        }
     hl
   })
}

#' stop hail
#' @param a hail object produced by hail_init()
#' @export
hail_stop = function(hl) hl$stop()
