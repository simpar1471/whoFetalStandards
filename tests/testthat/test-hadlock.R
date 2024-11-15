test_that("Hadlock EFW works", {
  # Uses estimates from https://srhr.org/fetalgrowthcalculator/#/
  # as the `expected` values
  expect_equal(
    round(hadlock_efw(6, 6, 6), digits = 1),
    expected = 304.5
  )

  expect_equal(
    round(hadlock_efw(9, 9, 9), digits = 1),
    expected = 942.8
  )

  expect_equal(
    round(hadlock_efw(12, 12, 12), digits = 1),
    expected = 2550.1
  )

  expect_equal(
    round(hadlock_efw(6, 9, 12), digits = 1),
    expected = 2129.7
  )
})
