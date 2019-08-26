#' Find local JSON files
#'
#' Helper function to find paths to json files saved locally, before using the
#' various parsing functions in this package to process the data.
#'
#' Note: This function determines file type ("bill", "people", "vote", or "text")
#' by looking at sub-directories, thus the json files will need to be saved in the
#' approriate folder, e.g. bill json files need to be saved as \code{xxx/bill/file.json},
#' vote json files will need to be saved as \code{xxx/vote/file.json}.
#' This should not be a problem if the files are unzipped directly from LegiScan bulk dataset.
#'
#' @param base_dir Character vector of the directory where the json files are stored locally
#' @param file_type Character. Accepts \code{"bill"}, \code{"people"},
#' \code{"vote"}, or \code{"text"}.
#'
#' @import assertthat
#' @importFrom fs dir_ls
#'
#' @return A vector of paths to local json file
#'
#' @examples
#' \dontrun{
#' find_json_path(base_dir = "data", "bill")
#' find_json_path(base_dir = "data", "vote")
#' }
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
