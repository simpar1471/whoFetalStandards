test_that("Conversion to centiles works", {
  # Test `acfga` for multiple GA values
  expect_equal(
    round(value2centile(90, (14:16) * 7, NA, "acfga"),
          digits = 3) * 100,
    c(91.5, 39.9, 4.0)
  )

  # Test `bpdfga` for multiple GA values
  expect_equal(
    round(value2centile(92, (35:37) * 7, NA, "bpdfga"),
          digits = 3) * 100,
    c(91.6, 80.1, 64.9)
  )

  # Test `efwfga` for multiple GA values
  expect_equal(
    round(value2centile(100, 14 * 7, c(NA, "M", "F"), "efwfga"),
          digits = 3) * 100,
    c(80.4, 77.0, 85.1)
  )

  expect_equal(
    round(value2centile(340, 20 * 7, c(NA, "M", "F"), "efwfga"),
           digits = 3) * 100,
    c(59.8, 53.0, 68.5)
  )

  expect_equal(
    round(value2centile(3600, 40 * 7, c(NA, "M", "F"), "efwfga"),
          digits = 3) * 100,
    c(48.5, 46.0, 53.1)
  )
})

test_that("Conversion to z-scores work", {
  # Test equality for multiple GA values
  expect_equal(
    value2zscore(90, (14:16) * 7, NA, "acfga"),
    qnorm(value2centile(90, (14:16) * 7, NA, "acfga"))
  )
})

test_that("Conversion fn errors work", {
  expect_error(
    value2centile("hello", 35 * 7, "M", "efwfga"),
    regexp = "Must be of type 'numeric'"
  )

  expect_error(
    value2centile(140, 35 * 7, "M", c("efwfga", "efwfga")),
    regexp = "`acronym` must be a string"
  )

  expect_error(
    value2centile(140, 35 * 7, "M", c("BAD ACRONYM")),
    regexp = "`acronym` must be one of"
  )
})

test_that("Conversion warning works", {
  expect_warning(
    value2centile(seq(10, 50, 10), 14 * 7, acronym = "flfga")
  )
})

