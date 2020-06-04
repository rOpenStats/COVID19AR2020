#' COVID19ARCurator
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @export
COVID19ARCurator <- R6Class("COVID19ARCurator",
   public = list(
    data.dir            = NA,
    url                 = NA,
    #specification
    specification       = NA,
    cols.delim          = NA,
    cols.specifications = NA,
    curate.functions    = NA,
    edad.coder          = NA,
    curated             = FALSE,
    fields.temporal         = c("sepi_apertura", "fecha_apertura"),
    data                = NA,
    data.summary        = NA,
    logger              = NA,
    initialize = function(url, data.dir = getEnv("data_dir")){
     self$data.dir <- data.dir
     self$url      <- url
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

    },
    loadData = function(){
     file.path <- retrieveURL(self$url, dest.dir = self$data.dir)
     filename <- strsplit(file.path, split = "/")[[1]]
     filename <- filename[length(filename)]
     self$specification <- "200603"
     self$data <- read_delim(file.path,
                                 delim = self$cols.delim[[self$specification]],
                             col_types = self$cols.specifications[[self$specification]])
     self$edad.coder <- EdadCoder$new()
     self$edad.coder$setupCoder()
     self
    },
    curateData = function(){
      if (is.null(self$specification)){
        stop("Specification not defined")
      }
      self$curate.functions[[self$specification]]()
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
    },
    normalize = function(){
      logger <- getLogger(self)
      logger$info("Normalize")
      self$data$fixed <- ""
      self$data %<>% mutate(clasificacion = tolower(clasificacion))
      self$data %<>% mutate(clasificacion_resumen = tolower(clasificacion_resumen))
      self$data %<>% mutate(fallecido = tolower(fallecido))
    },
    curateData200603 = function(){
      logger <- getLogger(self)
      if (!self$curated){
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
        self$data %<>% mutate(fallecido  = ifelse(confirmado & fallecido == "si", 1, 0))
        self$curated <- TRUE
      }
    },

    makeSummary = function(group.vars = c("residencia_provincia_nombre", "sepi_apertura"),
                           temporal.acum = TRUE){
     logger <- getLogger(self)
     self$curateData()
     #self$data$edad.rango <- NA
     #levels(self$data$edad.rango) <- self$edad.coder$agelabels
     temporal.fields.agg<- group.vars[group.vars %in% self$fields.temporal]
     non.temporal.fields.agg <- setdiff(group.vars, temporal.fields.agg)
     non.temporal.groups <- self$data %>%
       group_by_at(non.temporal.fields.agg) %>%
       summarise( .groups = "keep") %>%
       arrange_at(non.temporal.fields.agg)
     if(length(temporal.fields.agg) == 0){
       self$data.summary <- self$getAggregatedData(group.fields = group.vars, current.data = self$data)
     }
     else{
       self$data.summary <- NULL
       for (i in seq_len(nrow(non.temporal.groups))){
         current.group <- non.temporal.groups[i,]
         logger$info("Processing", current.group = paste(names(current.group), current.group,
                                                         sep =" = ", collapse = "|"))
         current.group.data <- self$data %>% inner_join(current.group, by = non.temporal.fields.agg)
         temporal.groups <- current.group.data %>%
                             group_by_at(temporal.fields.agg) %>%
                             summarise( .groups = "keep") %>%
                             arrange_at(temporal.fields.agg)
         current.temporal.group.acum <- NULL
         current.group.data.agg <- NULL
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

             current.group.data.agg <- rbind(current.group.data.agg, current.temporal.group.data.agg)
           }
         }
         self$data.summary <- rbind(self$data.summary, current.group.data.agg)
         logger$info("Total data after aggregating group",
                     current.group = paste(names(current.group), current.group,
                                                   sep =" = ", collapse = "|"),
                     nrow = nrow(self$data.summary))

       }
     }
     # if ("sepi_apertura" %in% group.vars){
     #   semanas <- self$data %>% group_by(sepi_apertura) %>% summarize(min.fecha = min(fecha_apertura),
     #                                                                  max.fecha = max(fecha_apertura)
     #                                                                  #,dias = max.fecha -min.fecha +1
     #   )
     #   self$data.summary %>% inner_join(semanas, by = "sepi_apertura")
     # }
     self$data.summary
     },
     getAggregatedData = function(group.fields, current.data, min.confirmados = 0){
       current.data %>%
         group_by_at(group.fields) %>%
         summarize(n = n(),
                   confirmados        = sum(ifelse(confirmado, 1, 0)),
                   descartados        = sum(ifelse(descartado, 1, 0)),
                   sospechosos        = sum(ifelse(sospechoso, 1, 0)),
                   fallecidos         = sum(ifelse(fallecido, 1, 0)),
                   sin.clasificar     = sum(ifelse(clasificacion_resumen == "sin clasificar", 1, 0)),
                   letalidad.min.porc = round(fallecidos / (confirmados+sospechosos), 3),
                   letalidad.max.porc = round(fallecidos / confirmados, 3),
                   positividad.porc   = round(confirmados / (confirmados+descartados), 3),
                   internados         = sum(ifelse(confirmado &!is.na(fecha_internacion), 1, 0)),
                   internados.porc    = round(internados/confirmados, 3),
                   cuidado.intensivo  = sum(ifelse(confirmado & !is.na(cuidado_intensivo) & cuidado_intensivo == "SI", 1, 0)),
                   cuidado.intensivo.porc = round(cuidado.intensivo/confirmados, 3),
                   respirador         = sum(ifelse(confirmado & !is.na(asistencia_respiratoria_mecanica) & asistencia_respiratoria_mecanica == "SI", 1, 0)),
                   respirador.porc    = round(respirador / confirmados, 3),
                   dias.diagnostico   = round(mean(ifelse(confirmado, as.numeric(fecha_diagnostico - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                   dias.apertura      = round(mean(ifelse(confirmado, as.numeric(fecha_apertura - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                   dias.cuidado.intensivo = round( mean(ifelse(confirmado, as.numeric(fecha_cui_intensivo - fecha_inicio_sintomas), NA), na.rm = TRUE), 1),
                   dias.fallecimiento = round( mean(ifelse(confirmado, as.numeric(fecha_fallecimiento - fecha_inicio_sintomas), NA), na.rm = TRUE), 1)
         )  %>% filter (confirmados >= min.confirmados)
     }
    ))

#' COVID19ARCurator200519
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @import readr
#' @export
COVID19ARCurator200519 <- R6Class("COVID19ARCurator200519",
  public = list(
    data.dir            = NA,
    url                 = NA,
    #specification
    specification       = NA,
    cols.delim          = NA,
    cols.specifications = NA,
    curate.functions     = NA,
    edad.coder          = NA,
    curated             = FALSE,
    fields.date         = c("sepi_apertura", "fecha_apertura"),
    data                = NA,
    data.summary        = NA,
    logger              = NA,
    initialize = function(url, data.dir = getEnv("data_dir")){
      self$data.dir <- data.dir
      self$url      <- url
      self$logger   <- genLogger(self)
      self$setupColsSpecifications()
      self
    },
    setupColsSpecifications = function(){
      self$cols.delim <- list()
      self$cols.specifications <- list()
      self$curate.functions <- list()
      self$curate.functions[["200519"]] <- self$curateData200519
      self$cols.delim[["200519"]] <- ";"
      self$cols.specifications[["200519"]] <- cols(
        .default = col_character(),
        id_evento_caso      = col_integer(),
        edad_actual_anios   = col_integer(),
        prov_residencia_id  = col_integer(),
        prov_carga_id       = col_integer(),
        fis                 = col_date(format = ""),
        fecha_apertura      = col_date(format = ""),
        sepi_apertura       = col_double(),
        #fecha_cui_intensivo = col_date(format = ""),
        fecha_internacion   = col_date(format = ""),
        fecha_fallecimiento = col_date(format = ""),
        fecha_diagnostico   = col_date(format = "")
      )
    },
    loadData = function(){
      file.path <- retrieveURL(self$url, dest.dir = self$data.dir)
      filename <- strsplit(file.path, split = "/")[[1]]
      filename <- filename[length(filename)]
      self$specification <- "200519"
      self$data <- read_delim(file.path,
                              delim = self$cols.delim[[self$specification]],
                              col_types = self$cols.specifications[[self$specification]])
      self$edad.coder <- EdadCoder$new()
      self$edad.coder$setupCoder()
      self
    },
    curateData = function(){
      if (is.null(self$specification)){
        stop("Specification not defined")
      }
      self$curate.functions[[self$specification]]()
    },
    curateData200519 = function(){
      logger <- getLogger(self)
      if (!self$curated){
        logger$info("Mutating data")
        #self$data$edad.rango <- NA
        #levels(self$data$edad.rango) <- self$edad.coder$agelabels
        self$data$edad.rango <- vapply(self$data$edad_actual_anios,
                                       FUN = self$edad.coder$codeEdad,
                                       FUN.VALUE = character(1))
        # TODO import as date
        self$data$fecha_cui_intensivo <- as.Date(self$data$fecha_cui_intensivo, format = "%d/%m/%Y")

        self$data %<>% mutate(confirmado = ifelse(clasificacion_resumen == "Confirmado", 1, 0))
        self$data %<>% mutate(descartado = ifelse(clasificacion_resumen == "Descartado", 1, 0))
        self$data %<>% mutate(sospechoso = ifelse(clasificacion_resumen == "Sospechoso", 1, 0))
        #self$data %<>% mutate(fallecido  = ifelse(confirmado & fallecido == "SI", 1, 0))
        self$data$fallecido
        self$curated <- TRUE
      }
    },
    makeSummary = function(group.vars = c("provincia_residencia", "edad.rango", "sepi_apertura", "origen_financiamiento")){
      logger <- getLogger(self)
      self$curateData()
      #self$data$edad.rango <- NA
      #levels(self$data$edad.rango) <- self$edad.coder$agelabels
      self$data.summary <- current.data %>%
          group_by_at(group.vars) %>%
          summarize(n = n(),
                    confirmados = sum(ifelse(confirmado, 1, 0)),
                    descartados = sum(ifelse(descartado, 1, 0)),
                    sospechosos = sum(ifelse(sospechoso, 1, 0)),
                    fallecidos  = sum(ifelse(confirmado & !is.na(fallecido) & fallecido == "SI", 1, 0)),
                    sin.clasificar = sum(ifelse(clasificacion_resumen == "Sin Clasificar", 1, 0)),
                    letalidad.min.porc = round(fallecidos / (confirmados+sospechosos), 3),
                    letalidad.max.porc = round(fallecidos / confirmados, 3),
                    positividad.porc = round(confirmados / (confirmados+descartados), 3),
                    internados  = sum(ifelse(confirmado &!is.na(fecha_internacion), 1, 0)),
                    internados.porc = round(internados/confirmados, 3),
                    cuidado.intensivo = sum(ifelse(confirmado & !is.na(cuidado_intensivo) & cuidado_intensivo == "SI", 1, 0)),
                    cuidado.intensivo.porc = round(cuidado.intensivo/confirmados, 3),
                    respirador  = sum(ifelse(confirmado & !is.na(asist_resp_mecanica) & asist_resp_mecanica == "SI", 1, 0)),
                    respirador.porc = round(respirador / confirmados, 3),
                    dias.diagnostico = round(mean(ifelse(confirmado, as.numeric(fecha_diagnostico - fecha_apertura), NA), na.rm = TRUE), 1),
                    dias.atencion = round(mean(ifelse(confirmado, as.numeric(fecha_apertura - fis), NA), na.rm = TRUE), 1),
                    dias.cuidado.intensivo = round( mean(ifelse(confirmado, as.numeric(fecha_cui_intensivo - fis), NA), na.rm = TRUE), 1),
                    dias.fallecimiento = round( mean(ifelse(confirmado, as.numeric(fecha_fallecimiento - fis), NA), na.rm = TRUE), 1)
          )  %>% filter (confirmados > 0)
      # if ("sepi_apertura" %in% group.vars){
      #   semanas <- self$data %>% group_by(sepi_apertura) %>% summarize(min.fecha = min(fecha_apertura),
      #                                                                  max.fecha = max(fecha_apertura)
      #                                                                  #,dias = max.fecha -min.fecha +1
      #   )
      #   self$data.summary %>% inner_join(semanas, by = "sepi_apertura")
      # }
      self$data.summary
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
                                                               provincia_residencia_fecha_apertura = c("provincia_residencia", "fecha_apertura")))
  {
  logger <- lgr
  for (group.vars in aggrupation.criteria){
    current.filename <- paste("covid19ar_",paste(group.vars, collapse = "-"), ".csv", sep = "")
    logger$info("Generating ", filename = current.filename)
    data.summary <- covid.ar.curator$makeSummary(group.vars = group.vars)
    output.path <- file.path(output.dir, current.filename)
    write_csv(data.summary, output.path)
  }
}
