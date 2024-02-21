box::use(
  glue[glue],
  shiny[
    icon,
    div
  ]
)

box::use(
  app/logic/general_utils[check_text_error, format_timestamp]
)

#' Function to process each row for the log table
#' This creates the HTML for the row
#'
#' @export
process_log_data <- function(
  log_data
) {
  log_info <- strsplit(log_data, "_-_")[[1]]
  status <- get_status_info(log_info[1], log_info[3])
  div(
    class = glue("log-entry {status[1]}-highlight"),
    icon(
      name = status[2],
      class = glue(
        "log-status {status[1]}-text fa-solid"
      ),
    ),
    div(
      class = "log-info-block",
      div(
        class = glue("log-info {status[1]}-text"),
        log_info[3]
      ),
      div(
        class = "log-time",
        format_timestamp(log_info[2])
      )
    )
  )
}

get_status_info <- function(
  output_type,
  log_data
) {
  if (output_type == "stdout") {
    c("green", "circle-info")
  } else if (output_type == "stderr" && check_text_error(log_data)) {
    c("red", "circle-xmark")
  } else {
    c("yellow", "circle-info")
  }
}
