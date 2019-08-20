#' Wrapper for getBillText operation
#'
#' Return bill text and save to disk
#'
#' @param api_key LegiScan API key (required)
#' @param bill_json
#'
#' @import dplyr
#' @import tidyr
#' @import purrr
#' @import magrittr
#' @importFrom magrittr "%>%"
#' @import httr
#' @import fs
#'
#' @return data.frame
#'
#' @export
get_bill_text <- function(bill_json, api_key){

  # initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  ♪┏(・o･)┛♪ downloading [:bar] :percent in :elapsed.",
    total = length(bill_json), clear = FALSE, width= 60)
  pb$tick(0)

  call_api_text <- function(input_bill_json){

    # Start counter
    pb$tick()

    # Import json
    bill <- jsonlite::fromJSON(input_bill_json)

    # Return NULL is no texts element exist
    if (length(bill[["bill"]][["texts"]]) == 0) {

      return(NULL)

    } else {

      # Get the unique id for bill text, to be used for API
      doc_id <- bill[["bill"]][["texts"]][["doc_id"]]

      # Generate API request url
      text_url <- paste0("https://api.legiscan.com/?key=", api_key,
                         "&op=getBillText&id=", doc_id)

      # Find directory to save text json in. Same session directory as the associated bill
      doc_dir <- fs::path_dir(input_bill_json) %>% fs::path_dir()
      doc_dir <- paste0(doc_dir, "/text/")

      # Create directory if does not exist
      fs::dir_create(doc_dir)

      # Send API request and get response
      resp_text <- text_url %>%
        purrr::map(httr::GET) %>%
        purrr::map(httr::content)

      # Write API response to local disk
      text <- resp_text %>%
        map(function(x){

          # Check for API errors and send message
          if(x[["status"]] == "ERROR"){
            message(x[[2]])
          } else {

            # Create path to save the text.json in
            file_path <- (paste0(doc_dir, x[["text"]][["doc_id"]], ".json"))
            # Save as json
            jsonlite::write_json(x[["text"]], path = file_path)
          }
        })
    }
    # End of inner function
  }

  # Iterate over input bill json to download text json
  bill_json %>%
    purrr::walk(call_api_text)

  # End of function
}
