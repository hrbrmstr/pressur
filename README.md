
# pressur

Query and Orchestrate the ‘WordPress’ ‘API’

## Description

‘WordPress’ has a fairly comprehensive ‘API’
<https://developer.wordpress.com/> that makes it possible to perform
blog orchestration (‘CRUD’ operations on posts, users, sites, etc.) as
well as retrieve and process blog statistics. Tools are provided to work
with the ‘WordPress’ ‘API’ functions.

### `<dalek_voice>` YOU WILL O-BEY `</dalek_voice>`

WordPress API requiring authentication means you have to do the OAuth2
dance, and most API calls require authentication. That means you need to
start off working with the WordPress API in/from `pressur` using the
`wp_auth()` function. For that to work, **YOU MUST**::

\=\> Go here and make an app: <https://developer.wordpress.com/apps/>

\=\> Put the `Client ID` you receive into `~/.Renviron` with a line that
looks like:

    `WORDPRESS_API_KEY=#####`

\=\> Put the `Client Secret` you receive into `~/.Renviron` with a line
that looks like:

    `WORDPRESS_API_SECRET=Yn50ds........`

And start with a fresh R session for any of this to even have a remote
possibility of working.

I’ll make friendlier documentation for ^^ in the near future.

### NOTE

Only minimal functionality is provided at present (enough to get stats
out).

You are encouraged to poke around the source and contribute PRs or
issues for high priority items you’d like to see in the package.

## What’s Inside The Tin

The following functions are implemented:

  - `wp_auth`: Authenticate to WordPress
  - `wp_about_me`: Get your user information
  - `wp_get_my_posts`: Get all ‘my’ posts across all sites
  - `wp_post_stats`: Retrieve statistics for a WordPress post
  - `wp_site_info`: Get information about a site
  - `wp_site_stats`: Get a site’s stats

## Installation

``` r
devtools::install_github("hrbrmstr/pressur")
```

## Usage

``` r
library(pressur)

# current verison
packageVersion("pressur")
```

    ## [1] '0.1.0'

### Basic operation

``` r
wp_auth()
me <- wp_about_me()
dplyr::glimpse(wp_site_stats(me$primary_blog))
```

    ## List of 3
    ##  $ date  : chr "2017-12-27"
    ##  $ stats :List of 24
    ##   ..$ visitors_today                 : int 86
    ##   ..$ visitors_yesterday             : int 129
    ##   ..$ visitors                       : int 203068
    ##   ..$ views_today                    : int 151
    ##   ..$ views_yesterday                : int 178
    ##   ..$ views_best_day                 : chr "2017-05-15"
    ##   ..$ views_best_day_total           : int 3984
    ##   ..$ views                          : int 347802
    ##   ..$ comments                       : int 1324
    ##   ..$ posts                          : int 445
    ##   ..$ followers_blog                 : int 197
    ##   ..$ followers_comments             : int 132
    ##   ..$ comments_per_month             : int 16
    ##   ..$ comments_most_active_recent_day: chr "2015-10-05 19:39:56"
    ##   ..$ comments_most_active_time      : chr "N/A"
    ##   ..$ comments_spam                  : int 0
    ##   ..$ categories                     : int 209
    ##   ..$ tags                           : int 695
    ##   ..$ shares                         : int 0
    ##   ..$ shares_twitter                 : int 0
    ##   ..$ shares_print                   : int 0
    ##   ..$ shares_linkedin                : int 0
    ##   ..$ shares_google-plus-1           : int 0
    ##   ..$ shares_email                   : int 0
    ##  $ visits:Classes 'tbl_df', 'tbl' and 'data.frame':  30 obs. of  3 variables:
    ##   ..$ period  : Date[1:30], format: "2017-11-28" "2017-11-29" "2017-11-30" "2017-12-01" ...
    ##   ..$ views   : int [1:30] 364 389 451 427 432 204 353 424 573 354 ...
    ##   ..$ visitors: int [1:30] 253 268 300 319 325 154 254 312 399 259 ...

## Code of Conduct

Please note that this project is released with a [Contributor Code of
Conduct](CONDUCT.md). By participating in this project you agree to
abide by its terms.
