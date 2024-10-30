# necessary for python module control
bsklenv <- basilisk::BasiliskEnvironment(
  envname = "bsklenv", packages = "pandas==2.2.3",
  pkgname = "BiocHail", pip = c("hail==0.2.133", "ukbb_pan_ancestry==0.0.2")
)
