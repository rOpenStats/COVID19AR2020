
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
     casos.plan %<>% filter(update.date >= min.date)
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

#' COVID19ARDailyReports
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import lubridate
#' @import magrittr
#' @export
COVID19ARDailyReports <- R6Class("COVID19ARDailyReports",
  public = list(
   report.diff.dir = NA,
   report.diff.summary.filename = NA,
   # state
   case.name            = NA,
   casos.mapping        = NA,
   casos.plan           = NULL,
   report.diff.builder  = NA,
   report.diff.summary  = NULL,
   mapache.data.agg     = NA,
   logger               = NA,
   initialize = function(min.rebuilt.date = "2020-06-16", report.diff.dir = "../COVID19ARdata/sources/COVID19AR"){
    self$report.diff.dir      <- report.diff.dir
    self$report.diff.summary.filename      <- "Covid19CasosReportSummary.csv"
    self$report.diff.builder  <- COVID19ARDiff$new(min.rebuilt.date = min.rebuilt.date, report.diff.dir)
    self$logger               <- genLogger(self)
    self
   },
   buildCasosMapping = function(){
    casos.mapping <- data.frame(git.id = "e9cb0d849b63aa0fb33b7dbeb4455d2202fb683a", update.date = as.Date("2020-06-24"))
    casos.mapping <- rbind(casos.mapping,
                           c("34b0f225559246caf2b04da95cbab7f99abd79e5", "2020-06-23"))
    casos.mapping <- rbind(casos.mapping,
                           c("6af5a72e3c828d4e6e6375b1593f87f344343d63", "2020-06-22"))
    casos.mapping <- rbind(casos.mapping,
                           c("41c024877da0ba0c58bd737ecb2adb2a7a75437f", "2020-06-21"))
    casos.mapping <- rbind(casos.mapping,
                           c("ec6d44768f4af6c73bd9cfc1492cbdd52c513519", "2020-06-20"))
    casos.mapping <- rbind(casos.mapping,
                           c("cd04f193142edcf502bb5667a136a037abeea2ba", "2020-06-19"))
    casos.mapping <- rbind(casos.mapping,
                           c("56a25dbd7061268308aa037e1a3aa7c207b57cc1", "2020-06-18"))
    casos.mapping <- rbind(casos.mapping,
                           c("ce9c7004ba377019fd3c106fe4a526b4371488ab", "2020-06-17"))
    casos.mapping <- rbind(casos.mapping,
                           c("2bf177b4087db97337c3956f30127eb3a279ed2e", "2020-06-16"))
    # Redo from 2020-06-12 to 2020-06-15
    # casos.mapping <- rbind(casos.mapping,
    #                        c("9de131e67b913b0aeae1e7e5b4db2d5f6d7d4cef", "2020-06-15"))
    # casos.mapping <- rbind(casos.mapping,
    #                        c("7f24d251521c371b09eaba351ba2b1e630dbfc0", "2020-06-14"))
    # casos.mapping <- rbind(casos.mapping,
    #                        c("c52a91fa61e5131ca5a3da27932430424455ab33", "2020-06-13"))
    # casos.mapping <- rbind(casos.mapping,
    #                        c("580a00b169c125e21ae4dfc2a9962b52825a0243", "2020-06-12"))
    #
    casos.mapping <- rbind(casos.mapping,
                           c("66cba3767a29d2452fff0dd62cd1e0352051aa2a", "2020-06-25"))
    casos.mapping <- rbind(casos.mapping,
                           c("58a3faf65dd00b48137703bc648dbbf5616677bd", "2020-06-26"))
    casos.mapping <- rbind(casos.mapping,
                           c("2e7591cf97443260d08be64c115328de2cd85411", "2020-06-27"))
    casos.mapping <- rbind(casos.mapping,
                           c("051bad4f7e40f81102ce89036c65f75150a1ad9f", "2020-06-28"))
    casos.mapping <- rbind(casos.mapping,
                           c("f04b4510e3bc70d2d302fbc0d351c20d21360e7f", "2020-06-29"))
    casos.mapping <- rbind(casos.mapping,
                           c("0187dbfe02bc6c6e2267065cf68b7a8537e83f94", "2020-06-30"))
    casos.mapping <- rbind(casos.mapping,
                           c("ad8cd697f9023788d8d422cc52b714efe90e0b8e", "2020-07-01"))
    casos.mapping <- rbind(casos.mapping,
                           c("d638ed9082ac1afbc414e2a4ba78609e0f9cb66f", "2020-07-02"))
    casos.mapping <- rbind(casos.mapping,
                           c("3509223f1cfd29954132f11c246229946b6aec10", "2020-07-03"))
    casos.mapping <- rbind(casos.mapping,
                           c("58a091be24048aac50c4a0535193f070150acb4a", "2020-07-04"))
    casos.mapping <- rbind(casos.mapping,
                           c("e03aa80d9a85ec2c78434e4091cbde9ad2d0f216", "2020-07-05"))
    #362739 Covid19CasosReporte20200705.csv but max(date) = 2020-07-04
    #360610 Covid19CasosReporte20200704.csv
    casos.mapping <- rbind(casos.mapping,
                           c("b7e6a50f61cb6fe7a9c8fd786d8085da36bd3ab4", "2020-07-06"))
    casos.mapping <- rbind(casos.mapping,
                           c("73c12d7b38c1e3592a765deb7e6032fcf8b91e3b", "2020-07-07"))
    casos.mapping <- rbind(casos.mapping,
                           c("dc5b1f06ed524d7d16f81b3532319f1400639fe7", "2020-07-08"))
    casos.mapping <- rbind(casos.mapping,
                           c("6032f75358d27dfcdf546aaa029bfecd4f428246", "2020-07-09"))
    casos.mapping <- rbind(casos.mapping,
                           c("4acd00d2d81a87348bc3c9adecec4190dc3ee5cb", "2020-07-10"))
    casos.mapping <- rbind(casos.mapping,
                           c("6d411a1aa38916d8ef0869f46a07ba3eda5fd76f", "2020-07-11"))
    casos.mapping <- rbind(casos.mapping,
                           c("51c705de5a0a42bdaf7b45a9dcf61acdae455870", "2020-07-12"))
    casos.mapping <- rbind(casos.mapping,
                           c("feabb601d2579e8f96dbebe31c0f9166f4d4c906", "2020-07-13"))
    casos.mapping <- rbind(casos.mapping,
                           c("3733ef007ed74ec782c43bd99c89a2ab8b60d8a9", "2020-07-14"))
    casos.mapping <- rbind(casos.mapping,
                           c("509d21b76a9ffb0e33500a9f1c1cd82a70644d9c", "2020-07-15"))
    casos.mapping <- rbind(casos.mapping,
                           c("9f78c3f65cffb782e7dd43aebd3087c40a3da909", "2020-07-16"))
    casos.mapping <- rbind(casos.mapping,
                           c("0b63594df6a148da9aab5b139432221603740828", "2020-07-17"))
    casos.mapping <- rbind(casos.mapping,
                           c("", "2020-07-18"))
    casos.mapping <- rbind(casos.mapping,
                           c("", "2020-07-19"))


    casos.mapping %<>% arrange(update.date)
    self$casos.mapping <- casos.mapping
    self$casos.mapping
   },
   buildCasosPlan = function(casos.dir = NULL){
    self$loadReportDiffSummary()
    self$buildCasosMapping()
    if (is.null(casos.dir)){
     # Build from casos mapping
     n.casos.mapping <- nrow(self$casos.mapping)
     for (i in seq_len(n.casos.mapping)){
      current.caso <- self$casos.mapping[i,]
      caso.plan <- data.frame(url = self$getReportUrl(current.caso$git.id),
                              update.date = current.caso$update.date,
                              stringsAsFactors = FALSE)
      self$casos.plan %<>% bind_rows(caso.plan)
     }
    }
    else{
     casos.files <- dir(casos.dir)
     parse.regexp <- "Covid19Casos\\_([[:alnum:]]+)\\_([0-9]{8})\\.csv"
     self$casos.plan <- data.frame(dir = casos.dir, file = casos.files, stringsAsFactors = FALSE)
     self$casos.plan$update.date.parsed <- gsub(parse.regexp, "\\2", self$casos.plan$file)
     self$casos.plan$update.date <- as.Date(self$casos.plan$update.date.parsed, "%Y%m%d")
     self$case.name <- sort(unique(gsub(parse.regexp, "\\1", self$casos.plan$file)))
    }
    self$buildMapacheData()
    self$casos.plan
   },
   getReportUrl = function(commit.id){
    paste("https://raw.githubusercontent.com/rOpenStats/COVID19ARdata",
          commit.id,
          "sources/msalnacion/Covid19Casos.csv", sep = "/")
   },
   buildMapacheData = function(){
    mapache.data <- loadMapacheData()
    tail(mapache.data %>%
          filter(osm_admin_level_4 == "Indeterminado") %>%
          select(fecha, dia_inicio, dia_cuarentena_dnu260, tot_casosconf, nue_casosconf_diff)
    )
    mapache.data %<>% mutate(date = dmy(fecha))
    names(mapache.data)
    self$mapache.data.agg <- mapache.data %>%
     group_by(osm_admin_level_2, date,	dia_inicio,	dia_cuarentena_dnu260) %>%
     summarise(tot_casosconf       = max(tot_casosconf),
               nue_casosconf_diff  = sum(nue_casosconf_diff),
               tot_fallecidos      = max(tot_fallecidos),
               nue_fallecidos_diff = sum(nue_fallecidos_diff),
               tot_recuperados     = max(tot_recuperados))
    self$mapache.data.agg
   },
   resetMerge = function(){
    self$report.diff.summary <- NULL
    self$report.diff.builder$report.diff <- NULL
   },
   buildCasosReport = function(max.n = 0, min.date = NULL){
    logger <- getLogger(self)
    report.days.processed <- sort(unique(self$report.diff.summary$fecha_reporte_ejecutado))
    casos.plan <- self$casos.plan
    if (!is.null(min.date)){
     casos.plan %<>% filter(update.date >= min.date)
    }
    n.casos.plan <- nrow(casos.plan)
    if (max.n > 0){
     n.casos.plan <- min(n.casos.plan, max.n)
    }
    for (i in seq_len(n.casos.plan)){
     current.case <- casos.plan[i, ]
     if (!current.case$update.date %in% report.days.processed){
      logger$info("Processing current date", current.date = current.case$update.date)
      # Starting from diff

      self$report.diff.builder$loadReports(current.case = current.case)
      #TODO automatically commit
      self$report.diff.builder$processDiff()
      self$report.diff.builder$saveReportDiff()
      self$generateReportDaySummary(update.date = current.case$update.date)
     }
    }
    self$report.diff.summary
   },
   generateReportDaySummary  = function(update.date){
    report.building.summary <- tail(self$report.diff.builder$report.diff %>%
                                     group_by(fecha_reporte) %>%
                                     summarize(n = n(),
                                               confirmados           = sum(confirmado),
                                               descartados           = sum(descartado),
                                               fallecidos            = sum(fallecido),
                                               min_fecha_diagnostico = min(fecha_diagnostico, na.rm = TRUE),
                                               max_fecha_diagnostico = max(fecha_diagnostico, na.rm = TRUE),
                                               fechas_diagnostico_n  = length(sort(unique(fecha_diagnostico))),
                                               fechas_diagnostico    = paste(sort(unique(fecha_diagnostico)), collapse = ", ")),
                                    n = 10)
    report.building.summary <- bind_cols(fecha_reporte_ejecutado = update.date, report.building.summary)
    expected.data <- tibble(self$mapache.data.agg) %>%
     select(date, nue_casosconf_diff, nue_fallecidos_diff)
    names(expected.data) <- c("fecha_reporte", "confirmados_informados", "fallecidos_informados")
    report.building.summary %<>% left_join(expected.data, by = "fecha_reporte")

    self$report.diff.summary %<>% bind_rows(report.building.summary)

    self$saveReportDiffSummary()
   },
   loadReportDiffSummary = function(){
    report.diff.summary.path <- file.path(self$report.diff.dir, self$report.diff.summary.filename)
    applied.delim <- ","
    if (file.exists(report.diff.summary.path)){
     #self$report.diff.summary <- read_csv(file = report.diff.summary.path, delim = applied.delim)
     self$report.diff.summary <- read_csv(file = report.diff.summary.path,
                                          col_types = cols(
                                           fecha_reporte_ejecutado = col_date(format = ""),
                                           fecha_reporte = col_date(format = ""),
                                           n = col_double(),
                                           confirmados = col_integer(),
                                           descartados = col_integer(),
                                           fallecidos = col_integer(),
                                           max_fecha_diagnostico = col_date(format = ""),
                                           min_fecha_diagnostico = col_date(format = ""),
                                           fechas_diagnostico_n = col_integer(),
                                           fechas_diagnostico = col_character()
                                          ))
    }
    self$report.diff.summary
   },
   saveReportDiffSummary = function(){
    report.diff.summary.path <- file.path(self$report.diff.dir, self$report.diff.summary.filename)
    applied.delim <- ","
    # No way of setting quotes in readr function
    #write_delim(self$report.diff, file = report.diff.path, sep = applied.delim, quote = TRUE)
    write.table(self$report.diff.summary, file = report.diff.summary.path, sep = applied.delim, quote = TRUE, row.names = FALSE)
   }
  ))
