#' Wrapper for getDatasetList operation
#'
#' Returns a list of available datasets, with optional state and year filtering
#'
#' @param state State filter (optional)
#' @param year Year filter (optional)
#' @param api_key Your LegiScan API key (see [legiscan_api_key()])
#'
#' @import httr
#'
#' @return data.frame
#'
#' @export
get_dataset_list <- function(state = NULL, year = NULL, api_key = legiscan_api_key()){

  # Chek for internet
  check_internet()

  # Get the API response
  resp <- httr::GET(
    url = base_url,
    query = list(key = api_key, op = "getDatasetList", state = state, year = year))

  # Get the content
  content <- httr::content(resp)

  # Check for errors in http status, and API errors
  check_http_status(resp)
  check_API_response(content)

  # Keep the inner element datasetlist
  dataset_list <- content[["datasetlist"]]

  dataset_list
}

