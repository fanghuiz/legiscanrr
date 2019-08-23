#' Helper functions
#'
#' @name utils
NULL

#' Check for internet connection
#'
#' @import assertthat
#' @importFrom curl has_internet
#' @rdname utils
check_internet <- function(){
  assertthat::assert_that(
    curl::has_internet(),
    msg = "Please check your internet connection"
  )
}


#' Check http status
#'
#' @import assertthat
#' @importFrom httr status_code
#' @rdname utils
check_http_status <- function(resp){
  assertthat::assert_that(
    httr::status_code(resp) == 200,
    msg = paste0("Status code ", httr::status_code(resp))
  )
}

# Check content is json
# check_content_type <- function(resp){
#   attempt::stop_if_not(
#     .x = httr::http_type(resp),
#     .p = ~ .x == "application/json",
#     msg = paste0("Error: API did not return json. \n", resp$url)
#     )
# }

#' Check API request errors
#'
#' @import assertthat
#' @rdname utils
check_API_response <- function(content){
  assertthat::assert_that(
    content$status == "OK",
    msg = content$alert$message
  )
}

#' Check input file class, API return or local path to json
#'
#' @import assertthat
#' @rdname utils
check_input_class <- function(input, class){

  if (any(class(input) == class)) {
    input_class <- class
    input_class
  } else if (assertthat::has_extension(input[1], "json")) {
    input_class <- "json"
    input_class
  } else {
    class
  }
}


# URLs for API requests
base_url <- "https://api.legiscan.com/"
