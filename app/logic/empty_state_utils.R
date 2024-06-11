box::use(
  shiny[
    div,
    img,
    p,
    renderUI
  ]
)

#' @description Function to generate an empty state UI
#' @param text Text to display in the empty state
#' @param image_path Path to the image to display in the empty state
#' @export
generate_empty_state_ui <- function(
  text = "Select an application and a job to view logs",
  image_path = "static/illustrations/empty_state.svg"
) {
  renderUI({
    div(
      class = "empty-state-container",
      p(
        class = "empty-state-text",
        text
      ),
      img(
        src = image_path,
        class = "empty-state-image",
        alt = text
      )
    )
  })
}
