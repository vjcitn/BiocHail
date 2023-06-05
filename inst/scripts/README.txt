The 1kg_annotations.txt was retrieved from https://storage.googleapis.com/hail-1kg/tutorial_data.tar

The my2ss.zip is a MatrixTable instance that has been compressed.  It is derived from the
annotation for GWAS summary statistics from UK Biobank provided at the Broad UK Biobank
portal.  Example of the underlying python structs:

[[7271]]
Struct(trait_type='prescriptions', phenocode='zopiclone', pheno_sex='both_sexes', coding='', modifier='', pheno_data=[Struct(n_cases=170, n_controls=6466, heritability=0.10794648895016906, saige_version='SAIGE_0.36.3', inv_normalized=False, pop='AFR'), Struct(n_cases=382, n_controls=8494, heritability=0.03487760637490611, saige_version='SAIGE_0.36.3', inv_normalized=False, pop='CSA'), Struct(n_cases=66, n_controls=2643, heritability=0.12246893045325642, saige_version='SAIGE_0.36.3', inv_normalized=False, pop='EAS'), Struct(n_cases=14323, n_controls=406208, heritability=0.051400442321158576, saige_version='SAIGE_0.36.3', inv_normalized=False, pop='EUR'), Struct(n_cases=65, n_controls=1534, heritability=0.06825527421937107, saige_version='SAIGE_0.36.3', inv_normalized=False, pop='MID')], description=None, description_more=None, coding_description=None, category='GABA agonist,sedative', n_cases_full_cohort_both_sexes=17242, n_cases_full_cohort_females=9864, n_cases_full_cohort_males=5441)

