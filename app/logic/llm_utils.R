box::use(
  config[
    get
  ],
  ellmer, #nolint: we do use this package just in a separate notation [[ ]]
  glue[
    glue
  ],
)

#' Check if LLM is enabled
#'
#' This function checks the LLM configuration and returns TRUE if enabled, FALSE otherwise.
#' @return Logical indicating if LLM is enabled
#' @export
is_llm_enabled <- function() {
  get("llm")$enabled %||% FALSE
}

#' Get valid LLM providers
#' @return A character vector of valid LLM providers
get_valid_providers <- function(
) {
  ellmer_functions <- ls(ellmer)[
    grepl(
      pattern = "^chat_",
      x = ls(ellmer)
    )
  ]
  sub(
    pattern = "^chat_",
    replacement = "",
    x = ellmer_functions
  )
}

#' Check if the provider is valid
#' @param provider The LLM provider to check
#' @param valid_providers A character vector of valid LLM providers
#' @return Logical indicating if the provider is valid
verify_provider <- function(
  provider,
  valid_providers = get_valid_providers()
) {
  if (!provider %in% valid_providers) {
    stop(
      glue(
        "Invalid LLM provider '{provider}'. ",
        "Valid providers are: {paste(valid_providers, collapse = ', ')}"
      )
    )
  }
  TRUE
}

#' Get LLM configuration
#'
#' Returns the LLM configuration if LLM is enabled. Otherwise, throws an error.
#' @return A list containing the LLM configuration
get_llm_config <- function() {
  if (!is_llm_enabled()) {
    stop("Oops! LLM is not enabled in config.yml!")
  }
  verify_provider(
    get("llm")$provider,
    get_valid_providers()
  )
  get("llm")
}

#' Get the LLM function based on the provider
#'
#' Extracts the chat function dynamically from the `ellmer` module.
#' @param llm_config Optional configuration for the LLM
#' @return A function to create a chat object
get_llm_function <- function(
  llm_config = get_llm_config()
) {
  ellmer[[glue("chat_{llm_config$provider}")]]
}

#' Create a chat object
#'
#' Uses the configured LLM provider and model to create a chat object.
#' @param llm_config Optional configuration for the LLM
#' @return A chat object
#' @export
create_chat_object <- function(
  llm_config = get_llm_config()
) {
  fun <- get_llm_function(llm_config)
  fun(
    api_key = llm_config$api_key,
    model = llm_config$model,
    system_prompt = llm_config$system_prompt,
    seed = 42,
    api_args = list(
      temperature = 0
    )
  )
}

#' Invoke LLM help with the logs data.frame
#' @param logs_data A data frame containing log data
#' @return A response from the LLM
#' @export
get_llm_help <- function(
  logs_data
) {
  chat <- create_chat_object()
  chat$chat(
    concatenate_logs(
      logs_data
    )
  )
}

#' Concatenate logs
#' @param processed_logs A data frame containing log data
#' @return A string with concatenated log entries
concatenate_logs <- function(
  processed_logs
) {
  paste(
    processed_logs$entries.data,
    collapse = "\n"
  )
}
