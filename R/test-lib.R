

#' TestCaseCOVID19ARGenerator
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import testthat
#' @export
TestCaseCOVID19ARGenerator <- R6Class("TestCaseCOVID19ARGenerator",
   public = list(
    name                = NA,
    testcase.dir        = NA,
    url.dir             = NA,
    filters             = NA,
    #state
    curator             = NA,
    data                = NA,
    agg.criteria        = NA,
    logger              = NA,
    initialize = function(name, testcase.dir, agg.criteria,
                          filters = NULL, url.dir = NULL
                          ){
      self$name         <- name
      self$testcase.dir <- testcase.dir
      self$url.dir      <- url.dir
      self$filters      <- filters
      self$agg.criteria <- agg.criteria
      self$logger       <- genLogger(self)
      self
    },
    generateTestCase = function(){
      logger <- getLogger(self)
      self$loadCurator()
      self$applyFilters()
      source.path <- file.path(source.dir, paste(self$getCaseFilename(), "csv", sep = "."))
      logger$info("Saving source file at", path = source.path)
      write_csv(self$data, path = source.path)
    },
    loadCurator = function(){
     self$curator <- COVID19ARCurator$new()
     self$curator$url
     dummy <- self$curator$loadData()
     self$curator$curateData()
     self$data <- self$curator$data
     self
    },
    setCurator = function(curator){
      self$curator <- curator
    },
    applyFilters = function(){
     logger <- getLogger(self)
     logger$info("Data with", nrow = nrow(self$data))
     for (field in names(self$filters)){
       self$data %<>% filter_at(vars(field), all_vars(. %in% self$filters[[field]]))
       logger$info("After filter", field = field, filter = self$filters[[field]], nrow = nrow(self$data))
     }
    },
    getCaseFilename = function(){
      paste("covid19ar", self$name, sep = "_")
    },
    generateExpectedSummaries = function(){
     expected.dir <- file.path(self$testcase.dir, "expected")
     dir.create(expected.dir, recursive = TRUE, showWarnings = FALSE)
     exportAggregatedTables(covid.ar.curator = self$curator,
                            output.dir = expected.dir,
                            aggrupation.criteria = self$agg.criteria,
                            data = self$data,
                            file.prefix = self$getCaseFilename())

    }
    ))


