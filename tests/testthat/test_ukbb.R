library(BiocHail)

test_that("basic matrix_table operations succeed", {
hl <- hail_init()
litzip <- system.file("extdata", "myss2.zip", package = "BiocHail")
td <- tempdir()
unzip(litzip, exdir = td)
ntab <- hl$read_matrix_table(paste0(td, "/myss2.mt"))
ntab$describe()
nt2 <- ntab$col$collect()
df1 = multipop_df(nt2[[1]]) # must select one element
expect_true(all(dim(df1)==c(6L,10L)))
expect_true(length(nt2)==7271L)
})

# code below here works but involves a huge zip file

#
#test_that("ukbb code succeeds", {
### ----setup,message=FALSE------------------------------------------------------
#library(BiocHail)
#
#
### ----getukbb------------------------------------------------------------------
#hl = hail_init()
#ss = get_ukbb_sumstat_10kloci_mt(hl) # can take about a minute to unzip 5GB
#ss$count()   # but if a persistent MatrixTable is at the location given
#             # by env var HAIL_UKBB_SUMSTAT_10K_PATH it goes quickly
#
#
### ----lkdesc-------------------------------------------------------------------
#ss$describe()
#expect_true(all.equal(unlist(ss$count()), c(9888,7271)))
#})
#
#
### ----lkba, eval=FALSE---------------------------------------------------------
### hl = bare_hail()
### hl$init(idempotent=TRUE, spark_conf=list(
###   'spark.hadoop.fs.gs.requester.pays.mode'= 'CUSTOM',
###   'spark.hadoop.fs.gs.requester.pays.buckets'= 'ukb-diverse-pops-public',
###   'spark.hadoop.fs.gs.requester.pays.project.id'= Sys.getenv("GOOGLE_PROJECT")))
#
#
### ----lkss---------------------------------------------------------------------
##sscol = ss$cols()$collect() # OK because we are just working over column metadata
##ss1 = sscol[[1]]
##names(ss1)
##ss1$get("phenocode")
##ss1$get("description")
##
##
#### ----lkmul--------------------------------------------------------------------
##multipop_df(ss1)
##
##
#### ----dodt, message=FALSE------------------------------------------------------
###library(DT)
###ndf = do.call(rbind, lapply(sscol[1:10], multipop_df))
###datatable(ndf)
###
###
##### ----dotrim-------------------------------------------------------------------
###sss = ss$sample_rows(.01)$sample_cols(.01)
###sss$count()
###
###
##### ----getrm--------------------------------------------------------------------
###rss = sss$rows()$collect()
###rss1 = rss[[1]]
###names(rss1)
###names(rss1$locus)
###rss1$locus$contig
###sapply(c("contig", "position"), function(x) rss1$locus[[x]])
###
###
##### ----getent-------------------------------------------------------------------
###sse = sss$entries()$collect()
###length(sse)
###names(sse[[1]])
###sse1 = sse[[1]]
###
###
##### ----lkss11-------------------------------------------------------------------
###length(sse1$summary_stats)
###names(sse1$summary_stats[[1]])
###expect_true(abs(sse1$summary_stats[[1]]$Pvalue +.3402)<.001)
