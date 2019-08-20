#' Wrapper for getDataset operation
#'
#' Unzip a single ZIP archive of the requested session dataset.
#'
#' @param api_key LegiScan API key (required)
#' @param dataset_list_object Object returned from get_dataset_list()
#' @param save_data_to
#'
#' @import dplyr
#' @import purrr
#' @import magrittr
#' @importFrom magrittr "%>%"
#' @import httr
#' @import jsonlite
#' @import utils
#' @import progress
#'
#' @return NULL. No return value. Dataset will be unzipped to local disk.
#'
#' @export
get_dataset <- function(api_key, dataset_list_object, save_data_to){

  # Stop if no api_key is given
  if (missing(api_key)) {
    stop("Must specify API key.
         Register for one at https://legiscan.com/legiscan")
  }

  if (missing(save_data_to)) {
    stop("Argument 'save_data_to' is missing.
         Must specify a local directory to save data to")
  }

  if (!is.character(save_data_to)) {
    stop("Argument 'save_data_to' must be a character string")
  }

  if (all(c("session_id", "access_key") %in%
          colnames(dataset_list_object)) == FALSE) {
    stop("Failed to download dataset. No session_id or access_key found.")
  } else {
    dataset_url <- paste0("https://api.legiscan.com/?key=", api_key,
                          "&op=getDataset&id=", dataset_list_object$session_id,
                          "&access_key=", dataset_list_object$access_key)
  }

  unzip_to_disk <- function(dataset){
    data_decode <- dataset[["dataset"]][["zip"]] %>%
      jsonlite::base64_dec()
    tmp <- tempfile()
    writeBin(data_decode, tmp)
    utils::unzip(tmp, exdir = save_data_to)
  }

  # Check for error
  check_API_error <- function(response){

    if(response$status == "ERROR"){
      message(paste0("API request error: ", response[[2]][[1]]))
    } else {
      # Unzip all downloaded datasets to disk
      unzip_to_disk(response)
    }
  }

  # initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  ♪┏(・o･)┛♪ downloading [:bar] :percent in :elapsed. eta: :eta",
    total = length(dataset_url), clear = FALSE, width= 60)
  pb$tick(0)

  check_error_save <- function(url){

    pb$tick()

    url %>%
      httr::GET() %>%
      httr::content() %>%
      check_API_error()

  }

  dataset_url %>%
    purrr::walk(check_error_save)

  return(NULL)
}
