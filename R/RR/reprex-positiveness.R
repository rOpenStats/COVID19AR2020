library(reprex)


reprex({
 library(COVID19AR)
 #library(ggplot2)
 #library(dplyr)
 #library(RColorBrewer)

 covid19.curator <- COVID19ARCurator$new()
 self <- covid19.curator
 dummy <- covid19.curator$loadData()

 covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
 covid19.ar.provincia.summary.selected <- covid19.ar.provincia.summary %>% filter(confirmados >= 100)

 covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))

 data2plot <- covid19.ar.summary %>%
  filter(residencia_provincia_nombre %in% covid19.ar.provincia.summary.selected$residencia_provincia_nombre) %>%
  filter(confirmados > 0 )

 sepi.fechas <- covid19.curator$data %>%
                  group_by(sepi_apertura) %>%
                  summarize(ultima_fecha_sepi = max(fecha_apertura), .groups = "keep")
 data2plot %<>% inner_join(sepi.fechas, by = "sepi_apertura")
 dates <- sort(unique(data2plot$ultima_fecha_sepi))
 total.dates <- length(dates)

 report.date <- max(dates)
 ggplot <- data2plot %>%
  ggplot(aes(x = ultima_fecha_sepi, y = positividad.porc, color = "positividad.porc")) +
  geom_line() +
  facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
 ggplot <- ggplot +
  geom_line(aes(x = ultima_fecha_sepi, y = cuidado.intensivo.porc, color = "cuidado.intensivo.porc")) +
  facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
 ggplot <- ggplot  +
  geom_line(aes(x = ultima_fecha_sepi, y = respirador.porc, color = "respirador.porc"))+
  facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
 ggplot <- ggplot +
  geom_line(aes(x = ultima_fecha_sepi, y = letalidad.min.porc, color = "letalidad.min.porc")) +
  facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")

 ggplot <- setupTheme(ggplot, report.date = report.date, x.values = dates, x.type = "dates",
                      total.colors = 4,
                      data.provider.abv = "@msalnacion", base.size = 6)
 ggplot
})
