test_that("download from Voteview", {
  skip_if_offline()

  online_rollcalls <- get_voteview_rollcall_votes()
  expect_s3_class(online_rollcalls, "tbl_df")
  expect_length(online_rollcalls, 18)
  expect_equal(levels(online_rollcalls$chamber), c("House", "Senate"))
  # allow Congresses to be 1:(current_congress() - 1) in January of odd years
  # since Voteview may not have votes from the new Congress yet
  if (is_odd_year_january()) {
    expect_true(all.equal(unique(online_rollcalls$congress), 1:current_congress()) ||
                  all.equal(unique(online_rollcalls$congress), 1:(current_congress() - 1)))
  } else {
    expect_equal(unique(online_rollcalls$congress), 1:current_congress())
  }
})

test_that("filter rollcalls by chamber", {
  skip_if_offline()

  s_votes <- get_voteview_rollcall_votes(chamber = "s")
  expect_s3_class(s_votes, "tbl_df")
  expect_length(s_votes, 18)
  expect_equal(levels(s_votes$chamber), "Senate")
  if (is_odd_year_january()) {
    expect_true(all.equal(unique(s_votes$congress), 1:current_congress()) ||
                  all.equal(unique(s_votes$congress), 1:(current_congress() - 1)))
  } else {
    expect_equal(unique(s_votes$congress), 1:current_congress())
  }

  hr_votes <- get_voteview_rollcall_votes(chamber = "hr")
  expect_s3_class(hr_votes, "tbl_df")
  expect_length(hr_votes, 18)
  expect_equal(levels(hr_votes$chamber), "House")
  if (is_odd_year_january()) {
    expect_true(all.equal(unique(hr_votes$congress), 1:current_congress()) ||
                  all.equal(unique(hr_votes$congress), 1:(current_congress() - 1)))
  } else {
    expect_equal(unique(hr_votes$congress), 1:current_congress())
  }

  # House has more recorded votes
  expect_gt(nrow(hr_votes), nrow(s_votes))
})

test_that("filter rollcalls by congress", {
  skip_if_offline()

  rollcalls_1_10 <- get_voteview_rollcall_votes(congress = 1:10)
  expect_s3_class(rollcalls_1_10, "tbl_df")
  expect_length(rollcalls_1_10, 18)
  expect_equal(levels(rollcalls_1_10$chamber), c("House", "Senate"))
  expect_equal(unique(rollcalls_1_10$congress), 1:10)
  expect_equal(nrow(rollcalls_1_10), 2339)

  rollcalls_101_110 <- get_voteview_rollcall_votes(congress = 101:110)
  expect_s3_class(rollcalls_101_110, "tbl_df")
  expect_length(rollcalls_101_110, 18)
  expect_equal(levels(rollcalls_101_110$chamber), c("House", "Senate"))
  expect_equal(unique(rollcalls_101_110$congress), 101:110)
  expect_equal(nrow(rollcalls_101_110), 18578)

  # combo of chamber and congress
  s_rollcalls_117 <- get_voteview_rollcall_votes(chamber = "s", congress = 117)
  expect_s3_class(s_rollcalls_117, "tbl_df")
  expect_length(s_rollcalls_117, 18)
  expect_equal(levels(s_rollcalls_117$chamber), "Senate")
  expect_equal(unique(s_rollcalls_117$congress), 117)
  expect_equal(nrow(s_rollcalls_117), 949)
})

test_that("rollcalls column types", {
  skip_if_offline()

  hr_votes_31 <- get_voteview_rollcall_votes(chamber = "hr", congress = 31)
  expect_s3_class(hr_votes_31, "tbl_df")
  expect_length(hr_votes_31, 18)
  expect_equal(nrow(hr_votes_31), 572)

  expect_length(dplyr::select(hr_votes_31, dplyr::where(is.character)), 5)
  expect_length(dplyr::select(hr_votes_31, dplyr::where(is.double)), 6)
  expect_length(dplyr::select(hr_votes_31, dplyr::where(is.factor)), 1)
  expect_length(dplyr::select(hr_votes_31, dplyr::where(is.integer)), 6)

  votes_109 <- get_voteview_rollcall_votes(congress = 109)
  expect_s3_class(votes_109, "tbl_df")
  expect_length(votes_109, 18)
  expect_equal(nrow(votes_109), 1855)

  expect_length(dplyr::select(votes_109, dplyr::where(is.character)), 5)
  expect_length(dplyr::select(votes_109, dplyr::where(is.double)), 6)
  expect_length(dplyr::select(votes_109, dplyr::where(is.factor)), 1)
  expect_length(dplyr::select(votes_109, dplyr::where(is.integer)), 6)
})
