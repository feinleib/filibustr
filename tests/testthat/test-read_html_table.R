test_that("read_html_table()", {
  skip_if_offline()

  # The table used in `get_senate_cloture_votes()`
  # NOTE: `get_senate_cloture_votes()` performs some cleaning on this table
  cloture_votes <- read_html_table(
    url = "https://www.senate.gov/legislative/cloture/clotureCounts.htm",
    css = ".cloturecount"
  )

  expect_s3_class(cloture_votes, "tbl_df")
  expect_length(cloture_votes, 5)
  # this table will add one row each Congress
  expect_equal(nrow(cloture_votes), 55 + (current_congress() - 118))
  expect_equal(colnames(cloture_votes),
               c("Congress", "Years", "Motions Filed", "Votes on Cloture", "Cloture Invoked"))


  # A table from Baseball Reference: Steve Garvey stats
  br_table <- read_html_table(
    url = "https://www.baseball-reference.com/players/g/garvest01.shtml",
    css = "#players_standard_batting"
  )

  expect_s3_class(br_table, "tbl_df")
  expect_length(br_table, 33)
  expect_equal(nrow(br_table), 24)
})

test_that("read live HTML table", {
  skip_if_offline()

  # WBSC site doesn't work on `read_html()`
  expect_error(rvest::read_html("https://www.wbsc.org/en/events/2025-u18-baseball-world-cup/stats"),
               regexp = "cannot open the connection")
  # works with live HTML
  live_html <- rvest::read_html_live("https://www.wbsc.org/en/events/2025-u18-baseball-world-cup/stats")
  expect_s3_class(live_html, c("LiveHTML", "R6"))

  # reading WBSC table requires `read_html_table(live = TRUE)`
  expect_error(read_html_table("https://www.wbsc.org/en/events/2025-u18-baseball-world-cup/stats",
                               css = "#table-stats_wrapper"),
               regexp = "cannot open the connection")

  # correctly-read live table
  skip_if(is.null(curl::nslookup("www.wbsc.org", error = FALSE)))
  wbsc_table <- read_html_table("https://www.wbsc.org/en/events/2025-u18-baseball-world-cup/stats",
                                css = "#table-stats_wrapper",
                                live = TRUE, live_wait = 0.5)
  expect_s3_class(wbsc_table, "tbl_df")
  expect_length(wbsc_table, 24)
  expect_equal(nrow(wbsc_table), 26)
})

test_that("dynamic table requires `live`", {
  skip_if_offline()

  # example dynamic table from FreeCodeCamp tutorial
  # tutorial URL:
  # <https://www.freecodecamp.org/news/convert-html-table-to-dynamic-javascript-data-grid/>
  tbl_url <- paste("https://eviltester.github.io",
                   "freecodecampexamples/html-table-to-data-grid/table-index.html",
                   sep = "/")
  tbl_css <- "#html-data-table"
  # empty version of the table there
  empty_tbl <- dplyr::tibble(userId = logical(),
                             id = logical(),
                             title = logical(),
                             completed = logical())

  ### STATIC TABLE ###
  static_tbl <- read_html_table(tbl_url, tbl_css)

  # the static part of the table is an empty (0x4) tibble
  expect_s3_class(static_tbl, "tbl_df")
  expect_identical(static_tbl, empty_tbl)

  # waiting does not change that
  static_wait <- read_html_table(tbl_url, tbl_css, live_wait = 1)
  expect_s3_class(static_wait, "tbl_df")
  expect_identical(static_wait, empty_tbl)
})

test_that("dynamic table succeeds when using `live`", {
  skip("Skipping 2nd live table test; test site is brittle.")
  skip_if_offline()

  # example dynamic table from FreeCodeCamp tutorial
  # tutorial URL:
  # <https://www.freecodecamp.org/news/convert-html-table-to-dynamic-javascript-data-grid/>
  tbl_url <- paste("https://eviltester.github.io",
                   "freecodecampexamples/html-table-to-data-grid/table-index.html",
                   sep = "/")
  tbl_css <- "#html-data-table"
  # empty version of the table there
  empty_tbl <- dplyr::tibble(userId = integer(),
                             id = integer(),
                             title = character(),
                             completed = character())

  ### DYNAMIC TABLE ###
  # the dynamically-generated table is 200x4,
  # but it can take some time to generate,
  # and the site sometimes errors

  # do 20 trials with a 1/2-second wait time
  # if failure rate is (at most) 70%,
  # this test will fail in less than 1 in 1200 runs
  dyn_wait_rows <- rep(0L, 20)
  wait_time <- 0.5
  i <- 1

  while (i <= length(dyn_wait_rows)) {
    failure <- 0
    start_time <- Sys.time()
    dyn_wait <- tryCatch(read_html_table(tbl_url, tbl_css, live = TRUE, live_wait = wait_time),
                         error = function(e) {
                           # on error: flag a failure, and return the empty table
                           failure <- 1
                           empty_tbl
                         })

    # read should take at least `wait_time`
    expect_gte(Sys.time() - start_time, wait_time)
    expect_s3_class(dyn_wait, "tbl_df")
    expect_length(dyn_wait, 4)

    # store the number of rows returned (as a success metric)
    dyn_wait_rows[i] <- nrow(dyn_wait)
    # advance i iff the read succeeded
    i <- i + 1 - failure
  }
  expect_true(any(dyn_wait_rows == 200))
})
