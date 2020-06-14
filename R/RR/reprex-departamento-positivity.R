library(reprex)


reprex({
 library(COVID19AR)
 library(ggplot2)
 #library(dplyr)
 #library(RColorBrewer)
 knitr::opts_chunk$set(fig.width = 4, fig.height = 6, dpi = 300, warning = FALSE)

 report.dir = file.path(getEnv("data_dir"), "reports")
 dir.create(report.dir, showWarnings = FALSE, recursive = TRUE)
 covid19.curator <- COVID19ARCurator$new(download.new.data = FALSE)

 self <- covid19.curator
 dummy <- covid19.curator$loadData()
 dummy <- covid19.curator$curateData()
 covid19.curator$max.date

 covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
 covid19.ar.provincia.summary.selected <- covid19.ar.provincia.summary %>% filter(confirmados >= 100)

 covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "residencia_departamento_nombre", "sepi_apertura"),
                                                   cache.filename = "covid19ar_residencia_provincia_nombre-residencia_departamento_nombre-sepi_apertura.csv"
                                                   )
 departamento_max_sepi_apertura <- covid19.ar.summary %>%
   group_by(residencia_provincia_nombre, residencia_departamento_nombre) %>%
   summarize(sepi_apertura = max(sepi_apertura), .groups = "keep")

 covid19.ar.summary.selected <- covid19.ar.summary %>% inner_join(departamento_max_sepi_apertura, by = c("residencia_provincia_nombre", "residencia_departamento_nombre", "sepi_apertura"))
 nrow(covid19.ar.summary)
 last_sepi_apertura <- max(covid19.ar.summary.selected$sepi_apertura)
 covid19.ar.summary.selected %<>% filter(sepi_apertura == last_sepi_apertura & confirmados >= 20) %>% arrange(desc(positividad.porc))

 departamentos2plot <- covid19.ar.summary.selected %>%
                #filter(positividad.porc >= 0.2) %>%
                select(residencia_provincia_nombre, residencia_departamento_nombre, sepi_apertura, confirmados, sospechosos, fallecidos, positividad.porc)
 departamentos2plot %<>% mutate(rank = rank(desc(positividad.porc)))
 departamentos2plot %<>% filter(rank <= 15)
 kable(departamentos2plot %>% select(residencia_provincia_nombre, residencia_departamento_nombre, confirmados, positividad.porc, rank))

 data2plot <- covid19.ar.summary %>%
              inner_join(departamentos2plot %>%
                           select(residencia_provincia_nombre, residencia_departamento_nombre, rank),
                         by = c("residencia_provincia_nombre", "residencia_departamento_nombre")) %>%
              filter(positividad.porc <=0.6 | confirmados >= 20) %>%
              arrange(rank, sepi_apertura)


 data2plot.caba  <- data2plot %>% filter(residencia_provincia_nombre %in% "CABA")
 data2plot.resto <- data2plot %>% filter(!residencia_provincia_nombre %in% "CABA")

 sepi.fechas <- covid19.curator$data %>%
                  group_by(sepi_apertura) %>%
                  summarize(ultima_fecha_sepi = max(fecha_apertura), .groups = "keep")
 data2plot.caba %<>% inner_join(sepi.fechas, by = "sepi_apertura")
 data2plot.resto %<>% inner_join(sepi.fechas, by = "sepi_apertura")

 report.date <- max(sepi.fechas$ultima_fecha_sepi)

 covplot <- data2plot.caba %>%
   ggplot(aes(x = ultima_fecha_sepi, y = confirmados, color = "confirmados")) +
   geom_line() +
   facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre),
              ncol = 2, scales = "free_y") +
   labs(title = "Evolución de casos confirmados y tests\n en departamentos > 20 confirmados y positividad >= .2")
 covplot <- covplot +
   geom_line(aes(x = ultima_fecha_sepi, y = tests, color = "tests")) +
   facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre),
              ncol = 2, scales = "free_y")
 covplot <- setupTheme(covplot, report.date = report.date, x.values = dates, x.type = "dates",
                       total.colors = 2,
                       data.provider.abv = "@msalnacion", base.size = 6)
 covplot <- covplot + scale_y_log10()
 covplot
 ggsave(file.path(report.dir, paste("caba-provincias-departamentos-confirmados-tests",".png", sep ="")),
        covplot,
        width = 7, height = 5, dpi = 300)

 covplot <- data2plot.caba %>%
  ggplot(aes(x = ultima_fecha_sepi, y = positividad.porc, color = "positividad.porc")) +
  geom_line() +
  facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre) , ncol = 2, scales = "free_y") +
  labs(title = "Porcentajes de positividad, uso de UCI, respirador y letalidad\n en provincias > 100 confirmados")
 covplot <- covplot +
  geom_line(aes(x = ultima_fecha_sepi, y = cuidado.intensivo.porc, color = "cuidado.intensivo.porc")) +
  facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre), ncol = 2, scales = "free_y")
 covplot <- covplot  +
  geom_line(aes(x = ultima_fecha_sepi, y = respirador.porc, color = "respirador.porc"))+
  facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre), ncol = 2, scales = "free_y")
 covplot <- covplot +
  geom_line(aes(x = ultima_fecha_sepi, y = letalidad.min.porc, color = "letalidad.min.porc")) +
  facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre), ncol = 2, scales = "free_y")

 covplot <- setupTheme(covplot, report.date = report.date, x.values = dates, x.type = "dates",
                      total.colors = 4,
                      data.provider.abv = "@msalnacion", base.size = 6)
 covplot
 ggsave(file.path(report.dir, paste("caba-provincias-departamentos-positividad",".png", sep ="")),
        covplot,
        width = 7, height = 5, dpi = 300)


 covplot <- data2plot.resto %>%
   ggplot(aes(x = ultima_fecha_sepi, y = confirmados, color = "confirmados")) +
   geom_line() +
   facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre),
              ncol = 2, scales = "free_y") +
   labs(title = "Evolución de casos confirmados y tests\n en provincias > 100 confirmados")
 covplot <- covplot +
   geom_line(aes(x = ultima_fecha_sepi, y = tests, color = "tests")) +
   facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre),
              ncol = 2, scales = "free_y")
 covplot <- setupTheme(covplot, report.date = report.date, x.values = dates, x.type = "dates",
                       total.colors = 2,
                       data.provider.abv = "@msalnacion", base.size = 6)
 covplot <- covplot + scale_y_log10()
 covplot
 ggsave(file.path(report.dir, paste("resto-provincias-departamentos-confirmados-tests",".png", sep ="")),
        covplot,
        width = 7, height = 5, dpi = 300)

 covplot <- data2plot.resto %>%
   ggplot(aes(x = ultima_fecha_sepi, y = positividad.porc, color = "positividad.porc")) +
   geom_line() +
   facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre) , ncol = 2, scales = "free_y") +
   labs(title = "Porcentajes de positividad, uso de UCI, respirador y letalidad\n en provincias > 20 confirmados y y positividad >= .2")
 covplot <- covplot +
   geom_line(aes(x = ultima_fecha_sepi, y = cuidado.intensivo.porc, color = "cuidado.intensivo.porc")) +
   facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre), ncol = 2, scales = "free_y")
 covplot <- covplot  +
   geom_line(aes(x = ultima_fecha_sepi, y = respirador.porc, color = "respirador.porc"))+
   facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre), ncol = 2, scales = "free_y")
 covplot <- covplot +
   geom_line(aes(x = ultima_fecha_sepi, y = letalidad.min.porc, color = "letalidad.min.porc")) +
   facet_wrap(vars(rank, residencia_provincia_nombre, residencia_departamento_nombre), ncol = 2, scales = "free_y")

 covplot <- setupTheme(covplot, report.date = report.date, x.values = dates, x.type = "dates",
                       total.colors = 4,
                       data.provider.abv = "@msalnacion", base.size = 6)
 covplot
 ggsave(file.path(report.dir, paste("resto-provincias-departamentos-positividad",".png", sep ="")),
        covplot,
        width = 7, height = 5, dpi = 300)
})
