# penguins/ggp2.R

# reset the path
options(box.path = getwd())

# import read module
box::use(
  penguins/read
)

# import clean module
box::use(
  penguins/clean
)

# import ggplot2
box::use(
  dplyr[filter],
  ggplot2 = ggplot2[ggplot, aes, geom_point, facet_wrap, labs, theme_minimal]
)

#' @export
scatter <- function() {
  # prep data
  prepped <- clean$prep()
  # remove missing sex
  filtered <- filter(prepped, !is.na(sex)) 
  # plot
  plotted <- ggplot2$ggplot(data = filtered, 
    ggplot2$aes(
      x = flipper_length_mm,
      y = body_mass_g,
      group = sex
    )
  ) +
    ggplot2$geom_point(
      ggplot2$aes(color = island)
    ) +
    ggplot2$facet_wrap(. ~ sex) +
    ggplot2$labs(
      x = "Flipper Length (mm)", y = "Body Mass (g)", color = "Island",
      title = "Flipper vs. Body Mass", subtitle = "Palmer Penguins"
    ) +
    ggplot2$theme_minimal()
  plotted
}
