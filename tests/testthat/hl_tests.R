
context("hail_init code works")

test_that("hl_init succeeds and is idempotent", {
   hl = hl_init()
   expect_true(substr(hl$version(),1,7)=="0.2.105")
   hl = hl_init()
   expect_true(substr(hl$version(),1,7)=="0.2.105")
})
