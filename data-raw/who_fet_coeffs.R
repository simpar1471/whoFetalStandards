coeffs_global <- read.csv(file.path("data-raw",
                                    "coeffs",
                                    "coefficientsGlobalV3.csv")) |>
  dplyr::mutate(fetalDimension = paste0(tolower(fetalDimension), "fga"))

who_fet_coeffs <- list(
  acfga = list(no_sex = NULL, x = NULL, y = NULL),
  bpdfga = list(no_sex = NULL, x = NULL, y = NULL),
  efwfga = list(male = NULL, female = NULL, no_sex = NULL, x = NULL, y = NULL),
  flfga = list(no_sex = NULL, x = NULL, y = NULL),
  hcfga = list(no_sex = NULL, x = NULL, y = NULL),
  hlfga = list(no_sex = NULL, x = NULL, y = NULL))

for (acronym in unique(coeffs_global$fetalDimension)) {
  who_fet_coeffs[[acronym]][["no_sex"]] <- coeffs_global |>
    dplyr::filter(fetalDimension == acronym) |>
    dplyr::select(!fetalDimension)
}
coeffs_efw <- read.csv(file.path("data-raw",
                                  "coeffs",
                                  "coefficientsEFWBySexV3.csv"))

for (sex_chr in rev(unique(coeffs_efw$sex))) {
  sex_str <- switch(sex_chr, "M" = "male", "F" = "female")
  who_fet_coeffs[["efwfga"]][[sex_str]] <- coeffs_efw |>
    dplyr::filter(sex == sex_chr) |>
    dplyr::select(!sex)
}

for (acronym in names(who_fet_coeffs)) {
  who_fet_coeffs[[acronym]][["x"]] <- "gest_days"
  who_fet_coeffs[[acronym]][["y"]] <-
    switch(acronym,
           acfga = "abdocirc_mm",
           bpdfga = "bpd_mm",
           efwfga = "efw_g",
           flfga = "femurlen_mm",
           hcfga = "headcirc_mm",
           hlfga = "humeruslen_mm")
}

usethis::use_data(who_fet_coeffs, overwrite = TRUE)
