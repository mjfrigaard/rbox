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

## Examples

The examples are in `box/`

    #>  box/
    #>  └── hello_world.R

### `hello_world`

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
str(hello_world)
#>  Class 'box$mod' <environment: 0x7f8f3c15ce08> 
#>   - attr(*, "name")= chr "mod:box/hello_world"
#>   - attr(*, "spec")=List of 5
#>    ..$ name    : chr "hello_world"
#>    ..$ prefix  : chr "box"
#>    ..$ attach  : NULL
#>    ..$ alias   : chr "hello_world"
#>    ..$ explicit: logi FALSE
#>    ..- attr(*, "class")= chr [1:2] "box$mod_spec" "box$spec"
#>   - attr(*, "info")=List of 2
#>    ..$ name       : chr "hello_world"
#>    ..$ source_path: chr "/Users/mjfrigaard/projects/rbox/boxes/box/hello_world.R"
#>    ..- attr(*, "class")= chr [1:2] "box$mod_info" "box$info"
#>   - attr(*, "namespace")=Class 'box$ns' <environment: 0x7f8f3c3878a8> 
#>    ..- attr(*, "name")= chr "namespace:hello_world"
#>    ..- attr(*, "loading")= logi FALSE
```

To use the `hello()` and `bye()` functions in `box/hello_world.R`, we
can use **`R script$function()`**:

``` r
hello_world$hello('Martin')
#>  Hello, Martin!
hello_world$bye('Martin')
#>  Goodbye Martin!
```
