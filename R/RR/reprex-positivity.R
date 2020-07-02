library(reprex)


reprex({
 library(COVID19AR)
 library(ggplot2)
 #library(dplyr)
 #library(RColorBrewer)
 knitr::opts_chunk$set(fig.width = 4, fig.height = 6, dpi = 300, warning = FALSE)
 report.dir <- file.path(getEnv("data_dir"), "reports")
 dir.create(report.dir, showWarnings = FALSE, recursive = TRUE)
 covid19.curator <- COVID19ARCurator$new(download.new.data = FALSE)
 dummy <- covid19.curator$loadData()
 dummy <- covid19.curator$curateData()

 covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
 covid19.ar.provincia.summary.selected <- covid19.ar.provincia.summary %>% filter(confirmados >= 100)

 covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))

 data2plot <- covid19.ar.summary %>%
  filter(residencia_provincia_nombre %in% covid19.ar.provincia.summary.selected$residencia_provincia_nombre) %>%
  filter(confirmados > 0 ) %>%
  filter(positividad.porc <= 0.6 | confirmados >= 20)

 sepi.fechas <- covid19.curator$data %>%
                  group_by(sepi_apertura) %>%
                  summarize(ultima_fecha_sepi = max(fecha_apertura), .groups = "keep")
 data2plot %<>% inner_join(sepi.fechas, by = "sepi_apertura")
 dates <- sort(unique(data2plot$ultima_fecha_sepi))
 total.dates <- length(dates)

 report.date <- max(dates)


 covplot <- data2plot %>%
   ggplot(aes(x = ultima_fecha_sepi, y = confirmados, color = "confirmados")) +
   geom_line() +
   facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
   labs(title = "Evolución de casos confirmados y tests\n en provincias > 100 confirmados")
 covplot <- covplot +
   geom_line(aes(x = ultima_fecha_sepi, y = tests, color = "tests")) +
   facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
 covplot <- setupTheme(covplot, report.date = report.date, x.values = dates, x.type = "dates",
                       total.colors = 2,
                       data.provider.abv = "@msalnacion", base.size = 6)
 covplot <- covplot + scale_y_log10()
 covplot
 ggsave(file.path(report.dir, paste("provincias-confirmados-tests", ".png", sep = "")),
        covplot,
        width = 7, height = 5, dpi = 300)


 covplot <- data2plot %>%
  ggplot(aes(x = ultima_fecha_sepi, y = positividad.porc, color = "positividad.porc")) +
  geom_line() +
  facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
  labs(title = "Porcentajes de positividad, uso de UCI, respirador y letalidad\n en provincias > 100 confirmados")
 covplot <- covplot +
  geom_line(aes(x = ultima_fecha_sepi, y = cuidado.intensivo.porc, color = "cuidado.intensivo.porc")) +
  facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
 covplot <- covplot  +
  geom_line(aes(x = ultima_fecha_sepi, y = respirador.porc, color = "respirador.porc")) +
  facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
 covplot <- covplot +
  geom_line(aes(x = ultima_fecha_sepi, y = letalidad.min.porc, color = "letalidad.min.porc")) +
  facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")

 covplot <- setupTheme(covplot, report.date = report.date, x.values = dates, x.type = "dates",
                      total.colors = 4,
                      data.provider.abv = "@msalnacion", base.size = 6)
 covplot
 ggsave(file.path(report.dir, paste("provincias-positividad", ".png", sep = "")),
        covplot,
        width = 7, height = 5, dpi = 300)

})
