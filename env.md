`env` vignette
================

- <a href="#module-env" id="toc-module-env">module <code>env</code></a>
  - <a href="#c" id="toc-c"><code>c</code></a>
  - <a href="#b" id="toc-b"><code>b</code></a>
  - <a href="#a" id="toc-a"><code>a</code></a>
  - <a href="#calling-c-from-a" id="toc-calling-c-from-a">Calling
    <code>c</code> from <code>a</code></a>
  - <a href="#calling-b-as-g-from-a" id="toc-calling-b-as-g-from-a">Calling
    <code>b</code> (as <code>g</code>) from <code>a</code></a>
  - <a href="#calling-a-from-a" id="toc-calling-a-from-a">Calling
    <code>a</code> from <code>a</code></a>
  - <a href="#f-of-c-1" id="toc-f-of-c-1"><code>f()</code> of <code>c</code>
    (1)</a>
  - <a href="#f-of-c-2" id="toc-f-of-c-2"><code>f()</code> of <code>c</code>
    (2)</a>

`box` is loaded using [`pak`](https://pak.r-lib.org/), which checks for
installation, and then loads with `pak::pkg_install()`.

``` r
if (!requireNamespace('pak')) {
    install.packages('pak', repos = 'https://r-lib.github.io/p/pak/dev/')
}
pak::pkg_install('klmr/box@dev')
```

# module `env`

This covers the “*The hierarchy of module environments*”
[vignette.](https://klmr.me/box/articles/mod-env-hierarchy.html) These
modules are stored in the `env/` folder

    # env
    # ├── a.R
    # ├── b.R
    # └── c.R

## `c`

> `c`1) defines and exports `f()`

``` r
# c1) defines and exports f()
#' @export
f = function() {
  "c$f"
}
```

## `b`

> - `b`1) defines and exports `f()`
>
> - `b`2) defines (but doesn’t export) `g()`

``` r
# b1) defines and exports f()
#' @export
f = function() {
  "b$f"
}

# b2) defines (but doesn't export) g()
g = function() {
  "b$g"
}
```

## `a`

> `a`1) imports and re-exports all names from `b` (changing the name of
> `b$f` to `g`)
>
> `a`2) imports, but does not re-export, all names from `c`
>
> `a`3) additionally, defines an alias for the module, which it exports

``` r
# a1) imports/re-exports all names from b (alias b$f as 'g')
#' @export
box::use(./b[g = f, ...]) 

# 2) imports (doesn't re-export) all names from c
box::use(./c[...]) 

# additionally, defines an alias for the module, which it exports
#' @export
box::use(./c)

#' @export
f = function() {
  "a$f"
}

f_of_c1 = c$f
f_of_c2 = get('f', parent.env(environment()))
stopifnot(identical(f_of_c1, f_of_c2))
```

> If users create a module alias in their `box::use` call, the alias
> will be a reference to this environment.

``` r
box::use(a = env/a[f, g])
a
# <module: env/a>
```

## Calling `c` from `a`

The `a` module is available to me as `a$c`

``` r
ls(a$c)
# [1] "f"
```

It’s function is available as `a$c$f()`

``` r
a$c$f()
# Exported c$f() from env/c
```

## Calling `b` (as `g`) from `a`

`b` uses the `g()` alias here, and only exported `f()`

``` r
a$g()
# Exported f() from env/b
```

## Calling `a` from `a`

We can access the `f()` function from a using `a$f()`

``` r
a$f()
# Exported f() from env/a
```

## `f()` of `c` (1)

`f_of_c1` stores `c$f()` from `a$c$f`

``` r
f_of_c1 = a$c$f
f_of_c1
# function() {
#   message("Exported c$f() from env/c")
# }
# <environment: 0x7f78d35007f0>
```

## `f()` of `c` (2)

`f_of_c2` stores the environment of `a$f()` function

``` r
environment()
# <environment: 0x7f78d2839eb8>
parent.env(environment())
# <module: env/a>
```

``` r
f_of_c2 = get("f", pos = parent.env(environment()))
f_of_c2
# function() {
#   message("Exported f() from env/a")
# }
# <environment: 0x7f78d4198800>
```
