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
    reactableLang,
    reactableOutput,
    renderReactable
  ],
  shiny[
    isTruthy,
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
server <- function(id, app_list) {
  moduleServer(id, function(input, output, session) {

    output$app_table <- renderReactable({

      if (nrow(app_list) > 0 && inherits(app_list, "data.frame")) {
        processed_apps <- app_list %>%
          select(
            guid,
            name,
            r_version,
            dashboard_url,
            last_deployed_time
          ) %>%
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
      } else {
        processed_apps <- data.frame(
          guid = character(),
          name = character()
        )
      }

      reactable(
        data = processed_apps,
        searchable = TRUE,
        borderless = TRUE,
        pagination = FALSE,
        onClick = "select",
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
        ),
        language = reactableLang(
          noData = "No apps found."
        )
      )
    })

    list(
      selected_app_ = reactive({
        index <- getReactableState("app_table", "selected")
        if (isTruthy(index) && nrow(app_list) > 0) {
          list(
            "guid" = app_list[index, ]$guid,
            "name" = app_list[index, ]$name
          )
        }
      })
    )

  })

}
