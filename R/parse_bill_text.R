#' Parse bill text json and decode from base64 to plain text
#'
#' Return a list containing bill text in a character string, and meta data
#'
#' @param bill_text_json
#'
#' @import dplyr
#' @import purrr
#' @import magrittr
#' @importFrom magrittr "%>%"
#' @import jsonlite
#' @import readtext
#' @import progress
#' @importFrom data.table rbindlist
#'
#' @return list of 6 elements
#'
#' @export
parse_bill_text <- function(bill_text_json){

  # initialize progress bar
  pb <- progress::progress_bar$new(
    format = "  ༼ つ ◕_◕ ༽つ GIVE TEXT [:bar] :percent in :elapsed.",
    total = length(bill_text_json), clear = FALSE, width= 60)
  pb$tick(0)

  # Decode each bill_text_json from base64 to character string
  decode_to_char <- function(input_bill_text_json){

    # Start counter
    pb$tick()

    input_bill_text <- input_bill_text_json %>%
      jsonlite::fromJSON()

    # Find correct file extension
    if(input_bill_text[["mime"]] == "text/html"){
      ext <- ".html"
    }

    if(input_bill_text[["mime"]] == "application/pdf"){
      ext <- ".pdf"
    }

    if(input_bill_text[["mime"]] == "application/wpd"){
      ext <- ".wpd"
    }

    if(input_bill_text[["mime"]] == "application/doc" |
       input_bill_text[["mime"]] == "application/docx"){
      ext <- ".docx"
    }

    if(input_bill_text[["mime"]] == "application/rtf"){
      ext <- ".rtf"
    }

    tmp <- tempfile(fileext = ext)

    input_bill_text[["doc"]] %>%
      jsonlite::base64_dec() %>%
      writeBin(tmp)

    text_decoded <- readtext::readtext(tmp) %>%
      dplyr::pull(text)

    output_doc <- list(doc_id = input_bill_text[["doc_id"]],
                       bill_id = input_bill_text[["bill_id"]],
                       date = input_bill_text[["date"]],
                       type = input_bill_text[["type"]],
                       type_id = input_bill_text[["type_id"]],
                       text = text_decoded)
    # Return a list of a single bill text doc
    output_doc <- purrr::compact(output_doc)

    # End of inner function decode_to_char
  }

  # Iterate over input json to decode text one by one
  output_list <- bill_text_json %>%
    purrr::map(decode_to_char)

  output_df <- output_list %>%
    data.table::rbindlist(fill = TRUE)
  output_df
  # End of function call
}
