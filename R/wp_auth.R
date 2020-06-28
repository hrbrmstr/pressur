oauth_app(
  appname = "wordpress",
  key = Sys.getenv("WORDPRESS_API_KEY"),
  secret = Sys.getenv("WORDPRESS_API_SECRET")
) -> wordpress_app

oauth_endpoint(
  base_url = "https://public-api.wordpress.com/oauth2",
  request = "authenticate",
  authorize = "authorize",
  access = "token"
) -> wordpress_endpoint

#' Authenticate to WordPress
#'
#' Call this at the start of any WordPress API interaction
#'
#' After authentication, the current running environment will contain
#' a copy of the token which the remaining functions will use and
#' the token will be returned invisibly.
#'
#' @param cache either `TRUE` (to read from the default {httr} oauth cache),
#'        `FALSE` (to not cache the oauth token), `NA` ({httr} will guess
#'        what to do using some sensible heuristics), or a string which will
#'        be used as a path to the cache file. You can use an environment
#'        variable `WP_OAUTH_CACHE` to populate this value. If no value is
#'        specified this value will default to `TRUE`.
#' @references <https://developer.wordpress.com/docs/oauth2/>
#' @return oauth token (invisibly)
#' @export
#' @examples
#' if (interactive()) {
#'   wp_auth()
#' }
wp_auth <- function(cache = Sys.getenv("WP_OAUTH_CACHE", unset = TRUE)) {

  oauth2.0_token(
    wordpress_endpoint,
    wordpress_app,
    user_params = list(
      grant_type = "authorization_code",
      response_type = "code",
      scope = "global"
    ),
    cache = cache
  ) -> wordpress_token

  .pkg$token <- wordpress_token
  .pkg$me <- wp_about_me()

  invisible(wordpress_token)

}