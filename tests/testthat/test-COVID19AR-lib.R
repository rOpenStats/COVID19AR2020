setup(assign(".tmp.data.dir",
             file.path(tempdir(), ".tmp"),
             env = parent.frame()))

test_that("COIVD19AR", {

 testcases.dir <- "inst/extdata/testcases/"
 agg.criteria <- list(provincia_residencia_fecha_apertura = c("residencia_provincia_nombre"),
                      provincia_departamento_residencia_sepi_apertura = c("residencia_provincia_nombre", "sepi_apertura"))

 dir.create(.tmp.data.dir, showWarnings = FALSE, recursive = TRUE)
 covid19.curator <- COVID19ARCurator$new(data.dir = .tmp.data.dir, report.date = as.Date("2020-06-02"))
 covid19.curator$url <- "https://raw.githubusercontent.com/rOpenStats/COVID19ARdata/master/testcases/covid19ar_La%20Rioja_10_20.csv"
 dummy <- covid19.curator$loadData()
 dummy <- covid19.curator$curateData()
 covid19ar.testcase.generator <- TestCaseCOVID19ARGenerator$new(name = "La_Rioja_10_20_",
                                                              testcase.dir = testcases.dir,
                                                              agg.criteria = agg.criteria)
 covid19ar.testcase.generator$setCurator(covid19.curator)
 #covid19ar.testcase.generator$validate()

})

unlink(.tmp.data.dir)
