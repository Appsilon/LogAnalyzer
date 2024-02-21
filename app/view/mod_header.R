box::use(
  shiny[
    NS,
    moduleServer,
    div,
    img,
    h2,
    icon,
    actionButton,
    actionLink
  ]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = "header",
    div(
      class = "left header-section",
      img(
        src = "static/appsilon-logo.png",
        alt = "Appsilon logo",
        href = "https://demo.appsilon.com"
      ),
      div(
        class = "vertical-line"
      ),
      h2(
        "LogAnalyzer"
      )
    ),
    div(
      class = "right header-section",
      actionLink(
        "lets-talk",
        label = "Let's Talk",
        class = "cta-button",
        onclick = "window.open('https://appsilon.com/#contact', '_blank');"
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

  })
}
