#' S3 support
#' @export
colnames = function(x, do.NULL = TRUE, prefix="col") UseMethod("colnames")

#' S3 support
#' @export
colnames.default = function(...) base::colnames(...)

#' acquire column names of a Hail Table
#' @return character()
#' @note writes one line of table to disk to retrieve field names
#' @param x instance of hail.table.Table
#' @examples
#' hl = hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute=TRUE)$key_by("Sample")
#' colnames(tab)
#' @export
colnames.hail.table.Table = function(x, ...) {
 tf = tempfile()
 on.exit(unlink(tf))
 zz = reticulate::py_capture_output(x$head(1L)$export(tf))
 names(read.delim(tf))
}

#' S3 generic for get_key
#' @param x anything
#' @export
get_key = function(x) UseMethod("get_key")

#' S3 method for get_key
#' @param x instance of hail.table.Table
#' @return a list with elements names (names of keys) and key_df (data.frame of key values, with column names)
#' @export
get_key.hail.table.Table = function(x) {
 tf = paste0(tempfile(), ".csv")
 zz = reticulate::py_capture_output(x$key$export(tf))
 ans = read.csv(tf)
 list(names=names(ans), key_df=ans)
}
