# BiocHail

This is a multi-step overview of Hail for genetic association
studies.  As of March 2023, there are three vignettes (articles),
described in the following subsections.

## Tutorial overview

The first
vignette follows the [Hail 0.2 GWAS tutorial](https://hail.is/docs/0.2/tutorials/01-genome-wide-association-study.html).

We'll see how to use a very small excerpt from the
1000 genomes study to produce

![litman](https://github.com/vjcitn/BiocHail/raw/main/litman.png)

Along the way, we illustrate and adjust for population stratification:

![popstrat](https://github.com/vjcitn/BiocHail/raw/main/popstrat.png)

## Larger data problem -- 1000 genomes data with T2T reference

We have arranged a serialization of genotypes on chromosome 17
for 3202 1000 genomes samples.  Code is provided
to explore population stratification with this
richer set of genotypes.  Exercises investigate
sampling loci, manipulation of annotation, and exploratory GWAS.

## Working with UK Biobank summary statistics

Some of the code of interest in this vignette needs to be run
in Rstudio to take advantage of quarto-based mixing of R and python.

Exercises address interface production to simplify querying of
available phenotypes and extraction of findings based
on strength of association.

## Relevant LD resources ... in which cloud?

Still to come.

## Simulating multipopulation genotype surveys

Still to come.

## Binding phenotypes from FHIR to Hail

Still to come.
