#' Get dataset archive
#'
#' This is the API wrapper function for the getDataset operation.
#' It retrieves the ZIP archive of the requested session dataset, then unzip
#' the content to a specified local directory.
#'
#' @param dataset_list List object returned from \code{\link{get_dataset_list}}
#' @param save_to_dir Local directory to save the unzipped dataset.
#' Default to working directory \code{"."}
#' @param api_key Your LegiScan API key (see \code{\link{legiscan_api_key}})
#'
#' @importFrom fs dir_create
#' @importFrom purrr flatten
#' @importFrom utils unzip
#' @import httr
#' @import jsonlite
#'
#' @examples
#' \dontrun{
#' # One dataset
#' get_dataset(one_dataset, save_to_dir = "data_json")
#'
#' # Multiple datasets. Use walk() to avoid printing NULL to console.
#' # But lapply() and map() works too
#' walk(multiple_datasets, get_dataset, save_to_dir = "data_json")
#' }
#'
#' @seealso \code{\link{get_dataset_list}}, \code{\link{legiscan_api_key}},
#' \href{https://legiscan.com/gaits/documentation/legiscan}{LegiScan API manual}.
#'
#' @return NULL. No return value. Dataset will be unzipped to local disk.
#'
#' @export
get_dataset <- function(dataset_list,
                        save_to_dir = ".",
                        api_key = legiscan_api_key()){

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
