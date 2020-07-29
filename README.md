
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
    #> INFO  [19:43:43.695] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [19:43:49.012] Normalize 
    #> INFO  [19:43:49.778] checkSoundness 
    #> INFO  [19:43:50.231] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-07-28"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-07-28"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-07-28"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-07-28              |      173342 |       3179 |              0.013 |              0.018 |                       155 | 565054 |            0.307 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      101822 |       1659 |              0.012 |              0.016 |                       153 | 285094 |            0.357 |
| CABA                          |       55637 |       1141 |              0.017 |              0.021 |                       151 | 139588 |            0.399 |
| Chaco                         |        3376 |        137 |              0.030 |              0.041 |                       139 |  20864 |            0.162 |
| Córdoba                       |        1945 |         45 |              0.013 |              0.023 |                       141 |  29162 |            0.067 |
| Río Negro                     |        1707 |         66 |              0.034 |              0.039 |                       134 |   6794 |            0.251 |
| Jujuy                         |        1689 |         31 |              0.006 |              0.018 |                       130 |   8068 |            0.209 |
| SIN ESPECIFICAR               |        1186 |          3 |              0.002 |              0.003 |                       129 |   2698 |            0.440 |
| Neuquén                       |        1095 |         23 |              0.018 |              0.021 |                       136 |   4329 |            0.253 |
| Santa Fe                      |        1035 |         11 |              0.007 |              0.011 |                       137 |  19413 |            0.053 |
| Mendoza                       |         946 |         26 |              0.019 |              0.027 |                       140 |   6322 |            0.150 |
| Entre Ríos                    |         769 |          7 |              0.007 |              0.009 |                       134 |   4552 |            0.169 |
| Tierra del Fuego              |         387 |          2 |              0.004 |              0.005 |                       133 |   2525 |            0.153 |
| Santa Cruz                    |         377 |          1 |              0.002 |              0.003 |                       126 |   1203 |            0.313 |
| Chubut                        |         265 |          2 |              0.004 |              0.008 |                       119 |   2754 |            0.096 |
| La Rioja                      |         260 |         16 |              0.050 |              0.062 |                       126 |   3552 |            0.073 |
| Salta                         |         226 |          2 |              0.005 |              0.009 |                       129 |   1757 |            0.129 |
| Tucumán                       |         149 |          4 |              0.005 |              0.027 |                       132 |  10645 |            0.014 |
| Corrientes                    |         146 |          1 |              0.003 |              0.007 |                       131 |   4000 |            0.036 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      101822 | 285094 |       1659 |               13.2 |              0.012 |              0.016 |            0.357 |           0.120 |                  0.014 |           0.006 |
| CABA                          |       55637 | 139588 |       1141 |               14.6 |              0.017 |              0.021 |            0.399 |           0.208 |                  0.019 |           0.009 |
| Chaco                         |        3376 |  20864 |        137 |               14.5 |              0.030 |              0.041 |            0.162 |           0.108 |                  0.063 |           0.027 |
| Córdoba                       |        1945 |  29162 |         45 |               23.1 |              0.013 |              0.023 |            0.067 |           0.072 |                  0.020 |           0.009 |
| Río Negro                     |        1707 |   6794 |         66 |               13.5 |              0.034 |              0.039 |            0.251 |           0.376 |                  0.026 |           0.018 |
| Jujuy                         |        1689 |   8068 |         31 |               12.6 |              0.006 |              0.018 |            0.209 |           0.008 |                  0.002 |           0.002 |
| SIN ESPECIFICAR               |        1186 |   2698 |          3 |               26.7 |              0.002 |              0.003 |            0.440 |           0.098 |                  0.008 |           0.004 |
| Neuquén                       |        1095 |   4329 |         23 |               18.6 |              0.018 |              0.021 |            0.253 |           0.676 |                  0.011 |           0.005 |
| Santa Fe                      |        1035 |  19413 |         11 |               15.4 |              0.007 |              0.011 |            0.053 |           0.121 |                  0.026 |           0.010 |
| Mendoza                       |         946 |   6322 |         26 |                9.9 |              0.019 |              0.027 |            0.150 |           0.471 |                  0.023 |           0.007 |
| Entre Ríos                    |         769 |   4552 |          7 |                9.9 |              0.007 |              0.009 |            0.169 |           0.217 |                  0.008 |           0.003 |
| Tierra del Fuego              |         387 |   2525 |          2 |               19.0 |              0.004 |              0.005 |            0.153 |           0.026 |                  0.008 |           0.008 |
| Santa Cruz                    |         377 |   1203 |          1 |                7.0 |              0.002 |              0.003 |            0.313 |           0.080 |                  0.013 |           0.008 |
| Chubut                        |         265 |   2754 |          2 |               10.5 |              0.004 |              0.008 |            0.096 |           0.053 |                  0.015 |           0.011 |
| La Rioja                      |         260 |   3552 |         16 |               13.2 |              0.050 |              0.062 |            0.073 |           0.096 |                  0.023 |           0.008 |
| Salta                         |         226 |   1757 |          2 |                2.5 |              0.005 |              0.009 |            0.129 |           0.381 |                  0.022 |           0.009 |
| Tucumán                       |         149 |  10645 |          4 |               14.2 |              0.005 |              0.027 |            0.014 |           0.221 |                  0.060 |           0.013 |
| Corrientes                    |         146 |   4000 |          1 |               12.0 |              0.003 |              0.007 |            0.036 |           0.021 |                  0.014 |           0.007 |
| Formosa                       |          78 |    820 |          0 |                NaN |              0.000 |              0.000 |            0.095 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     |          59 |   1894 |          0 |                NaN |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      |          59 |    707 |          0 |                NaN |              0.000 |              0.000 |            0.083 |           0.034 |                  0.000 |           0.000 |
| Misiones                      |          44 |   1966 |          2 |                6.5 |              0.010 |              0.045 |            0.022 |           0.659 |                  0.136 |           0.068 |
| Santiago del Estero           |          43 |   4629 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.047 |                  0.023 |           0.000 |
| San Luis                      |          22 |    748 |          0 |                NaN |              0.000 |              0.000 |            0.029 |           0.409 |                  0.045 |           0.000 |
| San Juan                      |          20 |    970 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.250 |                  0.050 |           0.000 |


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
    #> INFO  [19:45:16.499] Processing {current.group: }
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
|             12 | 2020-07-28              |                        59 |         411 |   2049 |        255 |         17 |              0.033 |              0.041 |            0.201 |           0.620 |                  0.092 |           0.054 |
|             13 | 2020-07-28              |                        90 |        1080 |   5516 |        599 |         63 |              0.049 |              0.058 |            0.196 |           0.555 |                  0.094 |           0.056 |
|             14 | 2020-07-28              |                       119 |        1764 |  11534 |        966 |        114 |              0.053 |              0.065 |            0.153 |           0.548 |                  0.095 |           0.057 |
|             15 | 2020-07-28              |                       141 |        2423 |  20249 |       1308 |        175 |              0.058 |              0.072 |            0.120 |           0.540 |                  0.090 |           0.051 |
|             16 | 2020-07-28              |                       150 |        3212 |  31850 |       1654 |        231 |              0.056 |              0.072 |            0.101 |           0.515 |                  0.080 |           0.044 |
|             17 | 2020-07-28              |                       153 |        4312 |  45900 |       2170 |        333 |              0.061 |              0.077 |            0.094 |           0.503 |                  0.073 |           0.038 |
|             18 | 2020-07-28              |                       153 |        5301 |  59091 |       2562 |        397 |              0.059 |              0.075 |            0.090 |           0.483 |                  0.065 |           0.035 |
|             19 | 2020-07-28              |                       153 |        6730 |  73221 |       3145 |        475 |              0.057 |              0.071 |            0.092 |           0.467 |                  0.061 |           0.032 |
|             20 | 2020-07-28              |                       153 |        9098 |  90584 |       3978 |        564 |              0.050 |              0.062 |            0.100 |           0.437 |                  0.056 |           0.029 |
|             21 | 2020-07-28              |                       153 |       13417 | 114008 |       5278 |        707 |              0.043 |              0.053 |            0.118 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-07-28              |                       153 |       18611 | 139361 |       6703 |        878 |              0.039 |              0.047 |            0.134 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-28              |                       153 |       24990 | 167614 |       8219 |       1081 |              0.036 |              0.043 |            0.149 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-07-28              |                       153 |       34512 | 202674 |      10323 |       1304 |              0.032 |              0.038 |            0.170 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-07-28              |                       153 |       47237 | 243992 |      12615 |       1580 |              0.028 |              0.033 |            0.194 |           0.267 |                  0.031 |           0.014 |
|             26 | 2020-07-28              |                       153 |       64808 | 295736 |      15586 |       1928 |              0.025 |              0.030 |            0.219 |           0.240 |                  0.027 |           0.012 |
|             27 | 2020-07-28              |                       153 |       83244 | 346018 |      18205 |       2281 |              0.023 |              0.027 |            0.241 |           0.219 |                  0.025 |           0.011 |
|             28 | 2020-07-28              |                       154 |      106141 | 404130 |      21207 |       2672 |              0.021 |              0.025 |            0.263 |           0.200 |                  0.022 |           0.010 |
|             29 | 2020-07-28              |                       155 |      133908 | 473363 |      24158 |       2992 |              0.018 |              0.022 |            0.283 |           0.180 |                  0.020 |           0.009 |
|             30 | 2020-07-28              |                       155 |      167003 | 550246 |      26517 |       3168 |              0.015 |              0.019 |            0.304 |           0.159 |                  0.017 |           0.007 |
|             31 | 2020-07-28              |                       155 |      173342 | 565054 |      26848 |       3179 |              0.013 |              0.018 |            0.307 |           0.155 |                  0.017 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [19:45:52.476] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [19:46:10.945] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [19:46:21.656] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [19:46:22.965] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [19:46:26.191] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [19:46:28.002] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [19:46:32.254] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [19:46:34.446] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [19:46:36.641] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [19:46:38.151] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [19:46:40.468] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [19:46:42.361] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [19:46:44.419] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [19:46:46.660] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [19:46:48.514] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [19:46:50.566] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [19:46:52.961] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [19:46:54.848] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [19:46:56.624] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [19:46:58.601] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [19:47:00.628] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [19:47:03.952] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [19:47:06.009] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [19:47:08.026] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [19:47:10.139] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       52041 |       6656 |        945 |              0.013 |              0.018 |            0.376 |           0.128 |                  0.017 |           0.007 |
| Buenos Aires                  | F    |       49402 |       5573 |        707 |              0.010 |              0.014 |            0.339 |           0.113 |                  0.012 |           0.004 |
| CABA                          | F    |       27965 |       5690 |        507 |              0.015 |              0.018 |            0.381 |           0.203 |                  0.014 |           0.006 |
| CABA                          | M    |       27441 |       5819 |        620 |              0.019 |              0.023 |            0.419 |           0.212 |                  0.024 |           0.011 |
| Chaco                         | F    |        1701 |        175 |         50 |              0.022 |              0.029 |            0.163 |           0.103 |                  0.052 |           0.019 |
| Chaco                         | M    |        1673 |        189 |         87 |              0.038 |              0.052 |            0.161 |           0.113 |                  0.075 |           0.035 |
| Jujuy                         | M    |        1108 |         12 |         18 |              0.006 |              0.016 |            0.242 |           0.011 |                  0.003 |           0.003 |
| Córdoba                       | M    |         975 |         62 |         23 |              0.013 |              0.024 |            0.068 |           0.064 |                  0.021 |           0.011 |
| Córdoba                       | F    |         968 |         77 |         22 |              0.012 |              0.023 |            0.065 |           0.080 |                  0.019 |           0.007 |
| Río Negro                     | M    |         854 |        320 |         43 |              0.045 |              0.050 |            0.269 |           0.375 |                  0.036 |           0.028 |
| Río Negro                     | F    |         853 |        322 |         23 |              0.024 |              0.027 |            0.236 |           0.377 |                  0.015 |           0.008 |
| SIN ESPECIFICAR               | F    |         706 |         56 |          0 |              0.000 |              0.000 |            0.429 |           0.079 |                  0.004 |           0.000 |
| Jujuy                         | F    |         578 |          2 |         13 |              0.005 |              0.022 |            0.167 |           0.003 |                  0.002 |           0.002 |
| Neuquén                       | M    |         557 |        348 |         10 |              0.016 |              0.018 |            0.255 |           0.625 |                  0.011 |           0.005 |
| Neuquén                       | F    |         538 |        392 |         13 |              0.020 |              0.024 |            0.251 |           0.729 |                  0.011 |           0.006 |
| Santa Fe                      | F    |         525 |         49 |          3 |              0.004 |              0.006 |            0.052 |           0.093 |                  0.017 |           0.004 |
| Santa Fe                      | M    |         510 |         76 |          8 |              0.010 |              0.016 |            0.054 |           0.149 |                  0.035 |           0.016 |
| Mendoza                       | M    |         479 |        229 |         19 |              0.028 |              0.040 |            0.154 |           0.478 |                  0.035 |           0.013 |
| SIN ESPECIFICAR               | M    |         476 |         59 |          2 |              0.003 |              0.004 |            0.457 |           0.124 |                  0.011 |           0.008 |
| Mendoza                       | F    |         461 |        213 |          5 |              0.008 |              0.011 |            0.146 |           0.462 |                  0.011 |           0.002 |
| Entre Ríos                    | M    |         392 |         94 |          4 |              0.008 |              0.010 |            0.179 |           0.240 |                  0.008 |           0.003 |
| Buenos Aires                  | NR   |         379 |         37 |          7 |              0.011 |              0.018 |            0.380 |           0.098 |                  0.026 |           0.013 |
| Entre Ríos                    | F    |         376 |         73 |          3 |              0.006 |              0.008 |            0.160 |           0.194 |                  0.008 |           0.003 |
| Tierra del Fuego              | M    |         247 |          7 |          2 |              0.006 |              0.008 |            0.179 |           0.028 |                  0.012 |           0.012 |
| CABA                          | NR   |         231 |         71 |         14 |              0.035 |              0.061 |            0.376 |           0.307 |                  0.052 |           0.039 |
| Santa Cruz                    | M    |         202 |         17 |          1 |              0.005 |              0.005 |            0.305 |           0.084 |                  0.020 |           0.010 |
| Santa Cruz                    | F    |         175 |         13 |          0 |              0.000 |              0.000 |            0.325 |           0.074 |                  0.006 |           0.006 |
| Chubut                        | M    |         143 |         10 |          1 |              0.003 |              0.007 |            0.101 |           0.070 |                  0.014 |           0.014 |
| La Rioja                      | F    |         141 |         14 |          7 |              0.041 |              0.050 |            0.082 |           0.099 |                  0.035 |           0.014 |
| Tierra del Fuego              | F    |         139 |          3 |          0 |              0.000 |              0.000 |            0.122 |           0.022 |                  0.000 |           0.000 |
| Salta                         | M    |         138 |         53 |          2 |              0.008 |              0.014 |            0.121 |           0.384 |                  0.029 |           0.014 |
| Chubut                        | F    |         118 |          4 |          1 |              0.004 |              0.008 |            0.091 |           0.034 |                  0.017 |           0.008 |
| La Rioja                      | M    |         117 |         11 |          9 |              0.062 |              0.077 |            0.064 |           0.094 |                  0.009 |           0.000 |
| Tucumán                       | M    |          91 |         18 |          2 |              0.004 |              0.022 |            0.014 |           0.198 |                  0.033 |           0.000 |
| Salta                         | F    |          88 |         33 |          0 |              0.000 |              0.000 |            0.144 |           0.375 |                  0.011 |           0.000 |
| Corrientes                    | M    |          87 |          3 |          1 |              0.005 |              0.011 |            0.039 |           0.034 |                  0.011 |           0.011 |
| Formosa                       | M    |          66 |          0 |          0 |              0.000 |              0.000 |            0.135 |           0.000 |                  0.000 |           0.000 |
| Corrientes                    | F    |          59 |          0 |          0 |              0.000 |              0.000 |            0.033 |           0.000 |                  0.017 |           0.000 |
| Tucumán                       | F    |          58 |         15 |          2 |              0.007 |              0.034 |            0.014 |           0.259 |                  0.103 |           0.034 |
| Catamarca                     | M    |          37 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      | M    |          32 |          1 |          0 |              0.000 |              0.000 |            0.091 |           0.031 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          31 |          2 |          0 |              0.000 |              0.000 |            0.010 |           0.065 |                  0.032 |           0.000 |
| La Pampa                      | F    |          27 |          1 |          0 |              0.000 |              0.000 |            0.076 |           0.037 |                  0.000 |           0.000 |
| Misiones                      | M    |          24 |         16 |          1 |              0.009 |              0.042 |            0.023 |           0.667 |                  0.167 |           0.083 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.010 |              0.050 |            0.022 |           0.650 |                  0.100 |           0.050 |
| San Luis                      | M    |          17 |          7 |          0 |              0.000 |              0.000 |            0.040 |           0.412 |                  0.059 |           0.000 |
| San Juan                      | M    |          15 |          2 |          0 |              0.000 |              0.000 |            0.027 |           0.133 |                  0.000 |           0.000 |
| Formosa                       | F    |          12 |          0 |          0 |              0.000 |              0.000 |            0.036 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          12 |          0 |          0 |              0.000 |              0.000 |            0.010 |           0.000 |                  0.000 |           0.000 |


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
