box::use(
  shiny[
    moduleServer,
    NS,
    div,
    reactive,
    req,
    downloadButton,
    downloadHandler,
    icon,
    renderUI,
    uiOutput,
    observeEvent
  ],
  reactable[
    reactable,
    renderReactable,
    reactableOutput,
    colDef
  ],
  dplyr[mutate],
  magrittr[`%>%`],
  glue[glue],
  shinycssloaders[withSpinner]
)

box::use(
  app/logic/api_utils[get_job_logs, download_job_logs],
  app/logic/logs_utils[process_log_data]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "logs-container",
    uiOutput(
      ns("download_logs")
    ),
    withSpinner(
      reactableOutput(
        ns("logs_table")
      ),
      type = 8,
      color = "#333333"
    )
  )
}

#' @export
server <- function(id, state) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    output$download <- downloadHandler(
      filename = function() {
        glue(
          "{state$selected_app()$name}_{state$selected_job()$id}.txt"
        )
      },
      content = function(file) {
        logs <- download_job_logs(
          state$selected_app()$guid,
          state$selected_job()$key
        )
        writeLines(logs, file)
      }
    )

    observeEvent(state$selected_job()$key, {
      req(state$selected_job()$key)
      output$download_logs <- renderUI({
        downloadButton(
          outputId = ns("download"),
          label = NULL,
          icon = icon("download"),
          class = "logs-download"
        )
      })
    })

    logs_data <- reactive({
      req(state$selected_job()$key)
      get_job_logs(
        state$selected_app()$guid,
        state$selected_job()$key
      )
    })

    output$logs_table <- renderReactable({

      processed_logs <- logs_data() %>%
        mutate(
          log_line = paste(
            entries.source,
            entries.timestamp,
            entries.data,
            sep = "_-_"
          )
        )

      reactable(
        data = processed_logs,
        searchable = TRUE,
        borderless = TRUE,
        pagination = FALSE,
        defaultSortOrder = "desc",
        defaultSorted = c("entries.timestamp"),
        columns = list(
          entries.source = colDef(
            show = FALSE
          ),
          entries.timestamp = colDef(
            show = FALSE
          ),
          entries.data = colDef(
            show = FALSE
          ),
          log_line = colDef(
            name = "Logs",
            cell = function(log_data) {
              process_log_data(log_data)
            }
          )
        )
      )
    })

  })
}
