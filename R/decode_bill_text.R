#' Decode based64 encoded bill text
#'
#' Full text of bill documents returned from LegiScan API is encoded in base64.
#' This function detects the document mime type, decodes the texts and turn it
#' as a character vector.
#'
#' @param bill_text List object or json file containing bill text details,
#' returned from \code{\link{get_bill_text}}
#'
#' @import readtext
#' @importFrom tibble as_tibble
#' @importFrom jsonlite base64_dec fromJSON
#' @importFrom assertthat has_extension
#'
#' @return  A data frame of 10 columns, containing all the information
#' returned from API query, with the decoded text attached.
#' See \href{../articles/decode-bill-text.html}{decode bill text vignette} for more.
#'
#' @seealso \code{\link{get_bill_text}}.
#' Text decoding utilizes R package \href{https://readtext.quanteda.io/}{readtext}.
#'
#' @export
decode_bill_text <- function(bill_text){

  # Check whether input is list returned from API or local path to json
  if (any(class(bill_text) == "billText")) {
    # As is if is API return
    input_bill_text <- bill_text
    input_bill_text
  } else if (assertthat::has_extension(bill_text, "json")) {
    # Import if is local json
    input_bill_text <- jsonlite::fromJSON(bill_text)
    input_bill_text
  }

  #input_bill_text <- bill_text

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
