library(reprex)


reprex({
 library(COVID19AR)
 library(ggplot2)
 covid19.curator <- COVID19ARCurator$new(url = "http://170.150.153.128/covid/Covid19Casos.csv")
 dummy <- covid19.curator$loadData()
 dummy <- covid19.curator$curateData()

 # Dates of current processed file
 max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
 # Ultima muerte
 max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)

 report.date <- max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
 covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))

 covid19.ar.provincia.summary.selected <- covid19.ar.provincia.summary %>% filter(confirmados >= 100)

 covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))
 names(covid19.ar.summary)
 nrow(covid19.ar.summary)
 porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
 porc.cols <- porc.cols[grep("letalidad.min|cuidado.intensivo|positividad", porc.cols)]

data2plot <- covid19.ar.summary %>% filter(residencia_provincia_nombre %in% covid19.ar.provincia.summary.selected$residencia_provincia_nombre)
 ggplot <- data2plot %>%
   ggplot(aes(x = edad.rango, y = cuidado.intensivo.porc, fill = edad.rango)) +
   geom_bar(stat = "identity") + facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
 ggplot <- setupTheme(ggplot, report.date = report.date, x.values = NULL, x.type = NULL,
                      total.colors = length(unique(data2plot$edad.rango)),
                      data.provider.abv = "@msalnacion", base.size = 6)
 ggplot

 ggplot <- data2plot %>%
   ggplot(aes(x = edad.rango, y = respirador.porc, fill = edad.rango)) +
   geom_bar(stat = "identity") +
   facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
 ggplot <- setupTheme(ggplot, report.date = report.date, x.values = NULL, x.type = NULL,
                      total.colors = length(unique(data2plot$edad.rango)),
                      data.provider.abv = "@msalnacion", base.size = 6)
 ggplot

 ggplot <- data2plot %>%
  ggplot(aes(x = edad.rango, y = letalidad.min.porc, fill = edad.rango)) +
  geom_bar(stat = "identity") +
  facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
 ggplot <- setupTheme(ggplot, report.date = report.date, x.values = NULL, x.type = NULL,
                      total.colors = length(unique(data2plot$edad.rango)),
                      data.provider.abv = "@msalnacion", base.size = 6)
 ggplot


 kable(covid19.ar.summary %>% arrange(desc(edad.rango)) %>%
        select_at(c("residencia_provincia_nombre", "edad.rango", "confirmados", "internados", "fallecidos",  porc.cols)))
})



