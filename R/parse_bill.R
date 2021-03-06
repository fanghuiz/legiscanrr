#' Parse bill meta-data
#'
#' Parse bill meta-data from local json or API response and return a data frame.
#'
#' @param bill Path to bill json file or list objected returned from
#' \code{\link{get_bill}}
#'
#' @importFrom jsonlite fromJSON
#' @importFrom progress progress_bar
#' @importFrom purrr keep compact flatten_df
#' @importFrom data.table rbindlist setDF
#' @importFrom tibble as_tibble
#'
#' @examples
#' HB1 <- system.file("extdata", "bill/HB1.json", package = "legiscanrr")
#' HB1 <- parse_bill(HB1)
#' str(HB1)
#'
#' @return A data frame of 24 columns.
#' For more details, see \href{../articles/parse-json.html#bill-metadata}{documentation}.
#'
#' @export
#'
parse_bill <- function(bill){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  parsing bills [:bar] :percent in :elapsed.",
    total = length(bill), clear = FALSE, width = 60)
  pb$tick(0)

  # Inner function to extract meta data from single bill
  extract_bill_meta <- function(input_bill){

    # Increment progress bar
    pb$tick()

    # Check if input is class `bill` or json file
    input_class <- check_input_class(input_bill, "billData")

    # As-is if input is list returned from API
    if (input_class == "billData") {
      input_bill <- input_bill
    }

    # Import if input is local json file
    if (input_class == "json") {
      input_bill <- jsonlite::fromJSON(input_bill)
      input_bill <- input_bill[["bill"]]
    }

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

  # If input is single bill object
  if (class(bill)[1] == "billData") {
    output_df <- extract_bill_meta(bill)
    output_df
  }
  # Iterate over input bill list to extract meta data from each one
  else {
    output_list <- lapply(bill, extract_bill_meta)

    # Bind list into flat data frame
    output_df <- data.table::rbindlist(output_list, fill = TRUE)
    output_df  <- tibble::as_tibble(data.table::setDF(output_df))
    output_df
  }
  # End of function call
}
