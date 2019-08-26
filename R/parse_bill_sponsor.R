#' Parse bill sponsor information
#'
#' Parse bill sponsor information from local json or API response and return a data frame.
#'
#' Sponsor type is represented in numeric id.
#' See \href{../articles/lookup_table.html#sponsor-type-id}{lookup table} for description.
#'
#' @param bill Path to bill json file or list objected returned from
#' \code{\link{get_bill}}
#'
#' @import jsonlite
#' @import progress
#' @importFrom purrr keep
#' @importFrom tibble as_tibble
#' @importFrom data.table rbindlist setDF
#'
#' @return A data frame of 9 columns.
#' For more details, see \href{../articles/parse-json.html#bill-sponsors}{documentation}.
#'
#' @examples
#' HB1 <- system.file("extdata", "bill/HB1.json", package = "legiscanrr")
#' HB1 <- parse_bill_sponsor(HB1)
#' str(HB1)
#'
#' @export
parse_bill_sponsor <- function(bill){

  # initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  parsing sponsors [:bar] :percent in :elapsed.",
    total = length(bill), clear = FALSE, width= 60)
  pb$tick(0)

  extract_sponsor <- function(input_bill){

    # Increment progress bar
    pb$tick()

    cols_to_keep <- c("people_id",
                      "party_id",
                      "party",
                      # "role_id",
                      # "role",
                      "name",
                      # "first_name",
                      # "middle_name",
                      # "last_name",
                      # "suffix",
                      # "nickname",
                      # "district",
                      # "ftm_eid",
                      # "votesmart_id",
                      # "opensecrets_id",
                      # "ballotpedia",
                      "sponsor_type_id",
                      "sponsor_order",
                      "committee_sponsor",
                      "committee_id"
    )

    # Check if input is class `bill` or json file
    input_class <- check_input_class(input_bill, "billData")

    # If input is list returned from API
    if (input_class == "billData") {

      # Extract progress element
      sponsor <- input_bill[["sponsors"]]

      # Bind as data frame
      sponsor <- data.table::rbindlist(sponsor, fill = TRUE)
      sponsor <-  purrr::keep(sponsor, names(sponsor) %in% cols_to_keep)
      sponsor$bill_id = input_bill[["bill_id"]]

      sponsor
    }

    # If input is local json file
    else if (input_class == "json") {

      # Import json
      input_bill <- jsonlite::fromJSON(input_bill)

      # Keep inner element
      input_bill <- input_bill[["bill"]]

      if (length(input_bill[["sponsors"]]) == 0){
        return(NULL)
      } else {

        sponsor <- input_bill[["sponsors"]]
        sponsor <-  purrr::keep(sponsor, names(sponsor) %in% cols_to_keep)
        sponsor$bill_id <- input_bill[["bill_id"]]

        sponsor
      }

    # End of inner function
    }
  }

  # If input is single bill object
  if (class(bill)[1] == "billData") {
    output_df <- extract_sponsor(bill)
    output_df
  }
  # Iterate over input bill list to extract meta data from each one
  else {
    output_list <- lapply(bill, extract_sponsor)

    # Bind list into flat data frame
    output_df <- data.table::rbindlist(output_list, fill = TRUE)
    output_df  <- tibble::as_tibble(data.table::setDF(output_df))
    output_df
  }
  # End of function call
}
