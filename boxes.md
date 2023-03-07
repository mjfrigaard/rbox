`box`es
================

- <a href="#box-examples" id="toc-box-examples"><code>box</code>
  examples</a>
  - <a href="#composing-box-modules"
    id="toc-composing-box-modules">Composing <code>box</code> modules</a>
  - <a href="#tidy" id="toc-tidy"><code>tidy</code></a>
    - <a href="#logo" id="toc-logo"><code>logo</code></a>
    - <a href="#plogo" id="toc-plogo"><code>plogo</code></a>
    - <a href="#tidy_logo" id="toc-tidy_logo"><code>tidy_logo</code></a>
  - <a href="#ggp2" id="toc-ggp2"><code>ggp2</code></a>
    - <a href="#ggplot2" id="toc-ggplot2"><code>ggplot2::</code></a>
    - <a href="#gg" id="toc-gg"><code>gg</code></a>
    - <a href="#line" id="toc-line"><code>line</code></a>
  - <a href="#penguins" id="toc-penguins"><code>penguins</code></a>
    - <a href="#import" id="toc-import"><code>import</code></a>
    - <a href="#read-with-alias-get_csv"
      id="toc-read-with-alias-get_csv"><code>read</code> (with alias
      <code>get_csv</code>)</a>
    - <a href="#clean" id="toc-clean"><code>clean</code></a>
    - <a href="#ggp2-1" id="toc-ggp2-1"><code>ggp2</code></a>

Load `box`

``` r
# load with pak:
# https://pak.r-lib.org/
if (!requireNamespace('pak')) {
    install.packages('pak', repos = 'https://r-lib.github.io/p/pak/dev/')
}
pak::pkg_install('klmr/box@dev')
```

# `box` examples

The examples are in the directories below

    .
    ├── bio
    ├── env
    ├── ggp2
    ├── hello
    ├── penguins
    └── tidy

## Composing `box` modules

Below are some examples from the [`box` package
website](https://klmr.me/box/index.html#loading-code) for including
packages and functions.

| Inside box::use()      | Action                                                                                 |
|:-----------------------|:---------------------------------------------------------------------------------------|
| pkg                    | imports ‘pkg’, does not attach any function names                                      |
| p = pkg                | imports ‘pkg’ with alias (‘p’), does not attach any function names                     |
| pkg = pkg\[foo, bar\]  | imports ‘pkg’ and attaches the function names ‘pkg::foo()’ and ‘pkg::bar()’            |
| pkg\[my_foo = foo, …\] | imports ‘pkg’ with alias for ‘foo’ (‘my_foo’) and attaches all exported function names |

## `tidy`

This is a simple example for the Rhino app post.

    tidy
    ├── logo.R
    ├── plogo.R
    └── tidy_logo.R

I’m going to be using the `tidyverse::tidyverse_logo()` to demonstrate
different ways of importing a single function from a package in a `box`
module. It’s important to note `tidyverse` has been installed, but not
loaded.

``` r
tidyverse_logo()
# Error in tidyverse_logo(): could not find function "tidyverse_logo"
```

#### `logo`

Inside the `tidy/logo.R` is the `tidy/logo` module containing the
following code for importing the `tidyverse_logo()` function from the
`tidyverse` meta-package:

``` r
# contents of tidy/logo.R
#' @export
box::use(
  tidyverse[tidyverse_logo]
  )
```

I can import the `tidyverse_logo()` function (and only this function)
using the `tidy/logo` module:

``` r
box::use(tidy/logo)
logo
# <module: tidy/logo>
ls(logo)
# [1] "tidyverse_logo"
```

To use the `tidyverse_logo()` function, I use `$`:

``` r
logo$tidyverse_logo()
# ⬢ __  _    __   .    ⬡           ⬢  . 
#  / /_(_)__/ /_ ___  _____ _______ ___ 
# / __/ / _  / // / |/ / -_) __(_-</ -_)
# \__/_/\_,_/\_, /|___/\__/_/ /___/\__/ 
#      ⬢  . /___/      ⬡      .       ⬢
```

#### `plogo`

We can also include `box::use()` to import `tidyverse_logo()` *inside* a
custom function (`plogo`)

``` r
# contents of tidy/plogo.R

#' prints tidyverse logo
#' @export
print_logo = function(){
  # import pkg[fun] inside function
box::use(
  tidyverse[tidyverse_logo])
  # use fun
    tidyverse_logo()
}
```

Use this module just like `tidy/logo`:

``` r
box::use(tidy/plogo)
ls(plogo)
# [1] "print_logo"
```

``` r
plogo$print_logo()
# ⬢ __  _    __   .    ⬡           ⬢  . 
#  / /_(_)__/ /_ ___  _____ _______ ___ 
# / __/ / _  / // / |/ / -_) __(_-</ -_)
# \__/_/\_,_/\_, /|___/\__/_/ /___/\__/ 
#      ⬢  . /___/      ⬡      .       ⬢
```

Both methods import `tidyverse`’s `tidyverse::tidyverse_logo()`
function, but not the entire package:

``` r
tidyverse_logo()
# Error in tidyverse_logo(): could not find function "tidyverse_logo"
```

#### `tidy_logo`

The `tidy_logo` module contains the following:

``` r
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
```

Confirm both functions have been imported:

``` r
box::use(tidy/tidy_logo)
ls(tidy_logo)
# [1] "print_logo" "tidy_logo"
```

Are these identical?

``` r
identical(
  x = tidy_logo$print_logo(), 
  y = tidy_logo$tidy_logo()
  )
# [1] TRUE
```

## `ggp2`

First we’ll build a graph using the `ggplot2` functions and from the
package namespace:

### `ggplot2::`

``` r
ggplot2::ggplot(data = ggplot2::mpg, 
  ggplot2::aes(x = displ, y = hwy)) + 
  ggplot2::geom_point()
```

![](/Users/mjfrigaard/projects/rbox/boxes_files/figure-gfm/namespace-1.png)<!-- -->

In the `ggp2/` folder, we create the following files.

    # ggp2
    # ├── __init__.R
    # ├── gg.R
    # └── line.R

### `gg`

The `gg` module imports the full `ggplot2` package, but with `the` gg
alias.

``` r
#' Exporting ggplot2
#'
#' The \code{ggp2/gg} module exports ggplot2 functions
".__module__."

# contents of ggp2/gg.R

#' @export
box::use(
  ggplot2 = ggplot2[...]
  )
```

``` r
box::use(ggp2/gg)
gg
# <module: ggp2/gg>
```

This can now be used with `gg$`:

``` r
gg$ggplot(gg$mpg, 
  gg$aes(x = displ, y = hwy)) + 
  gg$geom_point()
```

![](/Users/mjfrigaard/projects/rbox/boxes_files/figure-gfm/use-module-gg-1.png)<!-- -->

### `line`

The `line` module contains a `graph()` function, which also imports the

``` r
# contents of ggp2/line.R

#' line functions from 
#' @export
box::use(
  ggplot2 = ggplot2[ggplot, aes, geom_point]
  )

#' graph function
#' @export
graph <- function() {
  ggplot(
    mpg,
    aes(x = displ, y = hwy)
  ) +
    geom_point()
}
```

``` r
# box::unload(line)
box::use(ggp2/line)
line
# <module: ggp2/line>
```

``` r
line$graph()
```

![](/Users/mjfrigaard/projects/rbox/boxes_files/figure-gfm/line-graph-1.png)<!-- -->

## `penguins`

Below I’m going to create a module that imports, wrangles, and
visualizes data from the [palmerpenguins
package.](https://allisonhorst.github.io/palmerpenguins/) (**which is
installed, but not loaded**).

### `import`

I’ll start with a simple `import` module from the `penguins` directory.
The code below is stored in `penguins/import.R`:

``` r
# penguins/import.R

box::use(
  readr[read_csv],
)

#' @export
import <- function() {
  raw_csv_url <- "https://bit.ly/3SQJ6E3"
  read_csv(raw_csv_url)
}
```

Load and use the module:

``` r
# load import module
box::use(
  penguins/import
)
# use import
import$import()
# Rows: 344 Columns: 17
# ── Column specification ────────────────────────────────────
# Delimiter: ","
# chr  (9): studyName, Species, Region, Island, Stage, Ind...
# dbl  (7): Sample Number, Culmen Length (mm), Culmen Dept...
# date (1): Date Egg
# 
# ℹ Use `spec()` to retrieve the full column specification for this data.
# ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
# # A tibble: 344 × 17
#    studyName Sample Nu…¹ Species Region Island Stage Indiv…²
#    <chr>           <dbl> <chr>   <chr>  <chr>  <chr> <chr>  
#  1 PAL0708             1 Adelie… Anvers Torge… Adul… N1A1   
#  2 PAL0708             2 Adelie… Anvers Torge… Adul… N1A2   
#  3 PAL0708             3 Adelie… Anvers Torge… Adul… N2A1   
#  4 PAL0708             4 Adelie… Anvers Torge… Adul… N2A2   
#  5 PAL0708             5 Adelie… Anvers Torge… Adul… N3A1   
#  6 PAL0708             6 Adelie… Anvers Torge… Adul… N3A2   
#  7 PAL0708             7 Adelie… Anvers Torge… Adul… N4A1   
#  8 PAL0708             8 Adelie… Anvers Torge… Adul… N4A2   
#  9 PAL0708             9 Adelie… Anvers Torge… Adul… N5A1   
# 10 PAL0708            10 Adelie… Anvers Torge… Adul… N5A2   
# # … with 334 more rows, 10 more variables:
# #   `Clutch Completion` <chr>, `Date Egg` <date>,
# #   `Culmen Length (mm)` <dbl>, `Culmen Depth (mm)` <dbl>,
# #   `Flipper Length (mm)` <dbl>, `Body Mass (g)` <dbl>,
# #   Sex <chr>, `Delta 15 N (o/oo)` <dbl>,
# #   `Delta 13 C (o/oo)` <dbl>, Comments <chr>, and
# #   abbreviated variable names ¹​`Sample Number`, …
```

This is loading the raw penguins data from the url.

### `read` (with alias `get_csv`)

I’ll create a new module in `penguins/` using an alias for `readr`s
`read_csv()` function (`get_csv`) and include the `readr::cols()`
function to remove the lengthy message.

This code is stored in the `penguins/read.R` file:

``` r
# penguins/read.R

box::use(
  readr[get_csv = read_csv, cols]
)

#' @export
raw <- function() {
  raw_csv_url <- "https://bit.ly/3SQJ6E3"
  # use alias for read_csv()
  get_csv(raw_csv_url, col_types = cols())
}
```

Load and use `read`

``` r
# load import module
box::use(
  penguins/read
)
# use import
raw_peng <- read$raw() 
raw_peng |> head()
# # A tibble: 6 × 17
#   studyName Sample Num…¹ Species Region Island Stage Indiv…²
#   <chr>            <dbl> <chr>   <chr>  <chr>  <chr> <chr>  
# 1 PAL0708              1 Adelie… Anvers Torge… Adul… N1A1   
# 2 PAL0708              2 Adelie… Anvers Torge… Adul… N1A2   
# 3 PAL0708              3 Adelie… Anvers Torge… Adul… N2A1   
# 4 PAL0708              4 Adelie… Anvers Torge… Adul… N2A2   
# 5 PAL0708              5 Adelie… Anvers Torge… Adul… N3A1   
# 6 PAL0708              6 Adelie… Anvers Torge… Adul… N3A2   
# # … with 10 more variables: `Clutch Completion` <chr>,
# #   `Date Egg` <date>, `Culmen Length (mm)` <dbl>,
# #   `Culmen Depth (mm)` <dbl>, `Flipper Length (mm)` <dbl>,
# #   `Body Mass (g)` <dbl>, Sex <chr>,
# #   `Delta 15 N (o/oo)` <dbl>, `Delta 13 C (o/oo)` <dbl>,
# #   Comments <chr>, and abbreviated variable names
# #   ¹​`Sample Number`, ²​`Individual ID`
```

This is a much nicer output (and less to type!)

### `clean`

After importing the raw penguins data, I’ll write a module for wrangling
the data (that also imports the \`read\`\` module).

This module takes the following steps:

- reset the `box.path`  
- import the `penguins/read` module  
- load the necessary functions from `dplyr`, `stringr`, and `janitor`  
- compose `prep()` with wrangling steps

``` r
# penguins/clean.R

# reset the path
options(box.path = getwd())

# import alias import module
box::use(
  penguins/read
)

# import wrangle pkgs/funs/aliases
box::use(
  dplyr[...],
  stringr[str_ext = str_extract],
  janitor[fix_cols = clean_names]
)

# wrangle data
prep = function() {
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
```

Load and use:

``` r
# load clean module
box::use(
  penguins/clean
)
clean$prep() |> str()
# tibble [344 × 7] (S3: tbl_df/tbl/data.frame)
#  $ species          : chr [1:344] "Adelie" "Adelie" "Adelie" "Adelie" ...
#  $ island           : chr [1:344] "Torgersen" "Torgersen" "Torgersen" "Torgersen" ...
#  $ bill_length_mm   : num [1:344] 39.1 39.5 40.3 NA 36.7 39.3 38.9 39.2 34.1 42 ...
#  $ bill_depth_mm    : num [1:344] 18.7 17.4 18 NA 19.3 20.6 17.8 19.6 18.1 20.2 ...
#  $ flipper_length_mm: num [1:344] 181 186 195 NA 193 190 181 195 193 190 ...
#  $ body_mass_g      : num [1:344] 3750 3800 3250 NA 3450 ...
#  $ sex              : Factor w/ 2 levels "FEMALE","MALE": 2 1 1 NA 1 2 1 2 NA NA ...
```

These data look like they’re ready for graphing! Time to write another
module…

### `ggp2`

I will build my visualization with `ggplot2` (in the `penguins/ggp2.R`
module) and `dplyr::filter()`:

``` r
# penguins/ggp2.R

# reset the path
options(box.path = getwd())

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
  prepped <- clean$prep()
  # remove missing sex
  filtered <- filter(prepped, !is.na(sex)) |> 
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
```

load the `penguins/ggp2` module

``` r
box::use(
  penguins/ggp2
)
ggp2
# <module: penguins/ggp2>
```

Check our scatter plot with `ggp2$scatter()`

``` r
ggp2$scatter()
```

![](/Users/mjfrigaard/projects/rbox/boxes_files/figure-gfm/use-scatter-1.png)<!-- -->

<!-- ![](https://raw.githubusercontent.com/mjfrigaard/rbox/main/boxes/scatter-out.png) -->

And there you have it! A complete pipeline using `box` modules. Next
I’ll explore using `penguins/__init__.R`

<!--

## `hello`

The following module in `hello/hello.R`:


```r
#' @export
hello = function (name) {
    message('Hello, ', name, '!')
}

#' @export
bye = function (name) {
    message('Goodbye ', name, '!')
}
```

To use this module, we can use `box::use()` and refer to the path (unquoted)


```r
box::use(hello/hello_world)
hello_world
# <module: hello/hello_world>
```

The functions are visible with `names()`


```r
names(hello_world)
# [1] "bye"   "hello"
```

To use the `hello()` and `bye()` functions in `box/hello_world.R`, we can use **`R script$function()`**:


```r
hello_world$hello('Martin')
# Hello, Martin!
hello_world$bye('Martin')
# Goodbye Martin!
```


## `bio/`

We'll run through the example from the [Get Started vignette](https://klmr.me/box/articles/box.html) (stored in `box/bio/`)


```
# bio/
# ├── __init__.r
# ├── __tests__
# │   ├── __init__.r
# │   ├── helper-module.r
# │   ├── test-seq.r
# │   └── test-table.r
# └── seq.r
```

To use this `box` module, we can run `box::use()` and pass the path to the script file containing the `box` functions


```r
box::use(bio/seq)
seq
# <module: bio/seq>
```

*What is in `seq`?* 

We can use `ls(seq)`


```r
ls(seq)
# [1] "is_valid" "revcomp"  "seq"      "table"
```

Accessing the help from `revcomp()`


```r
box::help(seq$revcomp)
# Loading required namespace: roxygen2
```

Using `seq()` in `seq`


```r
s = seq$seq(
    gene1 = 'GATTACAGATCAGCTCAGCACCTAGCACTATCAGCAAC',
    gene2 = 'CATAGCAACTGACATCACAGCG'
)
s
# 2 DNA sequences:
#   >gene1
#   GATTACAGATCAGCTCAGCACCTAGCA...
#   >gene2
#   CATAGCAACTGACATCACAGCG
```


```r
seq$is_valid(s)
# [1] TRUE
```


```r
getS3method('print', 'bio/seq')
# function(x) {
#   box::use(stringr[trunc = str_trunc])
# 
#   if (is.null(names(x))) names(x) <- paste("seq", seq_along(x))
# 
#   cat(
#     sprintf("%d DNA sequence%s:\n", length(x), if (length(x) == 1L) "" else "s"),
#     sprintf("  >%s\n  %s\n", names(x), trunc(x, 30L)),
#     sep = ""
#   )
#   invisible(x)
# }
# <environment: 0x7fde6c99efd0>
```

## Appendix

The `box/bio/seq.r` file contains the box module.


```
  #' Biological sequences
  #'
  #' The \code{bio/seq} module provides a type for representing DNA sequences.
  ".__module__."
  
  #' Test whether input is valid biological sequence
  #' @param seq a character vector or \code{seq} object
  #' @name seq
  #' @export
  is_valid <- function(seq) {
    UseMethod("is_valid")
  }
  
  is_valid.default <- function(seq) {
    nucleotides <- unlist(strsplit(seq, ""))
    nuc_index <- match(nucleotides, c("A", "C", "G", "T"))
    !any(is.na(nuc_index))
  }
  
  `is_valid.bio/seq` <- function(seq) {
    TRUE
  }
  
  #' Create a biological sequence
  #'
  #' \code{seq()} creates a set of nucleotide sequences from one or several
  #' character vectors consisting of \code{A}, \code{C}, \code{G} and \code{T}.
  #' @param ... optionally named character vectors representing DNA sequences.
  #' @return Biological sequence equivalent to the input string.
  #' @export
  seq <- function(...) {
    x <- toupper(c(...))
    stopifnot(is_valid(x))
    structure(x, class = "bio/seq")
  }
  
  #' Print one or more biological sequences
  `print.bio/seq` <- function(x) {
    box::use(stringr[trunc = str_trunc])
  
    if (is.null(names(x))) names(x) <- paste("seq", seq_along(x))
  
    cat(
      sprintf("%d DNA sequence%s:\n", length(x), if (length(x) == 1L) "" else "s"),
      sprintf("  >%s\n  %s\n", names(x), trunc(x, 30L)),
      sep = ""
    )
    invisible(x)
  }
  
  box::register_S3_method("print", "bio/seq", `print.bio/seq`)
  
  #' Reverse complement
  #'
  #' The reverse complement of a sequence is its reverse, with all nucleotides
  #' substituted by their base complement.
  #' @param seq character vector of biological sequences
  #' @name seq
  #' @export
  revcomp <- function(seq) {
    nucleotides <- strsplit(seq, "")
    complement <- lapply(nucleotides, chartr, old = "ACGT", new = "TGCA")
    revcomp <- lapply(complement, rev)
    seq(vapply(revcomp, paste, character(1L), collapse = ""))
  }
  
  #' Tabulate nucleotides present in sequences
  #' @param seq sequences
  #' @return A \code{\link[base::table]{table}} for the nucleotides of each
  #'  sequence in the input.
  #' @name seq
  #' @export
  table <- function(seq) {
    box::use(stats[set_names = setNames])
    nucleotides <- lapply(strsplit(seq, ""), factor, c("A", "C", "G", "T"))
    set_names(lapply(nucleotides, base::table, dnn = NULL), names(seq))
  }
  
  if (is.null(box::name())) {
    box::use(. / `__tests__`)
  }
```

-->
