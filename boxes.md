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

    #>  box/
    #>  └── hello_world.R

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
#>  <module: box/hello_world>
```

The functions are visible with `names()`

``` r
names(hello_world)
#>  [1] "bye"   "hello"
```

To use the `hello()` and `bye()` functions in `box/hello_world.R`, we
can use **`R script$function()`**:

``` r
hello_world$hello('Martin')
#>  Hello, Martin!
hello_world$bye('Martin')
#>  Goodbye Martin!
```
