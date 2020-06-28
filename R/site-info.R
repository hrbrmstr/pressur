#' Get information about a site
#'
#' @references <https://developer.wordpress.com/docs/api/1.2/get/sites/$site/>
#' @param site site id or domain; if not specified, the primary site of the
#'        authenticated user will be used.
#' @export
#' @examples
#' if (interactive() {
#'   wp_auth()
#'   wp_site_info()
#' }
wp_site_info <- function(site) {

  if (missing(site)) {
    site_url <- .pkg$me$meta$links$site[1]
  } else {
    site_url <- sprintf("https://public-api.wordpress.com/rest/v1.2/sites/%s", site[1])
  }

  httr::GET(
    url = site_url,
    .add_bearer_token(),
    httr::accept_json()
  ) -> res

  httr::stop_for_status(res)

  httr::content(res)

}