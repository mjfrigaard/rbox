# penguins/import.R

box::use(
  readr[read_csv, cols],
)

#' @export
import <- function() {
  raw_csv_url <- "https://bit.ly/3SQJ6E3"
  read_csv(raw_csv_url, col_types = cols())
}