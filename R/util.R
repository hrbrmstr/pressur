.add_bearer_token <- function() {
  httr::add_headers(`Authorization` = sprintf("Bearer %s", .pkg$token$credentials$access_token))
}
