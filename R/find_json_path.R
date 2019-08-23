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
#' @import assertthat
#' @importFrom fs dir_ls
#'
#' @return A vector of paths to .json file
#'
#' @export
find_json_path <- function(base_dir, file_type){

  # Check if directory exists
  assertthat::is.dir(base_dir)

  # Check if file_type input is valid
  assertthat::assert_that(
    file_type %in% c("bill", "people", "vote", "text"),
    msg = "file_type must of one of the following: 'bill', 'people, 'vote', 'text'"
  )

  # Define patterns to match file name xxx/file_type/xxx.json
  pattern <- paste0("(", file_type, ")", ".*?(json)")

  path <-  fs::dir_ls(base_dir, recurse = TRUE, regexp = pattern)

  path
}
