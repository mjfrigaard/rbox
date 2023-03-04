#' @export
box::use(./b[g = f, ...])

box::use(./c[...])

#' @export
box::use(./c)

#' @export
f = function() {
  message("Exported f() from env/a")
}

f_of_c1 = c$f
f_of_c2 = get('f', parent.env(environment()))
stopifnot(identical(f_of_c1, f_of_c2))