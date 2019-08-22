#' Find paths to local JSON files
#'
#' Helper function to find local paths to json files before using the
#' various parsing functions in this package. Only works if directory structure
#' remains the same as XXX after the datasets from LegiScan,
#' either via API request or direct download of the bulk export.
#'
#' @param base_dir Character vector of the directory where the json files are stored locally
#' @param file_type Character string. Accepts "bill", "people", "vote", or "text"
#'
#' @importFrom checkmate assert_directory_exists assert_choice
#' @importFrom fs dir_ls
#'
#' @return A vector of paths to .json file
#'
#' @export
find_json_path <- function(base_dir, file_type){

  # Check if directory exists
  checkmate::assert_directory_exists(base_dir)

  # Check if file_type input is valid
  checkmate::assert_choice(file_type,
                           choices = c("bill", "people", "vote", "text"))

  # Define patterns to match file name
  pattern <- paste0("(", file_type, ")", ".*?(json)")

  # Find first layer sub-folders
  # sub_folder <- fs::dir_ls(path = base_path)
  #
  # path <- sub_folder %>%
  #   purrr::map(fs::dir_ls, recurse = TRUE, regexp = pattern)

  path <-  fs::dir_ls(base_dir, recurse = TRUE, regexp = pattern)

  path
}
