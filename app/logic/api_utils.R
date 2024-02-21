box::use(
  httr2[
    request,
    req_auth_bearer_token,
    req_dry_run,
    req_perform,
    resp_body_string,
    req_user_agent
  ],
  magrittr[`%>%`],
  jsonlite[fromJSON],
  dplyr[filter],
  glue[glue]
)

#' Simple function to get the access token from environment
#' @return Character token, if present
get_access_token <- function() {
  token <- Sys.getenv(
    "CONNECT_API_KEY",
    unset = "NO_TOKEN"
  )
  if (token == "NO_TOKEN" || token == "") {
    stop("Are you sure your CONNECT_API_KEY is set?")
  } else {
    token
  }
}

#' Simple function to make an API url
#' @param host Character. Default CONNECT_SERVER set as an envvar
#' @param endpoint Character. Default is "content"
#' @param versioned Logical. Whether to use versioned API. Default is FALSE
#' @return url for the API
get_api_url <- function(
  host = Sys.getenv("CONNECT_SERVER"),
  endpoint = "content",
  version = "v1"
) {
  glue("{host}__api__/{version}/{endpoint}/")
}

#' Function to get a list of all apps belonging to the token
#'
#' @param app_mode_filter Character. The filter for app_mode in the API
#' response. Default is "shiny".
#' @param url Character. The URL for API endpoint
#' @param dry_run Logical. Whether to dry run the API for debugging.
#' Default is FALSE
#' @export
get_app_list <- function(
  app_mode_filter = "shiny",
  endpoint = "content",
  dry_run = FALSE
) {

  url <- get_api_url(
    endpoint = endpoint
  )

  api_request <- request(url) %>%
    req_user_agent("LogAnalyzer") %>%
    req_auth_bearer_token(get_access_token())

  if (dry_run) {
    api_request %>%
      req_dry_run()
  } else {
    api_request %>%
      req_perform() %>%
      resp_body_string() %>%
      fromJSON() %>%
      filter(app_mode == app_mode_filter)
  }
}

#' Function to get a list of all jobs for a specific app
#'
#' @param guid Character. The guid for the app in question
#' @param url Character. The URL for API endpoint
#' @param dry_run Logical. Whether to dry run the API for debugging.
#' Default is FALSE
#' @export
get_job_list <- function(
  guid = NULL,
  endpoint = "content",
  dry_run = FALSE
) {

  url <- get_api_url(
    endpoint = endpoint
  )

  api_request <- request(
    glue("{url}{guid}/jobs")
  ) %>%
    req_user_agent("LogAnalyzer") %>%
    req_auth_bearer_token(get_access_token())

  if (dry_run) {
    api_request %>%
      req_dry_run()
  } else {
    api_request %>%
      req_perform() %>%
      resp_body_string() %>%
      fromJSON()
  }
}

#' Function to get a list of all logs for a job for a specific app
#'
#' @param guid Character. The guid for the app in question
#' @param job_key Character. The key for the job in question
#' @param url Character. The URL for API endpoint
#' @param tail Logical. Whether to show the tail only for the logs
#' @param dry_run Logical. Whether to dry run the API for debugging.
#' Default is FALSE
#' @export
get_job_logs <- function(
  guid = NULL,
  job_key = NULL,
  endpoint = "content",
  tail = FALSE,
  dry_run = FALSE
) {

  url <- get_api_url(
    endpoint = endpoint
  )

  api_request <- request(
    glue("{url}{guid}/jobs/{job_key}/{ifelse(tail, 'tail', 'log')}")
  ) %>%
    req_user_agent("LogAnalyzer") %>%
    req_auth_bearer_token(get_access_token())

  if (dry_run) {
    api_request %>%
      req_dry_run()
  } else {
    logs <- api_request %>%
      req_perform() %>%
      resp_body_string() %>%
      fromJSON()
    logs["entries"] %>%
      data.frame()
  }
}

#' Function to download the logfile for a specific app
#'
#' @param guid Character. The guid for the app in question
#' @param job_key Character. The key for the job in quesrtion
#' @param url Character. The URL for API endpoint
#' @param dry_run Logical. Whether to dry run the API for debugging.
#' Default is FALSE
#' @export
download_job_logs <- function(
  guid = NULL,
  job_key = NULL,
  endpoint = "content",
  dry_run = FALSE
) {

  url <- get_api_url(
    endpoint = endpoint
  )

  api_request <- request(
    glue("{url}{guid}/jobs/{job_key}/download")
  ) %>%
    req_user_agent("LogAnalyzer") %>%
    req_auth_bearer_token(get_access_token())

  if (dry_run) {
    api_request %>%
      req_dry_run()
  } else {
    api_request %>%
      req_perform() %>%
      resp_body_string()
  }
}
