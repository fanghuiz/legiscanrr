#' Lookup table
#'
#' Numerica value and corresponding description.
#' Can be used as reference, or be used to join with parsed json data.
#'
#' @format A list with 6 elements, each a data.frame with numeric id and corresponding description
#' \describe{
#'   \item{\code{stateID}}{State abbreviation and name}
#'   \item{\code{billStatusDict}}{Bill final status}
#'   \item{\code{billSponsorDict}}{Sponsor type}
#'   \item{\code{billProgressDict}}{Important events of bill progress}
#'   \item{\code{billTypeDict}}{Type of bill}
#'   \item{\code{billTextTypeDict}}{Type of bill text document}
#'   \item{\code{mimeTypeDict}}{Bill text document mime type}
#' }
#'
#' For further details, see LegiScan API documentation \url{https://legiscan.com/gaits/documentation/legiscan}
#'
"lookup_table"
