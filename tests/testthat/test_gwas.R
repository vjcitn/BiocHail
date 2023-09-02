# this test script introduced when vignette processing of
# these computations started to fail with too close to stack limit
# the computations work, just not in the context of vignette rendering as of 21 Aug 2023

test_that("gwas can be conducted", {

## ----getlib,message=FALSE-----------------------------------------------------
library(BiocHail)
library(ggplot2)


## ----get1, eval=TRUE----------------------------------------------------------
hl <- hail_init()
mt <- get_1kg(hl)
mt
print(mt$rows()$select()$show(5L)) # limited info


## r.mt.rows().select().show(5) # python chunk!


## r.mt.s.show(5)  # python chunk!


## ----getdim, eval=TRUE--------------------------------------------------------
mt$count()


## ----dodim, eval=TRUE---------------------------------------------------------
dim.hail.matrixtable.MatrixTable <- function(x) { 
  tmp <- x$count()
  c(tmp[[1]], tmp[[2]]) 
}
dim(mt)
ncol.hail.matrixtable.MatrixTable <- function(x) { 
 dim(x)[2]
}
nrow.hail.matrixtable.MatrixTable <- function(x) { 
 dim(x)[1]
}
nrow(mt)


## ----domo, eval=TRUE----------------------------------------------------------
annopath <- path_1kg_annotations()
tab <- hl$import_table(annopath, impute=TRUE)$key_by("Sample")

tab$describe()
tab$show(width=100L)

mt2 = mt$annotate_cols(pheno = tab[mt$s])
mt = mt2

mt$col$describe()

## r.mt = r.mt.annotate_cols(pheno = r.tab[r.mt.s])   # python chunk!

## r.mt.col.describe()


## ----getsup, eval=TRUE--------------------------------------------------------
mt$aggregate_cols(hl$agg$counter(mt$pheno$SuperPopulation))


## ----lkcaf, eval=TRUE---------------------------------------------------------
uu <- mt$aggregate_cols(hl$agg$stats(mt$pheno$CaffeineConsumption))
names(uu)
uu$mean
uu$stdev


## from pprint import pprint  # python chunk!

## snp_counts = r.mt.aggregate_rows(r.hl.agg.counter(r.hl.Struct(ref=r.mt.alleles[0], alt=r.mt.alleles[1])))

alls = mt$alleles$collect()
al1 = sapply(alls, "[", 1)
al2 = sapply(alls, "[", 2)
snp_counts = mt$aggregate_rows(hl$agg$counter(hl$Struct(ref=al1, alt=al2)))
snp_counts

## pprint(snp_counts)


## ----dohist, eval=TRUE--------------------------------------------------------
p_hist <- mt$aggregate_entries(
     hl$expr$aggregators$hist(mt$DP, 0L, 30L, 30L))
names(p_hist)
length(p_hist$bin_edges)
length(p_hist$bin_freq)
midpts <- function(x) diff(x)/2+x[-length(x)]
dpdf <- data.frame(x=midpts(p_hist$bin_edges), y=p_hist$bin_freq)
ggplot(dpdf, aes(x=x,y=y)) + geom_col() + ggtitle("DP") + ylab("Frequency")


## ----lkagg, eval=TRUE---------------------------------------------------------
names(hl$expr$aggregators)


## ----update, eval=TRUE--------------------------------------------------------
mt <- hl$sample_qc(mt)

## r.mt.col.describe()  # python!


## ----lkcr, eval=TRUE----------------------------------------------------------
callrate <- mt$sample_qc$call_rate$collect()
graphics::hist(callrate)


## # python chunk!

## r.mt = r.mt.filter_cols((r.mt.sample_qc.dp_stats.mean >= 4) & (r.mt.sample_qc.call_rate >= 0.97))

mt$count_cols()
mt = mt$filter_cols((mt$sample_qc$dp_stats$mean >= 4 & mt$sample_qc$call_rate >= 0.97))
mt$count_cols()

## print('After filter, %d/284 samples remain.' % r.mt.count_cols())


## ab = r.mt.AD[1] / r.hl.sum(r.mt.AD)

## 

## filter_condition_ab = ((r.mt.GT.is_hom_ref() & (ab <= 0.1)) |

##                         (r.mt.GT.is_het() & (ab >= 0.25) & (ab <= 0.75)) |

##                         (r.mt.GT.is_hom_var() & (ab >= 0.9)))

## 

## fraction_filtered = r.mt.aggregate_entries(r.hl.agg.fraction(~filter_condition_ab))

## print(f'Filtering {fraction_filtered * 100:.2f}% entries out of downstream analysis.')

## r.mt = r.mt.filter_entries(filter_condition_ab)


## ----after, eval=TRUE---------------------------------------------------------
dim(mt)


## ----addvarqc, eval=TRUE------------------------------------------------------
mt = hl$variant_qc(mt)

## r.mt.row.describe()  #! python


## r.mt = r.mt.filter_rows(r.mt.variant_qc.AF[1] > 0.01)

## r.mt = r.mt.filter_rows(r.mt.variant_qc.p_value_hwe > 1e-6)

## r.mt.count()

gwas = hl$linear_regression_rows(y=mt$pheno$CaffeineConsumption,
  x=mt$GT$n_alt_alleles(), covariates=list(1.0))
allp = gwas$p_value$collect()
summary(allp)

expect_true( abs( mean(allp, na.rm=TRUE) - 0.306 ) < .001 )
})

## r.gwas = r.hl.linear_regression_rows(y=r.mt.pheno.CaffeineConsumption,

##                                  x=r.mt.GT.n_alt_alleles(),

##                                  covariates=[1.0])

## # r.pl = r.hl.plot.manhattan(r.gwas.p_value)

## # import bokeh

## # bokeh.plotting.show(r.pl)


## ----dolam, eval=TRUE---------------------------------------------------------
###pv = gwas$p_value$collect()
###x2 = stats::qchisq(1-pv,1)
###lam = stats::median(x2, na.rm=TRUE)/stats::qchisq(.5,1)
###lam
###
###
##### ----doqq, eval=TRUE----------------------------------------------------------
###qqplot(-log10(ppoints(length(pv))), -log10(pv), xlim=c(0,8), ylim=c(0,8),
###  ylab="-log10 p", xlab="expected")
###abline(0,1)
###
###
##### ----eval=FALSE---------------------------------------------------------------
##### locs <- gwas$locus$collect()
##### conts <- sapply(locs, function(x) x$contig)
##### pos <- sapply(locs, function(x) x$position)
##### library(igvR)
##### mytab <- data.frame(chr=as.character(conts), pos=pos, pval=pv)
##### gt <- GWASTrack("simp", mytab, chrom.col=1, pos.col=2, pval.col=3)
##### igv <- igvR()
##### setGenome(igv, "hg19")
##### displayTrack(igv, gt)
###
###
##### r.pcastuff = r.hl.hwe_normalized_pca(r.mt.GT)
###
##### r.mt = r.mt.annotate_cols(scores=r.pcastuff[1][r.mt.s].scores)
###
###
##### ----lkpcs, eval=TRUE---------------------------------------------------------
###sc <- pcastuff[[2]]$scores$collect()
###pc1 = sapply(sc, "[", 1)
###pc2 = sapply(sc, "[", 2)
###fac = mt$pheno$SuperPopulation$collect()
###myd = data.frame(pc1, pc2, pop=fac)
###library(ggplot2)
###ggplot(myd, aes(x=pc1, y=pc2, colour=factor(pop))) + geom_point()
###
###
##### r.gwas2 = r.hl.linear_regression_rows(
###
#####     y=r.mt.pheno.CaffeineConsumption,
###
#####     x=r.mt.GT.n_alt_alleles(),
###
#####     covariates=[1.0,r.mt.pheno.isFemale,r.mt.scores[0],
###
#####         r.mt.scores[1], r.mt.scores[2]])
###
###
##### ----dolam2, eval=TRUE--------------------------------------------------------
###pv = gwas2$p_value$collect()
###x2 = stats::qchisq(1-pv,1)
###lam = stats::median(x2, na.rm=TRUE)/stats::qchisq(.5,1)
###lam
###
###
##### ----doman, eval=TRUE---------------------------------------------------------
###locs <- gwas2$locus$collect()
###conts <- sapply(locs, function(x) x$contig)
###pos <- sapply(locs, function(x) x$position)
###mytab <- data.frame(chr=as.character(conts), pos=pos, pval=pv)
###ggplot(mytab[mytab$chr=="8",], aes(x=pos, y=-log10(pval))) + geom_point()
###
###
##### ----sessionInfo--------------------------------------------------------------
###sessionInfo()
###
