#' Parse roll call votes
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
parse_rollcall_vote <- function(vote_json){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  ༼ つ ◕_◕ ༽つ GIVE ROLLCALL [:bar] :percent in :elapsed.",
    total = length(vote_json), clear = FALSE, width= 60)
  pb$tick(0)

  extract_rollcall <- function(input_vote_json){

    pb$tick()

    # Import json
    input_vote <- input_vote_json %>%
      jsonlite::fromJSON()

    # Keep inner element
    input_vote <- input_vote[["roll_call"]]

    element_single <- c("roll_call_id",
                        "bill_id",
                        "date",
                        "desc",
                        "yea",
                        "nay",
                        "nv",
                        "absent",
                        "total",
                        "passed",
                        "chamber",
                        "chamber_id")

    # Keep all elements with single value, i.e. everything except indivdual votes
    vote_info <- purrr::keep(input_vote, names(input_vote) %in% element_single)

    vote_info
    # End of inner function call
  }

  # Iterate over input json to decode text one by one
  output_list <- vote_json %>%
    purrr::map(extract_rollcall)

  output_df <- output_list %>%
    data.table::rbindlist(fill = TRUE)
  output_df
  # End of function call
}

