#' Wrapper for getBillText operation
#'
#' Return bill text json
#'
#' @param api_key LegiScan API key (required)
#' @param doc_id Identifier for bill text document
#'
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @import magrittr
#' @importFrom magrittr "%>%"
#' @import httr
#' @import fs
#'
#' @return data.frame
#'
#' @export
get_bill_text <- function(api_key, doc_id){

  # Stop if no api_key is given
  if (missing(api_key)) {
    stop("Must specify API key. Register for one at https://legiscan.com/legiscan")
  }

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
