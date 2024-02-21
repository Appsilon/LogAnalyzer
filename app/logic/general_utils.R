#' Function to check if a string of log text has error keywords
#'
#' @param text Character. The log string
#' @param wordlist Character vector. List of keywords to scan. Default
#' list is `c("halt", "err", "terminat", "not found")`
#' @param ignore_case Logical. Whether to ignore the case for words
#' Default is TRUE
#' @export
check_text_error <- function(
    text,
    wordlist = c("halt", "err", "terminat", "not found"),
    ignore_case = TRUE
) {
  grepl(
    paste(wordlist, collapse = "|"),
    text,
    ignore.case = ignore_case
  )
}

#' Function to convert timestamp between formats
#'
#' @param timestamp Character. The timestamp string
#' @param from Character. Original format. Default is "%Y-%m-%dT%H:%M:%OSZ"
#' @param to Character. New format. Default is "%Y-%m-%d %H:%M:%S"
#' @export
format_timestamp <- function(
    timestamp,
    from = "%Y-%m-%dT%H:%M:%OSZ",
    to = "%Y-%m-%d %H:%M:%S"
) {
  format(
    as.POSIXct(
      timestamp,
      format = from
    ),
    format = to
  )
}
