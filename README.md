
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
    #> INFO  [23:48:44.767] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [23:48:49.485] Normalize 
    #> INFO  [23:48:50.251] checkSoundness 
    #> INFO  [23:48:50.591] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-07-24"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-07-24"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-07-24"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-07-24              |      153507 |       2807 |              0.013 |              0.018 |                       151 | 520463 |            0.295 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |       88276 |       1428 |              0.011 |              0.016 |                       149 | 258645 |            0.341 |
| CABA                          |       51233 |       1020 |              0.017 |              0.020 |                       147 | 130243 |            0.393 |
| Chaco                         |        3218 |        132 |              0.031 |              0.041 |                       135 |  19560 |            0.165 |
| Córdoba                       |        1622 |         42 |              0.014 |              0.026 |                       137 |  27622 |            0.059 |
| Río Negro                     |        1526 |         63 |              0.036 |              0.041 |                       130 |   6358 |            0.240 |
| Jujuy                         |        1358 |         31 |              0.007 |              0.023 |                       126 |   6926 |            0.196 |
| SIN ESPECIFICAR               |        1177 |          4 |              0.002 |              0.003 |                       125 |   2816 |            0.418 |
| Neuquén                       |        1001 |         22 |              0.018 |              0.022 |                       132 |   4049 |            0.247 |
| Santa Fe                      |         868 |          9 |              0.007 |              0.010 |                       133 |  18517 |            0.047 |
| Mendoza                       |         726 |         21 |              0.019 |              0.029 |                       136 |   5631 |            0.129 |
| Entre Ríos                    |         722 |          6 |              0.006 |              0.008 |                       130 |   4222 |            0.171 |
| Santa Cruz                    |         302 |          0 |              0.000 |              0.000 |                       122 |   1118 |            0.270 |
| Tierra del Fuego              |         288 |          2 |              0.005 |              0.007 |                       129 |   2179 |            0.132 |
| Chubut                        |         259 |          2 |              0.004 |              0.008 |                       116 |   2631 |            0.098 |
| La Rioja                      |         216 |         15 |              0.054 |              0.069 |                       121 |   3281 |            0.066 |
| Salta                         |         204 |          2 |              0.006 |              0.010 |                       125 |   1691 |            0.121 |
| Corrientes                    |         131 |          1 |              0.003 |              0.008 |                       127 |   3867 |            0.034 |
| Tucumán                       |         102 |          4 |              0.007 |              0.039 |                       128 |   9845 |            0.010 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |       88276 | 258645 |       1428 |               13.2 |              0.011 |              0.016 |            0.341 |           0.128 |                  0.015 |           0.006 |
| CABA                          |       51233 | 130243 |       1020 |               14.5 |              0.017 |              0.020 |            0.393 |           0.214 |                  0.019 |           0.009 |
| Chaco                         |        3218 |  19560 |        132 |               14.6 |              0.031 |              0.041 |            0.165 |           0.106 |                  0.058 |           0.025 |
| Córdoba                       |        1622 |  27622 |         42 |               23.2 |              0.014 |              0.026 |            0.059 |           0.084 |                  0.022 |           0.010 |
| Río Negro                     |        1526 |   6358 |         63 |               14.0 |              0.036 |              0.041 |            0.240 |           0.385 |                  0.026 |           0.017 |
| Jujuy                         |        1358 |   6926 |         31 |               12.6 |              0.007 |              0.023 |            0.196 |           0.010 |                  0.003 |           0.003 |
| SIN ESPECIFICAR               |        1177 |   2816 |          4 |               20.0 |              0.002 |              0.003 |            0.418 |           0.109 |                  0.008 |           0.004 |
| Neuquén                       |        1001 |   4049 |         22 |               18.6 |              0.018 |              0.022 |            0.247 |           0.696 |                  0.012 |           0.006 |
| Santa Fe                      |         868 |  18517 |          9 |               17.9 |              0.007 |              0.010 |            0.047 |           0.124 |                  0.031 |           0.012 |
| Mendoza                       |         726 |   5631 |         21 |               10.0 |              0.019 |              0.029 |            0.129 |           0.508 |                  0.029 |           0.010 |
| Entre Ríos                    |         722 |   4222 |          6 |                8.3 |              0.006 |              0.008 |            0.171 |           0.211 |                  0.008 |           0.003 |
| Santa Cruz                    |         302 |   1118 |          0 |                NaN |              0.000 |              0.000 |            0.270 |           0.099 |                  0.017 |           0.010 |
| Tierra del Fuego              |         288 |   2179 |          2 |               19.0 |              0.005 |              0.007 |            0.132 |           0.035 |                  0.010 |           0.010 |
| Chubut                        |         259 |   2631 |          2 |               10.5 |              0.004 |              0.008 |            0.098 |           0.046 |                  0.015 |           0.012 |
| La Rioja                      |         216 |   3281 |         15 |               13.2 |              0.054 |              0.069 |            0.066 |           0.106 |                  0.028 |           0.009 |
| Salta                         |         204 |   1691 |          2 |                2.5 |              0.006 |              0.010 |            0.121 |           0.368 |                  0.020 |           0.005 |
| Corrientes                    |         131 |   3867 |          1 |               12.0 |              0.003 |              0.008 |            0.034 |           0.023 |                  0.015 |           0.008 |
| Tucumán                       |         102 |   9845 |          4 |               14.2 |              0.007 |              0.039 |            0.010 |           0.314 |                  0.088 |           0.020 |
| Formosa                       |          79 |    808 |          0 |                NaN |              0.000 |              0.000 |            0.098 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          59 |   1808 |          0 |                NaN |              0.000 |              0.000 |            0.033 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           |          49 |   4466 |          1 |               15.0 |              0.004 |              0.020 |            0.011 |           0.061 |                  0.041 |           0.020 |
| Misiones                      |          44 |   1901 |          2 |                6.5 |              0.010 |              0.045 |            0.023 |           0.659 |                  0.136 |           0.068 |
| San Luis                      |          20 |    727 |          0 |                NaN |              0.000 |              0.000 |            0.028 |           0.450 |                  0.050 |           0.000 |
| San Juan                      |          19 |    959 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.263 |                  0.053 |           0.000 |
| La Pampa                      |           8 |    593 |          0 |                NaN |              0.000 |              0.000 |            0.013 |           0.125 |                  0.000 |           0.000 |


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
    #> INFO  [23:50:18.158] Processing {current.group: }
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
|             16 | 2020-07-24              |                       146 |        3196 |  31848 |       1647 |        229 |              0.056 |              0.072 |            0.100 |           0.515 |                  0.080 |           0.044 |
|             17 | 2020-07-24              |                       149 |        4286 |  45898 |       2159 |        330 |              0.061 |              0.077 |            0.093 |           0.504 |                  0.073 |           0.038 |
|             18 | 2020-07-24              |                       149 |        5268 |  59085 |       2549 |        393 |              0.059 |              0.075 |            0.089 |           0.484 |                  0.066 |           0.035 |
|             19 | 2020-07-24              |                       149 |        6683 |  73210 |       3123 |        470 |              0.056 |              0.070 |            0.091 |           0.467 |                  0.061 |           0.032 |
|             20 | 2020-07-24              |                       149 |        9038 |  90571 |       3952 |        553 |              0.050 |              0.061 |            0.100 |           0.437 |                  0.055 |           0.029 |
|             21 | 2020-07-24              |                       149 |       13333 | 113988 |       5243 |        691 |              0.042 |              0.052 |            0.117 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-07-24              |                       149 |       18509 | 139333 |       6658 |        855 |              0.038 |              0.046 |            0.133 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-24              |                       149 |       24857 | 167560 |       8165 |       1055 |              0.035 |              0.042 |            0.148 |           0.328 |                  0.041 |           0.019 |
|             24 | 2020-07-24              |                       149 |       34339 | 202592 |      10248 |       1271 |              0.031 |              0.037 |            0.169 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-07-24              |                       149 |       47029 | 243872 |      12522 |       1539 |              0.028 |              0.033 |            0.193 |           0.266 |                  0.031 |           0.014 |
|             26 | 2020-07-24              |                       149 |       64535 | 295522 |      15462 |       1869 |              0.024 |              0.029 |            0.218 |           0.240 |                  0.027 |           0.012 |
|             27 | 2020-07-24              |                       149 |       82861 | 345641 |      18046 |       2190 |              0.022 |              0.026 |            0.240 |           0.218 |                  0.024 |           0.011 |
|             28 | 2020-07-24              |                       150 |      105528 | 403498 |      20947 |       2518 |              0.020 |              0.024 |            0.262 |           0.198 |                  0.022 |           0.010 |
|             29 | 2020-07-24              |                       151 |      132484 | 471513 |      23653 |       2733 |              0.017 |              0.021 |            0.281 |           0.179 |                  0.019 |           0.008 |
|             30 | 2020-07-24              |                       151 |      153507 | 520463 |      25091 |       2807 |              0.013 |              0.018 |            0.295 |           0.163 |                  0.018 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [23:50:55.353] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [23:51:14.784] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [23:51:25.894] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [23:51:27.169] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [23:51:30.242] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [23:51:32.026] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [23:51:36.026] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [23:51:38.201] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [23:51:40.362] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [23:51:41.909] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [23:51:44.289] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [23:51:46.092] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [23:51:48.064] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [23:51:50.169] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [23:51:51.923] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [23:51:55.145] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [23:51:59.383] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [23:52:01.437] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [23:52:03.623] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [23:52:06.329] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [23:52:08.616] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [23:52:11.654] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [23:52:13.622] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [23:52:15.616] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [23:52:18.326] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
    #> [1] 60
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |       45011 |       6136 |        819 |              0.013 |              0.018 |            0.359 |           0.136 |                  0.018 |           0.008 |
| Buenos Aires                  | F    |       42936 |       5165 |        603 |              0.010 |              0.014 |            0.324 |           0.120 |                  0.012 |           0.004 |
| CABA                          | F    |       25815 |       5411 |        447 |              0.014 |              0.017 |            0.376 |           0.210 |                  0.014 |           0.006 |
| CABA                          | M    |       25208 |       5511 |        560 |              0.019 |              0.022 |            0.413 |           0.219 |                  0.024 |           0.011 |
| Chaco                         | F    |        1626 |        165 |         50 |              0.023 |              0.031 |            0.166 |           0.101 |                  0.048 |           0.017 |
| Chaco                         | M    |        1590 |        176 |         82 |              0.038 |              0.052 |            0.163 |           0.111 |                  0.068 |           0.032 |
| Jujuy                         | M    |         902 |         11 |         18 |              0.007 |              0.020 |            0.228 |           0.012 |                  0.003 |           0.003 |
| Córdoba                       | M    |         815 |         59 |         21 |              0.014 |              0.026 |            0.060 |           0.072 |                  0.023 |           0.012 |
| Córdoba                       | F    |         805 |         76 |         21 |              0.013 |              0.026 |            0.057 |           0.094 |                  0.021 |           0.007 |
| Río Negro                     | F    |         766 |        295 |         22 |              0.025 |              0.029 |            0.226 |           0.385 |                  0.016 |           0.008 |
| Río Negro                     | M    |         760 |        292 |         41 |              0.048 |              0.054 |            0.256 |           0.384 |                  0.037 |           0.026 |
| SIN ESPECIFICAR               | F    |         689 |         63 |          0 |              0.000 |              0.000 |            0.401 |           0.091 |                  0.004 |           0.000 |
| Neuquén                       | F    |         504 |        369 |         12 |              0.020 |              0.024 |            0.251 |           0.732 |                  0.012 |           0.006 |
| Neuquén                       | M    |         497 |        328 |         10 |              0.017 |              0.020 |            0.244 |           0.660 |                  0.012 |           0.006 |
| SIN ESPECIFICAR               | M    |         484 |         64 |          3 |              0.005 |              0.006 |            0.446 |           0.132 |                  0.010 |           0.008 |
| Jujuy                         | F    |         454 |          3 |         13 |              0.007 |              0.029 |            0.154 |           0.007 |                  0.002 |           0.002 |
| Santa Fe                      | F    |         440 |         43 |          2 |              0.003 |              0.005 |            0.046 |           0.098 |                  0.023 |           0.007 |
| Santa Fe                      | M    |         428 |         65 |          7 |              0.011 |              0.016 |            0.048 |           0.152 |                  0.040 |           0.016 |
| Mendoza                       | M    |         370 |        184 |         15 |              0.027 |              0.041 |            0.133 |           0.497 |                  0.043 |           0.016 |
| Entre Ríos                    | M    |         368 |         85 |          3 |              0.006 |              0.008 |            0.180 |           0.231 |                  0.008 |           0.003 |
| Entre Ríos                    | F    |         353 |         67 |          3 |              0.006 |              0.008 |            0.162 |           0.190 |                  0.008 |           0.003 |
| Mendoza                       | F    |         350 |        181 |          4 |              0.007 |              0.011 |            0.124 |           0.517 |                  0.014 |           0.003 |
| Buenos Aires                  | NR   |         329 |         36 |          6 |              0.010 |              0.018 |            0.364 |           0.109 |                  0.030 |           0.015 |
| CABA                          | NR   |         210 |         67 |         13 |              0.036 |              0.062 |            0.363 |           0.319 |                  0.052 |           0.038 |
| Tierra del Fuego              | M    |         196 |          7 |          2 |              0.008 |              0.010 |            0.163 |           0.036 |                  0.015 |           0.015 |
| Santa Cruz                    | M    |         167 |         16 |          0 |              0.000 |              0.000 |            0.268 |           0.096 |                  0.024 |           0.012 |
| Chubut                        | M    |         138 |          8 |          1 |              0.004 |              0.007 |            0.102 |           0.058 |                  0.014 |           0.014 |
| Santa Cruz                    | F    |         135 |         14 |          0 |              0.000 |              0.000 |            0.274 |           0.104 |                  0.007 |           0.007 |
| Salta                         | M    |         122 |         45 |          2 |              0.009 |              0.016 |            0.111 |           0.369 |                  0.025 |           0.008 |
| La Rioja                      | F    |         118 |         14 |          7 |              0.048 |              0.059 |            0.074 |           0.119 |                  0.042 |           0.017 |
| Chubut                        | F    |         116 |          4 |          1 |              0.005 |              0.009 |            0.093 |           0.034 |                  0.017 |           0.009 |
| La Rioja                      | M    |          98 |          9 |          8 |              0.062 |              0.082 |            0.058 |           0.092 |                  0.010 |           0.000 |
| Tierra del Fuego              | F    |          91 |          3 |          0 |              0.000 |              0.000 |            0.094 |           0.033 |                  0.000 |           0.000 |
| Corrientes                    | M    |          82 |          3 |          1 |              0.005 |              0.012 |            0.038 |           0.037 |                  0.012 |           0.012 |
| Salta                         | F    |          82 |         30 |          0 |              0.000 |              0.000 |            0.139 |           0.366 |                  0.012 |           0.000 |
| Formosa                       | M    |          67 |          1 |          0 |              0.000 |              0.000 |            0.140 |           0.015 |                  0.000 |           0.000 |
| Tucumán                       | M    |          63 |         17 |          2 |              0.006 |              0.032 |            0.010 |           0.270 |                  0.048 |           0.000 |
| Corrientes                    | F    |          49 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.020 |           0.000 |
| Tucumán                       | F    |          39 |         15 |          2 |              0.010 |              0.051 |            0.010 |           0.385 |                  0.154 |           0.051 |
| Catamarca                     | M    |          37 |          0 |          0 |              0.000 |              0.000 |            0.033 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          36 |          2 |          0 |              0.000 |              0.000 |            0.012 |           0.056 |                  0.028 |           0.000 |
| Misiones                      | M    |          25 |         16 |          1 |              0.011 |              0.040 |            0.025 |           0.640 |                  0.160 |           0.080 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          19 |         13 |          1 |              0.010 |              0.053 |            0.021 |           0.684 |                  0.105 |           0.053 |
| San Luis                      | M    |          16 |          7 |          0 |              0.000 |              0.000 |            0.039 |           0.438 |                  0.062 |           0.000 |
| San Juan                      | M    |          14 |          2 |          0 |              0.000 |              0.000 |            0.026 |           0.143 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          13 |          1 |          1 |              0.011 |              0.077 |            0.011 |           0.077 |                  0.077 |           0.077 |
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
    #> Warning: Removed 16 rows containing missing values (position_stack).

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
