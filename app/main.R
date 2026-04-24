box::use(
  config[get],
  shiny,
)

box::use(
  app/logic/api_utils[get_app_list],
  app/logic/empty_state_utils[generate_empty_state_ui],
  app/logic/general_utils[generate_css_variables],
  app/view/mod_app_table,
  app/view/mod_header,
  app/view/mod_job_list,
  app/view/mod_logs,
)

# Load Branding
branding <- get("branding")
branding_css_variables <- generate_css_variables(
  branding
)

#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$fluidPage(
    class = "dashboard-body",
    shiny$tags$head(
      shiny$tags$style(shiny$HTML(branding_css_variables))
    ),
    mod_header$ui("header"),
    shiny$div(
      class = "dashboard-container",
      shiny$div(
        class = "app-table",
        mod_app_table$ui(ns("app_table"))
      ),
      shiny$div(
        class = "vertical-line"
      ),
      shiny$div(
        class = "job-list",
        shiny$uiOutput(ns("job_list_pane"))
      ),
      shiny$div(
        class = "vertical-line"
      ),
      shiny$div(
        class = "logs",
        shiny$uiOutput(ns("logs_pane"))
      )
    )
  )
}

#' @export
server <- function(id) {
  shiny$moduleServer(id, function(input, output, session) {

    ns <- session$ns

    app_list <- get_app_list()

    mod_header$server("header")

    selected_app_ <- mod_app_table$server(
      "app_table",
      app_list
    )$selected_app_

    selected_job_ <- mod_job_list$server(
      "job_list",
      selected_app_
    )$selected_job_

    mod_logs$server(
      "logs",
      selected_app_,
      selected_job_
    )

    output$job_list_pane <- shiny$renderUI({
      if (!shiny$isTruthy(selected_app_()$guid)) {
        NULL
      }

      mod_job_list$ui(ns("job_list"))
    })

    output$logs_pane <- shiny$renderUI({
      if (!is.data.frame(app_list) || nrow(app_list) == 0) {
        generate_empty_state_ui(
          text = "Oops! Can't read apps from Posit Connect.",
          image_path = "app/static/illustrations/missing_apps.svg",
          color = branding$colors$primary
        )
      }

      if (!shiny$isTruthy(selected_job_()$key)) {
        generate_empty_state_ui(
          text = "Select an application and a job to view logs.",
          image_path = "app/static/illustrations/empty_state.svg",
          color = branding$colors$primary
        )
      }

      mod_logs$ui(ns("logs"))
    })

  })
}
