

#' ReportGeneratorCOVID19AR
#' @importFrom R6 R6Class
#' @import TTR
#' @import magrittr
#' @import ggplot2
#' @export
ReportGeneratorCOVID19AR <- R6Class("ReportGeneratorCOVID19AR",
  public = list(
   covid19ar.curator = NA,
   report.date = NA,
   departamentos.ranking = NA,
   covid19.ar.summary = NA,
   ma.n = NA,
   initialize = function(covid19ar.curator, ma.n = 3){
      # Manual type check
      stopifnot(inherits(covid19ar.curator, "COVID19ARCurator"))
      self$covid19ar.curator <- covid19ar.curator
      self$ma.n <- ma.n
      self
   },
   preprocess = function(){
      self$report.date <- as.Date(self$covid19ar.curator$max.date)
      max.date.complete <- self$report.date - 1
      covid19.ar.summary <- self$covid19ar.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "residencia_departamento_nombre", "fecha_apertura"),
                                                          cache.filename = "covid19ar_residencia_provincia_nombre-residencia_departamento_nombre-fecha_apertura.csv")

      # CABA reports data twice
      nrow(covid19.ar.summary)
      covid19.ar.summary %<>% filter(!(residencia_provincia_nombre == "CABA" & residencia_departamento_nombre == "SIN ESPECIFICAR"))
      nrow(covid19.ar.summary)

      covid19.ar.summary.last <- covid19.ar.summary %>% filter(fecha_apertura == max.date.complete)
      covid19.ar.summary.last %<>% mutate(rank = rank(desc(confirmados)))
      covid19.ar.summary.last %<>% arrange(rank)
      confirmados.tot <- sum(covid19.ar.summary.last$confirmados)
      covid19.ar.summary.last %<>% mutate(confirmados.prop = confirmados / confirmados.tot)
      covid19.ar.summary.last %<>% mutate(confirmados.cum = cumsum(confirmados))
      covid19.ar.summary.last %<>% mutate(confirmados.cumprop = confirmados.cum / confirmados.tot)
      covid19.ar.summary.last %<>% select(residencia_departamento_nombre, residencia_provincia_nombre, fecha_apertura, n,
                                          confirmados, rank, confirmados.cumprop, confirmados.cum, confirmados.prop)
      covid19.ar.summary.last %<>% mutate(departamento = paste(sprintf("%02d", round(rank)), residencia_provincia_nombre, residencia_departamento_nombre, sep = "-"))

      self$departamentos.ranking <- covid19.ar.summary.last
      covid19.ar.summary %<>% inner_join(covid19.ar.summary.last %>% select(residencia_departamento_nombre, residencia_provincia_nombre, confirmados.prop, confirmados.cumprop, rank),
                                         by = c("residencia_departamento_nombre", "residencia_provincia_nombre"))
      covid19.ar.summary %<>% mutate(departamento = paste(sprintf("%02d", round(rank)), residencia_provincia_nombre, residencia_departamento_nombre, sep = "-"))
      nrow(covid19.ar.summary)
      length(unique(covid19.ar.summary$departamento))
      departamentos.calculate <- covid19.ar.summary %>%
         group_by(departamento) %>%
         summarise(observations = n()) %>%
         filter(observations >= self$ma.n) %>%
         arrange(observations)
      covid19.ar.summary %<>% inner_join(departamentos.calculate, by = "departamento")
      nrow(covid19.ar.summary)
      length(unique(covid19.ar.summary$departamento))
      covid19.ar.summary %<>% group_by(departamento) %>% mutate(confirmados.smoothed = runMean(confirmados, self$ma.n))
      self$covid19.ar.summary <- covid19.ar.summary
   },
   getDepartamentosExponentialGrowthPlot = function(n.highlighted = 10){
      data2plot <- self$covid19.ar.summary %>% filter(confirmados >= 20 & confirmados.smoothed >= 20)
      dates <- sort(unique(data2plot$fecha_apertura))

      data2plot.highlighed <- data2plot %>% filter(rank <= n.highlighted)
      data2plot.gray <- data2plot %>% filter(rank > n.highlighted)
      covplot <- data2plot.gray %>%
         ggplot(aes(x = fecha_apertura, y = confirmados.smoothed, color = " otros", group = departamento)) +
         geom_line() +
         labs(title = "Evolución de casos confirmados por Departamento") +
         ylab(paste("Confirmados -observado y promedio", self$ma.n, "días- (log)"))
      covplot <- covplot +
         geom_point(data = data2plot.highlighed, aes(x = fecha_apertura, y = confirmados, color = departamento))
      covplot <- covplot +
         geom_line(data = data2plot.highlighed, aes(x = fecha_apertura, y = confirmados.smoothed, color = departamento))
      covplot <- setupTheme(covplot, report.date = report.date, x.values = dates,
                            x.type = "dates",
                            total.colors = n.highlighted,
                            manual.colors = brewer.pal(n = 9, name = "Greys")[4],
                            data.provider.abv = "@msalnacion", base.size = 6)
      covplot <- covplot + scale_y_log10()
      covplot
   },
   getDepartamentosCrossSectionConfirmedPostitivyPlot = function(n.highlighted = 10){
      data2plot <- self$covid19.ar.summary %>% filter(confirmados >= 20 & confirmados.smoothed >= 20)
      data2plot.highlighed <- data2plot %>% filter(rank <= n.highlighted)
      data2plot.gray <- data2plot %>% filter(rank > n.highlighted)
      covplot <- data2plot.gray %>%
         ggplot(aes(x = confirmados.smoothed, y = positividad.porc, color = " otros", group = departamento)) +
         geom_line() +
         labs(title = "Evolución de casos confirmados por Departamento") +
         xlab("Confirmados (log)") + ylab("Positividad")
      covplot <- covplot +
         geom_line(data = data2plot.highlighed, aes(x = confirmados.smoothed, y = positividad.porc, color = departamento))
      covplot <- setupTheme(covplot, report.date = report.date,
                            x.values = covplot[, "confirmados"], x.type = "field.x",
                            total.colors = n.highlighted,
                            manual.colors = brewer.pal(n = 9, name = "Greys")[4],
                            data.provider.abv = "@msalnacion", base.size = 6)
      covplot <- covplot + scale_x_log10()
      covplot
   }
   ))


#' setup Dataviz theme
#' @import RColorBrewer
#' @importFrom grDevices colorRampPalette
#' @import scales
#' @import ggplot2
#' @export
setupTheme <- function(ggplot, report.date, x.values, data.provider.abv, total.colors, manual.colors = NULL,
                       x.type = "dates", base.size = 6){
 if (!is.null(x.type)){
  if (x.type == "dates"){
   dates    <- x.values
   max.date <- max(dates)
   min.date <- min(dates)
   date.breaks.freq  <- "7 day"
   minor.breaks.freq <- "1 day"
   date.labels.format <- "%y-%m-%d"
   neg.date.breaks.freq <- paste("-", date.breaks.freq, sep ="")
   neg.minor.breaks.freq <- paste("-", minor.breaks.freq, sep ="")
   date.breaks  <- sort(seq(max.date,
                            min.date,
                            by = neg.date.breaks.freq))
   minor.breaks  <- sort(seq(max.date,
                             min.date,
                             by = neg.minor.breaks.freq))
   ggplot <- ggplot + scale_x_date(date_labels = date.labels.format,
                                   breaks  = date.breaks,
                                   minor_breaks = minor.breaks
                                   #,limits = c(min.date, max.date)
   )
  }
  if (x.type == "epidemy.day"){
   max.value <- max(x.values)
   min.value <- min(x.values)
   breaks  <- sort(seq(max.value, min.value,
                       by = -7))
   ggplot <- ggplot + scale_x_continuous(breaks  = breaks,
                                         minor_breaks = x.values)
  }
 }
 if (!is.null(total.colors)){
  #, selected.palette = "Paired"
  #colors.palette <- colorRampPalette(brewer.pal(8, selected.palette))(total.colors)
  colors.palette <- c(brewer.pal(n = 9, name = "Set1")[1:8], # Gray removed
                      brewer.pal(n = 8, name = "Set2")[1:7], # Gray removed
                      brewer.pal(n = 12, name = "Set3"))
  if ( total.colors > length(colors.palette)){
   colors.palette <- colorRampPalette(colors.palette)(total.colors)
  }
  else{
   colors.palette <- colors.palette[seq_len(total.colors)]
  }
  colors.palette <- c(manual.colors, colors.palette)
  ggplot <- ggplot +
   #scale_fill_brewer(palette = selected.palette)
   scale_fill_manual(values = colors.palette) +
   scale_color_manual(values = colors.palette)
 }
 ggplot <- ggplot +
      theme_bw(base_size = base.size,
               #base_family = "Courier"
               base_family = "mono",
      ) +
      scale_y_continuous(labels = comma) +
      theme(legend.title = element_blank(),
            plot.caption = element_text(size = 5),
            axis.text.x = element_text(angle = 90)) +
      labs(caption = getCitationNote(report.date = report.date, data.provider.abv = data.provider.abv))
 ggplot
}



#'
#' @export
getCitationNote <- function(add.date = TRUE, report.date, data.provider.abv){
 ret <- "credit @ken4rab"
 if (add.date){
  ret <- paste(ret, report.date)
 }
 ret <- paste(ret, "\nsource: https://github.com/rOpenStats/COVID19AR/ based on", data.provider.abv)
 ret
}


