test_that("get_online_data(): Voteview members", {
  vv_resp_members_s117 <- get_online_data(
    "https://voteview.com/static/data/out/members/S117_members.csv", "Voteview")
  expect_type(vv_resp_members_s117, "character")
  # check that CSV format works
  members_s117_df <- readr::read_csv(vv_resp_members_s117, show_col_types = FALSE)
  expect_s3_class(members_s117_df, "tbl_df")
  expect_length(members_s117_df, 22)
  expect_equal(nrow(members_s117_df), 104)
  expect_equal(unique(members_s117_df$chamber), c("President", "Senate"))
  expect_equal(unique(members_s117_df$congress), 117)
})

test_that("get_online_data(): Voteview parties", {
  vv_resp_parties <- get_online_data(
    "https://voteview.com/static/data/out/parties/HSall_parties.csv", "Voteview")
  expect_type(vv_resp_parties, "character")
  # check that CSV format works
  parties_df <- readr::read_csv(vv_resp_parties, show_col_types = FALSE)
  expect_s3_class(parties_df, "tbl_df")
  expect_length(parties_df, 9)
  expect_equal(unique(parties_df$chamber), c("President", "House", "Senate"))
  expect_equal(unique(parties_df$congress), 1:118)
})

test_that("filter_chamber()", {
  # testing with `get_voteview_members()`
  members_94 <- get_voteview_members(congress = 94)
  expect_s3_class(members_94, "tbl_df")
  expect_equal(nrow(members_94), 543)

  # no filter
  expect_equal(filter_chamber(members_94, chamber = "all"),
               members_94)
  expect_equal(filter_chamber(members_94, chamber = "congress"),
               members_94)
  expect_equal(filter_chamber(members_94, chamber = "HS"),
               members_94)

  # filter to Senate
  sen_94 <- filter_chamber(members_94, chamber = "s")
  expect_s3_class(sen_94, "tbl_df")
  expect_equal(nrow(sen_94), 102)
  expect_equal(sen_94, dplyr::filter(members_94, chamber != "House"))

  expect_equal(filter_chamber(members_94, "senate"), sen_94)
  expect_equal(filter_chamber(members_94, "sen"), sen_94)

  # filter to House
  hr_94 <- filter_chamber(members_94, chamber = "hr")
  expect_s3_class(hr_94, "tbl_df")
  expect_equal(nrow(hr_94), 442)
  expect_equal(hr_94, dplyr::filter(members_94, chamber != "Senate"))

  expect_equal(filter_chamber(members_94, "h"), hr_94)
  expect_equal(filter_chamber(members_94, "house"), hr_94)
})
