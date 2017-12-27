.wp_next_posts_page <- function(.x) {

  ret <- NULL

  if (!is.null(.x$meta$next_page)) {

    httr::GET(
      url = "https://public-api.wordpress.com/rest/v1.1/me/posts",
      query = list(page_handle = .x$meta$next_page),
      .add_bearer_token(),
      httr::accept_json()
    ) -> res

    return(httr::content(res))

  }

  return(ret)

}

#' Get all 'my' posts across all sites
#'
#' @md
#' @references <https://developer.wordpress.com/docs/api/1.1/get/me/posts/>
#' @param .quiet if `TRUE` then no progress information will be displayed
#' @export
#' @examples \dontrun{
#' wp_auth()
#' my_posts <- wp_get_my_posts()
#' }
wp_get_my_posts <- function(.quiet=FALSE) {

  httr::GET(
    url = "https://public-api.wordpress.com/rest/v1.1/me/posts",
    .add_bearer_token(),
    httr::accept_json()
  ) -> res

  httr::stop_for_status(res)

  pg <- httr::content(res)

  .posts <- list()
  .posts[[1]] <- pg

  n_pages <- ceiling(pg$found / 20)

  for (idx in 2:n_pages) {
    if (!.quiet) cat(crayon::green("."), sep="")
    pg <- .wp_next_posts_page(pg)
    .posts[[idx]] <- pg
  }
  if (!.quiet) cat("\n",sep="")

  purrr::map_df(.posts, ~{

    purrr::map_df(.x$posts, ~{

      list(
        post_id = as.character(.x$ID),
        site_id = as.character(.x$site_ID),
        author = list(.x$author),
        date = .x$date,
        modified = .x$modified,
        title = .x$title,
        url = .x$URL,
        short_url = .x$short_URL,
        content = .x$content,
        excerpt = .x$excerpt,
        slug = .x$slug,
        guid = .x$guid,
        status = .x$status,
        sticky = .x$sticky,
        password = .x$password,
        parent = .x$parent,
        type = .x$type,
        discussion = list(.x$discussion),
        likes_enabled = .x$likes_enabled,
        sharing_enabled = .x$sharing_enabled,
        like_count = .x$like_count,
        i_like = .x$i_like,
        is_reblogged = .x$is_reblogged,
        is_following = .x$is_following,
        global_id = .x$global_ID,
        featured_image = .x$featured_image,
        post_thumbnail = list(.x$post_thumbnail),
        format = .x$format,
        geo = .x$geo,
        menu_order = .x$menu_order,
        page_template = .x$page_template,
        publicize_urls = list(.x$publicize_URLs),
        terms = list(.x$terms),
        tags = list(.x$tags),
        categories = list(.x$categories),
        attachments = list(.x$attachments),
        attachment_count = list(.x$attachment_count),
        metadata = list(.x$metadata),
        meta = list(.x$meta),
        capabilities = list(.x$capabilities),
        other_URLs = list(.x$other_URLs)
      )

    })

  }) -> .posts_df

  .posts_df$date <- anytime::anytime(.posts_df$date)
  .posts_df$modified <- anytime::anytime(.posts_df$modified)

  return(.posts_df)

}
