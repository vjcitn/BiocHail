#' acquire row names of a Hail Table, assuming key has been set
#' @importFrom BiocGenerics rownames
#' @return character()
#' @param x instance of hail.table.Table
#' @param do.NULL not used
#' @param prefix not used
#' @note To try example, run `example("rownames,hail.table.Table-method")`
#' @return character vector
#' @examples
#' hl <- hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute = TRUE)$key_by("Sample")
#' rt <- rownames(tab)
#' length(rt)
#' head(rt)
#' @export
setMethod(
  "rownames", "hail.table.Table",
  function(x, do.NULL = TRUE, prefix = "row") {
    kk <- get_key(x)
    x$key$get(kk[[1]])$collect()
  }
)
