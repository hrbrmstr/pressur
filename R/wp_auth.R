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
#' @md
#' @references <https://developer.wordpress.com/docs/oauth2/>
#' @export
#' @examples \dontrun{
#' wp_auth()
#' }
wp_auth <- function() {

  oauth2.0_token(
    wordpress_endpoint,
    wordpress_app,
    user_params = list(
      grant_type = "authorization_code",
      response_type = "code",
      scope = "global"
    ),
    cache = TRUE
  ) -> wordpress_token

  .pkg$token <- wordpress_token

  invisible(wordpress_token)

}