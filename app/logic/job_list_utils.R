box::use(
  shiny[
    div,
    span,
    icon,
    a,
    strong
  ],
  glue[glue]
)

box::use(
  app/logic/general_utils[format_timestamp]
)


#' Function to process each row for the job table
#' This creates the HTML for the row
#'
#' @export
process_job_data <- function(
  job_data
) {
  job_info <- strsplit(job_data, "_-_")[[1]]
  div(
    class = "job-entry",
    div(
      class = "job-id",
      job_info[1]
    ),
    div(
      class = "job-key",
      strong("Key: "),
      job_info[2]
    ),
    div(
      class = "job-start-time",
      strong("Start: "),
      format_timestamp(job_info[3], "%Y-%m-%dT%H:%M:%S")
    ),
    div(
      class = "job-end-time",
      strong("End: "),
      format_timestamp(job_info[4], "%Y-%m-%dT%H:%M:%S")
    )
  )
}
