test_that("get_online_data(): informative error for bot-blocked requests", {
  # the Harvard Dataverse's AWS WAF answers automated requests with
  # an empty HTTP 202, not an HTTP error (#65)
  waf_challenge <- function(req) {
    httr2::response(status_code = 202,
                    headers = list("x-amzn-waf-action" = "challenge"))
  }

  httr2::with_mocked_responses(waf_challenge, {
    expect_error(
      get_online_data("https://dataverse.harvard.edu/api/access/datafile/6299608",
                      "Harvard Dataverse"),
      "behind bot protection"
    )
  })
})

test_that("get_online_data(): informative error for empty responses", {
  httr2::with_mocked_responses(function(req) httr2::response(status_code = 200), {
    expect_error(
      get_online_data("https://voteview.com/static/data/out/parties/HSall_parties.csv",
                      "Voteview"),
      "returned an empty response"
    )
  })
})

test_that("get_online_data(): Voteview members", {
  skip_if_offline()

  vv_resp_members_s117 <- get_online_data(
    "https://voteview.com/static/data/out/members/S117_members.csv", "Voteview")
  expect_type(vv_resp_members_s117, "character")
  # check that CSV format works
  members_s117_df <- readr::read_csv(I(vv_resp_members_s117), show_col_types = FALSE)
  expect_s3_class(members_s117_df, "tbl_df")
  expect_length(members_s117_df, 22)
  expect_equal(nrow(members_s117_df), 104)
  expect_equal(unique(members_s117_df$chamber), c("President", "Senate"))
  expect_equal(unique(members_s117_df$congress), 117)
})

test_that("get_online_data(): Voteview parties", {
  skip_if_offline()

  vv_resp_parties <- get_online_data(
    "https://voteview.com/static/data/out/parties/HSall_parties.csv", "Voteview")
  expect_type(vv_resp_parties, "character")
  # check that CSV format works
  parties_df <- readr::read_csv(I(vv_resp_parties), show_col_types = FALSE)
  expect_s3_class(parties_df, "tbl_df")
  expect_length(parties_df, 9)
  expect_equal(unique(parties_df$chamber), c("President", "House", "Senate"))
  # allow Congresses to be 1:(current_congress() - 1) in January of odd years
  # since Voteview may not have votes from the new Congress yet
  if (is_odd_year_january()) {
    expect_true(all.equal(unique(parties_df$congress), 1:current_congress()) ||
                  all.equal(unique(parties_df$congress), 1:(current_congress() - 1)))
  } else {
    expect_equal(unique(parties_df$congress), 1:current_congress())
  }
})
