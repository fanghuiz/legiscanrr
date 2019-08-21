#' Parse bill sponsors
#'
#' Import bill json and parse
#'
#' @param bill_json Path to bill json file
#'
#' @import jsonlite
#' @import progress
#' @importFrom purrr keep
#' @importFrom tibble as_tibble
#' @importFrom data.table rbindlist setDF
#'
#' @return data.frame
#'
#' @export
parse_bill_sponsor <- function(bill_json){

  # initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  parsing sponsors [:bar] :percent in :elapsed.",
    total = length(bill_json), clear = FALSE, width= 60)
  pb$tick(0)

  extract_sponsor <- function(input_bill){

    # Increment progress bar
    pb$tick()

    # Import json
    input_bill <- jsonlite::fromJSON(input_bill)

    # Keep inner element
    input_bill <- input_bill[["bill"]]

    if (length(input_bill[["sponsors"]]) == 0){

      return(NULL)

    } else {

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

      sponsor <- input_bill[["sponsors"]]
      sponsor <-  purrr::keep(sponsor, names(sponsor) %in% cols_to_keep)
      sponsor$bill_id <- input_bill[["bill_id"]]

      return(sponsor)
    }
    # End of inner function
  }

  # Iterate over input json to decode text one by one
  output_list <- lapply(bill_json, extract_sponsor)

  # Bind list into flat data frame
  output_df <- data.table::rbindlist(output_list, fill = TRUE)
  output_df  <- tibble::as_tibble(data.table::setDF(output_df))

  # End of function call
}
