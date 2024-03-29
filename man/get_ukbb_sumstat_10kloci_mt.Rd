% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/get_ukbb_sumst.R
\name{get_ukbb_sumstat_10kloci_mt}
\alias{get_ukbb_sumstat_10kloci_mt}
\title{interface to a small subset of UKBB summary stats in MatrixTable format}
\usage{
get_ukbb_sumstat_10kloci_mt(
  hl,
  folder = tempdir(),
  cache = BiocFileCache::BiocFileCache(),
  timeout.ukbb = 3600,
  simple = FALSE
)
}
\arguments{
\item{hl}{hail object}

\item{folder}{character(1) destination of 1kg.mt as retrieved using hl.utils.get_1kg, import_vcf, write}

\item{cache}{a BiocFileCache-type cache}

\item{timeout.ukbb}{numeric(1) defaults to 3600 for timeout setting in `options()`; option value is reset on exit}

\item{simple}{logical(1) avoids basilisk if TRUE}
}
\value{
"hail.matrixtable.MatrixTable" instance
}
\description{
interface to a small subset of UKBB summary stats in MatrixTable format
}
\note{
The loci were selected using a .000345% random sample
of over 28 million loci recorded in the UKBB pan-ancestry
record.  The sample is made available a) to assess some issues with data volume (the full
resource is about 12.78 TB according to [this doc](https://pan-dev.ukbb.broadinstitute.org/docs/hail-format/index.html), and b) to provide full information on the scope of phenotypes and populations available.

This function will unzip 5GB of MatrixTable data.  It may be desirable to cache the
unzipped image to a persistent location.  If this has been done and the environment variable
`HAIL_UKBB_SUMSTAT_10K_PATH` has been set to this location, this function will use
the MatrixTable content found there.
}
\examples{
hl <- hail_init()
ss <- get_ukbb_sumstat_10kloci_mt(hl)
# consider saving the unzipped image and recaching
ss$count()
}
