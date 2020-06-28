.add_bearer_token <- function() {
  httr::add_headers(`Authorization` = sprintf("Bearer %s", .pkg$token$credentials$access_token))
}

iso_it <- function(x) {

  if (is.null(x)) return(x)

  if (is.character(x)) x <- anytime::anytime(x)

  if (!inherits(x, c("Date", "POSIXct"))) {
    stop("Speficied object is not a Date, POSIXct, or compatible string.", call.=FALSE)
  }

  anytime::iso8601(x)

}