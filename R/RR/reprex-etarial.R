library(reprex)


reprex({
 library(COVID19AR)
 library(ggplot2)
 library(dplyr)
 library()
 covid19.curator <- COVID19ARCurator$new(url = "http://170.150.153.128/covid/covid_19_casos.csv")
 self <- covid19.curator
 dummy <- covid19.curator$loadData()

 # Dates of current processed file
 max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
 # Ultima muerte
 max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)

 report.date <- max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
 covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("provincia_residencia"))

 covid19.ar.provincia.summary %>% arrange(desc(confirmados))
 covid19.ar.provincia.summary.selected <- covid19.ar.provincia.summary %>% filter(confirmados >= 100)

 covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("provincia_residencia", "edad.rango"))
 names(covid19.ar.summary)
 nrow(covid19.ar.summary)
 porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
 porc.cols <- porc.cols[grep("letalidad.min|cuidado.intensivo|positividad", porc.cols)]
 colors.palette <- c(brewer.pal(n = 9, name = "Set1"), brewer.pal(n = 8, name = "Set2"), brewer.pal(n = 12, name = "Set3"))

 covid19.ar.summary %>% filter(provincia_residencia %in% covid19.ar.provincia.summary.selected$provincia_residencia) %>%
  ggplot(aes(x = edad.rango, y = cuidado.intensivo.porc, fill = edad.rango)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  scale_fill_manual(values = colors.palette) +
  theme(legend.title = element_blank(),
        #TODO caption size is not working. Fix it
        plot.caption = element_text(size = 5),
        axis.text.x = element_text(angle = 90)) +
  facet_wrap(~provincia_residencia, ncol = 2, scales = "free_y") +
  labs(caption = getCitationNote(report.date = report.date, data.provider = "@msalnacion"))

 covid19.ar.summary %>% filter(provincia_residencia %in% covid19.ar.provincia.summary.selected$provincia_residencia) %>%
  ggplot(aes(x = edad.rango, y = letalidad.min.porc, fill = edad.rango)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  scale_fill_manual(values = colors.palette) +
  theme(legend.title = element_blank(),
        #TODO caption size is not working. Fix it
        plot.caption = element_text(size = 5),
        axis.text.x = element_text(angle = 90)) +
  facet_wrap(~provincia_residencia, ncol = 2, scales = "free_y") +
  labs(caption = getCitationNote(report.date = report.date, data.provider = "@msalnacion"))


 kable(covid19.ar.summary %>% arrange(desc(edad.rango)) %>%
        select_at(c("provincia_residencia", "edad.rango", "confirmados", "internados", "fallecidos",  porc.cols)))
})
