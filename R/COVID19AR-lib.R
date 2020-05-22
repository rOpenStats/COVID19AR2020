#' COVID19ARCurator
#' @importFrom R6 R6Class
#' @import dplyr
#' @import magrittr
#' @export
COVID19ARCurator <- R6Class("COVID19ARCurator",
   public = list(
    data.dir = NA,
    url = NA,
    edad.coder = NA,
    curated = FALSE,
    data = NA,
    data.summary = NA,
    logger = NA,
    initialize = function(url, data.dir = getEnv("data_dir")){
     self$data.dir <- data.dir
     self$url      <- url
     self$logger   <- genLogger(self)
     self
    },
    loadData = function(){
     retrieveURL(self$url, dest.dir = data.dir)
     self$data <- read_delim("~/.R/COVID19AR/sources/200521/covid_19_casos.csv",
                                 delim = ";",
                                 col_types = cols(
                                  .default = col_character(),
                                  id_evento_caso = col_integer(),
                                  edad_actual_anios = col_double(),
                                  prov_residencia_id = col_double(),
                                  prov_carga_id = col_double(),
                                  fis = col_date(format = ""),
                                  fecha_apertura = col_date(format = ""),
                                  sepi_apertura = col_double(),
                                  fecha_internacion = col_date(format = ""),
                                  fecha_fallecimiento = col_date(format = ""),
                                  fecha_diagnostico = col_date(format = "")
                                 ))
      self$edad.coder <- EdadCoder$new()
      self$edad.coder$setupCoder()
      self
    },
    curateData = function(){
     logger <- getLogger(self)
     if (!self$curated){
      logger$info("Mutating data")
      #self$data$edad.rango <- NA
      #levels(self$data$edad.rango) <- self$edad.coder$agelabels
      self$data$edad.rango <- vapply(self$data$edad_actual_anios,
                                     FUN = self$edad.coder$codeEdad,
                                     FUN.VALUE = character(1))
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
     logger$info("Mutating data")
     #self$data$edad.rango <- NA
     #levels(self$data$edad.rango) <- self$edad.coder$agelabels
     names(self$data)
     self$data.summary <- self$data %>%
      group_by_at(group.vars) %>%
      summarize(n = n(),
                tiempo.diagnostico = mean(fecha_diagnostico - fecha_apertura),
                confirmados = sum(ifelse(confirmado, 1, 0)),
                descartados = sum(ifelse(descartado, 1, 0)),
                sospechosos = sum(ifelse(sospechoso, 1, 0)),
                fallecidos  = sum(ifelse(confirmado & fallecido == "SI", 1, 0)),
                sin.clasificar = sum(ifelse(clasificacion_resumen == "Sin Clasificar", 1, 0)),
                positividad = confirmados / (confirmados+descartados),
                internados  = sum(ifelse(confirmado &!is.na(fecha_internacion), 1, 0)),
                internados.porc = internados/confirmados,
                cuidado.intensivo = sum(ifelse(confirmado & !is.na(cuidado_intensivo) & cuidado_intensivo == "SI", 1, 0)),
                cuidado.intensivo.porc = cuidado.intensivo/confirmados,
                respirador  = sum(ifelse(confirmado & !is.na(asist_resp_mecanica) & asist_resp_mecanica == "SI", 1, 0)),
                respirador.porc = respirador/confirmados,
                )
     if ("sepi_apertura" %in% group.vars){
       semanas <- self$data %>% group_by(sepi_apertura) %>% summarize(min.fecha = min(fecha_apertura),
                                                                      max.fecha = max(fecha_apertura)
                                                                      #,dias = max.fecha -min.fecha +1
       )
       self$data.summary %>% inner_join(semanas, by = "sepi_apertura")
     }
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

