#' Parse bill progress
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
#' @return data.frame
#'
#' @export
parse_bill_progress <- function(bill_json){

  # Initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  ༼ つ ◕_◕ ༽つ GIVE PROGRESS [:bar] :percent in :elapsed.",
    total = length(bill_json), clear = FALSE, width= 60)
  pb$tick(0)

  # Inner function
  extract_progress <- function(input_bill_json){

    pb$tick()

    # Import json
    input_bill <- jsonlite::fromJSON(input_bill_json)

    if (length(input_bill[["bill"]][["progress"]]) == 0){

      return(NULL)

    } else {

      # Extract progress element
      bill_progress <- input_bill[["bill"]][["progress"]]
      bill_progress$bill_id = input_bill[["bill"]][["bill_id"]]

      bill_progress
    }
    # End of inner function call
  }

  # Iterate over input json to decode text one by one
  output_list <- bill_json %>%
    purrr::map(extract_progress)

  output_df <- output_list %>%
    data.table::rbindlist(fill = TRUE)
  output_df
  # End of function call
}
