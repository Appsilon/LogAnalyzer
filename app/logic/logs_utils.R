box::use(
  glue[glue],
  shiny[
    div,
    icon
  ],
)

box::use(
  app/logic/general_utils[check_text_error, format_timestamp],
)

#' Function to process each row for the log table
#' This creates the HTML for the row
#'
#' @export
process_log_data <- function(
  log_data
) {
  log_info <- strsplit(log_data, "_-_")[[1]]
  div(
    class = glue("log-entry {log_info[4]}-highlight"),
    icon(
      name = log_info[5],
      class = glue(
        "log-status {log_info[4]}-text fa-solid"
      ),
    ),
    div(
      class = "log-info-block",
      div(
        class = glue("log-info {log_info[4]}-text"),
        log_info[3]
      ),
      div(
        class = "log-time",
        format_timestamp(log_info[2])
      )
    )
  )
}

#' @export
get_status_info <- function(
  output_type,
  log_data
) {
  if (output_type == "stdout") {
    status_list <- list("green", "circle-info")
  } else if (output_type == "stderr" && check_text_error(log_data)) {
    status_list <- list("red", "circle-xmark")
  } else {
    status_list <- list("yellow", "circle-info")
  }
  names(status_list) <- c("entries.status", "entries.icon")
  status_list
}
