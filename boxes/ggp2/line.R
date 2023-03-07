# contents of ggp2/line.R

#' graph function
#' @export
graph <- function() {
  box::use(ggplot2 = ggplot2[...])
  ggplot(
    mpg,
    aes(x = displ, y = hwy)
  ) +
    geom_point()
}
