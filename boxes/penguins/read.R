# penguins/read.R

# reset the path
options(box.path = getwd())

# import read_csv() (with alias) and cols()
box::use(
  readr[get_csv = read_csv, cols]
)

#' @export
raw <- function() {
  raw_csv_url <- "https://bit.ly/3SQJ6E3"
  # use alias for read_csv()
  get_csv(raw_csv_url, col_types = cols())
}