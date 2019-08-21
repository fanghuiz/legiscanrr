#' Wrapper for getBill operation
#'
#' This operation returns the primary bill detail information including sponsors,
#' committee references, full history, bill text and roll call information.
#'
#' @param api_key LegiScan API key (required)
#' @param bill_id Identifier for bill
#'
#' @importFrom fs dir_create
#' @import purrr
#' @import httr
#' @import jsonlite
#' @import utils
#'
#' @return List
#'
#' @export
get_bill <- function(api_key, bill_id){

  # Stop if no api_key is given
  if (missing(api_key)) {
    stop("Must specify API key. Register for one at https://legiscan.com/legiscan")
  }

  # Chek for internet
  check_internet()

  # Get the API response
  resp <- httr::GET(
    url = base_url,
    query = list(key = api_key, op = "getBill", id = bill_id))

  # Get the content
  content <- httr::content(resp)

  # Check for errors in http status, http type, and API errors
  check_http_status(resp)
  check_API_response(content)

  # Keep the inner element content
  content <- content[["bill"]]

  content
}
