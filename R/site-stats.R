#' Get a site's stats
#'
#' @references <https://developer.wordpress.com/docs/api/1.1/get/sites/$site/stats/>
#' @param site site id or domain; if not specified, the primary site of the
#'        authenticated user will be used.
#' @return list with a great deal of stats metadata. You are probably most
#'         interested in the `visits` element.
#' @export
#' @examples
#' if (interactive()) {
#'   wp_auth()
#'   wp_site_stats()
#' }
wp_site_stats <- function(site) {

  if (missing(site)) {
    site_stats_url <- paste0(.pkg$me$meta$links$site[1], "/stats")
  } else {
    site_stats_url <- sprintf("https://public-api.wordpress.com/rest/v1.2/sites/%s/stats", site[1])
  }

  httr::GET(
    url = site_stats_url,
    .add_bearer_token(),
    accept_json()
  ) -> res

  httr::stop_for_status(res)

  .stats <- httr::content(res)

  .stats$visits <- purrr::map_df(.stats$visits$data, ~purrr::set_names(.x, .stats$visits$fields))
  .stats$visits$period <- anytime::anydate(.stats$visits$period)

  return(.stats)

}
