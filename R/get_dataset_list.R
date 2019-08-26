#' Get list of available datasets
#'
#' This is the API wrapper function for the getDatasetList operation.
#' It returns a list of available datasets, with optional \code{state}
#' and/or \code{year} filtering.
#'
#' This opertation does not return the dataset itself. Rather, it gives the
#' dataset meta-data, and the \code{session_id} and \code{access_key} required
#' for the \code{\link{get_dataset}} function to retrieve the dataset.
#'
#' \itemize{
#'   \item If neither \code{state} nor \code{year} is given, returns a full list of all available dataset
#'   \item If only \code{state} is given, returns datasets for that state from all available years
#'   \item If only \code{year} is given, returns datasets for that year from all 50 states,
#' plus DC and Congress.
#' }
#'
#' @param state State filter (optional)
#' @param year Year filter (optional)
#' @param api_key Your LegiScan API key (see \code{\link{legiscan_api_key}})
#'
#' @import httr
#'
#' @seealso \code{\link{get_dataset}}, \code{\link{legiscan_api_key}},
#' \href{https://legiscan.com/gaits/documentation/legiscan}{LegiScan API manual}
#'
#' @return List of dataset information.
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

