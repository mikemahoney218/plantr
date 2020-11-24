#' Search the USDA PLANTS database API
#'
#' Most parameter descriptions below have been adapted from the official USDA
#' PLANTS Web Services Interface Definition.
#' If the search is broad, and if the number of symbols to be returned are
#' greater than 10,then only basic information of those symbols are returned.
#' If more detailed records are required, please narrow the search criteria.
#'
#' @param symbol Returns plants that match the USDA symbol given. Example
#' values: ABBA, CAR.
#' @param scientific_name Returns plants that match the specified scientific
#' name (without author).  Parameter is case sensitive.
#' Example value: Abies balsamea.
#' @param common_name Represents the National Common Name (Also known as the
#' accepted or preferred common name). Returns plants that match the specified
#' common name. Parameter is case sensitive. Example values: balsam fir.
#' @param state_province Returns plants that are present in the specified state
#' or province. When state is specified it should be referenced as state name.
#' Example values: Alabama, Colorado, Alberta.
#' @param county Returns plants that are present in the specified county.
#' Example values (for the state of Colorado): Adams, Larimer, Yuma.
#' @param introduced,native Only one of these
#' parameters may be specified. A list of acceptable values is included below.
#' @param federal_noxious Returns only plants that have the specified federal
#' noxious status. Current statuses are "Noxious Weed" (`nw`), "Quarantine"
#' (`q`).
#' @param state_noxious Returns only plants that are designated as noxious weeds
#' (or equivalent) in a specified state. As the categories of noxious weeds vary
#' greatly by state, specific noxious codes are not used as a filter. When state
#' is specified it can be referenced as state code. Example values: UT, AZ
#' @param federal_te Returns only plants that have the specified federal
#' threatened, endangered status. The possible statuses are `endangered` or
#' `threatened`.
#' @param state_te Returns only plants that are designated on any threatened or
#' endangered list in the specified state. As the categories of threatened and
#' endangered weeds vary greatly by state, specific codes are not used as a
#' filter. When state is specified it can be referenced as state code. Example
#' values: CO, CA
#' @param basic Logical: should the search use the basic API (returning data on
#' plant symbols, accepted common names, and scientific names) or the full
#' API which returns much more data? Note that queries using the full API
#' without many parameters (such as searching using a common name or symbol
#' without specifying restrictions using the other arguments) may take a long
#' time, time out or error in unexpected ways, or (if more than 10 species will
#' be returned) fall back to using the basic API with a warning. When using the
#' full API, it is often a good idea to run multiple queries for smaller regions
#' rather than attempting to run a single query for a larger region.
#' @param flatten Logical: attempt to flatten nested data frames into a
#' data frame with fewer nested layers? Passed to [jsonlite::fromJSON].
#'
#' @section Nativity status:
#' Only one of `introduced` and `native` may be
#' specified in a single API call, as filtering for only introduced species in a
#' region necessarily excludes native species in that region.
#'
#' Valid values for these fields are:
#' * `l48`: Lower 48 states
#' * `Ak`: Alaska
#' * `Hi`: Hawaii
#' * `pr`: Puerto Rico
#' * `vi`: U.S. Virgin Islands
#' * `can`: Canada
#' * `gl`: Greenland (Denmark)
#' * `spm`: St. Pierre and Miquelon (France)
#' * `na`: North America
#'
#' Specifying `introduced = l48`, for example, will return a list of introduced
#' species within the lower 48 states, while `native = Hi` will return a list of
#' plants native to Hawaii.
#'
#' @name ptr_search
#'
#' @return A data frame containing the data returned by the API call requested.
#'
#' @examples
#' \dontrun{
#' # Get basic results matching the common name "balsam fir":
#' ptr_search(common_name = "balsam fir")
#'
#' # Get full results for the same query:
#' ptr_search(common_name = "balsam fir", basic = FALSE)
#'
#' }
#'
#' @export
ptr_search <- function(symbol = NULL,
                       scientific_name = NULL,
                       common_name = NULL,
                       state_province = NULL,
                       county = NULL,
                       introduced = NULL,
                       native = NULL,
                       federal_noxious = NULL,
                       state_noxious = NULL,
                       federal_te = NULL,
                       state_te = NULL,
                       basic = TRUE,
                       flatten = TRUE) {

  if (sum(is.null(introduced),
          is.null(native)) == 0) {
    stop("Can only specify one of introduced and",
         "native -- otherwise, all species are excluded.")
  }

  if (!is.null(federal_te)) federal_te <- tolower(federal_te)

  if (!is.null(federal_noxious)) {
    federal_noxious <- tolower(federal_noxious)
    if (federal_noxious == "noxious weed") federal_noxious <- "nw"
    if (federal_noxious == "quarantine") federal_noxious <- "q"
  }

  query_url <- "http://plants.usda.gov/api/plants/search"
  if (basic) {
    query_url <- paste0(query_url, "/basic")
  }

  # you can't have NULL elements in a vector, so wrapping all the arguments to
  # our API call in a vector, then making a list from that vector, ensures we're
  # only using provided arguments
  query_args <- c(symbol = symbol,
                  scientific_name = scientific_name,
                  common_name = common_name,
                  state_province = state_province,
                  county = county,
                  nativityIntroducedSelected = introduced,
                  nativityNativeSelected = native,
                  federal_noxious = federal_noxious,
                  state_noxious = state_noxious,
                  federal_te = federal_te,
                  state_te = state_te)
  # Create a named list of all non-NULL arguments from the above step
  query_args <- lapply(query_args, function(x) x)

  query_url <- httr::modify_url(query_url,
                                query = query_args)

  res <- httr::GET(query_url,
                   httr::add_headers(accept = "application/json"))

  res <- jsonlite::fromJSON(httr::content(res, as = "text"),
                            flatten = flatten)[[1]]

  if (length(res) == 2 && !basic) {
    # This warning is returned as data by the USDA, so we need to raise it as a
    # warning on our own
    warning("This is basic search. To see more information narrow your search ",
    "or do a full search.")
  }

  return(res[[length(res)]])
}
