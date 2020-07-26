
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/COVID19AR.png" height="139" align="right" />

COVID19AR
=========

A package for analysing COVID-19 Argentina’s outbreak

<!-- . -->

Package
=======

| Release                                                                                                | Usage                                                                                                    | Development                                                                                                                                                                                            |
|:-------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                                                                                                        | [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)](https://cran.r-project.org/) | [![Travis](https://travis-ci.org/rOpenStats/COVID19AR.svg?branch=master)](https://travis-ci.org/rOpenStats/COVID19AR)                                                                                  |
| [![CRAN](http://www.r-pkg.org/badges/version/COVID19AR)](https://cran.r-project.org/package=COVID19AR) |                                                                                                          | [![codecov](https://codecov.io/gh/rOpenStats/COVID19AR/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenStats/COVID19AR)                                                                     |
|                                                                                                        |                                                                                                          | [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) |

Argentina COVID19 open data
===========================

-   [Casos daily
    file](https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.csv)
-   [Determinaciones daily
    file](https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Determinaciones.csv)

How to get started (Development version)
========================================

Install the R package using the following commands on the R console:

    # install.packages("devtools")
    devtools::install_github("rOpenStats/COVID19AR")

How to use it
=============

First add variable with your preferred configurations in `~/.Renviron`.
COVID19AR\_data\_dir is mandatory while COVID19AR\_credits can be
configured if you want to publish your own research.

    COVID19AR_data_dir = "~/.R/COVID19AR"
    COVID19AR_credits = "@youralias"

    library(COVID19AR)
    #> Loading required package: dplyr
    #> 
    #> Attaching package: 'dplyr'
    #> The following objects are masked from 'package:stats':
    #> 
    #>     filter, lag
    #> The following objects are masked from 'package:base':
    #> 
    #>     intersect, setdiff, setequal, union
    #> Loading required package: knitr
    #> Loading required package: magrittr
    #> Loading required package: lgr
    #> Warning: replacing previous import 'ggplot2::Layout' by 'lgr::Layout' when
    #> loading 'COVID19AR'
    #> Warning: replacing previous import 'readr::col_factor' by 'scales::col_factor'
    #> when loading 'COVID19AR'
    #> Warning: replacing previous import 'magrittr::equals' by 'testthat::equals' when
    #> loading 'COVID19AR'
    #> Warning: replacing previous import 'magrittr::not' by 'testthat::not' when
    #> loading 'COVID19AR'
    #> Warning: replacing previous import 'magrittr::is_less_than' by
    #> 'testthat::is_less_than' when loading 'COVID19AR'
    #> Warning: replacing previous import 'dplyr::matches' by 'testthat::matches' when
    #> loading 'COVID19AR'
    library(ggplot2)
    #> 
    #> Attaching package: 'ggplot2'
    #> The following object is masked from 'package:lgr':
    #> 
    #>     Layout

COVID19AR datos abiertos del Ministerio de Salud de la Nación
=============================================================

opendata From Ministerio de Salud de la Nación Argentina

    log.dir <- file.path(getEnv("data_dir"), "logs")
    dir.create(log.dir, recursive = TRUE, showWarnings = FALSE)
    log.file <- file.path(log.dir, "covid19ar.log")
    lgr::get_logger("root")$add_appender(AppenderFile$new(log.file))
    lgr::threshold("info", lgr::get_logger("root"))
    lgr::threshold("info", lgr::get_logger("COVID19ARCurator"))

    # Data from
    # http://datos.salud.gob.ar/dataset/covid-19-casos-registrados-en-la-republica-argentina
    covid19.curator <- COVID19ARCurator$new(download.new.data = FALSE)

    dummy <- covid19.curator$loadData()
    #> INFO  [08:41:21.542] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:41:26.863] Normalize 
    #> INFO  [08:41:27.583] checkSoundness 
    #> INFO  [08:41:27.926] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-07-25"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-07-25"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-07-25"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-07-25              |      158321 |       2893 |              0.013 |              0.018 |                       152 | 531769 |            0.298 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |       91513 |       1502 |              0.012 |              0.016 |                       150 | 265262 |            0.345 |
| CABA                          |       52364 |       1028 |              0.016 |              0.020 |                       148 | 132672 |            0.395 |
| Chaco                         |        3260 |        134 |              0.031 |              0.041 |                       136 |  19996 |            0.163 |
| Córdoba                       |        1692 |         42 |              0.013 |              0.025 |                       138 |  27952 |            0.061 |
| Río Negro                     |        1554 |         63 |              0.036 |              0.041 |                       131 |   6450 |            0.241 |
| Jujuy                         |        1393 |         31 |              0.007 |              0.022 |                       127 |   7170 |            0.194 |
| SIN ESPECIFICAR               |        1181 |          4 |              0.002 |              0.003 |                       126 |   2797 |            0.422 |
| Neuquén                       |        1026 |         23 |              0.019 |              0.022 |                       133 |   4093 |            0.251 |
| Santa Fe                      |         898 |          9 |              0.007 |              0.010 |                       134 |  18793 |            0.048 |
| Mendoza                       |         787 |         21 |              0.019 |              0.027 |                       137 |   5849 |            0.135 |
| Entre Ríos                    |         740 |          6 |              0.006 |              0.008 |                       131 |   4329 |            0.171 |
| Tierra del Fuego              |         324 |          2 |              0.004 |              0.006 |                       130 |   2281 |            0.142 |
| Santa Cruz                    |         310 |          1 |              0.003 |              0.003 |                       123 |   1129 |            0.275 |
| Chubut                        |         261 |          2 |              0.004 |              0.008 |                       116 |   2679 |            0.097 |
| Salta                         |         233 |          2 |              0.005 |              0.009 |                       126 |   1727 |            0.135 |
| La Rioja                      |         231 |         15 |              0.051 |              0.065 |                       122 |   3343 |            0.069 |
| Corrientes                    |         136 |          1 |              0.003 |              0.007 |                       128 |   3888 |            0.035 |
| Tucumán                       |         111 |          4 |              0.006 |              0.036 |                       129 |   9984 |            0.011 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |       91513 | 265262 |       1502 |               13.2 |              0.012 |              0.016 |            0.345 |           0.126 |                  0.015 |           0.006 |
| CABA                          |       52364 | 132672 |       1028 |               14.5 |              0.016 |              0.020 |            0.395 |           0.212 |                  0.019 |           0.008 |
| Chaco                         |        3260 |  19996 |        134 |               14.7 |              0.031 |              0.041 |            0.163 |           0.106 |                  0.057 |           0.024 |
| Córdoba                       |        1692 |  27952 |         42 |               23.2 |              0.013 |              0.025 |            0.061 |           0.080 |                  0.021 |           0.009 |
| Río Negro                     |        1554 |   6450 |         63 |               14.0 |              0.036 |              0.041 |            0.241 |           0.383 |                  0.026 |           0.017 |
| Jujuy                         |        1393 |   7170 |         31 |               12.6 |              0.007 |              0.022 |            0.194 |           0.011 |                  0.003 |           0.003 |
| SIN ESPECIFICAR               |        1181 |   2797 |          4 |               20.0 |              0.002 |              0.003 |            0.422 |           0.108 |                  0.008 |           0.004 |
| Neuquén                       |        1026 |   4093 |         23 |               18.6 |              0.019 |              0.022 |            0.251 |           0.706 |                  0.012 |           0.006 |
| Santa Fe                      |         898 |  18793 |          9 |               17.9 |              0.007 |              0.010 |            0.048 |           0.122 |                  0.030 |           0.011 |
| Mendoza                       |         787 |   5849 |         21 |               10.0 |              0.019 |              0.027 |            0.135 |           0.501 |                  0.027 |           0.009 |
| Entre Ríos                    |         740 |   4329 |          6 |                8.3 |              0.006 |              0.008 |            0.171 |           0.208 |                  0.008 |           0.003 |
| Tierra del Fuego              |         324 |   2281 |          2 |               19.0 |              0.004 |              0.006 |            0.142 |           0.031 |                  0.009 |           0.009 |
| Santa Cruz                    |         310 |   1129 |          1 |                7.0 |              0.003 |              0.003 |            0.275 |           0.100 |                  0.016 |           0.010 |
| Chubut                        |         261 |   2679 |          2 |               10.5 |              0.004 |              0.008 |            0.097 |           0.050 |                  0.015 |           0.011 |
| Salta                         |         233 |   1727 |          2 |                2.5 |              0.005 |              0.009 |            0.135 |           0.343 |                  0.017 |           0.004 |
| La Rioja                      |         231 |   3343 |         15 |               13.2 |              0.051 |              0.065 |            0.069 |           0.104 |                  0.026 |           0.009 |
| Corrientes                    |         136 |   3888 |          1 |               12.0 |              0.003 |              0.007 |            0.035 |           0.022 |                  0.015 |           0.007 |
| Tucumán                       |         111 |   9984 |          4 |               14.2 |              0.006 |              0.036 |            0.011 |           0.288 |                  0.081 |           0.018 |
| Formosa                       |          79 |    812 |          0 |                NaN |              0.000 |              0.000 |            0.097 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          59 |   1842 |          0 |                NaN |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           |          52 |   4471 |          1 |               15.0 |              0.004 |              0.019 |            0.012 |           0.077 |                  0.038 |           0.019 |
| Misiones                      |          47 |   1933 |          2 |                6.5 |              0.011 |              0.043 |            0.024 |           0.617 |                  0.128 |           0.064 |
| La Pampa                      |          33 |    629 |          0 |                NaN |              0.000 |              0.000 |            0.052 |           0.030 |                  0.000 |           0.000 |
| San Luis                      |          19 |    728 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.474 |                  0.053 |           0.000 |
| San Juan                      |          18 |    960 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.278 |                  0.056 |           0.000 |


    rg <- ReportGeneratorCOVID19AR$new(covid19ar.curator = covid19.curator)
    rg$preprocess()
    #> Parsed with column specification:
    #> cols(
    #>   .default = col_double(),
    #>   residencia_provincia_nombre = col_character(),
    #>   residencia_departamento_nombre = col_character(),
    #>   fecha_apertura = col_date(format = ""),
    #>   max_fecha_diagnostico = col_date(format = ""),
    #>   max_fecha_inicio_sintomas = col_date(format = ""),
    #>   confirmados.inc = col_logical(),
    #>   confirmados.rate = col_logical(),
    #>   fallecidos.inc = col_logical(),
    #>   tests.inc = col_logical(),
    #>   tests.rate = col_logical(),
    #>   sospechosos.inc = col_logical()
    #> )
    #> See spec(...) for full column specifications.
    rg$getDepartamentosExponentialGrowthPlot()
    #> Scale for 'y' is already present. Adding another scale for 'y', which will
    #> replace the existing scale.

<img src="man/figures/README-exponential_growth-1.png" width="100%" />

    rg$getDepartamentosCrossSectionConfirmedPostivityPlot()

<img src="man/figures/README-exponential_growth-2.png" width="100%" />

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
    #> INFO  [08:43:02.370] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 21
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-07-15              |                        36 |          95 |    666 |         66 |          9 |              0.066 |              0.095 |            0.143 |           0.695 |                  0.126 |           0.063 |
|             12 | 2020-07-15              |                        56 |         409 |   2048 |        254 |         17 |              0.033 |              0.042 |            0.200 |           0.621 |                  0.093 |           0.054 |
|             13 | 2020-07-23              |                        87 |        1078 |   5515 |        598 |         63 |              0.049 |              0.058 |            0.195 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-07-23              |                       115 |        1758 |  11533 |        964 |        113 |              0.052 |              0.064 |            0.152 |           0.548 |                  0.094 |           0.056 |
|             15 | 2020-07-24              |                       138 |        2415 |  20248 |       1305 |        174 |              0.058 |              0.072 |            0.119 |           0.540 |                  0.090 |           0.051 |
|             16 | 2020-07-24              |                       146 |        3196 |  31848 |       1648 |        229 |              0.056 |              0.072 |            0.100 |           0.516 |                  0.080 |           0.044 |
|             17 | 2020-07-25              |                       150 |        4289 |  45898 |       2161 |        330 |              0.061 |              0.077 |            0.093 |           0.504 |                  0.073 |           0.038 |
|             18 | 2020-07-25              |                       150 |        5274 |  59087 |       2552 |        393 |              0.059 |              0.075 |            0.089 |           0.484 |                  0.066 |           0.035 |
|             19 | 2020-07-25              |                       150 |        6692 |  73213 |       3127 |        470 |              0.056 |              0.070 |            0.091 |           0.467 |                  0.061 |           0.032 |
|             20 | 2020-07-25              |                       150 |        9051 |  90575 |       3958 |        554 |              0.050 |              0.061 |            0.100 |           0.437 |                  0.055 |           0.029 |
|             21 | 2020-07-25              |                       150 |       13353 | 113996 |       5250 |        692 |              0.042 |              0.052 |            0.117 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-07-25              |                       150 |       18533 | 139341 |       6666 |        857 |              0.038 |              0.046 |            0.133 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-25              |                       150 |       24889 | 167588 |       8174 |       1057 |              0.035 |              0.042 |            0.149 |           0.328 |                  0.041 |           0.019 |
|             24 | 2020-07-25              |                       150 |       34378 | 202622 |      10257 |       1276 |              0.031 |              0.037 |            0.170 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-07-25              |                       150 |       47077 | 243914 |      12531 |       1548 |              0.028 |              0.033 |            0.193 |           0.266 |                  0.031 |           0.014 |
|             26 | 2020-07-25              |                       150 |       64598 | 295580 |      15476 |       1883 |              0.025 |              0.029 |            0.219 |           0.240 |                  0.027 |           0.012 |
|             27 | 2020-07-25              |                       150 |       82983 | 345751 |      18067 |       2213 |              0.022 |              0.027 |            0.240 |           0.218 |                  0.025 |           0.011 |
|             28 | 2020-07-25              |                       151 |      105709 | 403664 |      21004 |       2567 |              0.020 |              0.024 |            0.262 |           0.199 |                  0.022 |           0.010 |
|             29 | 2020-07-25              |                       152 |      132850 | 471990 |      23757 |       2803 |              0.017 |              0.021 |            0.281 |           0.179 |                  0.019 |           0.008 |
|             30 | 2020-07-25              |                       152 |      158321 | 531769 |      25463 |       2893 |              0.013 |              0.018 |            0.298 |           0.161 |                  0.017 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:43:35.000] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:43:50.956] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:44:01.168] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:44:02.495] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:44:05.768] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:44:07.785] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:44:11.939] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:44:14.277] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:44:16.852] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:44:18.514] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:44:21.028] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:44:22.953] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:44:25.094] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:44:27.464] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:44:29.329] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:44:31.619] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:44:34.138] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:44:36.188] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:44:38.046] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:44:39.941] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:44:41.854] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:44:45.014] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:44:46.959] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:44:48.876] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:44:50.946] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 461
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    sepi.fechas <- covid19.curator$data %>% 
      group_by(sepi_apertura) %>% 
      summarize(ultima_fecha_sepi = max(fecha_apertura), .groups = "keep")


    data2plot <- covid19.ar.summary %>%
                    filter(residencia_provincia_nombre %in% covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre) %>%
                    filter(confirmados > 0 ) %>%
                    filter(positividad.porc <=0.6 | confirmados >= 20)

                    
    data2plot %<>% inner_join(sepi.fechas, by = "sepi_apertura")
    dates <- sort(unique(data2plot$ultima_fecha_sepi))

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
    #> Scale for 'y' is already present. Adding another scale for 'y', which will
    #> replace the existing scale.
    covplot

<img src="man/figures/README-residencia_provincia_nombre-sepi_apertura-1.png" width="100%" />


    covplot <- data2plot %>%
     ggplot(aes(x = ultima_fecha_sepi, y = positividad.porc, color = "positividad.porc")) +
     geom_line() +
     facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
     labs(title = "Porcentajes de positividad, uso de UCI, respirador y letalidad\n en provincias > 100 confirmados")
    covplot <- covplot +
     geom_line(aes(x = ultima_fecha_sepi, y = cuidado.intensivo.porc, color = "cuidado.intensivo.porc")) +
     facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
    covplot <- covplot  +
     geom_line(aes(x = ultima_fecha_sepi, y = respirador.porc, color = "respirador.porc"))+
     facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")
    covplot <- covplot +
     geom_line(aes(x = ultima_fecha_sepi, y = letalidad.min.porc, color = "letalidad.min.porc")) +
     facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y")

    covplot <- setupTheme(covplot, report.date = report.date, x.values = dates, x.type = "dates",
                         total.colors = 4,
                         data.provider.abv = "@msalnacion", base.size = 6)
    covplot

<img src="man/figures/README-residencia_provincia_nombre-sepi_apertura-plot-positividad-1.png" width="100%" />


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sexo"))
    nrow(covid19.ar.summary)
    #> [1] 61
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |       46669 |       6257 |        857 |              0.013 |              0.018 |            0.363 |           0.134 |                  0.017 |           0.007 |
| Buenos Aires                  | F    |       44501 |       5236 |        639 |              0.010 |              0.014 |            0.328 |           0.118 |                  0.012 |           0.004 |
| CABA                          | F    |       26332 |       5450 |        451 |              0.014 |              0.017 |            0.377 |           0.207 |                  0.014 |           0.006 |
| CABA                          | M    |       25819 |       5573 |        564 |              0.018 |              0.022 |            0.415 |           0.216 |                  0.024 |           0.011 |
| Chaco                         | F    |        1643 |        168 |         50 |              0.023 |              0.030 |            0.164 |           0.102 |                  0.047 |           0.017 |
| Chaco                         | M    |        1615 |        178 |         84 |              0.039 |              0.052 |            0.162 |           0.110 |                  0.067 |           0.032 |
| Jujuy                         | M    |         934 |         12 |         18 |              0.007 |              0.019 |            0.228 |           0.013 |                  0.003 |           0.003 |
| Córdoba                       | M    |         849 |         59 |         21 |              0.013 |              0.025 |            0.062 |           0.069 |                  0.022 |           0.012 |
| Córdoba                       | F    |         841 |         76 |         21 |              0.013 |              0.025 |            0.059 |           0.090 |                  0.020 |           0.007 |
| Río Negro                     | F    |         778 |        300 |         22 |              0.025 |              0.028 |            0.226 |           0.386 |                  0.015 |           0.008 |
| Río Negro                     | M    |         776 |        295 |         41 |              0.046 |              0.053 |            0.259 |           0.380 |                  0.037 |           0.027 |
| SIN ESPECIFICAR               | F    |         692 |         63 |          0 |              0.000 |              0.000 |            0.405 |           0.091 |                  0.004 |           0.000 |
| Neuquén                       | F    |         516 |        380 |         13 |              0.021 |              0.025 |            0.254 |           0.736 |                  0.012 |           0.006 |
| Neuquén                       | M    |         510 |        344 |         10 |              0.017 |              0.020 |            0.248 |           0.675 |                  0.012 |           0.006 |
| SIN ESPECIFICAR               | M    |         485 |         64 |          3 |              0.005 |              0.006 |            0.451 |           0.132 |                  0.010 |           0.008 |
| Jujuy                         | F    |         457 |          3 |         13 |              0.006 |              0.028 |            0.150 |           0.007 |                  0.002 |           0.002 |
| Santa Fe                      | F    |         455 |         44 |          2 |              0.003 |              0.004 |            0.047 |           0.097 |                  0.022 |           0.007 |
| Santa Fe                      | M    |         443 |         66 |          7 |              0.011 |              0.016 |            0.049 |           0.149 |                  0.038 |           0.016 |
| Mendoza                       | M    |         396 |        197 |         15 |              0.027 |              0.038 |            0.138 |           0.497 |                  0.040 |           0.015 |
| Mendoza                       | F    |         385 |        193 |          4 |              0.008 |              0.010 |            0.131 |           0.501 |                  0.013 |           0.003 |
| Entre Ríos                    | M    |         377 |         87 |          3 |              0.006 |              0.008 |            0.180 |           0.231 |                  0.008 |           0.003 |
| Entre Ríos                    | F    |         362 |         67 |          3 |              0.006 |              0.008 |            0.163 |           0.185 |                  0.008 |           0.003 |
| Buenos Aires                  | NR   |         343 |         36 |          6 |              0.010 |              0.017 |            0.368 |           0.105 |                  0.029 |           0.015 |
| Tierra del Fuego              | M    |         215 |          7 |          2 |              0.007 |              0.009 |            0.172 |           0.033 |                  0.014 |           0.014 |
| CABA                          | NR   |         213 |         67 |         13 |              0.036 |              0.061 |            0.366 |           0.315 |                  0.052 |           0.038 |
| Santa Cruz                    | M    |         173 |         17 |          1 |              0.005 |              0.006 |            0.276 |           0.098 |                  0.023 |           0.012 |
| Chubut                        | M    |         139 |          9 |          1 |              0.004 |              0.007 |            0.101 |           0.065 |                  0.014 |           0.014 |
| Salta                         | M    |         137 |         47 |          2 |              0.009 |              0.015 |            0.123 |           0.343 |                  0.022 |           0.007 |
| Santa Cruz                    | F    |         137 |         14 |          0 |              0.000 |              0.000 |            0.273 |           0.102 |                  0.007 |           0.007 |
| La Rioja                      | F    |         124 |         14 |          7 |              0.046 |              0.056 |            0.077 |           0.113 |                  0.040 |           0.016 |
| Chubut                        | F    |         118 |          4 |          1 |              0.005 |              0.008 |            0.093 |           0.034 |                  0.017 |           0.008 |
| Tierra del Fuego              | F    |         108 |          3 |          0 |              0.000 |              0.000 |            0.105 |           0.028 |                  0.000 |           0.000 |
| La Rioja                      | M    |         106 |         10 |          8 |              0.058 |              0.075 |            0.062 |           0.094 |                  0.009 |           0.000 |
| Salta                         | F    |          96 |         33 |          0 |              0.000 |              0.000 |            0.159 |           0.344 |                  0.010 |           0.000 |
| Corrientes                    | M    |          85 |          3 |          1 |              0.005 |              0.012 |            0.039 |           0.035 |                  0.012 |           0.012 |
| Formosa                       | M    |          67 |          1 |          0 |              0.000 |              0.000 |            0.138 |           0.015 |                  0.000 |           0.000 |
| Tucumán                       | M    |          67 |         17 |          2 |              0.005 |              0.030 |            0.011 |           0.254 |                  0.045 |           0.000 |
| Corrientes                    | F    |          51 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.020 |           0.000 |
| Tucumán                       | F    |          44 |         15 |          2 |              0.008 |              0.045 |            0.012 |           0.341 |                  0.136 |           0.045 |
| Catamarca                     | M    |          37 |          0 |          0 |              0.000 |              0.000 |            0.033 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          37 |          2 |          0 |              0.000 |              0.000 |            0.012 |           0.054 |                  0.027 |           0.000 |
| Misiones                      | M    |          27 |         16 |          1 |              0.011 |              0.037 |            0.026 |           0.593 |                  0.148 |           0.074 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.011 |              0.050 |            0.022 |           0.650 |                  0.100 |           0.050 |
| La Pampa                      | F    |          19 |          0 |          0 |              0.000 |              0.000 |            0.061 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | M    |          15 |          7 |          0 |              0.000 |              0.000 |            0.036 |           0.467 |                  0.067 |           0.000 |
| Santiago del Estero           | F    |          15 |          2 |          1 |              0.011 |              0.067 |            0.012 |           0.133 |                  0.067 |           0.067 |
| La Pampa                      | M    |          14 |          1 |          0 |              0.000 |              0.000 |            0.044 |           0.071 |                  0.000 |           0.000 |
| San Juan                      | M    |          14 |          2 |          0 |              0.000 |              0.000 |            0.025 |           0.143 |                  0.000 |           0.000 |
| Formosa                       | F    |          12 |          0 |          0 |              0.000 |              0.000 |            0.037 |           0.000 |                  0.000 |           0.000 |


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))
    #> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_, : no
    #> non-missing arguments to max; returning -Inf

     # Share per province
      provinces.cases <-covid19.ar.summary %>%
        group_by(residencia_provincia_nombre) %>%
        summarise(fallecidos.total.provincia = sum(fallecidos),
                  confirmados.total.provincia = sum(confirmados),
                  .groups = "keep")
     covid19.ar.summary %<>% inner_join(provinces.cases, by = "residencia_provincia_nombre")
     covid19.ar.summary %<>% mutate(fallecidos.prop = fallecidos/fallecidos.total.provincia)
     covid19.ar.summary %<>% mutate(confirmados.prop = confirmados/confirmados.total.provincia)

     # Data 2 plot
     data2plot <- covid19.ar.summary %>% filter(residencia_provincia_nombre %in%
     # Proporción de confirmados por rango etario
     covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre)

     
     covidplot <-
       data2plot %>%
       ggplot(aes(x = edad.rango, y = confirmados.prop, fill = edad.rango)) +
       geom_bar(stat = "identity") + facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
       labs(title = "Proporción de confirmados por rango etario\n en provincias > 100 confirmados")

     covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                             total.colors = length(unique(data2plot$edad.rango)),
                             data.provider.abv = "@msalnacion", base.size = 6)
     # Proporción de muertos por rango etario
     covidplot

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-1.png" width="100%" />



     #Plot of deaths share
     covidplot <-
        data2plot %>%
        ggplot(aes(x = edad.rango, y = fallecidos.prop, fill = edad.rango)) +
        geom_bar(stat = "identity") + facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
        labs(title = "Proporción de muertos por rango etario\n en provincias > 100 confirmados")
     covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                          total.colors = length(unique(data2plot$edad.rango)),
                          data.provider.abv = "@msalnacion", base.size = 6)
     # Proporción de muertos por rango etario
     covidplot

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-2.png" width="100%" />



     # UCI rate
     covidplot <- data2plot %>%
       ggplot(aes(x = edad.rango, y = cuidado.intensivo.porc, fill = edad.rango)) +
       geom_bar(stat = "identity") + facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
        labs(title = "Porcentaje de pacientes en Unidades de Cuidados Intensivos por rango etario\n en provincias > 100 confirmados")
     covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                          total.colors = length(unique(data2plot$edad.rango)),
                          data.provider.abv = "@msalnacion", base.size = 6)
     covidplot

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-3.png" width="100%" />


     # ventilator rate
     covidplot <- data2plot %>%
       ggplot(aes(x = edad.rango, y = respirador.porc, fill = edad.rango)) +
       geom_bar(stat = "identity") +
       facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
       labs(title = "Porcentaje de pacientes que utilizaron respirador mecánico por rango etario\n en provincias > 100 confirmados")
     covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                          total.colors = length(unique(data2plot$edad.rango)),
                          data.provider.abv = "@msalnacion", base.size = 6)
     covidplot

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-4.png" width="100%" />


     # fatality rate

     covidplot <- data2plot %>%
      ggplot(aes(x = edad.rango, y = letalidad.min.porc, fill = edad.rango)) +
      geom_bar(stat = "identity") +
      facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
      labs(title = "Porcentaje de letalidad por rango etario\n en provincias > 100 confirmados")
     covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                          total.colors = length(unique(data2plot$edad.rango)),
                          data.provider.abv = "@msalnacion", base.size = 6)
     covidplot

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-5.png" width="100%" />

Generar diferentes agregaciones y guardar csv / Generate different aggregations
===============================================================================

    output.dir <- "~/.R/COVID19AR/"
    dir.create(output.dir, showWarnings = FALSE, recursive = TRUE)
    exportAggregatedTables(covid19.curator, output.dir = output.dir,
                           aggrupation.criteria = list(provincia_residencia = c("residencia_provincia_nombre"),
                                                       provincia_localidad_residencia = c("residencia_provincia_nombre", "residencia_departamento_nombre"),
                                                       provincia_residencia_sexo = c("residencia_provincia_nombre", "sexo"),
                                                       edad_rango_sexo = c("edad.rango", "sexo"),
                                                       provincia_residencia_edad_rango = c("residencia_provincia_nombre", "edad.rango"),
                                                       provincia_residencia_sepi_apertura = c("residencia_provincia_nombre", "sepi_apertura"),
                                                       provincia_residencia = c("residencia_provincia_nombre", "residencia_departamento_nombre", "sepi_apertura"),
                                                       provincia_residencia_fecha_apertura = c("residencia_provincia_nombre", "fecha_apertura")))
                                                       
                                                      

All this tables are accesible at
[COVID19ARdata](https://github.com/rOpenStats/COVID19ARdata/tree/master/curated)

How to Cite This Work
=====================

Citation

    Alejandro Baranek, COVID19AR, 2020. URL: https://github.com/rOpenStats/COVID19AR

    BibTex
    @techreport{baranek2020Covid19AR,
    Author = {Alejandro Baranek},
    Institution = {rOpenStats},
    Title = {COVID19AR: a package for analysing Argentina COVID-19 outbreak},
    Url = {https://github.com/rOpenStats/COVID19AR},
    Year = {2020}}
