
#' S3 support
#' @export
rownames = function(x, do.NULL = TRUE, prefix="row") UseMethod("rownames")

#' S3 support
#' @export
rownames.default = function(...) base::rownames(...)

#' acquire row names of a Hail Table
#' @return character()
#' @note writes one line of table to disk to retrieve field names
#' @param x instance of hail.table.Table
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
