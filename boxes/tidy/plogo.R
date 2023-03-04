# box/plogo.R

#' prints tidyverse logo
#' @export
print_logo = function(){
  # import pkg[fun] inside function
box::use(
  tidyverse[tidyverse_logo])
  # use fun
    tidyverse_logo()
}