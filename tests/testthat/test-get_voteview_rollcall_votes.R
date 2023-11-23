test_that("download from Voteview", {
  online_rollcalls <- get_voteview_rollcall_votes(local = FALSE)
  expect_s3_class(online_rollcalls, "tbl_df")
  expect_length(online_rollcalls, 18)
  expect_equal(levels(online_rollcalls$chamber), c("House", "Senate"))
  expect_equal(unique(online_rollcalls$congress), 1:current_congress())
})
