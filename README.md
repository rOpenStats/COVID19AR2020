
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
    #> INFO  [09:41:34.178] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:41:41.250] Normalize 
    #> INFO  [09:41:42.252] checkSoundness 
    #> INFO  [09:41:42.634] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-07-27"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-07-27"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-07-27"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-07-27              |      166982 |       3044 |              0.013 |              0.018 |                       154 | 551105 |            0.303 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |       97378 |       1581 |              0.012 |              0.016 |                       152 | 276471 |            0.352 |
| CABA                          |       54355 |       1089 |              0.017 |              0.020 |                       150 | 136838 |            0.397 |
| Chaco                         |        3358 |        137 |              0.031 |              0.041 |                       137 |  20642 |            0.163 |
| Córdoba                       |        1868 |         43 |              0.013 |              0.023 |                       140 |  28737 |            0.065 |
| Río Negro                     |        1613 |         64 |              0.035 |              0.040 |                       133 |   6621 |            0.244 |
| Jujuy                         |        1523 |         31 |              0.006 |              0.020 |                       129 |   7598 |            0.200 |
| SIN ESPECIFICAR               |        1170 |          4 |              0.002 |              0.003 |                       128 |   2719 |            0.430 |
| Neuquén                       |        1074 |         23 |              0.018 |              0.021 |                       135 |   4253 |            0.253 |
| Santa Fe                      |         964 |         11 |              0.007 |              0.011 |                       136 |  19075 |            0.051 |
| Mendoza                       |         872 |         24 |              0.020 |              0.028 |                       139 |   6118 |            0.143 |
| Entre Ríos                    |         765 |          7 |              0.007 |              0.009 |                       133 |   4479 |            0.171 |
| Tierra del Fuego              |         362 |          2 |              0.004 |              0.006 |                       132 |   2405 |            0.151 |
| Santa Cruz                    |         345 |          1 |              0.003 |              0.003 |                       125 |   1165 |            0.296 |
| Chubut                        |         262 |          2 |              0.004 |              0.008 |                       118 |   2725 |            0.096 |
| La Rioja                      |         250 |         16 |              0.052 |              0.064 |                       125 |   3469 |            0.072 |
| Salta                         |         219 |          2 |              0.005 |              0.009 |                       128 |   1734 |            0.126 |
| Corrientes                    |         152 |          1 |              0.003 |              0.007 |                       130 |   3988 |            0.038 |
| Tucumán                       |         128 |          4 |              0.006 |              0.031 |                       131 |  10448 |            0.012 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |       97378 | 276471 |       1581 |               13.2 |              0.012 |              0.016 |            0.352 |           0.123 |                  0.014 |           0.006 |
| CABA                          |       54355 | 136838 |       1089 |               14.5 |              0.017 |              0.020 |            0.397 |           0.209 |                  0.019 |           0.009 |
| Chaco                         |        3358 |  20642 |        137 |               14.5 |              0.031 |              0.041 |            0.163 |           0.107 |                  0.060 |           0.026 |
| Córdoba                       |        1868 |  28737 |         43 |               23.4 |              0.013 |              0.023 |            0.065 |           0.074 |                  0.020 |           0.009 |
| Río Negro                     |        1613 |   6621 |         64 |               13.9 |              0.035 |              0.040 |            0.244 |           0.390 |                  0.027 |           0.019 |
| Jujuy                         |        1523 |   7598 |         31 |               12.6 |              0.006 |              0.020 |            0.200 |           0.009 |                  0.003 |           0.003 |
| SIN ESPECIFICAR               |        1170 |   2719 |          4 |               20.0 |              0.002 |              0.003 |            0.430 |           0.105 |                  0.008 |           0.004 |
| Neuquén                       |        1074 |   4253 |         23 |               18.6 |              0.018 |              0.021 |            0.253 |           0.675 |                  0.011 |           0.006 |
| Santa Fe                      |         964 |  19075 |         11 |               15.4 |              0.007 |              0.011 |            0.051 |           0.120 |                  0.028 |           0.010 |
| Mendoza                       |         872 |   6118 |         24 |               10.7 |              0.020 |              0.028 |            0.143 |           0.492 |                  0.025 |           0.008 |
| Entre Ríos                    |         765 |   4479 |          7 |                9.9 |              0.007 |              0.009 |            0.171 |           0.208 |                  0.008 |           0.003 |
| Tierra del Fuego              |         362 |   2405 |          2 |               19.0 |              0.004 |              0.006 |            0.151 |           0.028 |                  0.008 |           0.008 |
| Santa Cruz                    |         345 |   1165 |          1 |                7.0 |              0.003 |              0.003 |            0.296 |           0.087 |                  0.014 |           0.009 |
| Chubut                        |         262 |   2725 |          2 |               10.5 |              0.004 |              0.008 |            0.096 |           0.053 |                  0.015 |           0.011 |
| La Rioja                      |         250 |   3469 |         16 |               13.2 |              0.052 |              0.064 |            0.072 |           0.100 |                  0.024 |           0.008 |
| Salta                         |         219 |   1734 |          2 |                2.5 |              0.005 |              0.009 |            0.126 |           0.388 |                  0.018 |           0.005 |
| Corrientes                    |         152 |   3988 |          1 |               12.0 |              0.003 |              0.007 |            0.038 |           0.026 |                  0.013 |           0.007 |
| Tucumán                       |         128 |  10448 |          4 |               14.2 |              0.006 |              0.031 |            0.012 |           0.258 |                  0.070 |           0.016 |
| Formosa                       |          78 |    814 |          0 |                NaN |              0.000 |              0.000 |            0.096 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          59 |   1863 |          0 |                NaN |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      |          50 |    674 |          0 |                NaN |              0.000 |              0.000 |            0.074 |           0.020 |                  0.000 |           0.000 |
| Misiones                      |          48 |   1969 |          2 |                6.5 |              0.012 |              0.042 |            0.024 |           0.604 |                  0.125 |           0.062 |
| Santiago del Estero           |          48 |   4588 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.042 |                  0.021 |           0.000 |
| San Juan                      |          21 |    968 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.238 |                  0.048 |           0.000 |
| San Luis                      |          20 |    744 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.450 |                  0.050 |           0.000 |


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
    #> INFO  [09:43:38.156] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 22
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-07-15              |                        36 |          95 |    666 |         66 |          9 |              0.066 |              0.095 |            0.143 |           0.695 |                  0.126 |           0.063 |
|             12 | 2020-07-25              |                        58 |         410 |   2049 |        254 |         17 |              0.033 |              0.041 |            0.200 |           0.620 |                  0.093 |           0.054 |
|             13 | 2020-07-25              |                        89 |        1079 |   5516 |        598 |         63 |              0.049 |              0.058 |            0.196 |           0.554 |                  0.095 |           0.057 |
|             14 | 2020-07-26              |                       118 |        1763 |  11534 |        965 |        113 |              0.052 |              0.064 |            0.153 |           0.547 |                  0.095 |           0.057 |
|             15 | 2020-07-26              |                       140 |        2421 |  20249 |       1307 |        174 |              0.058 |              0.072 |            0.120 |           0.540 |                  0.090 |           0.051 |
|             16 | 2020-07-26              |                       148 |        3204 |  31850 |       1650 |        229 |              0.056 |              0.071 |            0.101 |           0.515 |                  0.081 |           0.044 |
|             17 | 2020-07-27              |                       152 |        4302 |  45900 |       2165 |        331 |              0.061 |              0.077 |            0.094 |           0.503 |                  0.073 |           0.038 |
|             18 | 2020-07-27              |                       152 |        5288 |  59090 |       2556 |        394 |              0.059 |              0.075 |            0.089 |           0.483 |                  0.066 |           0.035 |
|             19 | 2020-07-27              |                       152 |        6712 |  73219 |       3135 |        472 |              0.056 |              0.070 |            0.092 |           0.467 |                  0.061 |           0.032 |
|             20 | 2020-07-27              |                       152 |        9077 |  90581 |       3968 |        557 |              0.050 |              0.061 |            0.100 |           0.437 |                  0.055 |           0.029 |
|             21 | 2020-07-27              |                       152 |       13387 | 114004 |       5263 |        695 |              0.043 |              0.052 |            0.117 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-07-27              |                       152 |       18575 | 139352 |       6681 |        860 |              0.038 |              0.046 |            0.133 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-27              |                       152 |       24945 | 167602 |       8193 |       1061 |              0.036 |              0.043 |            0.149 |           0.328 |                  0.041 |           0.019 |
|             24 | 2020-07-27              |                       152 |       34453 | 202659 |      10285 |       1281 |              0.031 |              0.037 |            0.170 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-07-27              |                       152 |       47167 | 243974 |      12570 |       1556 |              0.028 |              0.033 |            0.193 |           0.266 |                  0.031 |           0.014 |
|             26 | 2020-07-27              |                       152 |       64709 | 295681 |      15535 |       1895 |              0.025 |              0.029 |            0.219 |           0.240 |                  0.027 |           0.012 |
|             27 | 2020-07-27              |                       152 |       83117 | 345908 |      18144 |       2239 |              0.023 |              0.027 |            0.240 |           0.218 |                  0.025 |           0.011 |
|             28 | 2020-07-27              |                       153 |      105927 | 403910 |      21125 |       2611 |              0.021 |              0.025 |            0.262 |           0.199 |                  0.022 |           0.010 |
|             29 | 2020-07-27              |                       154 |      133395 | 472745 |      24005 |       2904 |              0.018 |              0.022 |            0.282 |           0.180 |                  0.020 |           0.008 |
|             30 | 2020-07-27              |                       154 |      164604 | 545587 |      26121 |       3040 |              0.014 |              0.018 |            0.302 |           0.159 |                  0.017 |           0.007 |
|             31 | 2020-07-27              |                       154 |      166982 | 551105 |      26247 |       3044 |              0.013 |              0.018 |            0.303 |           0.157 |                  0.017 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:44:25.075] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:44:51.042] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:45:07.010] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:45:08.727] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:45:12.269] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:45:14.271] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:45:19.002] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:45:21.420] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:45:23.767] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:45:25.378] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:45:27.897] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:45:30.081] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:45:32.352] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:45:34.773] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:45:36.805] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:45:38.932] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:45:41.416] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:45:43.484] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:45:45.475] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:45:47.598] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:45:49.592] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:45:52.942] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:45:55.064] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:45:57.102] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:45:59.326] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 486
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
| Buenos Aires                  | M    |       49724 |       6471 |        899 |              0.013 |              0.018 |            0.370 |           0.130 |                  0.017 |           0.007 |
| Buenos Aires                  | F    |       47291 |       5423 |        676 |              0.010 |              0.014 |            0.335 |           0.115 |                  0.012 |           0.004 |
| CABA                          | F    |       27334 |       5602 |        480 |              0.015 |              0.018 |            0.379 |           0.205 |                  0.014 |           0.006 |
| CABA                          | M    |       26797 |       5706 |        596 |              0.019 |              0.022 |            0.418 |           0.213 |                  0.024 |           0.011 |
| Chaco                         | F    |        1688 |        172 |         50 |              0.023 |              0.030 |            0.163 |           0.102 |                  0.050 |           0.019 |
| Chaco                         | M    |        1668 |        187 |         87 |              0.039 |              0.052 |            0.162 |           0.112 |                  0.071 |           0.034 |
| Jujuy                         | M    |        1009 |         12 |         18 |              0.007 |              0.018 |            0.233 |           0.012 |                  0.003 |           0.003 |
| Córdoba                       | F    |         933 |         76 |         21 |              0.012 |              0.023 |            0.064 |           0.081 |                  0.018 |           0.006 |
| Córdoba                       | M    |         933 |         62 |         22 |              0.014 |              0.024 |            0.066 |           0.066 |                  0.021 |           0.012 |
| Río Negro                     | M    |         812 |        317 |         42 |              0.045 |              0.052 |            0.263 |           0.390 |                  0.039 |           0.030 |
| Río Negro                     | F    |         801 |        312 |         22 |              0.024 |              0.027 |            0.227 |           0.390 |                  0.015 |           0.007 |
| SIN ESPECIFICAR               | F    |         688 |         60 |          0 |              0.000 |              0.000 |            0.416 |           0.087 |                  0.004 |           0.000 |
| Neuquén                       | M    |         548 |        344 |         10 |              0.016 |              0.018 |            0.255 |           0.628 |                  0.011 |           0.005 |
| Neuquén                       | F    |         526 |        381 |         13 |              0.021 |              0.025 |            0.251 |           0.724 |                  0.011 |           0.006 |
| Jujuy                         | F    |         511 |          2 |         13 |              0.006 |              0.025 |            0.157 |           0.004 |                  0.002 |           0.002 |
| Santa Fe                      | F    |         495 |         45 |          3 |              0.004 |              0.006 |            0.050 |           0.091 |                  0.018 |           0.004 |
| SIN ESPECIFICAR               | M    |         478 |         62 |          3 |              0.005 |              0.006 |            0.454 |           0.130 |                  0.010 |           0.008 |
| Santa Fe                      | M    |         469 |         71 |          8 |              0.011 |              0.017 |            0.051 |           0.151 |                  0.038 |           0.017 |
| Mendoza                       | M    |         446 |        220 |         18 |              0.028 |              0.040 |            0.148 |           0.493 |                  0.038 |           0.013 |
| Mendoza                       | F    |         420 |        205 |          4 |              0.007 |              0.010 |            0.137 |           0.488 |                  0.012 |           0.002 |
| Entre Ríos                    | M    |         388 |         88 |          4 |              0.008 |              0.010 |            0.179 |           0.227 |                  0.008 |           0.003 |
| Entre Ríos                    | F    |         376 |         71 |          3 |              0.006 |              0.008 |            0.163 |           0.189 |                  0.008 |           0.003 |
| Buenos Aires                  | NR   |         363 |         36 |          6 |              0.010 |              0.017 |            0.377 |           0.099 |                  0.028 |           0.014 |
| Tierra del Fuego              | M    |         233 |          7 |          2 |              0.006 |              0.009 |            0.177 |           0.030 |                  0.013 |           0.013 |
| CABA                          | NR   |         224 |         68 |         13 |              0.034 |              0.058 |            0.371 |           0.304 |                  0.049 |           0.036 |
| Santa Cruz                    | M    |         191 |         17 |          1 |              0.005 |              0.005 |            0.295 |           0.089 |                  0.021 |           0.010 |
| Santa Cruz                    | F    |         154 |         13 |          0 |              0.000 |              0.000 |            0.298 |           0.084 |                  0.006 |           0.006 |
| Chubut                        | M    |         141 |         10 |          1 |              0.003 |              0.007 |            0.100 |           0.071 |                  0.014 |           0.014 |
| La Rioja                      | F    |         135 |         14 |          7 |              0.043 |              0.052 |            0.081 |           0.104 |                  0.037 |           0.015 |
| Salta                         | M    |         131 |         52 |          2 |              0.008 |              0.015 |            0.117 |           0.397 |                  0.023 |           0.008 |
| Tierra del Fuego              | F    |         128 |          3 |          0 |              0.000 |              0.000 |            0.118 |           0.023 |                  0.000 |           0.000 |
| Chubut                        | F    |         117 |          4 |          1 |              0.004 |              0.009 |            0.091 |           0.034 |                  0.017 |           0.009 |
| La Rioja                      | M    |         113 |         11 |          9 |              0.063 |              0.080 |            0.063 |           0.097 |                  0.009 |           0.000 |
| Corrientes                    | M    |          93 |          4 |          1 |              0.005 |              0.011 |            0.042 |           0.043 |                  0.011 |           0.011 |
| Salta                         | F    |          88 |         33 |          0 |              0.000 |              0.000 |            0.145 |           0.375 |                  0.011 |           0.000 |
| Tucumán                       | M    |          77 |         18 |          2 |              0.005 |              0.026 |            0.012 |           0.234 |                  0.039 |           0.000 |
| Formosa                       | M    |          66 |          1 |          0 |              0.000 |              0.000 |            0.136 |           0.015 |                  0.000 |           0.000 |
| Corrientes                    | F    |          59 |          0 |          0 |              0.000 |              0.000 |            0.033 |           0.000 |                  0.017 |           0.000 |
| Tucumán                       | F    |          51 |         15 |          2 |              0.008 |              0.039 |            0.013 |           0.294 |                  0.118 |           0.039 |
| Catamarca                     | M    |          37 |          0 |          0 |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          35 |          2 |          0 |              0.000 |              0.000 |            0.011 |           0.057 |                  0.029 |           0.000 |
| Misiones                      | M    |          28 |         16 |          1 |              0.011 |              0.036 |            0.027 |           0.571 |                  0.143 |           0.071 |
| La Pampa                      | M    |          27 |          1 |          0 |              0.000 |              0.000 |            0.079 |           0.037 |                  0.000 |           0.000 |
| La Pampa                      | F    |          23 |          0 |          0 |              0.000 |              0.000 |            0.069 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.012 |              0.050 |            0.022 |           0.650 |                  0.100 |           0.050 |
| San Juan                      | M    |          16 |          2 |          0 |              0.000 |              0.000 |            0.029 |           0.125 |                  0.000 |           0.000 |
| San Luis                      | M    |          15 |          7 |          0 |              0.000 |              0.000 |            0.036 |           0.467 |                  0.067 |           0.000 |
| Santiago del Estero           | F    |          13 |          0 |          0 |              0.000 |              0.000 |            0.010 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | F    |          12 |          0 |          0 |              0.000 |              0.000 |            0.036 |           0.000 |                  0.000 |           0.000 |


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
