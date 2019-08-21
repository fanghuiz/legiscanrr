#' Parse bill progress
#'
#' Import bill json and parse
#'
#' @param bill_json Path to bill json file
#'
#' @import jsonlite
#' @import progress
#' @importFrom data.table rbindlist setDF
#' @importFrom  tibble as_tibble
#'
#' @return data.frame
#'
#' @export
parse_bill_progress <- function(bill_json){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  parsing bill progress [:bar] :percent in :elapsed.",
    total = length(bill_json), clear = FALSE, width= 60)
  pb$tick(0)

  # Inner function
  extract_progress <- function(input_bill){

    pb$tick()

    # # Check if input is list of path to local json
    # if (is.list(input_bill)) {
    #
    #   # Extract progress element
    #   bill_progress <- input_bill[["progress"]]
    #
    #   bill_progress <- data.table::rbindlist(bill_progress, fill = TRUE)
    #   bill_progress$bill_id = input_bill[["bill_id"]]
    #
    #   return(bill_progress)
    #
    # } else if (is.character(input_bill)) {
    #   # Import json
    #   input_bill <- jsonlite::fromJSON(input_bill)
    #   input_bill <- input_bill[["bill"]]
    #
    #   # Extract progress element
    #   bill_progress <- input_bill[["progress"]]
    #   bill_progress$bill_id = input_bill[["bill_id"]]
    #
    #   return(bill_progress)
    # }

    # Import json
    input_bill <- jsonlite::fromJSON(input_bill)
    input_bill <- input_bill[["bill"]]

    # Extract progress element
    bill_progress <- input_bill[["progress"]]
    bill_progress$bill_id = input_bill[["bill_id"]]

    bill_progress
  }

  # Iterate over input json to extract bill progress on by one
  output_list <- lapply(bill_json, extract_progress)

  # Bind list into flat data frame
  output_df <- data.table::rbindlist(output_list, fill = TRUE)
  output_df  <- tibble::as_tibble(data.table::setDF(output_df))

  output_df
  # End of function call
}
