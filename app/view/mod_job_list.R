box::use(
  dplyr[
    mutate,
    select
  ],
  magrittr[`%>%`],
  reactable[
    colDef,
    getReactableState,
    reactable,
    reactableOutput,
    renderReactable
  ],
  shiny[
    moduleServer,
    NS,
    reactive,
    req
  ],
  shinycssloaders[withSpinner],
)

box::use(
  app/logic/api_utils[get_job_list],
  app/logic/job_list_utils[process_job_data],
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
server <- function(id, state) {
  moduleServer(id, function(input, output, session) {

    job_list_data <- reactive({
      req(state$selected_app()$guid)
      get_job_list(state$selected_app()$guid)
    })

    output$job_list_table <- renderReactable({

      processed_jobs <- job_list_data() %>%
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

      reactable(
        data = processed_jobs,
        selection = "single",
        borderless = TRUE,
        pagination = FALSE,
        columns = list(
          job = colDef(
            cell = function(job_data) {
              process_job_data(job_data)
            }
          )
        )
      )
    })

    state$selected_job <- reactive({
      index <- getReactableState("job_list_table", "selected")
      list(
        "key" = job_list_data()[index, ]$key,
        "id" = job_list_data()[index, ]$id
      )
    })

  })
}