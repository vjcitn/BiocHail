#' S3 support
#' @param x entity coercible to data.frame
#' @param row.names character or NULL
#' @param optional logical
#' @param \dots any args
#' @return data.frame
#' @examples
#' hl <- hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute = TRUE)$key_by("Sample")
#' as.data.frame(tab$head(3L))
#' @export
as.data.frame <- function(x, row.names = NULL, optional = FALSE, ...) UseMethod("as.data.frame")


#' S3 support
#' @param x entity coercible to data.frame
#' @param row.names character or NULL
#' @param optional logical
#' @param \dots any args
#' @return data.frame
#' @examples
#' hl <- hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute = TRUE)$key_by("Sample")
#' as.data.frame(tab$head(3L))
#' @method as.data.frame default
as.data.frame.default <- base::as.data.frame

mkrow <- function(str, cn) lapply(cn, function(x) str$get(x))

methods::setOldClass("hail.table.Table")


#' convert hail.table.Table to R data frame
#' @note only use on small table because collect is used
#' @param x instance of "hail.table.Table"
#' @param row.names not used
#' @param optional not used
#' @param \dots not used
#' @return data.frame
#' @examples
#' hl <- hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute = TRUE)$key_by("Sample")
#' as.data.frame(tab$head(3L))
#' @export
as.data.frame.hail.table.Table <- function(x, row.names = NULL, optional = FALSE, ...) {
  cx <- x$collect()
  cn <- colnames(x)
  tmpl <- lapply(cx, function(z) {
    tmp <- data.frame(mkrow(z, cn))
    names(tmp) <- paste0("x", seq_len(ncol(tmp)))
    tmp
  })
  tmpdf <- do.call(rbind, tmpl)
  names(tmpdf) <- cn
  tmpdf
}
