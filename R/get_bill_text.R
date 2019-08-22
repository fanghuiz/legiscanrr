#' Wrapper for getBillText operation
#'
#' Return bill text json
#'
#' @param doc_id Identifier for bill text document
#' @param api_key Your LegiScan API key (see [legiscan_api_key()])
#'
#' @import httr
#'
#' @return data.frame
#'
#' @export
get_bill_text <- function(doc_id, api_key = legiscan_api_key()){

  # Chek for internet
  check_internet()

  # Get the API response
  resp <- httr::GET(
    url = base_url,
    query = list(key = api_key, op = "getBillText", id = doc_id))

  # Get the content
  content <- httr::content(resp)

  # Check for errors in http status, http type, and API errors
  check_http_status(resp)
  check_API_response(content)

  # Keep the inner element content
  bill_text <- content[["text"]]

  bill_text
}
