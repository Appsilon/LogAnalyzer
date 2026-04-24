box::use(
  dplyr[
    as_tibble,
    bind_cols,
    filter,
    mutate,
    tibble
  ],
  glue[glue],
  magrittr[`%>%`],
  purrr[
    pmap_dfr
  ],
  reactable[
    colDef,
    reactable,
    reactableOutput,
    renderReactable
  ],
  shiny,
  shinycssloaders[withSpinner],
)

box::use(
  app/logic/api_utils[
    download_job_logs,
    get_job_logs
  ],
  app/logic/llm_utils[
    get_llm_help,
    is_llm_enabled
  ],
  app/logic/logs_utils[
    get_status_info,
    process_log_data
  ],
)

#' @export
ui <- function(id) {
  ns <- shiny$NS(id)
  shiny$div(
    class = "logs-container",
    shiny$uiOutput(
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
server <- function(
  id,
  selected_app_,
  selected_job_
) {
  shiny$moduleServer(id, function(input, output, session) {

    ns <- session$ns

    output$download <- shiny$downloadHandler(
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

    output$download_logs <- shiny$renderUI({
      if (is.null(selected_job_()$key)) {
        NULL
      }

      shiny$div(
        class = "logs-options",
        if (is_llm_enabled()) {
          shiny$actionButton(
            inputId = ns("llm"),
            label = NULL,
            icon = shiny$icon("robot"),
            class = "llm logs-options-button"
          )
        },
        shiny$downloadButton(
          outputId = ns("download"),
          label = NULL,
          icon = shiny$icon("download"),
          class = "download logs-options-button"
        )
      )
    })

    logs_data <- shiny$reactive({
      shiny$req(selected_job_()$key)
      get_job_logs(
        selected_app_()$guid,
        selected_job_()$key
      )
    })

    processed_logs <- shiny$reactive({
      logs_data() %>%
        pmap_dfr(
          ~ {
            get_status_info(..1, ..3) |>
              as_tibble() |>
              bind_cols(
                tibble(
                  entries.source = ..1,
                  entries.timestamp = ..2,
                  entries.data = ..3
                )
              )
          }
        ) %>%
        mutate(
          log_line = paste(
            entries.source,
            entries.timestamp,
            entries.data,
            entries.status,
            entries.icon,
            sep = "_-_"
          )
        )
    })

    output$logs_table <- renderReactable({
      reactable(
        data = processed_logs(),
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
          entries.status = colDef(
            show = FALSE
          ),
          entries.icon = colDef(
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

    if (is_llm_enabled()) {
      llm_result <- shiny$eventReactive(input$llm, {
        shiny$req(processed_logs())
        get_llm_help(
          processed_logs() %>%
            filter(
              entries.status %in% c("red", "yellow")
            )
        )
      })

      shiny$observeEvent(llm_result(), {
        shiny$removeModal()
        shiny$showModal(
          shiny$modalDialog(
            easyClose = TRUE,
            size = "m",
            footer = shiny$modalButton(
              shiny$icon(
                "xmark",
                class = "red-text"
              )
            ),
            shiny$HTML(llm_result())
          ) %>%
            shiny$tagAppendAttributes(class = "logs-llm-modal")
        )
      })
    }
  })
}
