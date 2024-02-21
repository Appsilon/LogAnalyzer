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

#' Function to process each row for the app table
#' This creates the HTML for the row
#'
#' @export
process_app_data <- function(
  app_data
) {
  app_info <- strsplit(app_data, "_-_")[[1]]
  div(
    class = "app-entry",
    div(
      class = "app-title",
      span(
        app_info[1],
        a(
          href = app_info[3],
          class = "app-link",
          icon(
            name = "arrow-up-right-from-square",
            class = "app-link-icon"
          ),
          target = "_blank"
        )
      )
    ),
    div(
      class = "app-metadata",
      div(
        class = "app-last-deployed",
        strong("Last Deployed: "),
        format_timestamp(app_info[4])
      ),
      span(
        class = "app-r-version",
        strong("R version: "),
        app_info[2]
      )
    )
  )
}
