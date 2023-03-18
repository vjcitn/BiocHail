
#> dplyr::filter
#function (.data, ..., .by = NULL, .preserve = FALSE) 
#{
#    check_by_typo(...)
#    by <- enquo(.by)
#    if (!quo_is_null(by) && !is_false(.preserve)) {
#        abort("Can't supply both `.by` and `.preserve`.")
#    }
#    UseMethod("filter")
#}

#' s3 support
#' @param .data instance of hail.table.Table
#' @param \dots should include named components `filter` which is a logical vector
#' with same number of rows as `.data`, `hl`, a reference to a hail environment (Module),
#' and `placeholder` an arbitrary character(1)
#' @param .by not used
#' @param .preserve not used
#' @examples
#' hl = hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute=TRUE)$key_by("Sample")
#' pick = rep(FALSE, 3500)
#' pick[1:10] = TRUE
#' ft = filter(tab, filter=pick, hl=hl)
#' ft$count()
#' ft$head(2L)$collect()
#' @export
filter = function(.data, ..., .by=NULL, .preserve=FALSE) UseMethod("filter")


#' filter rows of a hail Table
#' @importFrom dplyr filter
#' @importFrom methods is
#' @return character()
#' @note writes one line of table to disk to retrieve field names
#' @param .data instance of hail.table.Table
#' @param \dots should include named components `filter` which is a logical vector
#' with same number of rows as `.data`, `hl`, a reference to a hail environment (Module),
#' and `placeholder` an arbitrary character(1)
#' @param .by not used
#' @param .preserve not used
#' @note FIXME: uses disk because I don't know how to create a BooleanExpression except by importing.
#' @examples
#' hl = hail_init()
#' annopath <- path_1kg_annotations()
#' tab <- hl$import_table(annopath, impute=TRUE)$key_by("Sample")
#' pick = rep(FALSE, 3500)
#' pick[1:10] = TRUE
#' ft = filter(tab, filter=pick, hl=hl)
#' ft$count()
#' ft$head(2L)$collect()
#' @export
filter.hail.table.Table = function(.data, ..., .by = NULL, .preserve = FALSE) {
   input = list(...)
   nms = names(input)
   stopifnot(all(c("filter", "hl") %in% nms))
   hl = input$hl
   filter = input$filter
   placeholder = "tmpf"
   if (!is.null(input$placeholder)) placeholder = input$placeholder
   x = .data
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
 fil
}

