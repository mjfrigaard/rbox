# contents of tidy/tidy_logo.R

#' import alias tidyverse logo
#' @export
box::use(
  tidyverse[tidy_logo = tidyverse_logo]
  )

#' prints tidyverse logo
#' @export
print_logo = function(){
  # use fun alias
    tidy_logo()
}