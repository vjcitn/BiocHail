library(BiocHail)

context("tutorial-related code works")

test_that("get_1kg succeeds", {
  hl = hail_init()
  x = get_1kg(hl) # would populate, pull from cache
  cc = x$count()
  expect_true(all(unlist(cc)==c(10961, 284)))
})

