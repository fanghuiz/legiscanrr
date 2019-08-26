#' Parse legislator information
#'
#' Parse bill sponsor information from local json. (support for parsing from API response
#' not yet available.)
#'
#' @param people_json Path to people json file
#'
#' @import jsonlite
#' @import progress
#' @importFrom data.table rbindlist setDF
#' @importFrom  tibble as_tibble
#'
#' @examples
#' person_8630 <- system.file("extdata", "people/8630.json", package = "legiscanrr")
#' person_8630 <- parse_people(person_8630)
#' str(person_8630)
#'
#' @return A data frame of 20 columns.
#' For more details, see \href{../articles/parse-json.html#legislator-information}{documentation}.
#'
#' @export
#'
parse_people <- function(people_json){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  parsing people [:bar] :percent in :elapsed.",
    total = length(people_json), clear = FALSE, width= 60)
  pb$tick(0)

  # Inner function
  extract_people_meta <- function(input_people_json){

    pb$tick()

    # Import json
    input_people <- jsonlite::fromJSON(input_people_json)

    # Keep inner element
    people_meta <- input_people[["person"]]

    people_meta
    # End of inner functionn
  }

  # Iterate over input json to decode text one by one
  output_list <- lapply(people_json, extract_people_meta)

  # Bind list into flat data frame
  output_df <- data.table::rbindlist(output_list, fill = TRUE)
  output_df  <- tibble::as_tibble(data.table::setDF(output_df))
  output_df
  # End of function call
}

