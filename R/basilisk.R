# necessary for python module control
bsklenv <- basilisk::BasiliskEnvironment(
  envname = "bsklenv", packages = "pandas==1.3.5",
  pkgname = "BiocHail", pip = c("hail==0.2.108", "ukbb_pan_ancestry==0.0.2")
)
