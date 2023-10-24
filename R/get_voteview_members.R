get_voteview_members <- function(local = TRUE, local_dir = ".") {
  source <- ifelse(local,
                   paste0(local_dir, "/HSall_members.csv"),
                   "https://voteview.com/static/data/out/members/HSall_members.csv")
  readr::read_csv(source,
                  col_types = "ifiinfiiiccnnnnnni")
}
