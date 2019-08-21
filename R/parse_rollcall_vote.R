#' Parse roll call votes
#'
#' Import vote json and parse
#'
#' @param vote_json Path to vote json file
#'
#' @import jsonlite
#' @import progress
#' @importFrom purrr keep
#' @importFrom data.table rbindlist setDF
#' @importFrom  tibble as_tibble
#'
#' @return data.frame
#'
#' @export
parse_rollcall_vote <- function(vote_json){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  parsing roll call [:bar] :percent in :elapsed.",
    total = length(vote_json), clear = FALSE, width= 60)
  pb$tick(0)

  extract_rollcall <- function(input_vote_json){

    pb$tick()

    # Import json
    input_vote <- jsonlite::fromJSON(input_vote_json)

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
  output_list <- lapply(vote_json, extract_rollcall)

  # Bind list into flat data frame
  output_df <- data.table::rbindlist(output_list, fill = TRUE)
  output_df  <- tibble::as_tibble(data.table::setDF(output_df))
  # End of function call
}

