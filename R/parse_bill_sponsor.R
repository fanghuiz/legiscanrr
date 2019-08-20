#' Parse bill sponsors
#'
#' Import bill json and parse
#'
#' @param bill_json Path to bill json file
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
parse_bill_sponsor <- function(bill_json){

  # initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  ༼ つ ◕_◕ ༽つ GIVE SPONSOR [:bar] :percent in :elapsed.",
    total = length(bill_json), clear = FALSE, width= 60)
  pb$tick(0)

  extract_sponsor <- function(input_bill_json){

    # Increment progress bar
    pb$tick()

    # Import json
    input_bill <- input_bill_json %>%
      jsonlite::fromJSON()

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
  output_list <- bill_json %>%
    purrr::map(extract_sponsor)

  output_df <- output_list %>%
    data.table::rbindlist(fill = TRUE)
  output_df
  # End of function call
}
