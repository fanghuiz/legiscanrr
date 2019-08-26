#' Get or set LEGISCAN_API_KEY value
#'
#' Get or set the LegiScan API key for the current session. To request for an
#' API key from LegiScan, go to \url{https://legiscan.com/legiscan}.
#'
#' The API wrapper functions in this package will look for a LegiScan API
#' key residing in the environment variable \code{LEGISCAN_API_KEY}. Call this
#' function at the beginning of a new session to set the key for the current R session.
#' Or enter `\code{file.edit("~/.Renviron")}` in the console and make this edit to the file
#' `\code{LEGISCAN_API_KEY = "you_api_key"}` to set key on your local machine.
#'
#' @param set_new Set a new LegiScan API key for the current environment. Default is FALSE.
#'
#' @return atomic character vector containing the LegiScan API key
#'
#' @export

legiscan_api_key <- function(set_new = FALSE) {

  env <- Sys.getenv("LEGISCAN_API_KEY")

  if (!identical(env, "") && !set_new) return(env)

  if (!interactive()) {
    stop(
      "Please set your LegiScan API key as env var LEGISCAN_API_KEY in your '~/.Renviron' file.",
      call. = FALSE
    )
  }

  message("Couldn't find env var LEGISCAN_API_KEY See ?legiscan_api_key for more details.")
  message("Please enter your LegiScan API key and press enter:")

  pat <- readline(": ")

  if (identical(pat, "")) {
    stop("LegiScan API key entry failed", call. = FALSE)
  }

  message("Updating LEGISCAN_API_KEY env var with input;
          consider setting this in your ~/.Renviron file to avoid future input.")

  Sys.setenv(LEGISCAN_API_KEY = pat)

  pat

}
