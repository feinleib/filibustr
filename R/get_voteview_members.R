get_voteview_members <- function(local = TRUE, local_dir = ".", chamber = "all") {
  source <- ifelse(local,
                   local_dir,
                   "https://voteview.com/static/data/out/members")
  file <- dplyr::case_match(chamber,
                            c("all", "congress") ~ "HSall_members.csv",
                            c("house", "h", "hr") ~ "Hall_members.csv",
                            c("senate", "s", "sen") ~ "Sall_members.csv")
  full_path <- paste0(source, "/", file)
  readr::read_csv(full_path,
                  col_types = "ifiinfiiiccnnnnnni")
}
