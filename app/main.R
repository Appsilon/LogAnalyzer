box::use(
  shiny[
    NS,
    moduleServer,
    div,
    reactive,
    reactiveValues,
    observeEvent,
    isTruthy,
    tags,
    tagList,
    renderUI,
    uiOutput,
    img,
    removeUI,
    p,
    fluidPage
  ],
  magrittr[`%>%`],
  dplyr[select],
  shinycssloaders[withSpinner]
)

box::use(
  app/view/mod_app_table,
  app/view/mod_job_list,
  app/view/mod_logs,
  app/view/mod_header,
  app/logic/api_utils[get_app_list]
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
      app_list() %>%
        select(
          guid,
          name,
          r_version,
          dashboard_url,
          last_deployed_time
        ),
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
    }, ignoreInit = TRUE, ignoreNULL = TRUE)

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
        output$logs_pane <- renderUI({
          div(
            class = "empty-state-container",
            p(
              class = "empty-state-text",
              "Select an application and a job to view logs"
            ),
            img(
              src = "static/empty_state.svg",
              class = "empty-state-image",
              alt = "Select an application and a job to view logs"
            )
          )
        })
      }
    }, ignoreInit = FALSE, ignoreNULL = FALSE)

  })
}
