#' Wrapper for getBill operation
#'
#' This operation returns the primary bill detail information including sponsors,
#' committee references, full history, bill text and roll call information.
#'
#' @param bill_id Identifier for bill
#' @param api_key Your LegiScan API key (see [legiscan_api_key()])
#'
#' @import httr
#'
#' @return List
#'
#' @export
get_bill <- function(bill_id, api_key = legiscan_api_key()){

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
  bill <- content[["bill"]]

  class(bill) <- c("billData", class(bill))

  bill
}
