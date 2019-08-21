#' Parse bill JSON files
#'
#' Import bill json and parse
#'
#' @param bill_json Path to bill json file
#'
#' @import jsonlite
#' @import progress
#' @importFrom purrr keep compact flatten_df
#' @importFrom data.table rbindlist setDF
#' @importFrom tibble as_tibble
#'
#' @return list
#'
#' @export
#'
parse_bill <- function(bill_json){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  parsing bills [:bar] :percent in :elapsed.",
    total = length(bill_json), clear = FALSE, width = 60)
  pb$tick(0)

  # Inner function to extract meta data from single bill
  extract_bill_meta <- function(input_bill){

    # Increment progress bar
    pb$tick()

    # # Check if input is list of path to local json
    # if (is.list(input_bill)) {
    #   input_bill <- input_bill
    # } else if (is.character(input_bill)) {
    #   # Import json
    #   input_bill <- jsonlite::fromJSON(input_bill)
    #   input_bill <- input_bill[["bill"]]
    # }

    # Import json
    input_bill <- jsonlite::fromJSON(input_bill)
    input_bill <- input_bill[["bill"]]

    elements_single <- c("bill_id",
                         "change_hash",
                         "url",
                         "state_link",
                         "status",
                         "status_date",
                         "state",
                         "state_id",
                         "bill_number",
                         "bill_type",
                         "bill_type_id",
                         "body",
                         "body_id",
                         "current_body",
                         "current_body_id",
                         "title",
                         "description",
                         "pending_committee_id")

    # Keep all elements with single value (i.e. not df or list)
    bill_info <- purrr::keep(input_bill, names(input_bill) %in% elements_single)

    # Extract session info
    session <- input_bill[["session"]]

    # Combine bill info with session info
    bill_meta <- c(bill_info, session)

    # Flatten into df
    bill_meta <- purrr::compact(bill_meta)
    bill_meta <- purrr::flatten_df(bill_meta)

    # End of inner function extracting meta data from single bill object
    bill_meta
  }

  # Iterate over input bill list to extract meta data from each one
  output_list <- lapply(bill_json, extract_bill_meta)

  # Bind list into flat data frame
  output_df <- data.table::rbindlist(output_list, fill = TRUE)
  output_df  <- tibble::as_tibble(data.table::setDF(output_df))

  # End of function call
}
