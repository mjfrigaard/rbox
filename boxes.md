`box` examples
================

Package is loaded using [`pak`](https://pak.r-lib.org/), which checks
for installation, and then loads with `pak::pkg_install()`.

``` r
if (!requireNamespace('pak')) {
    install.packages('pak', repos = 'https://r-lib.github.io/p/pak/dev/')
}
pak::pkg_install('klmr/box@dev')
```

# Examples

The examples are in `box/`

    # box/
    # ├── bio
    # │   ├── __init__.r
    # │   ├── __tests__
    # │   └── seq.r
    # ├── c
    # │   ├── Makevars
    # │   ├── __init__.r
    # │   ├── __setup__.r
    # │   └── hello.c
    # ├── hello_world.R
    # └── penguins
    #     └── import.R

## `hello_world`

Now assume we’ve stored the following module in `box/hello.R`:

``` r
#' @export
hello = function (name) {
    message('Hello, ', name, '!')
}

#' @export
bye = function (name) {
    message('Goodbye ', name, '!')
}
```

To use this module, we can use `box::use()` and refer to the path
(unquoted)

``` r
box::use(box/hello_world)
hello_world
# <module: box/hello_world>
```

The functions are visible with `names()`

``` r
names(hello_world)
# [1] "bye"   "hello"
```

To use the `hello()` and `bye()` functions in `box/hello_world.R`, we
can use **`R script$function()`**:

``` r
hello_world$hello('Martin')
# Hello, Martin!
hello_world$bye('Martin')
# Goodbye Martin!
```

## `bio/`

We’ll run through the example from the [Get Started
vignette](https://klmr.me/box/articles/box.html) (stored in `box/bio/`)

    # box/bio/
    # ├── __init__.r
    # ├── __tests__
    # │   ├── __init__.r
    # │   ├── helper-module.r
    # │   ├── test-seq.r
    # │   └── test-table.r
    # └── seq.r

To use this `box` module, we can run `box::use()` and pass the path to
the script file containing the `box` functions

``` r
box::use(box/bio/seq)
seq
# <module: box/bio/seq>
```

What is in `seq`? We can use `ls(seq)`

``` r
ls(seq)
# [1] "is_valid" "revcomp"  "seq"      "table"
```

``` r
box::help(seq$revcomp)
# Loading required namespace: roxygen2
```

Use `seq()` in `seq`

``` r
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

``` r
seq$is_valid(s)
# [1] TRUE
```

``` r
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
# <environment: 0x7f8e90188808>
```

## Writing `box` modules

I am going to create a module that imports, performs some basic
wrangling, and then visualizes a dataset.

The data comes from the
[palmerpenguins](https://allisonhorst.github.io/palmerpenguins/) package
(**which I will install but not load here**).

The url to the raw data as a .csv is stored in raw_csv_url:

``` r
# box/penguins/import.R

box::use(
  vroom[vroom],
)

#' @export
import_penguins <- function() {
  raw_csv_url <- "https://raw.githubusercontent.com/allisonhorst/palmerpenguins/main/inst/extdata/penguins_raw.csv"
  vroom(raw_csv_url)
}
```

``` r
# load import module
box::use(
  box/penguins/import
)
# use import_penguins
import$import_penguins()
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

## Appendix

The `box/bio/seq.r` file contains the box module.

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
