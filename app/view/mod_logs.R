# nolint start: box_func_import_count_linter
box::use(
  dplyr[mutate],
  glue[glue],
  magrittr[`%>%`],
  reactable[
    colDef,
    reactable,
    reactableOutput,
    renderReactable
  ],
  shinycssloaders[withSpinner],
  shiny[
    div,
    downloadButton,
    downloadHandler,
    icon,
    moduleServer,
    NS,
    observeEvent,
    reactive,
    renderUI,
    req,
    uiOutput
  ],
)
# nolint end

box::use(
  app/logic/api_utils[download_job_logs, get_job_logs],
  app/logic/logs_utils[process_log_data],
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
server <- function(id, selected_app_, selected_job) {
  moduleServer(id, function(input, output, session) {

    ns <- session$ns

    output$download <- downloadHandler(
      filename = function() {
        glue(
          "{selected_app_()$name}_{selected_job_()$id}.txt"
        )
      },
      content = function(file) {
        logs <- download_job_logs(
          selected_app_()$guid,
          selected_job_()$key
        )
        writeLines(logs, file)
      }
    )

    observeEvent(selected_job_()$key, {
      req(selected_job_()$key)
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
      req(selected_job_()$key)
      get_job_logs(
        selected_app_()$guid,
        selected_job_()$key
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
