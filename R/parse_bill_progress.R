#' Parse bill progress events
#'
#' Parse bill progress data from local json or API response and return a data frame.
#'
#' Progress event is represented in numeric id.
#' See \href{../articles/lookup_table.html#bill-progress-id}{lookup table} for description.
#'
#' @param bill Path to bill json file or list objected returned from
#' \code{\link{get_bill}}
#'
#' @importFrom jsonlite fromJSON
#' @importFrom progress progress_bar
#' @importFrom data.table rbindlist setDF
#' @importFrom  tibble as_tibble
#'
#' @return A data frame of 3 columns.
#' For more details, see \href{../articles/parse-json.html#bill-progress}{documentation}.
#'
#' @examples
#' HB1 <- system.file("extdata", "bill/HB1.json", package = "legiscanrr")
#' HB1 <- parse_bill_progress(HB1)
#' str(HB1)
#'
#' @export
parse_bill_progress <- function(bill){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  parsing bill progress [:bar] :percent in :elapsed.",
    total = length(bill), clear = FALSE, width= 60)
  pb$tick(0)

  # Inner function
  extract_progress <- function(input_bill){

    pb$tick()

    # Check if input is class `bill` or json file
    input_class <- check_input_class(input_bill, "billData")

    # If input is list returned from API
    if (input_class == "billData") {

        # Extract progress element
        bill_progress <- input_bill[["progress"]]

        # Bind as data frame
        bill_progress <- data.table::rbindlist(bill_progress, fill = TRUE)
        bill_progress$bill_id = input_bill[["bill_id"]]

        bill_progress
    }

    # If input is local json file
    else if (input_class == "json") {

      input_bill <- jsonlite::fromJSON(input_bill)
      input_bill <- input_bill[["bill"]]

      # Extract progress element
      bill_progress <- input_bill[["progress"]]
      bill_progress$bill_id = input_bill[["bill_id"]]

      bill_progress
    }
  }

  # If input is single bill object
  if (class(bill)[1] == "billData") {
    output_df <- extract_progress(bill)
    output_df
  }
  # Iterate over input bill list to extract meta data from each one
  else {
    output_list <- lapply(bill, extract_progress)

    # Bind list into flat data frame
    output_df <- data.table::rbindlist(output_list, fill = TRUE)
    output_df  <- tibble::as_tibble(data.table::setDF(output_df))
    output_df
  }
  # End of function call
}
