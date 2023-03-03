# penguins/clean.R

# reset the path
options(box.path = getwd())

# import alias import module
box::use(
  penguins/read
)

# import wrangle pkgs/funs
box::use(
  dplyr[...],
  stringr[str_ext = str_extract],
  janitor[fix_cols = clean_names]
)

# prep data
prep = function() {
  # import raw data
  raw <- read$raw()
  clean_cols <- fix_cols(raw)
  vars <- select(clean_cols, 
    species, 
    island, 
    bill_length_mm = culmen_length_mm,
    bill_depth_mm = culmen_depth_mm,
    flipper_length_mm,
    body_mass_g,
    sex)
  mutate(vars, 
    species = str_ext(species, "([[:alpha:]]+)"),
    sex = factor(sex))
}