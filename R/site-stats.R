#' Get a site's stats
#'
#' @md
#' @references <https://developer.wordpress.com/docs/api/1.1/get/sites/$site/stats/>
#' @param site site id or domain
#' @note I've only had this work successfully with my blog by using the site id.
#' @export
#' @examples \dontrun{
#' wp_auth()
#' me <- wp_about_me()
#' wp_site_stats(me$primary_blog)
#' }
wp_site_stats <- function(site) {

  httr::GET(
    url = sprintf("https://public-api.wordpress.com/rest/v1.1/sites/%s/stats", site),
    .add_bearer_token(),
    accept_json()
  ) -> res

  httr::stop_for_status(res)

  .stats <- httr::content(res)

  .stats$visits <- purrr::map_df(.stats$visits$data, ~purrr::set_names(.x, .stats$visits$fields))
  .stats$visits$period <-  anytime::anydate(.stats$visits$period)

  return(.stats)

}
