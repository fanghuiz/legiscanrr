#' Wrapper for getDatasetList operation
#'
#' Returns a list of available datasets, with optional state and year filtering
#'
#' @param api_key LegiScan API key (required)
#' @param state State filter (optional)
#' @param year Year filter (optional)
#'
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @import magrittr
#' @importFrom magrittr "%>%"
#' @import httr
#'
#' @return data.frame
#'
#' @export
get_dataset_list <- function(api_key, state, year){

  # Stop if no api_key is given
  if (missing(api_key)) {
    stop("Must specify API key. Register for one at https://legiscan.com/legiscan")
  }

  # Generate request URL based on input parameters
  if (missing(state) & missing(year)){
    # If no year or state is specified
    req_url <- paste0("https://api.legiscan.com/?key=", api_key,
                      "&op=getDatasetList")

  } else if (!missing(state) & missing(year)) {
    # If only state is specified
    req_url <- paste0("https://api.legiscan.com/?key=", api_key,
                      "&op=getDatasetList&state=", state)

  } else if (missing(state) & !missing(year)){
    # If only year is specified
    req_url <- paste0("https://api.legiscan.com/?key=", api_key,
                      "&op=getDatasetList&year=", year)

  } else if (!missing(state) & !missing(year)){
    # If both year and state are specified
    # Generate unique combination of state and year input
    state_year <- tidyr::crossing(state = state, year = year)
    req_url <- paste0("https://api.legiscan.com/?key=", api_key,
                      "&op=getDatasetList&state=", state_year$state, "&year=", state_year$year)
  }

  # Get dataset info from API
  dataset_list <-
    # Sent GET request to req_url
    purrr::map(req_url, httr::GET) %>%
    # Retrieve the content of GET request
    purrr::map(httr::content)

  # Check for error
  check_API_error <- function(response){
    if(response$status == "ERROR"){

      message(paste0("API request error: ", response[[2]][[1]]))

      return(NULL)
    } else {

      response[["datasetlist"]]

    }
  }

  dataset_list_df <- dataset_list %>%
    purrr::map(check_API_error) %>%
    purrr::flatten_df() %>%
    dplyr::distinct()

  dataset_list_df
}

