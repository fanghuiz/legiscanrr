#' Parse people JSON files
#'
#' Import people json and parse
#'
#' @param people_json Path to people json file
#'
#' @import dplyr
#' @import purrr
#' @importFrom magrittr "%>%"
#' @import jsonlite
#' @importFrom data.table rbindlist
#'
#' @return list
#'
#' @export
#'
parse_people <- function(people_json){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  ༼ つ ◕_◕ ༽つ GIVE PEOPLE [:bar] :percent in :elapsed.",
    total = length(people_json), clear = FALSE, width= 60)
  pb$tick(0)

  # Inner function
  extract_people_meta <- function(input_people_json){

    pb$tick()

    # Import json
    input_people <- input_people_json %>%
      jsonlite::fromJSON()

    # Keep inner element
    people_meta <- input_people[["person"]]

    people_meta
    # End of inner functionn
  }

  # Iterate over input json to decode text one by one
  output_list <- people_json %>%
    purrr::map(extract_people_meta)

  output_df <- output_list %>%
    data.table::rbindlist(fill = TRUE)
  output_df
  # End of function call

}

