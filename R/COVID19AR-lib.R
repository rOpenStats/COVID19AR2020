#' COVID19ARCurator
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @export
COVID19ARCurator <- R6Class("COVID19ARCurator",
   public = list(
    download.new.data = NA,
    data.dir            = NA,
    url                 = NA,
    #specification
    specification       = NA,
    cols.delim          = NA,
    cols.specifications = NA,
    curate.functions    = NA,
    edad.coder          = NA,
    curated             = FALSE,
    fields.temporal     = NA,
    data.fields         = NA,
    data                = NA,
    max.date            = NA,
    data.summary        = NA,
    logger              = NA,
    initialize = function(data.dir = getEnv("data_dir"),
                          download.new.data = TRUE){
     self$data.dir <- data.dir
     self$url      <- "https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.csv"
     self$download.new.data <- download.new.data
     self$logger   <- genLogger(self)
     self$setupColsSpecifications()
     self
    },
    setupColsSpecifications = function(){
      self$cols.delim <- list()
      self$cols.specifications <- list()
      self$curate.functions <- list()
      self$curate.functions[["200603"]] <- self$curateData200603
      self$cols.delim[["200603"]] <- ","
      self$cols.specifications[["200603"]] <-
              cols(
                .default = col_character(),
                id_evento_caso = col_number(),
                edad = col_double(),
                fecha_inicio_sintomas = col_date(format = ""),
                fecha_apertura = col_date(format = ""),
                sepi_apertura = col_integer(),
                fecha_internacion = col_date(format = ""),
                fecha_cui_intensivo = col_date(format = ""),
                fecha_fallecimiento = col_date(format = ""),
                fecha_diagnostico = col_date(format = ""),
                ultima_actualizacion = col_date(format = "")
              )
      self$edad.coder  <- EdadCoder$new()
      self$edad.coder$setupCoder()
      self
    },
    loadData = function(url = self$url,
                        force.download = FALSE,
                        dest.filename = NULL){
      self$specification <- "200603"
      if (is.null(dest.filename)){
        url.splitted <- strsplit(url, split = "/")[[1]]
        dest.filename <- url.splitted[length(url.splitted)]
      }
      file.path <- retrieveURL(data.url = url, dest.dir = self$data.dir,
                               dest.filename = dest.filename,
                               col.types = self$cols.specifications[[self$specification]],
                               download.new.data = self$download.new.data,
                               force.download = force.download)
      self$curated <- FALSE
      # Fix encoding
      file.path <- fixEncoding(file.path)
      file.info(file.path)

      self$readFile(file.path)
      self$data
    },
    readFile = function(file.path, assign = TRUE){
      ret <- read_delim(file.path,
                 delim = self$cols.delim[[self$specification]]
                 ,col_types = self$cols.specifications[[self$specification]])
      if (assign){
        self$data <- ret
      }
      ret
    },
    curateData = function(){
      if (is.null(self$specification)){
        stop("Specification not defined")
      }
      self$curate.functions[[self$specification]]()
      names.data <- names(self$data)
      self$fields.temporal <- c("sepi_apertura", names.data[grep("fecha", names.data)])
    },
    checkSoundness = function(fix.dates = TRUE){
      logger <- getLogger(self)
      logger$info("checkSoundness")
      #self$data %<>% mutate(cal_semana_apertura = as.numeric(as.character(fecha_apertura, format = "%V")))
      #self$data %<>% mutate(cal_dow = as.character(fecha_apertura, format = "%a"))
      #self$data %<>% mutate(cal_sepi_apertura_match = cal_semana_apertura == sepi_apertura)
      #$tail(self$data %>% filter(!cal_sepi_apertura_match) %>% select(semana_apertura, sepi_apertura, fecha_apertura))
      #self$data %>% group_by(cal_sepi_apertura_match, cal_dow) %>% summarize(n = n(), dif)

      #rows.fix.apertura <- which(covid19.curator$data$fecha_apertura > covid19.curator$data$fecha_diagnostico)
      #covid19.curator$data %>% filter(fecha_apertura > fecha_diagnostico) %>% select(fecha_inicio_sintomas, fecha_apertura, fecha_internacion, fecha_diagnostico, fecha_fallecimiento)

      #self$data %>% filter(abs(fecha_apertura- fecha_inicio_sintomas) > 60) %>% select(fecha_apertura, fecha_inicio_sintomas, confirmado, fallecido) %>% group_by(confirmado, fallecido) %>% summarize(n = n())

      current_sepi <- as.numeric(as.character(max(self$data$fecha_apertura, na.rm = TRUE), format = "%V"))
      # Removing data from future sepi
      self$data %<>% filter(sepi_apertura <= current_sepi + 1)
    },
    getData = function(){
      self$data
    },
    normalize = function(){
      logger <- getLogger(self)
      logger$info("Normalize")
      # Normalize column names of self$data
      names(self$data) <- tolower(names(self$data))
      self$data.fields <- names(self$data)
      self$data$fixed <- ""
      self$data %<>% mutate(clasificacion = tolower(clasificacion))
      self$data %<>% mutate(clasificacion_resumen = tolower(clasificacion_resumen))
      self$data %<>% mutate(fallecido = tolower(fallecido))
    },
    curateData200603 = function(){
      logger <- getLogger(self)
      if (!self$curated){
        nrows.before <- nrow(self$data)
        self$normalize()
        self$checkSoundness()
        logger$info("Mutating data")
        #self$data$edad.rango <- NA
        #levels(self$data$edad.rango) <- self$edad.coder$agelabels
        names(self$data)
        unique(self$data$edad_años_meses)
        #Generate edad_actual_anios
        self$data$edad_actual_anios <- self$data$edad
        self$data[self$data$edad_años_meses == "Meses",]$edad_actual_anios <- 0
        self$data$edad.rango <- vapply(self$data$edad_actual_anios,
                                       FUN = self$edad.coder$codeEdad,
                                       FUN.VALUE = character(1))
        # TODO import as date
        self$data$fecha_cui_intensivo <- as.Date(self$data$fecha_cui_intensivo, format = "%d/%m/%Y")
        unique(self$data$clasificacion_resumen)
        self$data %<>% mutate(confirmado = ifelse(clasificacion_resumen == "confirmado", 1, 0))
        self$data %<>% mutate(descartado = ifelse(clasificacion_resumen == "descartado", 1, 0))
        self$data %<>% mutate(sospechoso = ifelse(clasificacion_resumen == "sospechoso", 1, 0))
        self$data %<>% mutate(fallecido.original = fallecido)
        self$data %<>% mutate(fallecido = ifelse(is.na(fallecido), "no", fallecido))
        self$data %<>% mutate(fallecido  = ifelse(confirmado & fallecido == "si", 1, 0))
        self$curated <- TRUE
        nrows.after <- nrow(self$data)
        if (nrows.after < nrows.before*.99){
          # If in curation we loose more than 1% of records. SHow a warning
          logger$warn("Too much data filtered in curation",
                      nrows.before = nrows.before, nrows.after = nrows.after)
        }

        self$max.date <- getMaxDate(self$data)
      }
    },
    checkDataFields = function(current.data){
      errors <- ""
      if (!inherits(current.data, "data.frame")){
        classes <- class(current.data)
        errors <- paste(errors, "current.data doesn't inherits a data.frame. It is a", classes[1])
      }
      if (nchar(errors) == 0){
        missing.fields <- setdiff(self$data.fields, names(current.data))
        if (length(missing.fields) > 0){
          errors <- paste(errors, "Missing fields in current.data:", paste(missing.fields, collapse = ","))
        }
      }
      if (nchar(errors) > 0){
        stop(errors)
      }
    },
    makeSummary = function(group.vars = c("residencia_provincia_nombre", "sepi_apertura"),
                           data2process = self$data,
                           temporal.acum = TRUE,
                           cache.filename = NULL){
     logger <- getLogger(self)
     if (!self$curated){
       stop("Data must be curated before execuitng makeSummary")
     }

     self$checkDataFields(data2process)
     ret <- NULL
     if (nrow(self$data) == nrow(data2process) & !is.null(cache.filename)){
       ret <- retrieveFromCache(cache.filename)
     }
     if (is.null(ret)){
       #self$data$edad.rango <- NA
       #levels(self$data$edad.rango) <- self$edad.coder$agelabels
       temporal.fields.agg<- group.vars[group.vars %in% self$fields.temporal]
       non.temporal.fields.agg <- setdiff(group.vars, temporal.fields.agg)
       non.temporal.groups <- data2process %>%
         group_by_at(non.temporal.fields.agg) %>%
         summarise( .groups = "keep") %>%
         arrange_at(non.temporal.fields.agg)
       if(length(temporal.fields.agg) == 0){
         ret <- self$getAggregatedData(group.fields = group.vars, current.data = data2process)
       }
       else{
         ret <- NULL
         for (i in seq_len(nrow(non.temporal.groups))){
           current.group <- non.temporal.groups[i,]
           logger$info("Processing", current.group = paste(names(current.group), current.group,
                                                           sep =" = ", collapse = "|"))
           current.group.data <- data2process %>% inner_join(current.group, by = non.temporal.fields.agg)
           temporal.groups <- current.group.data %>%
             group_by_at(temporal.fields.agg) %>%
             summarise( .groups = "keep") %>%
             arrange_at(temporal.fields.agg)
           current.temporal.group.acum <- NULL
           current.group.data.agg <- NULL
           dias.contador <- 0
           for (j in seq_len(nrow(temporal.groups))){
             current.temporal.group <- temporal.groups[j,]
             if (!temporal.acum){
               current.temporal.group.acum <- NULL
             }
             current.temporal.group.acum <- rbind(current.temporal.group.acum,
                                                  current.temporal.group)
             current.temporal.group.data <- current.group.data %>% inner_join(current.temporal.group.acum,
                                                                              by = names(current.temporal.group))
             for (field in names(current.temporal.group)){
               current.temporal.group.data[, field] <- current.temporal.group[, field]
             }
             if (nrow(current.temporal.group.data) > 0){
               logger$debug("Summarizing adding temporal group",
                            group = paste(names(current.temporal.group),
                                          current.temporal.group, sep = "=", collapse = ","),
                            nrow = nrow(current.temporal.group.data))
               current.temporal.group.data.agg <- self$getAggregatedData(group.fields = group.vars,
                                                                         current.data = current.temporal.group.data)
               if (!is.null(current.temporal.group.data.agg)){
                 current.temporal.group.data.agg$dias.inicio <- dias.contador
                 current.group.data.agg <- rbind(current.group.data.agg, current.temporal.group.data.agg)
               }
               dias.contador <- dias.contador + 1
             }
           }
           if (!is.null(current.group.data.agg)){
             # Indicators
             current.group.data.agg %<>%  mutate(confirmados.inc = ifelse(dias.inicio >= 1, confirmados - lag(confirmados, n = 1), NA))
             current.group.data.agg %<>%  mutate(confirmados.rate = ifelse(dias.inicio >= 1, confirmados.inc/lag(confirmados, n = 1), NA))
             current.group.data.agg %<>%  mutate(fallecidos.inc = ifelse(dias.inicio >= 1, fallecidos - lag(fallecidos, n = 1), NA))
             current.group.data.agg %<>%  mutate(tests.inc = ifelse(dias.inicio >= 1, tests - lag(tests, n = 1), NA))
             current.group.data.agg %<>%  mutate(tests.rate = ifelse(dias.inicio >= 1, tests.inc / lag(tests, n = 1), NA))
             current.group.data.agg %<>%  mutate(sospechosos.inc = ifelse(dias.inicio >= 1, sospechosos - lag(sospechosos, n = 1), NA))
             ret <- rbind(ret, current.group.data.agg)
             logger$debug("Total data after aggregating group",
                          current.group = paste(names(current.group), current.group,
                                                sep =" = ", collapse = "|"),
                          nrow = nrow(ret))
           }
         }
       }
       }
       self$data.summary <- ret
       self$data.summary
     },
     getAggregatedData = function(group.fields, current.data, min.confirmados = 0){
       logger <- getLogger(self)
       keys.confirmados <- current.data %>%
         group_by_at(group.fields) %>%
         summarize(n = n(),
                   confirmados = sum(ifelse(confirmado, 1, 0)))
       keys.confirmados  %<>% filter(confirmados > 0)
       keys.confirmados$key <- apply(keys.confirmados[, group.fields], MARGIN = 1, FUN = function(x){paste(x, collapse = "|")})

       current.data$key <- apply(current.data[, group.fields], MARGIN = 1, FUN = function(x){paste(x, collapse = "|")})
       key.fields <- paste(group.fields, collapse = "|")
       nrow <- nrow(current.data)
       current.data.casos <- current.data %>% filter(key %in% keys.confirmados$key)
       nrow.filtered <- nrow(current.data.casos)
       logger$trace("After filter", field = key.fields, nrow = nrow, nrow.filtered = nrow.filtered)
       ret <- NULL
       if (nrow(current.data.casos) > 0){
         ret <- current.data.casos %>%
           group_by_at(group.fields) %>%
           summarize(n = n(),
                     max_fecha_diagnostico     = max(fecha_diagnostico, na.rm = TRUE),
                     max_fecha_inicio_sintomas = max(fecha_inicio_sintomas, na.rm = TRUE),
                     count_fecha_diagnostico   = n_distinct(fecha_diagnostico, na.rm = TRUE),
                     confirmados        = sum(ifelse(confirmado, 1, 0)),
                     descartados        = sum(ifelse(descartado, 1, 0)),
                     sospechosos        = sum(ifelse(sospechoso, 1, 0)),
                     fallecidos         = sum(ifelse(fallecido, 1, 0)),
                     tests              = sum(ifelse(!is.na(fecha_diagnostico), 1, 0)),
                     sin.clasificar     = sum(ifelse(clasificacion_resumen == "sin clasificar", 1, 0)),
                     letalidad.min.porc = round(fallecidos / (confirmados+sospechosos), 3),
                     letalidad.max.porc = round(fallecidos / confirmados, 3),
                     positividad.porc   = round(confirmados / tests, 3),
                     internados         = sum(ifelse(confirmado &!is.na(fecha_internacion), 1, 0)),
                     internados.porc    = round(internados/confirmados, 3),
                     cuidado.intensivo  = sum(ifelse(confirmado & !is.na(cuidado_intensivo) & cuidado_intensivo == "SI", 1, 0)),
                     cuidado.intensivo.porc = round(cuidado.intensivo/confirmados, 3),
                     respirador         = sum(ifelse(confirmado & !is.na(asistencia_respiratoria_mecanica) & asistencia_respiratoria_mecanica == "SI", 1, 0)),
                     respirador.porc    = round(respirador / confirmados, 3),
                     dias.diagnostico   = round(mean(ifelse(confirmado, as.numeric(fecha_diagnostico - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                     dias.apertura      = round(mean(ifelse(confirmado, as.numeric(fecha_apertura - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                     dias.cuidado.intensivo = round( mean(ifelse(confirmado, as.numeric(fecha_cui_intensivo - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                     dias.fallecimiento = round( mean(ifelse(confirmado, as.numeric(fecha_fallecimiento - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                     , .groups = "keep"
           )  %>% filter (confirmados >= min.confirmados)
       }
       ret
     }
    ))


#' EdadCoder
#' @importFrom R6 R6Class
#' @import dplyr
#' @export
EdadCoder <- R6Class("EdadCoder",
  public = list(
   agebreaks = NA,
   agelabels = NA,
  initialize = function(){
    self
  },
  setupCoder = function(){
   self$agebreaks <- c(0, 1, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 65, 70, 75, 80, 120)
   self$agelabels <- c("0","1-9","10-14","15-19","20-24","25-29","30-34",
                  "35-39","40-44","45-49","50-54","55-59","60-64","65-69",
                  "70-74","75-79","80+")
   self
  },
  codeEdad = function(edad){
   as.character(cut(edad,
       breaks = self$agebreaks,
       right = FALSE,
       labels = self$agelabels))
  }
  ))

#' exportAggregatedTables
#' @import readr
#' @import lgr
#' @export
exportAggregatedTables <- function(covid.ar.curator, output.dir,
                                   aggrupation.criteria = list(provincia_residencia = c("provincia_residencia"),
                                                               provincia_residencia_sexo = c("provincia_residencia", "sexo"),
                                                               edad_rango_sexo = c("edad.rango", "sexo"),
                                                               provincia_residencia_sepi_apertura = c("provincia_residencia", "sepi_apertura"),
                                                               provincia_departamento_residencia_sepi_apertura = c("residencia_provincia_nombre", "residencia_departamento_nombre", "sepi_apertura"),
                                                               provincia_residencia_fecha_apertura = c("provincia_residencia", "fecha_apertura")),
                                   data2process = covid.ar.curator$getData(),
                                   file.prefix = "covid19ar_")
  {
  logger <- lgr
  for (group.vars in aggrupation.criteria){
    current.filename <- paste(file.prefix, paste(group.vars, collapse = "-"), ".csv", sep = "")
    logger$info("Generating ", filename = current.filename)
    data.summary <- covid.ar.curator$makeSummary(group.vars = group.vars, data2process = data2process,
                                                 #cache.filename = current.filename
                                                 cache.filename = NULL
                                                 )
    output.path <- file.path(output.dir, current.filename)
    write_csv(data.summary, output.path)
  }
}

#' retrieveFromCache
#' @export
retrieveFromCache <- function(filename, subfolder = "curated/"){
  path <- paste("https://raw.githubusercontent.com/rOpenStats/COVID19ARdata/master/", subfolder, sep = "")
  read_csv(paste(path, filename, sep =""))
  #TODO check the names of the destination filename matches with expected names

}



#' COVID19ARDiff
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @export
COVID19ARDiff <- R6Class("COVID19ARDiff",
public = list(
  report.url           = NA,
  report.filename      = NA,
  report.diff.dir      = NA,
  report.diff.filename = NA,
  min.rebuilt.date     = NA,
  # state
  report               = NA,
  report.prev          = NULL,
  report.prev.diff     = NA,
  report.diff          = NA,
  curator              = NA,
  logger               = NA,
  initialize = function(min.rebuilt.date = '2020-06-16', report.diff.dir = "../COVID19ARdata/sources/COVID19AR"){
    self$min.rebuilt.date     <- min.rebuilt.date
    self$curator              <- COVID19ARCurator$new(download.new.data = FALSE)
    self$report.diff.dir      <- report.diff.dir
    self$report.diff.filename <- "Covid19CasosReporte.csv"
    self$logger               <- genLogger(self)
    self
  },
  loadReports = function(commit.id, max.date){
    self$report.url       <- self$getReportUrl(commit.id)
    self$report.filename <- "Covid19CasosReporteNew.csv"
    self$curator$loadData(url = self$report.url, force.download = TRUE,
                                         dest.filename = self$report.filename)
    self$curator$curateData()
    self$report <- self$curator$getData()
    if (max(self$report$fecha_diagnostico, na.rm =  TRUE) < max.date){
      stop(paste("File doesn't reach expected date", max.date,". Max date in data is", max(self$report$fecha_diagnostico), " for ", commit.id))
    }
    report.diff.path <- file.path(self$report.diff.dir, self$report.diff.filename)
    if (file.exists(report.diff.path)){
      self$curator$readFile(file.path = report.diff.path, assign = TRUE)
      self$curator$curateData()
      self$report.prev <- self$curator$getData()
    }
    self
  },
  getReportUrl = function(commit.id){
    paste("https://raw.githubusercontent.com/rOpenStats/COVID19ARdata",
          commit.id,
          "sources/msalnacion/Covid19Casos.csv", sep = "/")
  },
  #' processDiff
  #' binds report.prev and report adding rows from self$report with fecha_diagnostico to self$report.prev
  processDiff = function(){
    logger <- getLogger(self)
    self$report.diff <- self$report
    if (!is.null(self$report.prev)){
      self$report.prev.diff <- self$report.prev
      fechas.fields <- names(self$report)[grepl("fecha_", names(self$report))]

      if (!"fecha_reporte" %in% names(self$report.diff.prev)){
        max.fecha <- apply(self$report.prev.diff[,fechas.fields], MARGIN = 1, FUN = function(x){max(x, na.rm = TRUE)})
        self$report.prev.diff %<>% mutate(fecha_reporte = fecha_diagnostico)
        self$report.prev.diff$fecha_actualizacion <- max.fecha
        self$report.prev.diff %<>% mutate(diff_obs = "")
      }

      sospechosos.prev.ids <- self$report.prev.diff %>% filter(is.na(fecha_reporte)) %>% select (id_evento_caso)
      diagnosticados.ids   <- self$report.prev.diff %>% filter(!is.na(fecha_reporte)) %>% select (id_evento_caso)
      report.prev.diff.reporte  <- self$report.prev.diff %>% select(id_evento_caso, fecha_reporte, fecha_actualizacion, diff_obs)
      nrow(self$report.diff)
      max(self$report.diff$fecha_diagnostico, na.rm = TRUE)
      nrow(self$report.prev.diff)
      max(self$report.prev.diff$fecha_diagnostico, na.rm = TRUE)

      logger$info("Joining fecha reporte", nrow = nrow(self$report.diff), nrow.prev = nrow(report.prev.diff.reporte))
      self$report.diff %<>% left_join(report.prev.diff.reporte, by = "id_evento_caso")
      self$report.diff %>% filter(is.na(fecha_reporte)) %>% select(fecha_apertura)
      report.date <- max(self$report$fecha_diagnostico, na.rm = TRUE)

      sospechosos.remaining.ids <- self$report.diff %>% filter(is.na(fecha_reporte)) %>% select (id_evento_caso)
      logger$info("Filling report date for ", report.date = report.date, nrow(sospechosos.remaining.ids))
      self$report.diff %<>% mutate_cond(id_evento_caso %in% sospechosos.remaining.ids$id_evento_caso &
                                          !is.na(fecha_diagnostico) & fecha_diagnostico >= self$min.rebuilt.date, fecha_reporte = report.date)
      # For days previous to min.rebuilt.date report date is fecha_diagnostico
      self$report.diff %<>% mutate_cond(id_evento_caso %in% sospechosos.remaining.ids$id_evento_caso &
                                          !is.na(fecha_diagnostico) & fecha_diagnostico < self$min.rebuilt.date, fecha_reporte = fecha_diagnostico)
      max.fecha <- apply(self$report.diff[,fechas.fields], MARGIN = 1, FUN = function(x){max(x, na.rm = TRUE)})
      #updated.rows <- which(self$report.diff$fecha_actualizacion != max.fecha)
      #self$report %<>% mutate(fecha_actualizacion = across( = max(fecha_))
      self$report.diff$ultima_actualizacion <- max.fecha
      tail(self$report.diff %>%
             group_by(fecha_reporte, fecha_diagnostico) %>%
             summarise(n = n(),
                       confirmados = sum(confirmado),
                       descartados = sum(descartado),
                       sospechosos = sum(sospechoso)) %>%
             filter(fecha_reporte < fecha_diagnostico)
             #filter(fecha_reporte >= report.date - 2)
             , n = 45)

    }
    self$report.diff
  },
  #' processDiffMethod1
  #' Is self$report  with  fecha_reporte updated from report.diff
  #' All data is updated and fecha_reporte (when diagnostic was filled in db) is correct
  processDiffMethod1 = function(){
    self$report.diff <- self$report.prev
    if (!"fecha_reporte" %in% names(self$report.diff)){
      self$report.diff %<>% mutate(fecha_reporte = fecha_diagnostico)
      self$report.diff %<>% mutate(fecha_actualizacion = fecha_reporte)
      self$report.diff %<>% mutate(diff_obs = "")
    }
    sospechosos.prev.ids <- self$report.diff %>% filter(is.na(fecha_reporte)) %>% select (id_evento_caso)
    diagnosticados.ids   <- self$report.diff %>% filter(!is.na(fecha_reporte)) %>% select (id_evento_caso)
    report.new <- self$report %>% filter(!id_evento_caso %in% diagnosticados.ids$id_evento_caso)
    report.date <- max(report.new$fecha_apertura, na.rm = TRUE)
    if (!"fecha_reporte" %in% names(report.new)){
      #report.new %<>% mutate(fecha_reporte = ifelse(!is.na(fecha_diagnostico), as.Date(max(fecha_diagnostico, na.rm = TRUE)), NA))
      report.new %<>% mutate(fecha_reporte = as.Date(NA))
      report.new %<>% mutate_cond(!is.na(fecha_diagnostico), fecha_reporte = report.date)
      report.new %<>% mutate(fecha_actualizacion = fecha_reporte)
      report.new %<>% mutate(diff_obs = "")
    }

    report.new[which(!is.na(report.new$fecha_reporte)),]$fecha_reporte
    report.new %>%
      group_by(fecha_reporte, fecha_diagnostico) %>%
      summarise(n = n(),
                confirmados = sum(confirmado),
                descartados = sum(descartado),
                sospechosos = sum(sospechoso))
    tail(report.new %>%
           group_by(fecha_reporte, fecha_diagnostico) %>%
           summarise(n = n(),
                     confirmados = sum(confirmado),
                     descartados = sum(descartado),
                     sospechosos = sum(sospechoso)),
         n = 20)
    # Fix update info
    self$report.diff %<>%  bind_rows(self$report.diff, report.new)
  },
  saveReportDiff = function(){
    report.diff.path <- file.path(self$report.diff.dir, self$report.diff.filename)
    applied.delim <- self$curator$cols.delim[[self$curator$specification]]
    # No way of setting quotes in readr function
    #write_delim(self$report.diff, file = report.diff.path, sep = applied.delim, quote = TRUE)
    write.table(self$report.diff, file = report.diff.path, sep = applied.delim, quote = TRUE, row.names = FALSE)
  }
  ))
