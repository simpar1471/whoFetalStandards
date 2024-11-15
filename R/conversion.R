#' Convert values to z-scores/centiles in the WHO Fetal Standards
#' @param y Numeric vectors of fetal biometry values. These should have the
#'   units specified below for `acronym`.
#' @param gest_days A numeric vector of lenght one or more with gestational ages
#' in days. Elements should be between 98 and 280 days (14 to 40 weeks).
#' @param sex A character vector of "M" and "F" values (case-sensitive). Only
#' used for the WHO estimated fetal weight (EFW)-for-GA standard, which uses
#' sex-specific coefficients for each quantile where `sex` is either `"M"` or
#' `"F"`. An error will be thrown if there are values in `sex` which are not
#' `"M"` or `"F"`.
#' @param acronym A single string denoting the WHO Fetal Standard in use.
#'   Available acronyms are:
#'   * "acfga" - abdominal circumference (mm)-for-GA
#'   * "bpdfga" - biparietal diameter (mm)-for-GA
#'   * "efwfga" - estimated fetal weight (grams)-for-GA
#'   * "flfga" - femur length (mm)-for-GA
#'   * "hcfga" - head circumference (mm)-for-GA
#'   * "hlfga" - humerus length (mm)-for-GA
#'
#'   `acronym` is case-sensitive, and an error will be thrown if `acronym` is
#'   not one of the above values.
#' @examples
#' # Get a centile for a femur length value
#' value2centile(30, 20 * 7, acronym = "flfga")
#'
#' # Get a centile for an estimated fetal weight value in males
#' value2centile(330, 20 * 7, "M", "efwfga")
#'
#' # Get the equivalent z-score
#' value2zscore(330, 20 * 7, "M", "efwfga")
#'
#' # The function is vectorised and will recycle inputs
#' value2zscore(seq(300, 390, 30), 20 * 7, "F", "efwfga")
#' @returns A numeric vector of centiles (`value2centile()`) or z-scores
#'   `value2zscore()`. Where centiles/z-scores would be very extreme (i.e.
#'   above the)
#' @inherit who_fet_coeffs references
#' @rdname value2centile
#' @export
value2centile <- function(y, gest_days, sex = NULL, acronym) {
  checkmate::assert_numeric(y)
  checkmate::assert_numeric(gest_days)
  checkmate::assert_character(sex, pattern = "M|F", null.ok = TRUE)
  inputs <- vctrs::list_drop_empty(list(y = y,
                                        gest_days = gest_days,
                                        sex = sex))
  inputs <- do.call(vctrs::vec_recycle_common, args = inputs)
  if (!checkmate::test_string(acronym)) {
    cli::cli_abort(c(
      "`acronym` must be a string.",
      "i" = "`acronym` was class {.cls {class(acronym)}} with length {.val {length(acronym)}}."
      ))
  }
  acronym_choices <- c("acfga", "bpdfga", "efwfga", "flfga", "hcfga", "hlfga")
  if (!checkmate::test_subset(acronym, choices = acronym_choices)) {
    cli::cli_abort(c("`acronym` must be one of {.val {acronym_choices}}.",
                     "i" = "`acronym` was {.val {acronym}}."))
  }
  with(inputs, who_fet_v2c_internal(y, gest_days, sex, acronym))
}

#' @rdname value2centile
#' @importFrom stats qnorm
#' @export
value2zscore <- function(y, gest_days, sex = NULL, acronym) {
  qnorm(value2centile(y, gest_days, sex, acronym))
}

#' Get centiles in the WHO Fetal Standards for the sex-specific EFW charts
#' (internal)
#' @inherit value2centile params return
#' @importFrom stats complete.cases
#' @noRd
who_fet_v2c_internal <- function(y, gest_days, sex, acronym) {
  gest_wks <- gest_days / 7
  if (acronym != "efwfga" | is.null(sex)) {
    sex <- rep_len("no_sex", length(y))
  } else {
    sex[is.na(sex)] <- "no_sex"
  }
  is_complete <- complete.cases(y, gest_days, sex)
  out <- rep_len(NA_real_, length(y))
  for (curr_sex in unique(sex[is_complete])) {
    coeff_set <- whoFetalStandards::who_fet_coeffs[[acronym]][[
      switch(curr_sex, "M" = "male", "F" = "female", "no_sex")
    ]]
    is_curr_sex <- is_complete & sex == curr_sex
    for (ga in unique(gest_wks[is_curr_sex], na.rm = TRUE)) {
      is_curr_ga <- is_complete & gest_wks == ga
      curr_y <- y[is_curr_ga & is_curr_sex]
      out[is_curr_ga & is_curr_sex] <- who_fet_v2c_from_coeffs(coeff_set,
                                                               curr_y, ga)
    }
  }
  if (anyNA(out[is_complete])) {
    complete_led_to_NA <- is_complete & is.na(out)
    n_complete_led_to_NA <- sum(complete_led_to_NA)
    cli::cli_warn(message = c(
      paste0("Your output had {.val {n_complete_led_to_NA}} extreme ",
             "measurement{?s}, which {cli::qty(n_complete_led_to_NA)}",
             "{?is/are} now `NA`."),
      "!" = paste0("This happened for {cli::qty(n_complete_led_to_NA)} ",
                   "observation{?s} ",
                   "{.val {cli::cli_vec(which(complete_led_to_NA))}}."),
      "i" = paste0("This means that {cli::qty(n_complete_led_to_NA)}",
                   "{?this/these} {cli::qty(n_complete_led_to_NA)}centile{?s} ",
                   "{cli::qty(n_complete_led_to_NA)}{?was/were} ",
                   "<{.val {0.01}} and >{.val {0.99}}.")
    ))
  }
  out
}

#' INTERNAL: Get centiles from the WHO Fetal standards using a dataframe with
#' coefficients
#' @param coeff_set A set of coefficients from the WHO Fetal Standards.
#' @param y A numeric vector with measured fetal biometry values.
#' @param ga_wks A numeric vector with gestational age in weeks.
#' @importFrom stats approx
#' @noRd
who_fet_v2c_from_coeffs <- function(coeff_set, y, ga_wks) {
  quantiles <- with(
    coeff_set,
    b0 + b1 * ga_wks + b2 * ga_wks^2 + b3 * ga_wks^3 + b4 * ga_wks^4
  )
  # Linearly approximate centile (not on log scale)
  approx(x = exp(quantiles),
         y = coeff_set$quantile,
         xout = y)$y
}
