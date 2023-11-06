test_that("all parties data", {
  all_parties <- get_voteview_parties()
  expect_s3_class(all_parties, "tbl_df")
  expect_length(all_parties, 9)
  expect_equal(levels(all_parties$chamber),
               c("President", "House", "Senate"))
  expect_equal(unique(all_parties$congress), 1:current_congress())
})
