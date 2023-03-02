# box/penguins/import.R

box::use(
  vroom[vroom],
)

#' @export
import_penguins <- function() {
  raw_csv_url <- "https://raw.githubusercontent.com/allisonhorst/palmerpenguins/main/inst/extdata/penguins_raw.csv"
  vroom(raw_csv_url)
}