#' Parse bill JSON files
#'
#' Import bill json and parse
#'
#' @param bill_json Path to bill json file
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
parse_bill <- function(bill_json){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  ༼ つ ◕_◕ ༽つ GIVE BILL [:bar] :percent in :elapsed.",
    total = length(bill_json), clear = FALSE, width = 60)
  pb$tick(0)

  # Inner function
  extract_bill_meta <- function(input_bill_json){

    pb$tick()

    # Import json
    input_bill <- input_bill_json %>%
      jsonlite::fromJSON()

    # Keep inner element
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
    bill_meta <- bill_meta %>%
      purrr::compact() %>%
      purrr::flatten_df()

    bill_meta
    # End of inner functionn
  }

  # Iterate over input json to decode text one by one
  output_list <- bill_json %>%
    purrr::map(extract_bill_meta)

  output_df <- output_list %>%
    data.table::rbindlist(fill = TRUE)
  output_df
  # End of function call

}
