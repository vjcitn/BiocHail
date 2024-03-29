% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/hail_control.R
\name{bare_hail}
\alias{bare_hail}
\title{bare interface to hail using reticulate}
\usage{
bare_hail()
}
\value{
python reference to hail module
}
\description{
bare interface to hail using reticulate
}
\note{
`/home/jupyter/.local/share/r-miniconda/envs/r-reticulate/bin/pip3 install...` is 
used to ensure that reticulate's python ecosystem is what we want

`bare_hail()$init(idempotent=TRUE)` should be run
}
\examples{
# assumes terra
if (nchar(Sys.getenv("WORKSPACE_NAMESPACE"))>0) {
  hl = bare_hail()
  hl$init(idempotent=TRUE, spark_conf=list(
      'spark.hadoop.fs.gs.requester.pays.mode'= 'CUSTOM',
      'spark.hadoop.fs.gs.requester.pays.buckets'= 'ukb-diverse-pops-public',
      'spark.hadoop.fs.gs.requester.pays.project.id'= Sys.getenv("GOOGLE_PROJECT")))
  hl$read_matrix_table('gs://ukb-diverse-pops-public/sumstats_release/results_full.mt')$describe()
  \dontrun{
  # this is supposed to get us some LD data but xx.shape fails, issue filed
    hli = reticulate::import("hail.linalg")
    upa = reticulate::import("ukbb_pan_ancestry")
    xx = hli$BlockMatrix$read(upa$get_ld_matrix_path('AFR'))
   }
  }
}
