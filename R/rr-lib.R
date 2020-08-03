
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
    casos.mapping <- data.frame(git.id = "7903a570c65736ad931ac25e05c92c4c7315cd8d", update.date = as.Date("2020-06-24"))
    casos.mapping <- rbind(casos.mapping,
                           c("6732da9116949a47eb5d76230565ebaa1552a250", "2020-06-23"))
    casos.mapping <- rbind(casos.mapping,
                           c("302a212eddb1c7b21a8806c2d589868e58c8c63a", "2020-06-22"))
    casos.mapping <- rbind(casos.mapping,
                           c("92086347aa6eb88e57cf6bee5c4ddd6cc17e26f3", "2020-06-21"))
    casos.mapping <- rbind(casos.mapping,
                           c("9f334f0d679f0af8731c6c5d001a36bf61f7e360", "2020-06-20"))
    casos.mapping <- rbind(casos.mapping,
                           c("3d9409aae05c14d6ba6fc570e866eac24e404b6e", "2020-06-19"))
    casos.mapping <- rbind(casos.mapping,
                           c("c61cdf724c8676ed9a995f69b624a9cc4fc526ac", "2020-06-18"))
    casos.mapping <- rbind(casos.mapping,
                           c("1f3dfe30d87d18530b53205c83dbddb7b17578c7", "2020-06-17"))
    casos.mapping <- rbind(casos.mapping,
                           c("414090f440649265bd5e9e6835271306f318208f", "2020-06-16"))
    casos.mapping <- rbind(casos.mapping,
                           c("9de131e67b913b0aeae1e7e5b4db2d5f6d7d4cef", "2020-06-15"))
    casos.mapping <- rbind(casos.mapping,
                           c("7f24d251521c371b09eaba351ba2b1e630dbfc0", "2020-06-14"))
    casos.mapping <- rbind(casos.mapping,
                           c("c52a91fa61e5131ca5a3da27932430424455ab33", "2020-06-13"))
    casos.mapping <- rbind(casos.mapping,
                           c("580a00b169c125e21ae4dfc2a9962b52825a0243", "2020-06-12"))
    casos.mapping <- rbind(casos.mapping,
                           c("a0ace6c7bb8393d67d142f0c3d4f67785f32258f", "2020-06-25"))
    casos.mapping <- rbind(casos.mapping,
                           c("224b24155b79e13a4edbb76a367f5cf326ab3194", "2020-06-26"))
    casos.mapping <- rbind(casos.mapping,
                           c("1f001f367d63b4413497ea7fb68b8704e710995f", "2020-06-27"))
    casos.mapping <- rbind(casos.mapping,
                           c("5e121f76e31ddae57f5d991e7dd9296de453b952", "2020-06-28"))
    casos.mapping <- rbind(casos.mapping,
                           c("f217d13707738a0b2f9442365460bce4a538b9ab", "2020-06-29"))
    casos.mapping <- rbind(casos.mapping,
                           c("8ca97731452fa62d6755c4ace9141acf7d68bc7d", "2020-06-30"))
    casos.mapping <- rbind(casos.mapping,
                           c("c7051a08952f48b747ba4b0eadfd4ba15aa0ddbb", "2020-07-01"))
    casos.mapping <- rbind(casos.mapping,
                           c("d0fa4b764fd742c9d8c846e245c80700b759c302", "2020-07-02"))

    casos.mapping <- rbind(casos.mapping,
                           c("25b8d6b7a2e51b988f65900dd2738494bb318e3d", "2020-07-03"))
    casos.mapping <- rbind(casos.mapping,
                           c("8e0d93a5ede2c4a55ed053e4bea1071a2b1a7125", "2020-07-04"))
    casos.mapping <- rbind(casos.mapping,
                           c("e0c4bca62362d9b10278d94209538f18cd1c5cfa", "2020-07-05"))
    #362739 Covid19CasosReporte20200705.csv but max(date) = 2020-07-04
    #360610 Covid19CasosReporte20200704.csv
    casos.mapping <- rbind(casos.mapping,
                           c("3120ce6dab8515195d977b9d4933a162c3507ce9", "2020-07-06"))
    casos.mapping <- rbind(casos.mapping,
                           c("64ece3070f1ebedbd57b3605b92a323eae1c9068", "2020-07-07"))
    casos.mapping <- rbind(casos.mapping,
                           c("973232f299d8185fbb63a5f7ca917242597d726e", "2020-07-08"))
    casos.mapping <- rbind(casos.mapping,
                           c("cfdafefc1f023ed032ad434058683328928780b0", "2020-07-09"))
    casos.mapping <- rbind(casos.mapping,
                           c("5cb28eee2aaba93e457705742bd97b5dc1707ccc", "2020-07-10"))
    casos.mapping <- rbind(casos.mapping,
                           c("e7f3ec1b851b485d6066519cf5b2b9b502053387", "2020-07-11"))
    casos.mapping <- rbind(casos.mapping,
                           c("f0afdfeab9547f3fe90aa255f4be5849e46d359e", "2020-07-12"))
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



#' COVID19ARLegacyCompressor
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @export
COVID19ARLegacyCompressor <- R6Class("COVID19ARLegacyCompressor",
  public = list(
   report.source.dir = NA,
   report.snapshots.dir = NA,
   temp.dir = NA,
   report.diff.summary.filename = NA,
   # state
   casos.mapping        = NA,
   logger               = NA,
   initialize = function(report.source.dir = "~/.R/COVID19AR/",
                         report.snapshots.dir = "../COVID19ARdata/sources/msalnacion"){
    self$report.source.dir    <- report.source.dir
    self$report.snapshots.dir <- report.snapshots.dir
    self$temp.dir             <- file.path(tempdir(), "COVID19AR")
    self$logger               <- genLogger(self)
    self
   },
   buildCasosMapping = function(){
    casos.mapping <- data.frame(git.id = "7903a570c65736ad931ac25e05c92c4c7315cd8d",
                                update.date = as.Date("2020-06-24"))
    casos.mapping <- rbind(casos.mapping,
                           c("6732da9116949a47eb5d76230565ebaa1552a250", "2020-06-23"))
    casos.mapping <- rbind(casos.mapping,
                           c("302a212eddb1c7b21a8806c2d589868e58c8c63a", "2020-06-22"))
    casos.mapping <- rbind(casos.mapping,
                           c("92086347aa6eb88e57cf6bee5c4ddd6cc17e26f3", "2020-06-21"))
    casos.mapping <- rbind(casos.mapping,
                           c("9f334f0d679f0af8731c6c5d001a36bf61f7e360", "2020-06-20"))
    casos.mapping <- rbind(casos.mapping,
                           c("3d9409aae05c14d6ba6fc570e866eac24e404b6e", "2020-06-19"))
    casos.mapping <- rbind(casos.mapping,
                           c("c61cdf724c8676ed9a995f69b624a9cc4fc526ac", "2020-06-18"))
    casos.mapping <- rbind(casos.mapping,
                           c("1f3dfe30d87d18530b53205c83dbddb7b17578c7", "2020-06-17"))
    casos.mapping <- rbind(casos.mapping,
                           c("414090f440649265bd5e9e6835271306f318208f", "2020-06-16"))
    casos.mapping <- rbind(casos.mapping,
                           c("9de131e67b913b0aeae1e7e5b4db2d5f6d7d4cef", "2020-06-15"))
    casos.mapping <- rbind(casos.mapping,
                           c("7f24d251521c371b09eaba351ba2b1e630dbfc0", "2020-06-14"))
    casos.mapping <- rbind(casos.mapping,
                           c("c52a91fa61e5131ca5a3da27932430424455ab33", "2020-06-13"))
    casos.mapping <- rbind(casos.mapping,
                           c("580a00b169c125e21ae4dfc2a9962b52825a0243", "2020-06-12"))
    casos.mapping <- rbind(casos.mapping,
                           c("a0ace6c7bb8393d67d142f0c3d4f67785f32258f", "2020-06-25"))
    casos.mapping <- rbind(casos.mapping,
                           c("224b24155b79e13a4edbb76a367f5cf326ab3194", "2020-06-26"))
    casos.mapping <- rbind(casos.mapping,
                           c("1f001f367d63b4413497ea7fb68b8704e710995f", "2020-06-27"))
    casos.mapping <- rbind(casos.mapping,
                           c("5e121f76e31ddae57f5d991e7dd9296de453b952", "2020-06-28"))
    casos.mapping <- rbind(casos.mapping,
                           c("f217d13707738a0b2f9442365460bce4a538b9ab", "2020-06-29"))
    casos.mapping <- rbind(casos.mapping,
                           c("8ca97731452fa62d6755c4ace9141acf7d68bc7d", "2020-06-30"))
    casos.mapping <- rbind(casos.mapping,
                           c("c7051a08952f48b747ba4b0eadfd4ba15aa0ddbb", "2020-07-01"))
    casos.mapping <- rbind(casos.mapping,
                           c("d0fa4b764fd742c9d8c846e245c80700b759c302", "2020-07-02"))
    casos.mapping <- rbind(casos.mapping,
                           c("25b8d6b7a2e51b988f65900dd2738494bb318e3d", "2020-07-03"))
    casos.mapping <- rbind(casos.mapping,
                           c("8e0d93a5ede2c4a55ed053e4bea1071a2b1a7125", "2020-07-04"))
    casos.mapping <- rbind(casos.mapping,
                           c("e0c4bca62362d9b10278d94209538f18cd1c5cfa", "2020-07-05"))
    #362739 Covid19CasosReporte20200705.csv but max(date) = 2020-07-04
    #360610 Covid19CasosReporte20200704.csv
    casos.mapping <- rbind(casos.mapping,
                           c("3120ce6dab8515195d977b9d4933a162c3507ce9", "2020-07-06"))
    casos.mapping <- rbind(casos.mapping,
                           c("64ece3070f1ebedbd57b3605b92a323eae1c9068", "2020-07-07"))
    casos.mapping <- rbind(casos.mapping,
                           c("973232f299d8185fbb63a5f7ca917242597d726e", "2020-07-08"))
    casos.mapping <- rbind(casos.mapping,
                           c("cfdafefc1f023ed032ad434058683328928780b0", "2020-07-09"))
    casos.mapping <- rbind(casos.mapping,
                           c("5cb28eee2aaba93e457705742bd97b5dc1707ccc", "2020-07-10"))
    casos.mapping <- rbind(casos.mapping,
                           c("e7f3ec1b851b485d6066519cf5b2b9b502053387", "2020-07-11"))
    casos.mapping <- rbind(casos.mapping,
                           c("f0afdfeab9547f3fe90aa255f4be5849e46d359e", "2020-07-12"))
    casos.mapping %<>% arrange(update.date)
    self$casos.mapping <- casos.mapping
    self$casos.mapping
   },
   getReportUrl = function(commit.id){
    paste("https://raw.githubusercontent.com/rOpenStats/COVID19ARdata",
          commit.id,
          "sources/msalnacion/Covid19Casos.csv", sep = "/")
   },
   compressSnapshot = function(snapshot.date, dest.filename = NULL){
     logger <- getLogger(self)
     dir.create(self$temp.dir, showWarnings = FALSE, recursive = TRUE)
     snapshot.caso <- self$casos.mapping %>% filter(update.date == snapshot.date)
     covid19casos.filename <- "Covid19Casos.csv"
     dest.filepath <- ""
     if (nrow(snapshot.caso) == 1){
       current.url <- self$getReportUrl(snapshot.caso$git.id)
       if (is.null(dest.filename)){
        url.splitted <- strsplit(current.url, split = "/")[[1]]
        dest.filename <- url.splitted[length(url.splitted)]
       }
       logger$info("Downloading url", url = current.url)
       file.path <- retrieveURL(data.url = current.url,
                                dest.dir = self$temp.dir,
                                dest.filename = dest.filename,
                                col.types = self$cols.specifications[[self$specification]],
                                force.download = TRUE)
       dest.filepath <- file.path(self$temp.dir, dest.filename)
     }
     else{
      if (nrow(snapshot.caso) == 0){
        source.filepath <- file.path(self$report.source.dir,
                                 paste("Covid19Casos", as.character(snapshot.caso$update.date, format = "%Y%m%d"), ".csv", sep = ""))
        logger$info("Copying file from", path = source.file)
        dest.filepath <- file.path(self$temp.dir, covid19casos.filename)
        copied <- file.copy(source.filepath, dest.filepath)
        if (!copied){
          stop(paste("File not found at source path"))
        }
      }
      else{
       stop(paste("Snapshot definition should be unique but found", nrow(snapshot.caso, "for snapshot.date", snapshot.date)))
      }
     }
     #Translate from UTF16 if corresponds
     dest.filepath <- fixEncoding(dest.filepath)
     covid19casos.filename <- file.path(self$report.snapshots.dir , covid19casos.filename)
     logger$info("Compressing file from", source.dir = self$temp.dir,
                  filename = covid19casos.filename,
                  dest.dir = self$report.snapshots.dir)
     zipFile(source.dir = self$temp.dir, current.file = covid19casos.filename, dest.dir = self$report.snapshots.dir,
             rm.original = FALSE,
             overwrite = TRUE)
   }))

