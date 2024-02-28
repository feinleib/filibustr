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
