#' Retrieve statistics for a WordPress post
#'
#' TODO: make most of the list columns more immediately usable
#'
#' @md
#' @references <https://developer.wordpress.com/docs/api/1.1/get/sites/$site/stats/post/$post_id/>
#' @param site site id or domain
#' @param post_id a valid post id
#' @note I've only had this work successfully with my blog by using the site id.
#' @export
#' @examples \dontrun{
#' wp_auth()
#' me <- wp_about_me()
#' wp_post_stats(me$primary_blog, "7713")
#' }
wp_post_stats <- function(site, post_id) {

  httr::GET(
    url = sprintf("https://public-api.wordpress.com/rest/v1.1/sites/%s/stats/post/%s", site, post_id),
    .add_bearer_token(),
    accept_json()
  ) -> res

  httr::stop_for_status(res)

  .stats <- httr::content(res)

  tibble::tibble(
    date = as.Date(.stats$date),
    views = .stats$views,
    years = list(.stats$years),
    averages = list(.stats$averages),
    weeks = list(.stats$weeks),
    fields = list(.stats$fields),
    data = list(.stats$data),
    highest_month = .stats$highest_month,
    highest_day_average = .stats$highest_day_average,
    highest_week_average = .stats$highest_week_average,
    post_detail = list(.stats$post)
  ) -> .stats_df

  return(.stats_df)

}
