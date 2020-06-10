test_that("utils", {
  expect_equal(normalizeString("Canción"), "cancion")
  #Dieresis normalization in Linux does not have the same behavior
  #expect_equal(normalizeString("Perspectïva"), "perspect\"iva")

})
