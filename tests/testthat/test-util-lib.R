test_that("utils", {
  expect_equal(normalizeString("Canción"), "cancion")
  expect_equal(normalizeString("Perspectïva"), "perspect\"iva")

})
