#' update the reference genome for a hail instance
#' @param hc hail context
#' @param init character(1) valid name for a reference genome, defaults to "GRCh38"
#' @param newjson character(1) path to a json spec of a reference genome [needs doc]
#' @return a python list; the function is used for its side effect
#' @export
rg_update = function(hc, init="GRCh38", newjson=system.file("json/t2tAnVIL.json", package="BiocHail")) {
   rg = hc$get_reference(init)
   rg$read(newjson)
}
