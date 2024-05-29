box::use(
  dplyr[
    mutate,
    select
  ],
  magrittr[
    `%>%`
  ],
  shiny[
    div,
    strong
  ],
)

box::use(
  app/logic/general_utils[format_timestamp],
)

#' Process the dataframe for job list
#' @param job_list_data the job list data to process for the mod_job_list
#' @export
#'
process_job_data <- function(job_list_data) {
  if (length(job_list_data)) {
    job_list_data %>%
      select(id, key, start_time, end_time) %>%
      mutate(
        job = paste(
          id,
          key,
          start_time,
          end_time,
          sep = "_-_"
        )
      ) %>%
      select(
        -c(
          id,
          key,
          start_time,
          end_time
        )
      )
  } else {
    data.frame(
      job = character()
    )
  }
}

#' Function to process each row for the job table
#' This creates the HTML for the row
#' @param job_data the job_data for a single job
#' @export
render_job_data <- function(
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
