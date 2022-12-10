#' interface to 1kg import
#' @param hl hail object 
#' @param retrieve_web logical(1) if TRUE, use hl.utils.get_1kg to retrieve data, otherwise use installed zip
#' @param folder character(1) destination of 1kg.mt as retrieved using hl.utils.get_1kg, import_vcf, write
#' @note overwrite is permitted in the import_vcf.write event
#' @return "hail.matrixtable.MatrixTable" instance
#' @examples
#' hl <- hail_init()
#' mt <- get_1kg(hl)
#' mt
#' mt$rows()$select()$show(5L) # must use integer
#' annopath = path_1kg_annotations()
#' tab = hl$import_table(annopath, impute=TRUE)$key_by("Sample")
#' tab$describe()
#' tab$show(width=100L)
#' @export
get_1kg = function(hl, retrieve_web=FALSE, folder=tempdir()) {
 proc = basilisk::basiliskStart(bsklenv, testload="hail") # avoid package-specific import
 on.exit(basilisk::basiliskStop(proc))
 basilisk::basiliskRun(proc, function(hl, folder) {
     if (retrieve_web) {
       hl$utils$get_1kg(folder)
       hl$import_vcf(paste0(folder, '/1kg.vcf.bgz'))$write(paste0(folder, '/1kg.mt'), overwrite=TRUE)
       }
     else {
       zf = system.file("extdata/1kg.zip", package="BiocHail")
       unzip(zf, exdir=folder)
       }
     mt = hl$read_matrix_table(paste0(folder, '/1kg.mt'))
     mt
   }, hl=hl, folder=folder)
}

#' generate path to installed annotations file
#' @export
path_1kg_annotations = function() {
  system.file("extdata/1kg_annotations.txt", package="BiocHail")
}
