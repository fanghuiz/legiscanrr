#' Decode bill text from base64 to plain text
#'
#' Return a list containing bill text in a character string, and meta data
#'
#' @param bill_text object returned from get_bill_text()
#'
#' @import jsonlite
#' @import readtext
#' @importFrom tibble as_tibble
#'
#' @return data frame of 10 columns
#'
#' @export
decode_bill_text <- function(bill_text){

  input_bill_text <- bill_text

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

  # Decode base64 to binary
  text_bin <- jsonlite::base64_dec(input_bill_text[["doc"]])

  # Write binary text to temp file using correct mime type extension
  tmp <- tempfile(fileext = ext)
  writeBin(text_bin, tmp)

  # Read in from temp file as plain text
  text_decoded <- readtext::readtext(tmp)
  text_decoded <- text_decoded[["text"]]

  # Return a dataframe with decoded texts added in
  output_bill_text <- tibble::as_tibble(input_bill_text)
  output_bill_text$text_decoded <- text_decoded
  output_bill_text
}
