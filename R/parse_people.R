#' Parse people JSON files
#'
#' Import people json and parse
#'
#' @param people_json Path to people json file
#'
#' @import jsonlite
#' @import progress
#' @importFrom data.table rbindlist setDF
#' @importFrom  tibble as_tibble
#'
#' @return list
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
  # End of function call

}

