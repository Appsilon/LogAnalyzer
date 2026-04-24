box::use(
  config[
    get
  ],
  shiny[
    a,
    actionLink,
    div,
    h2,
    img,
    moduleServer,
    NS
  ],
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  branding <- get("branding")
  div(
    class = "header",
    div(
      class = "left header-section",
      a(
        img(
          src = branding$logo$src,
          alt = branding$logo$alt
        ),
        href = branding$logo$href,
        target = "_blank"
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
        ns("lets-talk"),
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
