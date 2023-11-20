test_that("congress numbers", {
  ## proper usage
  # numbers
  expect_equal(congress_in_year(1789), 1)
  expect_equal(congress_in_year(2000), 106)
  expect_equal(congress_in_year(2023), 118)
  expect_equal(congress_in_year(2100), 156)
  expect_equal(congress_in_year(3000), 606)

  # Date objects
  expect_equal(congress_in_year(as.Date("1789-01-01")), 1)
  expect_equal(congress_in_year(as.Date("1800-07-01")), 6)
  expect_equal(congress_in_year(as.Date("1800-07-01")), 6)
  expect_equal(congress_in_year(as.Date("2021-01-06")), 117)

  ## error handling
  expect_error(congress_in_year("word"),
               regexp = "Must provide the year as a number or Date object.",
               fixed = TRUE)
  expect_error(congress_in_year("1901"),
               regexp = "Must provide the year as a number or Date object.",
               fixed = TRUE)
  expect_error(congress_in_year(1788),
               regexp = paste("The provided year (1788) is too early.",
                              "The first Congress started in 1789."),
               fixed = TRUE)
  expect_error(congress_in_year(110),
               regexp = paste("The provided year (110) is too early.",
                              "The first Congress started in 1789."),
               fixed = TRUE)
  expect_error(congress_in_year(as.Date("1492-09-01")),
               regexp = paste("The provided year (1492) is too early.",
                              "The first Congress started in 1789."),
               fixed = TRUE)
})

test_that("current congress", {
  curr_cong <- current_congress()
  # check that current congress is integer
  expect_equal(curr_cong, as.integer(curr_cong))

  # matches congress_in_year()
  expect_equal(curr_cong, congress_in_year(as.numeric(format(Sys.Date(), "%Y"))))
  expect_equal(curr_cong, congress_in_year(Sys.Date()))

  expect_gte(curr_cong, 118)
  # reasonable upper bound on current congress
  # (this will fail in the year 2187)
  expect_lt(curr_cong, 200)
})

test_that("match chamber", {
  # all
  expect_equal(match_chamber("all"), "HS")
  expect_equal(match_chamber("ALL"), "HS")
  expect_equal(match_chamber("congress"), "HS")
  expect_equal(match_chamber("coNGrEsS"), "HS")

  # house
  expect_equal(match_chamber("h"), "H")
  expect_equal(match_chamber("H"), "H")
  expect_equal(match_chamber("hr"), "H")
  expect_equal(match_chamber("HR"), "H")
  expect_equal(match_chamber("hR"), "H")
  expect_equal(match_chamber("house"), "H")
  expect_equal(match_chamber("House"), "H")
  expect_equal(match_chamber("HOUSE"), "H")

  # senate
  expect_equal(match_chamber("s"), "S")
  expect_equal(match_chamber("S"), "S")
  expect_equal(match_chamber("sen"), "S")
  expect_equal(match_chamber("Sen"), "S")
  expect_equal(match_chamber("senate"), "S")
  expect_equal(match_chamber("Senate"), "S")
  expect_equal(match_chamber("SENATE"), "S")
  expect_equal(match_chamber("sENaTE"), "S")

  # all by default
  expect_warning(abc_match <- match_chamber("abc"))
  expect_equal(abc_match, "HS")
  expect_warning(spaces_match <- match_chamber(" senate "))
  expect_equal(spaces_match, "HS")
})

test_that("match congress number", {
  # valid congress numbers
  expect_equal(match_congress(118), "118")
  expect_equal(match_congress(110), "110")
  expect_equal(match_congress(23), "023")
  expect_equal(match_congress(1), "001")

  # invalid congress numbers
  expect_equal(match_congress(0), "all")
  expect_equal(match_congress(-2), "all")
  expect_equal(match_congress("five"), "all")
  expect_equal(match_congress("all"), "all")
})

test_that("build file path", {
  # expected usage
  expect_equal(build_file_path(sheet_type = "members"),
               "https://voteview.com/static/data/out/members/HSall_members.csv")
  expect_equal(build_file_path(sheet_type = "rollcalls"),
               "https://voteview.com/static/data/out/rollcalls/HSall_rollcalls.csv")

  # specify chamber, congress
  expect_equal(build_file_path(sheet_type = "members", congress = 117),
               "https://voteview.com/static/data/out/members/HS117_members.csv")
  expect_equal(build_file_path(sheet_type = "rollcalls", chamber = "senate"),
               "https://voteview.com/static/data/out/rollcalls/Sall_rollcalls.csv")
  expect_equal(build_file_path(sheet_type = "members", chamber = "hr", congress = 90),
               "https://voteview.com/static/data/out/members/H090_members.csv")

  # TODO: specify local path
})
