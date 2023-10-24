test_that("download from Voteview", {
  online_voteview_members <- get_voteview_members(local = FALSE)
  expect_s3_class(online_voteview_members, "tbl_df")
  expect_length(online_voteview_members, 22)
  expect_equal(levels(online_voteview_members$chamber), c("President", "House", "Senate"))
  expect_equal(unique(online_voteview_members$congress), 1:118)
})

test_that("filter by chamber", {
  hr <- get_voteview_members(chamber = "house")
  expect_length(hr, 22)
  expect_equal(levels(hr$chamber), c("President", "House"))
  expect_equal(unique(hr$congress), 1:118)

  s <- get_voteview_members(chamber = "senate")
  expect_length(s, 22)
  expect_equal(levels(s$chamber), c("President", "Senate"))
  expect_equal(unique(s$congress), 1:118)

  expect_gt(nrow(hr), nrow(s))
})

test_that("online fallback", {
  expect_equal(get_voteview_members(local_dir = "fake_folder_DNE"),
               get_voteview_members(local = FALSE))
  expect_equal(get_voteview_members(),
               get_voteview_members(local = FALSE))
})

