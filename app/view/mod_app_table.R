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
    reactive
  ],
  shinycssloaders[withSpinner],
)

box::use(
  app/logic/app_table_utils[process_app_data],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  withSpinner(
    reactableOutput(
      ns("app_table")
    ),
    type = 8,
    color = "#333333"
  )
}

#' @export
server <- function(id, app_list, state) {
  moduleServer(id, function(input, output, session) {

    output$app_table <- renderReactable({

      processed_apps <- app_list %>%
        mutate(
          name = paste(
            name,
            r_version,
            dashboard_url,
            last_deployed_time,
            sep = "_-_"
          )
        ) %>%
        select(
          -c(
            r_version,
            dashboard_url,
            last_deployed_time
          )
        )

      reactable(
        data = processed_apps,
        searchable = TRUE,
        borderless = TRUE,
        pagination = FALSE,
        selection = "single",
        columns = list(
          guid = colDef(
            show = FALSE
          ),
          name = colDef(
            name = "Application",
            cell = function(app_data) {
              process_app_data(app_data)
            }
          )
        )
      )
    })

    state$selected_app <- reactive({
      index <- getReactableState("app_table", "selected")
      list(
        "guid" = app_list[index, ]$guid,
        "name" = app_list[index, ]$name
      )
    })

  })

}
