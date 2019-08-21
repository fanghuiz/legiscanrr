#' Wrapper for getDataset operation
#'
#' Unzip a single ZIP archive of the requested session dataset.
#'
#' @param api_key LegiScan API key (required)
#' @param dataset_list Object returned from get_dataset_list()
#' @param save_to_dir Local directory to save the unzipped dataset.
#' Default to working directory "."
#'
#' @importFrom fs dir_create
#' @import purrr
#' @import httr
#' @import jsonlite
#' @import utils
#'
#' @return NULL. No return value. Dataset will be unzipped to local disk.
#'
#' @export
get_dataset <- function(api_key, dataset_list, save_to_dir = "."){

  # Stop if no api_key is given
  if (missing(api_key)) {
    stop("Must specify API key. Register for one at https://legiscan.com/legiscan")
  }

  # Create directory to save the dataset
  fs::dir_create(save_to_dir)

  #df <- data.table::rbindlist(dataset_list, fill = TRUE)
  dataset_list <- purrr::flatten(dataset_list)

  # Chek for internet
  check_internet()

  resp <- httr::GET(
    url = base_url,
    query = list(key = api_key,
                 op = "getDataset",
                 id = dataset_list$session_id,
                 access_key = dataset_list$access_key))

  # Get the content
  content <- httr::content(resp)

  # Check for errors in http status, API errors
  check_http_status(resp)
  check_API_response(content)

  # Decode the dataset from Base64
  data_decode <- jsonlite::base64_dec(content[["dataset"]][["zip"]])

  # Write the decoded data to temp file, then unzip to local directory
  tmp <- tempfile()
  writeBin(data_decode, tmp)
  utils::unzip(tmp, exdir = save_to_dir)

  message("Saved: ",
          "state id - ", content[["dataset"]][["state_id"]], ", ",
          "session - ", content[["dataset"]][["session_name"]])
}
