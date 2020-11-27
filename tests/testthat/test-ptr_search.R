test_that("basic search is stable", {
  skip_on_cran()
  load("testdata/balsam_fir.rds")
  bf_dl <- ptr_search(common_name = "balsam fir")
  expect_equal(
    nrow(bf_dl),
    nrow(balsam_fir)
    )
  expect_equal(
    levels(factor(bf_dl$accepted_plant.symbol)),
    levels(factor(balsam_fir$accepted_plant.symbol))
  )
})

test_that("advanced search is stable", {
  skip_on_cran()
  load("testdata/abbab.rds")
  abbab_dl <- ptr_search("ABBAB", basic = FALSE)
  expect_equal(
    nrow(abbab_dl),
    nrow(abbab)
  )
})

test_that("expected failures happen", {
  expect_error(
    ptr_search("ABBA", introduced = "l48", native = "l48")
  )
})
