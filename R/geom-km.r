#' Add a Kaplan-Meier survival curve
#'
#' @section Aesthetics:
#' \Sexpr[results=rd,stage=build]{ggplot2:::rd_aesthetics("geom", "km")}
#'
#' @inheritParams geom_smooth
#' @seealso The default stat for this geom is \code{\link{stat_km}} see
#'   that documentation for more options to control the underlying statistical transformation.
#' @export
#' @examples
#' df <- survival::lung
#' ggplot(df, aes(x = time, status = status, color = factor(sex))) + geom_km()
#' qplot(time, status = status, data = df, geom = "km")

geom_km <- function (mapping = NULL, data = NULL, stat = "km", position = "identity", ...) {
  GeomKm$new(mapping = mapping, data = data, stat = stat, position = position, ...)
}

GeomKm <- proto(Geom, {
  objname <- "km"

  draw <- function(., data, scales, coordinates, ...) {
    ribbon <- transform(data, colour = NA)
    path <- transform(data, alpha = NA)

    has_ribbon <- function(x) !is.null(x$ymax) && !is.null(x$ymin)

    gList(
      if (has_ribbon(data)) GeomRibbon$draw(ribbon, scales, coordinates),
      GeomStep$draw(path, scales, coordinates)
    )
  }

  default_stat <- function(.) StatKm
  required_aes <- c("x", "y")
  default_aes <- function(.) aes(colour="black", fill="grey60", size=.75, linetype=1, weight=1, alpha=0.4)

  guide_geom <- function(.) "smooth"


})
