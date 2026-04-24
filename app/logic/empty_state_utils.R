box::use(
  base64enc[
    base64encode
  ],
  shiny[
    div,
    img,
    p,
  ],
)

#' @description Function to generate an empty state UI
#' @param text Text to display in the empty state
#' @param image_path Path to the image to display in the empty state
#' @param color Color to use for the image
#' @export
generate_empty_state_ui <- function(
  text = "Select an application and a job to view logs",
  image_path = "static/illustrations/empty_state.svg",
  color = "#0099f9"
) {
  div(
    class = "empty-state-container",
    p(
      class = "empty-state-text",
      text
    ),
    replace_svg_fill(
      color = color,
      svg_path = image_path,
      alt = text
    )
  )
}

#' Function to replace fill color in SVG
#' @param color Character. The color to replace
#' @param svg_path Character. The path to the SVG file
#' @param placeholder Character. The placeholder. Default is "PRIMARY"
#' @param alt Character. The alt text for the image
#' @return an image tag with the SVG content
replace_svg_fill <- function(
  color,
  svg_path = "",
  placeholder = "PRIMARY",
  alt = "",
  class = "empty-state-image"
) {
  svg_content <- readLines(svg_path)
  svg_content <- paste(svg_content, collapse = "\n")
  svg_content <- gsub(
    placeholder,
    color,
    svg_content
  )
  img(
    class = class,
    src = paste0(
      "data:image/svg+xml;base64,",
      base64encode(charToRaw(svg_content))
    ),
    alt = alt
  )
}
