`box` notes
================

Package is loaded using [`pak`](https://pak.r-lib.org/), which checks
for installation, and then loads `pak` with `pak::pkg_install()`

``` r
if (!requireNamespace('pak')) {
    install.packages('pak', repos = 'https://r-lib.github.io/p/pak/dev/')
}
pak::pkg_install('klmr/box@dev')
```

## Most interesting thing about `box`?

> `box` completely replaces the base R `library` and `require` functions

### What else does `box` do?

> enables *writing modular code* by treating files and folders of R code
> as independent (potentially nested) modules, without requiring the
> user to wrap reusable code into packages.

And

> It provides a new syntax to import reusable code (both from packages
> and from modules) which is more powerful and less error-prone than
> `library` or `require`, by limiting the number of names that are made
> available

Traditionally **reusable code** is accomplished by creating [R
packages,](https://r-pkgs.org/index.html)

> *Packages are the fundamental units of reproducible R code. They
> include reusable R functions, the documentation that describes how to
> use them, and sample data.*

## What problems does `box` solve?

**“*How can I use a function from a package without loading ALL the
functions in that package?*”**

- This is essentially occurring when we use `pkg::fun()`, but the
  standard practice assumes we’ve imported all functions within the
  package using `library(package)`

- From help on `library`:

  <div>

  > *`library(package)` and `require(package)` both load the namespace
  > of the package with `name package` and attach it on the search list.
  > `require` is designed for use inside other functions; it returns
  > `FALSE` and gives a warning (rather than an error as `library()`
  > does by default) if the package does not exist. Both functions check
  > and update the list of currently attached packages and do not reload
  > a namespace which is already loaded*

  </div>

**“*Which function (`name`) comes from which package?*”**

- Again, we can see this when we explicitly call `pkg::fun()`, but `box`
  makes the function and package namespacing **explicit** by using:

  ``` r
  box::use(pkg = [pkg, fun])
  ```

<!-- -->

- If we’re developing a package, we can use `@import` or `@importFrom`,
  but these are only used in that context. The `roxygen2` package
  converts the [tags into a
  **directive**](https://r-pkgs.org/dependencies-mindset-background.html#sec-dependencies-namespace):

| `roxygen2`    | `NAMESPACE` directive                                                                                                     |
|---------------|---------------------------------------------------------------------------------------------------------------------------|
| `@importFrom` | `importFrom()` : import *selected* object from another `NAMESPACE` (including S4 generics)                                |
| `@import`     | `import()`: import all objects from another package’s `NAMESPACE`.                                                        |
| `@export`     | `export()` : export the function, method, generic, or class so it’s available outside of the package (in the `NAMESPACE`) |

- “*It is possible, but not generally recommended to import all
  functions from a package with `@import` package. This is risky if you
  import functions from more than one package, because while it might be
  OK today, in the future the packages might end up with a function
  having the same name, and your users will get a warning every time
  your package is loaded*.” - [`roxygen2`
  package](https://roxygen2.r-lib.org/articles/namespace.html#imports)

- Outside of the package (or shiny app) development, explicit
  namespacing isn’t typically considered.

## The `NAMESPACE`

Some background on the `NAMESPACE` from
[r-pkgs](https://bookdown.dongzhuoer.com/hadley/r-pkgs/namespace.html):

> *…having a high quality namespace helps encapsulate your package and
> makes it self-contained. This ensures that other packages won’t
> interfere with your code, that your code won’t interfere with other
> packages, and that your package works regardless of the environment in
> which it’s run.*

However, when we use `library(package)` , we load ALL the functions from
a package, which `box` discourages:

> *attaching everything is generally **discouraged**…since it leads to
> name clashes, and makes it harder to retrace which names belong to
> what packages.*

> *To make code more explicit, readable and maintainable, software
> engineering best practices encourage limiting both the scope of names,
> as well as the number of names available in each scope*

***“If I write a function for a specific task in a project (or shiny
app), how can I reuse it without building a package?”***

- With `box`, we can nest R scripts (or *modules*) and add the
  `#' export` in front of the functions to be included in the
  `NAMESPACE` search list

What is the ‘search list’? This is accessible using the `search()`
function:

``` r
# what does search() do?
search()
#>   [1] ".GlobalEnv"        "package:cli"      
#>   [3] "package:lubridate" "package:forcats"  
#>   [5] "package:stringr"   "package:dplyr"    
#>   [7] "package:purrr"     "package:readr"    
#>   [9] "package:tidyr"     "package:tibble"   
#>  [11] "package:ggplot2"   "package:tidyverse"
#>  [13] "package:stats"     "package:graphics" 
#>  [15] "package:grDevices" "package:utils"    
#>  [17] "package:datasets"  "package:methods"  
#>  [19] "Autoloads"         "package:base"
```
