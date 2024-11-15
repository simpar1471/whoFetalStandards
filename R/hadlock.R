#' Estimate fetal weight with Hadlock's three-parameter formula
#' @param headcirc_cm,abdocirc_cm,femurlen_cm Numeric vectors of length one or
#'   more with head circumference/abdominal circumference/femur length
#'   measurements in centimetres. These inputs should be recyclable by
#'   `vctrs::vec_recycle_common()`.
#' @references
#' Hadlock F, Harrist R, Sharman R, et al. **Estimation of fetal weight with the
#' use of head, body, and femur measurements — a prospective study.** *Am J
#' Obstet Gynecol.* 1985, **151(3):333–7)**.
#' @examples
#' hadlock_efw(5, 5, 5)
#' @returns A numeric vector the same length as the inputs, with Hadlock's
#'   estimated fetal weight values in grams.
#' @export
hadlock_efw <- function(headcirc_cm, abdocirc_cm, femurlen_cm) {
  checkmate::check_numeric(headcirc_cm, min.len = 1)
  checkmate::check_numeric(abdocirc_cm, min.len = 1)
  checkmate::check_numeric(femurlen_cm, min.len = 1)
  inputs <- list(hc = headcirc_cm, ac = abdocirc_cm, fl = femurlen_cm)
  inputs <- do.call(vctrs::vec_recycle_common, args = inputs)
  log10_efw <- with(
    inputs, 1.326 + 0.0107 * hc + 0.0438 * ac + 0.158 * fl - 0.00326 * ac * fl
  )
  10^(log10_efw)
}
