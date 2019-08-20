#' Lookup table
#'
#' Static values. Can be used as reference, or be used to join with parsed json data.
#'
#' @format A list with 6 elements, each a data.frame:
#' \describe{
#'   \item{\code{stateID}}{stateID}
#'   \item{\code{billStatus}}{probability of death at age \code{x}}
#'   \item{\code{billProgress}}{number of survivors, of birth cohort of 100,000, at next integral age}
#'   \item{\code{billType}}{number of deaths that would occur between integral ages}
#'   \item{\code{billTextType}}{Number of person-years lived between \code{x} and \code{x+1}}
#'   \item{\code{mimeType}}{Total number of person-years lived beyond age \code{x}}
#' }
#'
#' For further details, see LegiScan API documentation \url{https://legiscan.com/gaits/documentation/legiscan}
#'
"lookup_table"
