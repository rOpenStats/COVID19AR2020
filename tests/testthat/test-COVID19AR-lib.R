setup(assign(".tmp.data.dir",
             file.path(tempdir(), ".tmp"),
             env = parent.frame()))

test_that("COIVD19AR", {
 covid19.curator <- COVID19ARCurator$new(data.dir = .tmp.data.dir)
 covid19.curator$url <- ""
 dummy <- covid19.curator$loadData()
 dummy <- covid19.curator$curateData()

})
