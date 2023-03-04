#' @export
f = function() {
  message("Exported f() from env/b")
}

g = function() {
  message("Non-exported g() from env/b")
}