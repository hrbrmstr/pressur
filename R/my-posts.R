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

#' Get all posts across all sites of the authenticated user
#'
#' @references <https://developer.wordpress.com/docs/api/1.1/get/me/posts/>
#' @param context `edit` (default) for raw post source; `display` for HTML
#'        rendered source.
#' @param author id of the author or empty (the default) for 'all authors'
#' @param after,before (POSIXct or Date object or string that can be converted to one of those)
#'        Return posts dated before/after the specified datetime.
#' @param modified_after,modified_before (POSIXct or Date object) Return posts modified before/after
#'        the specified datetime.
#' @param status Comma-separated list of statuses for which to query, including any of:
#'        "publish", "private", "draft", "pending", "future", and "trash", or simply "any". Defaults to "publish"
#' @param search Search query checked against `title`, `content`, `category.name`, `tag.name`,
#'        and `author`, and will return results sorted by relevance. Limit: 250 characters
#' @param sites Optional comma-separated list of specific site IDs to further limit results
#' @param .quiet if `TRUE` then no progress information will be displayed
#' @export
#' @return data frame of posts
#' @examples
#' if (interactive()) {
#'   wp_auth()
#'   my_posts <- wp_get_posts()
#' }
wp_get_posts <- function(context = c("edit", "display"),
                         author = NULL,
                         after = NULL,
                         before = NULL,
                         modified_after = NULL,
                         modified_before = NULL,
                         status = NULL,
                         search = NULL,
                         sites = NULL,
                         .quiet=FALSE) {

  context <- match.arg(context[1], c("edit", "display"))

  if (!is.null(status)) {
    match.arg(
      status[1],
      c("publish", "private", "draft", "pending", "future", "trash", "any")
    ) -> status
  }

  after <- iso_it(after[1])
  before <- iso_it(before[1])
  modified_after <- iso_it(modified_after[1])
  modified_before <- iso_it(modified_before[1])

  httr::GET(
    url = "https://public-api.wordpress.com/rest/v1.1/me/posts",
    .add_bearer_token(),
    httr::accept_json(),
    query = list(
      context = context,
      author = author[1],
      after = after[1],
      before = before[1],
      modified_after = modified_after[1],
      modified_before = modified_before[1],
      status = status[1],
      search = search[1],
      sites = sites[1]
    )
  ) -> res

  httr::stop_for_status(res)

  pg <- httr::content(res)

  .posts <- list()
  .posts[[1]] <- pg

  n_pages <- ceiling(pg$found / 20)

  if (n_pages > 1) {

    progress::progress_bar$new(
      format = " retrieving posts [:bar:] :percent eta: :eta",
      total = n_pages - 1
    ) -> .pb

    for (idx in 2:n_pages) {
      if (!.quiet) .pb$tick()
      pg <- .wp_next_posts_page(pg)
      .posts[[idx]] <- pg
    }

  }

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

  .date <- try(anytime::anytime(.posts_df$date), silent = TRUE)
  .modified <- try(anytime::anytime(.posts_df$modified), silent = TRUE)

  if (!inherits(.date, "try-error")) .posts_df$date <- .date
  if (!inherits(.modified, "try-error")) .posts_df$modified <- .modified

  return(.posts_df)

}
