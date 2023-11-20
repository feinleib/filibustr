get_senate_sessions <- function() {
  rvest::read_html(paste0("https://www.senate.gov",
                          "/legislative/DatesofSessionsofCongress.htm")) %>%
    rvest::html_elements(css = "#SortableData_table") %>%
    rvest::html_table() %>%
    # unlist
    `[[`(1) %>%
    # move row 1 to column names
    setNames(as.character(.[1, ]) %>% stringr::str_replace_all(" ", "_") %>% tolower()) %>%
    dplyr::slice(-1) %>%
    # remove footnotes and newline characters from dates
    dplyr::mutate(dplyr::across(
      .cols = c(begin_date, adjourn_date),
      .fns = function(.x) {
        stringr::str_remove_all(.x,
                                pattern = paste("(?<=[:digit:]{4})[:digit:]*[:space:]",
                                                "(?<=[:digit:]{4})[:digit:]*$",
                                                "\\n", sep = "|"))
      })) %>%
    # split each session into its own row
    tidyr::separate_longer_delim(cols = c(begin_date, adjourn_date),
                                 delim = stringr::regex("(?<=[:digit:]{4})(?=[:alpha:])")) %>%
    dplyr::mutate(session = stringr::str_split_1(dplyr::first(session), ""),
                  .by = congress) %>%
    # fix column types
    dplyr::mutate(congress = as.numeric(congress),
                  session = as.factor(session),
                  begin_date = as.Date(begin_date, format = "%b %d, %Y"),
                  adjourn_date = as.Date(adjourn_date, format = "%b %d, %Y"))
}
