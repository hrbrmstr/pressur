#' Get metadata about the current user.
#'
#' @references <https://developer.wordpress.com/docs/api/1.1/get/me/>
#' @return list with user metadata
#' @export
#' @examples
#' if (interactive()) {
#'   wp_auth()
#'   wp_about_me()
#' }
wp_about_me <- function() {

  httr::GET(
    url = sprintf("https://public-api.wordpress.com/rest/v1.1/me"),
    .add_bearer_token(),
    httr::accept_json()
  ) -> res

  httr::stop_for_status(res)

  httr::content(res)

}