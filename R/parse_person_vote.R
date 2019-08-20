#' Parse individual legislator votinf record
#'
#' Import vote json and parse
#'
#' @param vote_json Path to vote json file
#'
#' @import dplyr
#' @import purrr
#' @importFrom magrittr "%>%"
#' @import jsonlite
#' @importFrom tibble tibble as_tibble
#' @importFrom data.table rbindlist
#'
#' @return data.frame
#'
#' @export
parse_person_vote <- function(vote_json){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  ༼ つ ◕_◕ ༽つ GIVE VOTE [:bar] :percent in :elapsed.",
    total = length(vote_json), clear = FALSE, width= 60)
  pb$tick(0)

  extract_vote <- function(input_vote_json){

    pb$tick()

    # Import json
    input_vote <- input_vote_json %>%
      jsonlite::fromJSON()

    # Keep inner element
    input_vote <- input_vote[["roll_call"]]

    person_vote <- input_vote[["votes"]]
    #person_vote$bill_id <- input_vote[["bill_id"]]
    person_vote$roll_call_id <- input_vote[["roll_call_id"]]

    person_vote
    # End of inner function call
  }

  # Iterate over input json to decode text one by one
  output_list <- vote_json %>%
    purrr::map(extract_vote)

  output_df <- output_list %>%
    data.table::rbindlist(fill = TRUE)
  output_df
  # End of function call
}

