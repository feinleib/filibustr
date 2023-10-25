test_that("download from Voteview", {
  online_voteview_members <- get_voteview_members(local = FALSE)
  expect_s3_class(online_voteview_members, "tbl_df")
  expect_length(online_voteview_members, 22)
  expect_equal(levels(online_voteview_members$chamber),
               c("President", "House", "Senate"))
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

  expect_warning(get_voteview_members(chamber = "not a chamber"))
})

test_that("online fallback", {
  expect_equal(get_voteview_members(local_dir = "fake_folder_DNE"),
               get_voteview_members(local = FALSE))
  expect_equal(get_voteview_members(),
               get_voteview_members(local = FALSE))
})

test_that("filter by congress", {
  members_110 <- get_voteview_members(congress = 110, chamber = "s")
  expect_s3_class(members_110, "tbl_df")
  expect_equal(levels(members_110$chamber),
               c("President", "Senate"))
  expect_equal(unique(members_110$congress), 110)

  members_1 <- get_voteview_members(congress = 1)
  expect_s3_class(members_1, "tbl_df")
  expect_equal(levels(members_1$chamber),
               c("President", "House", "Senate"))
  expect_equal(unique(members_1$congress), 1)

  members_all_congresses <- get_voteview_members(congress = 200, chamber = "sen")
  expect_s3_class(members_all_congresses, "tbl_df")
  expect_equal(levels(members_all_congresses$chamber),
               c("President", "Senate"))
  expect_equal(unique(members_all_congresses$congress), 1:118)

  expect_gt(nrow(members_all_congresses), nrow(members_110))
})
