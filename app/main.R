box::use(
  shiny[
    div,
    fluidPage,
    isTruthy,
    moduleServer,
    NS,
    reactive,
    reactiveValues,
    renderUI,
    uiOutput
  ],
)

box::use(
  app/logic/api_utils[get_app_list],
  app/logic/empty_state_utils[generate_empty_state_ui],
  app/view/mod_app_table,
  app/view/mod_header,
  app/view/mod_job_list,
  app/view/mod_logs,
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  fluidPage(
    class = "dashboard-body",
    mod_header$ui("header"),
    div(
      class = "dashboard-container",
      div(
        class = "app-table",
        mod_app_table$ui(ns("app_table"))
      ),
      div(
        class = "vertical-line"
      ),
      div(
        class = "job-list",
        uiOutput(ns("job_list_pane"))
      ),
      div(
        class = "vertical-line"
      ),
      div(
        class = "logs",
        uiOutput(ns("logs_pane"))
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    app_list <- get_app_list()

    mod_header$server("header")

    state <- reactiveValues()
    state$selected_app <- reactive({})
    state$selected_job <- reactive({})

    mod_app_table$server(
      "app_table",
      app_list,
      state
    )

    mod_job_list$server(
      "job_list",
      state
    )

    mod_logs$server(
      "logs",
      state
    )

    output$job_list_pane <- renderUI({
      if (!isTruthy(state$selected_app()$guid)) {
        return(NULL)
      }

      mod_job_list$ui(ns("job_list"))
    })

    output$logs_pane <- renderUI({
      if (!is.data.frame(app_list) || nrow(app_list) == 0) {
        return(
          generate_empty_state_ui(
            text = "Oops! Can't read apps from Posit Connect.",
            image_path = "static/illustrations/missing_apps.svg"
          )
        )
      }

      if (!isTruthy(state$selected_job()$key)) {
        return(
          generate_empty_state_ui(
            text = "Select an application and a job to view logs.",
            image_path = "static/illustrations/empty_state.svg"
          )
        )
      }

      mod_logs$ui(ns("logs"))
    })

  })
}
