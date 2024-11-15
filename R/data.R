#' WHO Fetal Standard quantile coefficients
#' @name who_fet_coeffs
#' @description
#' A list with data.frames containing `b0`, `b1`, `b2` and `b3` values for each
#' quantile of the Fetal Standards. These are used to calculate quantiles at
#' each GA, from which centiles can then be derived. For the estimated fetal
#' weight standards (`efwfga`), there are sex-specific tables as well as a
#' sex-agnostic table.
#' @references
#' Kiserud T, Piaggio G, Carroli G, et al. **The World Health Organization fetal
#' growth charts: a multinational longitudinal study of ultrasound biometric
#' measurements and estimated fetal weight.** *PLoS Med* 2017, **14:e1002220**.
#' \doi{10.1371/journal.pmed.1002220}
#'
#' Kiserud T, Benachi A, Hecher K, et al. **The World Health Organisation fetal
#' growth charts: concept, findings, interpretation, and application.** *Am J
#' Obstet Gynecol.* 2018, **218(2S):S619-29**. \doi{10.1016/j.ajog.2017.12.010}
#' @source
#' [whoFetalGrowth GitHub repo](https://github.com/jcarvalho45/whoFetalGrowth/)
#' @examples
#' names(whoFetalStandards::who_fet_coeffs)
#' head(whoFetalStandards::who_fet_coeffs$flfga)
#' @docType data
#' @keywords data
NULL
