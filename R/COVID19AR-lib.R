#' COVID19ARCurator
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @export
COVID19ARCurator <- R6Class("COVID19ARCurator",
   public = list(
    download.new.data   = NA,
    data.dir            = NA,
    url                 = NA,
    report.date         = NA,
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
    initialize = function(report.date, data.dir = getEnv("data_dir"),
                          download.new.data = TRUE){
     self$report.date <- report.date
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
                 delim = self$cols.delim[[self$specification]],
                 col_types = self$cols.specifications[[self$specification]])
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
        self$data[self$data$edad_años_meses == "Meses", ]$edad_actual_anios <- 0
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
        if (nrows.after < nrows.before * .99){
          # If in curation we loose more than 1% of records. SHow a warning
          logger$warn("Too much data filtered in curation",
                      nrows.before = nrows.before, nrows.after = nrows.after)
        }

        self$max.date <- getMaxDate(covid19ar.data = self$data, self$report.date)
        self$data <- self$data %>% filter(fecha_apertura <= self$report.date)
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
       temporal.fields.agg <- group.vars[group.vars %in% self$fields.temporal]
       non.temporal.fields.agg <- setdiff(group.vars, temporal.fields.agg)
       non.temporal.groups <- data2process %>%
         group_by_at(non.temporal.fields.agg) %>%
         summarise( .groups = "keep") %>%
         arrange_at(non.temporal.fields.agg)
       if (length(temporal.fields.agg) == 0){
         ret <- self$getAggregatedData(group.fields = group.vars, current.data = data2process)
       }
       else{
         ret <- NULL
         for (i in seq_len(nrow(non.temporal.groups))){
           current.group <- non.temporal.groups[i, ]
           logger$info("Processing", current.group = paste(names(current.group), current.group,
                                                           sep = " = ", collapse = "|"))
           current.group.data <- data2process %>% inner_join(current.group, by = non.temporal.fields.agg)
           temporal.groups <- current.group.data %>%
             group_by_at(temporal.fields.agg) %>%
             summarise( .groups = "keep") %>%
             arrange_at(temporal.fields.agg)
           current.temporal.group.acum <- NULL
           current.group.data.agg <- NULL
           dias.contador <- 0
           for (j in seq_len(nrow(temporal.groups))){
             current.temporal.group <- temporal.groups[j, ]
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
             current.group.data.agg %<>%  mutate(confirmados.rate = ifelse(dias.inicio >= 1, confirmados.inc / lag(confirmados, n = 1), NA))
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
       keys.confirmados$key <- apply(keys.confirmados[, group.fields], MARGIN = 1,
                                     FUN = function(x){paste(x, collapse = "|")})

       current.data$key <- apply(current.data[, group.fields], MARGIN = 1,
                                 FUN = function(x){
                                   paste(x, collapse = "|")
                                   })
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
                     letalidad.min.porc = round(fallecidos / (confirmados + sospechosos), 3),
                     letalidad.max.porc = round(fallecidos / confirmados, 3),
                     positividad.porc   = round(confirmados / tests, 3),
                     internados         = sum(ifelse(confirmado & !is.na(fecha_internacion), 1, 0)),
                     internados.porc    = round(internados / confirmados, 3),
                     cuidado.intensivo  = sum(ifelse(confirmado & !is.na(cuidado_intensivo) & cuidado_intensivo == "SI", 1, 0)),
                     cuidado.intensivo.porc = round(cuidado.intensivo / confirmados, 3),
                     respirador         = sum(ifelse(confirmado & !is.na(asistencia_respiratoria_mecanica) & asistencia_respiratoria_mecanica == "SI", 1, 0)),
                     respirador.porc    = round(respirador / confirmados, 3),
                     dias.diagnostico   = round(mean(ifelse(confirmado, as.numeric(fecha_diagnostico - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                     dias.apertura      = round(mean(ifelse(confirmado, as.numeric(fecha_apertura - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                     dias.cuidado.intensivo = round( mean(ifelse(confirmado, as.numeric(fecha_cui_intensivo - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                     dias.fallecimiento = round( mean(ifelse(confirmado, as.numeric(fecha_fallecimiento - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                     , .groups = "keep")  %>%
                filter (confirmados >= min.confirmados)
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
   self$agelabels <- c("0", "1-9", "10-14", "15-19", "20-24", "25-29", "30-34",
                  "35-39", "40-44", "45-49", "50-54", "55-59", "60-64", "65-69",
                  "70-74", "75-79", "80+")
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
                                   file.prefix = "covid19ar_"){
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
  read_csv(paste(path, filename, sep = ""))
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
  report.date          = NA,
  report               = NA,
  report.prev          = NULL,
  report.prev.diff     = NA,
  report.diff          = NA,
  report.last.date          = NA,
  curator              = NA,
  logger               = NA,
  initialize = function(min.rebuilt.date, report.diff.dir){
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
      stop(paste("File doesn't reach expected date", max.date, ". Max date in data is", max(self$report$fecha_diagnostico), " for ", commit.id))
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
    if (!dir.exists(self$report.diff.dir)){
      stop("Folder", self$report.diff.dir, "must be manually created for running processDiff")
    }
    self$report.diff <- self$report
    self$report.date <- max(self$report.diff$fecha_diagnostico, na.rm = TRUE)
    if (!is.null(self$report.prev)){
      self$report.prev.diff <- self$report.prev
      fechas.fields <- names(self$report)[grepl("fecha_", names(self$report))]
      sospechosos.prev.ids <- self$report.prev.diff %>%
                                filter(is.na(fecha_reporte)) %>%
                                select(id_evento_caso)
      diagnosticados.ids   <- self$report.prev.diff %>%
                                    filter(!is.na(fecha_reporte)) %>%
                                    select(id_evento_caso)
      report.prev.diff.reporte  <- self$report.prev.diff %>% select(id_evento_caso, fecha_reporte, ultima_actualizacion, fecha_diagnostico_prev = fecha_diagnostico, clasificacion_resumen_prev = clasificacion_resumen, diff_obs)
      nrow(self$report.diff)
      max(self$report.diff$fecha_diagnostico, na.rm = TRUE)
      nrow(self$report.prev.diff)
      max(self$report.prev.diff$fecha_diagnostico, na.rm = TRUE)

      logger$info("Joining fecha reporte",
                  nrow = nrow(self$report.diff),
                  nrow.prev = nrow(report.prev.diff.reporte))
      self$report.diff %<>% left_join(report.prev.diff.reporte, by = "id_evento_caso")
      # Checked PK in report.diff
      self$report.diff %>%
        group_by(id_evento_caso) %>%
        summarise(n = n()) %>%
        filter(n > 1)
      # sospechosos.remaining.ids <- self$report.diff %>%
      #                               filter(is.na(fecha_reporte)) %>%
      #                               select (id_evento_caso)
      #new diagnostics
      nuevos.diagnosticos.id <- self$report.diff %>%
        filter(is.na(fecha_reporte) &
                 !is.na(fecha_diagnostico)) %>% select(id_evento_caso)
      #rectifications
      rectification.diagnostico.ids <-  self$report.diff %>%
                                          filter(!is.na(fecha_reporte) & fecha_diagnostico != fecha_diagnostico_prev) %>%
                                          select (id_evento_caso)

      rectification.clasificacion.ids <- self$report.diff %>%
                                          filter(!is.na(fecha_reporte) & clasificacion_resumen != clasificacion_resumen_prev) %>%
                                          select (id_evento_caso)
      rectification.clasificacion.ids
      self$report.diff %>% filter(id_evento_caso %in%  c(802474, 1077510)) %>% select(fecha_reporte, fecha_diagnostico, fecha_diagnostico_prev, clasificacion_resumen, clasificacion_resumen_prev)
      which(rectification.clasificacion.ids$id_evento_caso %in% c(802474, 1077510))

      # news
      diagnosticos.date <- unique(c(nuevos.diagnosticos.id$id_evento_caso, rectification.diagnostico.ids$id_evento_caso, rectification.clasificacion.ids$id_evento_caso))
      logger$info("Filling report date for ", report.date = self$report.date,
                  diagnosticos.fecha          = length(diagnosticos.date),
                  nuevos.diagnosticos         = nrow(nuevos.diagnosticos.id),
                  rectificacion.diagnostico   = nrow(rectification.diagnostico.ids),
                  rectificacion.clasificacion = nrow(rectification.clasificacion.ids))
      #debug
      self.debug <<- self
      diagnosticos.date <<- diagnosticos.date

      # Check no NA row name
      is.na(self$report.diff$id_evento_caso %in% diagnosticos.date &
        self$report.diff$fecha_diagnostico >= self$min.rebuilt.date)

      na.rows <- which(is.na(self$report.diff$id_evento_caso %in% diagnosticos.date &
        ifelse(!is.na(self$report.diff$fecha_diagnostico), self$report.diff$fecha_diagnostico >= self$min.rebuilt.date, TRUE)))
      if (length(na.rows) > 0){
        stop(paste("Cannot asssign NA rows and having", length(na.rows), "rows"))
      }
      # Update fecha_reporte report.date
      self$report.diff %<>% mutate_cond(id_evento_caso %in% diagnosticos.date &
                                        ifelse(!is.na(fecha_diagnostico), fecha_diagnostico >= self$min.rebuilt.date, TRUE),
                                        fecha_reporte = self$report.date)
      # Update fecha_reporte fecha_diagnostico (previous to min.rebuilt.date)
      # If fecha_diagnostico is NA, not update fecha diagnostico
      self$report.diff %<>% mutate_cond(id_evento_caso %in% diagnosticos.date &
                                        ifelse(!is.na(fecha_diagnostico), fecha_diagnostico < self$min.rebuilt.date, FALSE),
                                        fecha_reporte = fecha_diagnostico)
      # Update diff_obs with rectification diagnostico
      self$report.diff %<>% mutate_cond(id_evento_caso %in% rectification.diagnostico.ids$id_evento_caso,
                                        diff_obs = paste(diff_obs, "|rectFD=", fecha_diagnostico_prev, sep = ""))
      self$report.diff %<>% mutate_cond(id_evento_caso %in% rectification.clasificacion.ids$id_evento_caso,
                                        diff_obs = paste(diff_obs, "|rectCla=", clasificacion_resumen_prev, sep = ""))
      #check
      self$report.diff %>% filter(id_evento_caso %in% rectification.clasificacion.ids$id_evento_caso) %>% select(fecha_diagnostico, clasificacion_resumen, diff_obs)

      # Remove aux columns
      self$report.diff %<>% select(-fecha_diagnostico_prev, -clasificacion_resumen_prev)
        # Not useful as it is not consistent
    }
    self$report.diff %<>% select(-clasificacion)
    if (!"fecha_reporte" %in% names(self$report.diff)){
      self$report.diff %<>% mutate(fecha_reporte = fecha_diagnostico)
      self$report.diff %<>% mutate(diff_obs = "")
    }

    max.fecha <- apply(self$report.diff[, fechas.fields], MARGIN = 1, FUN = function(x){max(x, na.rm = TRUE)})
    #updated.rows <- which(self$report.diff$ultima_actualizacion != max.fecha)
    #self$report %<>% mutate(ultima_actualizacion = across( = max(fecha_))
    self$report.diff$ultima_actualizacion <- max.fecha
    self$report.last.date <- self$report.diff %>% filter(id_evento_caso %in% diagnosticos.date)
    self$report.diff
  },
  saveReportDiff = function(){
    report.diff.path <- file.path(self$report.diff.dir, self$report.diff.filename)
    report.date.path <- gsub("\\.csv", paste("_", as.character(self$report.date, "%Y%m%d"), ".csv", sep = ""), report.diff.path)
    applied.delim <- self$curator$cols.delim[[self$curator$specification]]
    # No way of setting quotes in readr function
    #write_delim(self$report.diff, file = report.diff.path, sep = applied.delim, quote = TRUE)
    write.table(self$report.diff, file = report.diff.path, sep = applied.delim, quote = TRUE, row.names = FALSE)
    write.table(self$report.last.date, file = report.date.path, sep = applied.delim, quote = TRUE, row.names = FALSE)
    report.date
  }
  ))

#' COVID19ARDiffBuilder
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @export
COVID19ARDiffSummarizer <- R6Class("COVID19ARDiffBuilder",
 public = list(
   report.diff.dir = NA,
   report.diff.summary.filename = NA,
   # state
   casos.mapping        = NA,
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
     self$loadReportDiffSummary()
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


     casos.mapping %<>% arrange(update.date)
     self$casos.mapping <- casos.mapping
     self$buildMapacheData()
     self$casos.mapping
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
   buildCasosReport = function(max.n = 0, min.date = NULL){
     logger <- getLogger(self)
     report.days.processed <- sort(unique(self$report.diff.summary$fecha_reporte_ejecutado))
     casos.mapping <- self$casos.mapping
     if (!is.null(min.date)){
       casos.mapping %<>% filter(update.date >= min.date)
     }
     n <- nrow(self$casos.mapping)
     if (max.n > 0){
       n <- min(n, max.n)
     }
     for (i in seq_len(n)){
       current.case <- casos.mapping[i, ]
       if (!current.case$update.date %in% report.days.processed){
         logger$info("Processing current date", current.date = current.case$update.date)
         # Starting from diff
         self$report.diff.builder$loadReports(commit = current.case$git.id, max.date = current.case$update.date)
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

#' loadMapacheData
#' @import readr
#' @export
loadMapacheData <- function(){
  read_csv("https://docs.google.com/spreadsheets/d/16-bnsDdmmgtSxdWbVMboIHo5FRuz76DBxsz_BbsEVWA/export?format=csv&id=16-bnsDdmmgtSxdWbVMboIHo5FRuz76DBxsz_BbsEVWA&gid=0",
           col_types = cols(
             fecha = col_character(),
             dia_inicio = col_double(),
             dia_cuarentena_dnu260 = col_double(),
             osm_admin_level_2 = col_character(),
             osm_admin_level_4 = col_character(),
             osm_admin_level_8 = col_character(),
             tot_casosconf = col_double(),
             nue_casosconf_diff = col_double(),
             tot_fallecidos = col_double(),
             nue_fallecidos_diff = col_double(),
             tot_recuperados = col_double(),
             tot_terapia = col_double(),
             `test_RT-PCR_negativos` = col_double(),
             `test_RT-PCR_total` = col_double(),
             transmision_tipo = col_character(),
             informe_tipo = col_character(),
             informe_link = col_character(),
             observacion = col_character(),
             covid19argentina_admin_level_4 = col_character()
           ))
}
