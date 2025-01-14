test_that("all parties data", {
  skip_if_offline()

  all_parties <- get_voteview_parties()
  expect_s3_class(all_parties, "tbl_df")
  expect_length(all_parties, 9)
  expect_equal(levels(all_parties$chamber),
               c("President", "House", "Senate"))
  # allow Congresses to be 1:(current_congress() - 1) in January of odd years
  # since Voteview may not have votes from the new Congress yet
  if (is_odd_year_january()) {
    expect_true(identical(unique(all_parties$congress), 1:current_congress()) ||
                  identical(unique(all_parties$congress), 1:(current_congress() - 1)))
  } else {
    expect_equal(unique(all_parties$congress), 1:current_congress())
  }
})

test_that("filter parties by congress", {
  skip_if_offline()

  parties_99_101 <- get_voteview_parties(congress = 99:101)
  expect_s3_class(parties_99_101, "tbl_df")
  expect_length(parties_99_101, 9)
  expect_equal(nrow(parties_99_101), 15)
  expect_equal(unique(parties_99_101$congress), 99:101)
  expect_equal(levels(parties_99_101$party_name),
               c("Republican", "Democrat"))

  parties_117 <- get_voteview_parties(congress = 117)
  expect_s3_class(parties_117, "tbl_df")
  expect_length(parties_117, 9)
  expect_equal(nrow(parties_117), 7)
  expect_equal(unique(parties_117$congress), 117)
  expect_equal(levels(parties_117$party_name),
               c("Democrat", "Republican", "Independent"))
})
