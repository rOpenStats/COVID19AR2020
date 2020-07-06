
TestCaseCOVID19ARGenerator.class <-

 #' TestCaseCOVID19ARGenerator
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


#' COVID19ARSampleGenerator
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import lubridate
#' @import magrittr
#' @export
COVID19ARSampleGenerator <- R6Class("COVID19ARSampleGenerator",
  public = list(
    daily.reports = NA,
    sample.name   = NA,
    sample.ratio  = NA,
    seed          = NA,
    output.dir    = NA,
    min.date      = NA,
    # state
    sampled.data  = NA,
    samples       = NA,
    logger        = NA,
    initialize = function(daily.reports,
                          sample.name,
                          sample.ratio = 0.01, seed = 0,
                          output.dir = "../COVID19ARdata/dev/samples",
                          min.date = NULL){
      self$daily.reports      <- daily.reports
      self$sample.name        <- sample.name
      self$sample.ratio       <- sample.ratio
      self$seed               <- seed
      self$output.dir <- file.path(output.dir, sample.name)
      self$min.date           <- min.date
      self$logger             <- genLogger(self)
      #state
      self$samples            <- list()

      self
    },
    genSample = function(current.case){
      logger <- getLogger(self)
      current.date.c <- as.character(current.case$update.date)
      self$daily.reports$report.diff.builder$loadReports(current.case, curate = FALSE)
      covid19.data <- self$daily.reports$report.diff.builder$report
      all.dates <- sort(unique(covid19.data$fecha_inicio_sintomas))
      dates.samples <- list()
      self$sampled.data <- NULL
      set.seed(self$seed)
      sample.size <- NA
      min.date <- min(all.dates)
      for (j in seq_len(length(all.dates))){
        current.date.sample <- all.dates[j]
        cases.current.date <- covid19.data %>% filter(fecha_inicio_sintomas == current.date.sample)
        n.current.date <- nrow(cases.current.date)
        sample.size    <- max(ceiling(n.current.date * self$sample.ratio), sample.size, na.rm = TRUE)
        current.sample <- sample(1:n.current.date,
                                 size = sample.size,
                                 replace = FALSE)
        self$sampled.data %<>% bind_rows(cases.current.date[current.sample, ])
        dates.samples[[as.character(current.date.sample)]] <- current.sample
        logger$debug("generating sample:", current.fis = as.character(current.date.sample),
                     current.fis.size = n.current.date, current.sample.size = sample.size,
                     percent = round(sample.size / n.current.date, 3))
      }
      self$samples[[current.date.c]] <- dates.samples
      current.output.filename <- self$getCaseFileName(current.case)
      current.output.path <- file.path(self$output.dir, current.output.filename)
      self$sampled.data

      write.csv(self$sampled.data, file = current.output.path, quote = TRUE, row.names = FALSE)
    },
    getCaseFileName = function(current.case){
      paste("Covid19Casos_", self$sample.name, "_", as.character(current.case$update.date, format = "%Y%m%d"), ".csv", sep = "")
    },
    genSampleBatch = function(max.n = 0,
                              min.date = NULL){
      logger <- getLogger(self)
      report.days.processed <- sort(unique(self$report.diff.summary$fecha_reporte_ejecutado))
      casos.plan <- self$daily.reports$casos.plan
      if (!is.null(min.date)){
        casos.plan %<>% filter(update.date >= self$min.date)
      }
      total.cases <- nrow(casos.plan)
      if (max.n > 0){
        total.cases <- min(total.cases, max.n)
      }
      if (!dir.exists(self$output.dir)){
        stop(paste("Target dir", output.dir, "must be manually created for running genSample"))
      }
      for (i in seq_len(total.cases)){
        current.case <- casos.plan[i,]
        logger$info("Generating sample for",
                    commit.id = current.case$git.id,
                    current.date = current.case$update.date)
        self$genSample(current.case = current.case)
      }
    }
  ))

