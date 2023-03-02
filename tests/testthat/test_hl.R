library(BiocHail)

context("hail_init code works")

test_that("hail_init succeeds and is idempotent", {
   hl = hail_init()
   expect_true(substr(hl$version(),1,7)=="0.2.108")
   hl = hail_init()
   expect_true(substr(hl$version(),1,7)=="0.2.108")
})
