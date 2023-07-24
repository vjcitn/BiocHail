methods::setOldClass("hail.table.Table")

#' extract field names from hail.table.Table
#' @importFrom BiocGenerics colnames as.data.frame
#' @param x hail.table.Table instance
#' @param do.NULL ignored
#' @param prefix ignored
#' @return character vector
#' @examples
#' hl <- hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute = TRUE)$key_by("Sample")
#' colnames(tab)
#' @export
setMethod(
  "colnames", "hail.table.Table",
  function(x, do.NULL = TRUE, prefix = "col") {
    tf <- tempfile()
    on.exit(unlink(tf))
    zz <- reticulate::py_capture_output(x$head(1L)$export(tf)) # unpleasant, trying to find a better way
    names(read.delim(tf))
  }
)

#' S3 generic for get_key
#' @param x anything
#' @return typically a list
#' @examples
#' hl <- hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute = TRUE)$key_by("Sample")
#' get_key(tab)
#' @export
get_key <- function(x) UseMethod("get_key")

#' S3 method for get_key
#' @param x instance of hail.table.Table
#' @return a list with elements names (names of keys) and key_df (data.frame of key values, with column names)
#' @examples
#' hl <- hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute = TRUE)$key_by("Sample")
#' get_key(tab)
#' @export
get_key.hail.table.Table <- function(x) {
  tf <- paste0(tempfile(), ".csv")
  zz <- reticulate::py_capture_output(x$key$export(tf))
  ans <- read.csv(tf)
  list(names = names(ans), key_df = ans)
}
