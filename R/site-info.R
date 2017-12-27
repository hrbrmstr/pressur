#' Get information about a site
#'
#' @md
#' @references <https://developer.wordpress.com/docs/api/1.2/get/sites/$site/>
#' @param site site id or domain
#' @note I've only had this work successfully with my blog by using the site id.
#' @export
#' @examples \dontrun{
#' wp_auth()
#' me <- wp_about_me()
#' wp_site_info(me$primary_blog)
#' }
wp_site_info <- function(site) {

  httr::GET(
    url = sprintf("https://public-api.wordpress.com/rest/v1.2/sites/%s", site),
    httr::accept_json()
  ) -> res

  httr::stop_for_status(res)

  httr::content(res)

}