`box` internals
================

Package is loaded using [`pak`](https://pak.r-lib.org/), which checks
for installation, and then loads with `pak::pkg_install()`.

``` r
if (!requireNamespace('pak')) {
    install.packages('pak', repos = 'https://r-lib.github.io/p/pak/dev/')
}
pak::pkg_install('klmr/box@dev')
```

# Internals

For this example, we’ll use the example in `box/`

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

## What is `hello_world`?

We can use the `get_info()` function to explore it’s contents:

``` r
get_info(hello_world)
#>  object: `hello_world`
#>      attributes => name, class, spec, info, namespace
#>      class => box$mod
#>      type => environment
#>      *mode => environment
```

This tells me there are multiple nested attributes in the `box$mod`
class.

## `"box$mod"`

If we look at the structure of hello_world, we can see the multiple
layers of attributes and classes:

``` r
str(hello_world)
#>  Class 'box$mod' <environment: 0x7fc3f0b38008> 
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
#>   - attr(*, "namespace")=Class 'box$ns' <environment: 0x7fc3ef487cf8> 
#>    ..- attr(*, "name")= chr "namespace:hello_world"
#>    ..- attr(*, "loading")= logi FALSE
```

### `"environment"` name

``` r
environmentName(hello_world)
#>  [1] "mod:box/hello_world"
```

### “name”

``` r
attr(hello_world, "name")
#>  [1] "mod:box/hello_world"
```

This is a character vector

``` r
attr(hello_world, "name") |> str()
#>   chr "mod:box/hello_world"
```

### “spec”

``` r
attr(hello_world, "spec")
#> mod_spec(mod(box/hello_world))
```

This is a list of five items: 3 character vectors (`name`, `prefix`,
`alias`), one logical vector (`explicit`), and one `NULL` value
(`attach`)

``` r
attr(hello_world, "spec") |> str()
#>  List of 5
#>   $ name    : chr "hello_world"
#>   $ prefix  : chr "box"
#>   $ attach  : NULL
#>   $ alias   : chr "hello_world"
#>   $ explicit: logi FALSE
#>   - attr(*, "class")= chr [1:2] "box$mod_spec" "box$spec"
```

There’s also a nested class in the `"spec"`

``` r
attr(hello_world, "spec") |> class()
#>  [1] "box$mod_spec" "box$spec"
```

### “info”

The `"info"` attribute contains the full path to the module.

``` r
attr(hello_world, "info")
#> <mod_info: hello_world at /Users/mjfrigaard/projects/rbox/boxes/box/hello_world.R>
```

The `"info"` attribute is a list with two items and two classes

``` r
attr(hello_world, "info") |> str()
#>  List of 2
#>   $ name       : chr "hello_world"
#>   $ source_path: chr "/Users/mjfrigaard/projects/rbox/boxes/box/hello_world.R"
#>   - attr(*, "class")= chr [1:2] "box$mod_info" "box$info"
```

The `"info"` attribute contains two classes:

``` r
attr(hello_world, "info") |> class()
#>  [1] "box$mod_info" "box$info"
```

The `"info"` attribute list has a `'name'`

``` r
attr(hello_world, "info")['name']
#>  $name
#>  [1] "hello_world"
```

The `"info"` attribute list also has a `'source_path'`

``` r
attr(hello_world, "info")['source_path']
#>  $source_path
#>  [1] "/Users/mjfrigaard/projects/rbox/boxes/box/hello_world.R"
```

### “namespace”

The namespace has an environment and three attributes (`"name"`,
`"class"`, `"loading"`)

``` r
attr(hello_world, "namespace")
#>  <environment: 0x7fc3ef487cf8>
#>  attr(,"name")
#>  [1] "namespace:hello_world"
#>  attr(,"class")
#>  [1] "box$ns"
#>  attr(,"loading")
#>  [1] FALSE
```

The `"name"` of the `"namespace"` attributes is a character vector

``` r
attr(hello_world, "namespace") |> attr("name") |> str()
#>   chr "namespace:hello_world"
```

The `class` of the `"namespace"` attribute is `"box$ns"`

``` r
attr(hello_world, "namespace") |> class()
#>  [1] "box$ns"
```

The `loading` attribute of the `"namespace"` attribute is a logical
(`FALSE`)

``` r
attr(hello_world, "namespace") |> attr("loading") |> str()
#>   logi FALSE
```
