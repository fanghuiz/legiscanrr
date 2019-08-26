#' Get master list of bills in a session
#'
#' This is the API wrapper function for the getMasterList operation.
#' It returns a master list of bills in a given session,
#' or in the current session of a given state.
#'
#' Only one of the two parameters are accepted: specifying \code{state} paramter
#' returns the bill master list of the current session from that state; specifying
#' the \code{session_id} parameter returns the bill master list of that specific session.
#'
#' @param state Two letter abbreviation of the state
#' @param session_id Session identifier
#' @param api_key Your LegiScan API key (see \code{\link{legiscan_api_key}})
#'
#' @import httr
#' @importFrom data.table rbindlist setDF
#' @importFrom tibble as_tibble
#'
#' @seealso \code{\link{legiscan_api_key}},
#' \href{https://legiscan.com/gaits/documentation/legiscan}{LegiScan API manual}.
#'
#' @return Data frame of bill information in the session requested,
#' including `bill_id` and other information.
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
get_bill_masterlist <- function(state = NULL,
                                session_id = NULL,
                                api_key = legiscan_api_key()) {

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
