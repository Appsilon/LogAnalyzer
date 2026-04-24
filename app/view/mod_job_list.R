box::use(
  reactable[
    colDef,
    getReactableState,
    reactable,
    reactableLang,
    reactableOutput,
    renderReactable
  ],
  shiny[
    isTruthy,
    moduleServer,
    NS,
    reactive,
    req
  ],
  shinycssloaders[withSpinner],
)

box::use(
  app/logic/api_utils[get_job_list],
  app/logic/job_list_utils[
    process_job_data,
    render_job_data
  ],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  withSpinner(
    reactableOutput(
      ns("job_list_table")
    ),
    type = 8,
    color = "#333333"
  )
}

#' @export
server <- function(id, selected_app_) {
  moduleServer(id, function(input, output, session) {

    job_list_data <- reactive({
      req(selected_app_()$guid)
      get_job_list(selected_app_()$guid)
    })

    output$job_list_table <- renderReactable({

      processed_jobs <- process_job_data(
        job_list_data()
      )

      reactable(
        data = processed_jobs,
        selection = "single",
        borderless = TRUE,
        pagination = FALSE,
        onClick = "select",
        columns = list(
          job = colDef(
            cell = function(job_data) {
              render_job_data(job_data)
            }
          )
        ),
        language = reactableLang(
          noData = "No jobs found."
        )
      )

    })

    list(
      selected_job_ = reactive({
        index <- getReactableState("job_list_table", "selected")
        if (isTruthy(index) && nrow(job_list_data()) > 0) {
          list(
            "key" = job_list_data()[index, ]$key,
            "id" = job_list_data()[index, ]$id
          )
        }
      })
    )

  })
}
