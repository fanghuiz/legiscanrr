#' Helper functions

#' Check for internet
#'
#' @importFrom attempt stop_if_not
#' @importFrom curl has_internet
check_internet <- function(){
  attempt::stop_if_not(.x = curl::has_internet(),
                       msg = "Please check your internet connection")
}


#' Check http status
#'
#' @importFrom httr status_code
check_http_status <- function(resp){
  attempt::stop_if_not(
    .x = httr::status_code(resp),
    .p = ~ .x == 200,
    msg = paste0("Error: status code ", httr::status_code(resp)))
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
check_API_response <- function(content){
  attempt::stop_if(
    .x = content$status,
    .p = ~ .x == "ERROR",
    msg = content$alert$message)
}


#' URLs for API requests
base_url <- "https://api.legiscan.com/"


