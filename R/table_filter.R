#' S3 support
#' @export
filter = function (x, filter, method = c("convolution", "recursive"), 
    sides = 2L, circular = FALSE, init = NULL, ..., hl = NULL, 
    placeholder = NULL, drop_placeholder = NULL) UseMethod("filter")

#' S3 support
#' @export
filter.default = function(...) stats::filter(...)

#' acquire column names of a Hail Table
#' @return character()
#' @note writes one line of table to disk to retrieve field names
#' @param x instance of hail.table.Table
#' @param filter an entity that is already a component of the table `x`
#' @param hl instance of Hail module, should have idempotent attribute set
#' that is an instance of `hail.expr.expressions.typed_expressions.BooleanExpression`
#' that evaluates to bool, or a logical vector that has length equal to `x$count()`
#' @param placeholder character(1) defaults to "tmpf"
#' @param drop_placeholder logical(1), defaults to FALSE; if TRUE will try to
#' drop field used as placeholder
#' @note Will use field name given by `placeholder` to join filter if filter is a logical R vector
#' FIXME: uses disk because I don't know how to create a BooleanExpression except by importing.
#' @examples
#' hl = hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute=TRUE)$key_by("Sample")
#' pick = rep(FALSE, 3500)
#' pick[1:10] = TRUE
#' ft = filter(tab, pick)
#' ft$count()
#' ft$head(2L)$collect()
#' @export
filter.hail.table.Table = function(x, filter, hl = hail_init(), 
  placeholder="tmpf", drop_placeholder=FALSE, ...) {
 if (!inherits(filter, "hail.expr.expressions.typed_expressions.BooleanExpression")) {
# must build such
   stopifnot(is(filter, "logical"))
   nrec = x$count()
   if ((nf <- length(filter)) != nrec) stop(sprintf("filter must have length %d; got %d.\n",
                 nrec, nf))
   kk = get_key(x)
   tmp = data.frame(k=kk[[2]], filter)
   names(tmp) = c(kk[[1]], placeholder)  # get key name from table
   tf = paste0(tempfile(), ".csv")
   write.csv(tmp, tf, row.names=FALSE, quote=FALSE)
   tlist = list(hl$tstr, hl$tbool)
   names(tlist) = c(kk[[1]], placeholder)
   y = hl$import_table(tf, types=tlist, delimiter=",")
   x = x$join(y$key_by(kk[[1]]))
   filter = x$tmpf
   }
 fil = x$filter(filter)
 if (drop_placeholder) fil = fil$drop(placeholder)
 fil
}

