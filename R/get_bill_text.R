#' Get bill full text
#'
#' This is the API wrapper function for the getBillText operation.
#' It returns a copy of base64 encoded bill text document, along with other
#' information such as document date, type, MIME type etc.
#'
#' @param doc_id Identifier for bill text document
#' @param api_key Your LegiScan API key (see \code{\link{legiscan_api_key}})
#'
#' @import httr
#'
#' @return A list, with \code{doc_id} as the unique identifier.
#'
#' @seealso \code{\link{legiscan_api_key}},
#' \href{https://legiscan.com/gaits/documentation/legiscan}{LegiScan API manual}.
#' For decoding the base64 encoded document, see \code{\link{decode_bill_text}}
#' and the related \href{../articles/decode-bill-text.html}{vignette}.
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

  class(bill_text) <- c("billText", class(bill_text))

  bill_text
}
