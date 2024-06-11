# nolint start: box_func_import_count_linter
box::use(
  dplyr[select],
  magrittr[`%>%`],
  shiny[
    div,
    fluidPage,
    img,
    isTruthy,
    moduleServer,
    NS,
    observeEvent,
    p,
    reactive,
    reactiveValues,
    removeUI,
    renderUI,
    tagList,
    tags,
    uiOutput
  ],
  shinycssloaders[withSpinner],
)
# nolint end

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

    mod_header$server("header")

    state <- reactiveValues()
    state$selected_app <- reactive({})
    state$selected_job <- reactive({})

    app_list <- reactive({
      get_app_list()
    })

    mod_app_table$server(
      "app_table",
      app_list(),
      state
    )

    observeEvent(state$selected_app()$guid, {

      if (isTruthy(state$selected_app()$guid)) {

        output$job_list_pane <- renderUI({
          mod_job_list$ui(ns("job_list"))
        })

        mod_job_list$server(
          "job_list",
          state
        )

      } else {

        removeUI(ns("job_list_pane"))

      }
    }, ignoreInit = FALSE, ignoreNULL = FALSE)

    observeEvent(state$selected_job()$key, {

      if (isTruthy(state$selected_job()$key)) {

        output$logs_pane <- renderUI({
          mod_logs$ui(ns("logs"))
        })

        mod_logs$server(
          "logs",
          state
        )
      } else {

        if (class(app_list()) != "data.frame") {
          empty_state <- generate_empty_state_ui(
            text = "Oops! Can't read apps from Posit Connect.",
            image_path = "static/illustrations/missing_apps.svg"
          )
        } else {
          empty_state <- generate_empty_state_ui(
            text = "Select an application and a job to view logs",
            image_path = "static/illustrations/empty_state.svg"
          )
        }

        output$logs_pane <- empty_state
      }

    }, ignoreInit = FALSE, ignoreNULL = FALSE)

  })
}
