#' Wrapper for getMasterList operation
#'
#' This operation returns a master list of bills in the given session or current state session.
#'
#' @param state State abr
#' @param session_id Session identifier
#' @param api_key Your LegiScan API key (see [legiscan_api_key()])
#'
#' @import httr
#' @importFrom data.table rbindlist setDF
#' @importFrom tibble as_tibble
#'
#' @return Data frame of bill information, including bill_id and bill number.
#'
#' @examples
#' \dontrun{
#' # One state
#' get_bill_masterlist(state = "PA")
#'
#' # Multiple states, use iterators, e.g. lapply() or map()
#' state_list <- c("AR", "AZ")
#' bills_current <- lapply(state_list, get_bill_masterlist)
#' }
#'
#' @export
get_bill_masterlist <- function(state = NULL, session_id = NULL, api_key = legiscan_api_key()) {

  # Stop if no state or session_id
  if (is.null(state) & is.null(session_id)){
    stop("Wrong input parameters: specify EITHER state OR sessions_id")
  }

  # Stop if both paramters are specified
  if (!is.null(state) & !is.null(session_id)){
    stop("Wrong input parameters: specify EITHER state OR sessions_id")
  }

  # Chek for internet
  check_internet()

  resp <- httr::GET(
    url = base_url,
    query = list(key = api_key, op = "getMasterList", state = state, id = session_id))

  # Get the content
  content <- httr::content(resp)

  # Check for errors in http status, API errors
  check_http_status(resp)
  check_API_response(content)

  # Keep the inner element content
  content <- content[["masterlist"]]

  # Extract session element
  session <- content[["session"]]

  # Remove session element from original list, keep bills only
  content[["session"]] <- NULL

  # Bind list of bills into flat data frame
  bill_df <- data.table::rbindlist(content, fill = TRUE)
  bill_df <- tibble::as_tibble(data.table::setDF(bill_df))

  # Combine session id back into bills df
  bill_df$session_id <- session$session_id
  bill_df$session_name <- session$session_name

  # Return dataframe of bills
  bill_df
}
