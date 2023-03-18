
#' S3 support
#' @param x array-like entity
#' @param do.NULL logical
#' @param prefix character
#' @export
rownames = function(x, do.NULL = TRUE, prefix="row") UseMethod("rownames")

#' S3 support
#' @param \dots any args
#' @export
rownames.default = function(...) base::rownames(...)

#' acquire row names of a Hail Table
#' @return character()
#' @note writes one line of table to disk to retrieve field names
#' @param x instance of hail.table.Table
#' @param \dots not used
#' @examples
#' hl = hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute=TRUE)$key_by("Sample")
#' rownames(tab)
#' @export
rownames.hail.table.Table = function(x, ...) {
 kk = get_key(x)
 x$key$get(kk[[1]])$collect()
}
