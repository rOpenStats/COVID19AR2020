
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
    #> INFO  [09:26:26.645] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:26:36.128] Normalize 
    #> INFO  [09:26:37.398] checkSoundness 
    #> INFO  [09:26:37.775] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-07-26"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-07-26"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-07-26"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-07-26              |      162513 |       2939 |              0.013 |              0.018 |                       153 | 541185 |              0.3 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |       94389 |       1531 |              0.012 |              0.016 |                       151 | 270681 |            0.349 |
| CABA                          |       53293 |       1040 |              0.016 |              0.020 |                       149 | 134721 |            0.396 |
| Chaco                         |        3326 |        134 |              0.031 |              0.040 |                       137 |  20410 |            0.163 |
| Córdoba                       |        1772 |         43 |              0.014 |              0.024 |                       139 |  28378 |            0.062 |
| Río Negro                     |        1572 |         64 |              0.037 |              0.041 |                       131 |   6519 |            0.241 |
| Jujuy                         |        1439 |         31 |              0.006 |              0.022 |                       128 |   7234 |            0.199 |
| SIN ESPECIFICAR               |        1182 |          4 |              0.002 |              0.003 |                       127 |   2758 |            0.429 |
| Neuquén                       |        1051 |         23 |              0.019 |              0.022 |                       134 |   4208 |            0.250 |
| Santa Fe                      |         939 |          9 |              0.006 |              0.010 |                       135 |  18884 |            0.050 |
| Mendoza                       |         818 |         24 |              0.021 |              0.029 |                       138 |   5969 |            0.137 |
| Entre Ríos                    |         761 |          6 |              0.006 |              0.008 |                       132 |   4432 |            0.172 |
| Santa Cruz                    |         330 |          1 |              0.003 |              0.003 |                       124 |   1147 |            0.288 |
| Tierra del Fuego              |         330 |          2 |              0.004 |              0.006 |                       131 |   2334 |            0.141 |
| Chubut                        |         263 |          2 |              0.004 |              0.008 |                       118 |   2723 |            0.097 |
| La Rioja                      |         240 |         15 |              0.050 |              0.062 |                       124 |   3428 |            0.070 |
| Salta                         |         233 |          2 |              0.005 |              0.009 |                       127 |   1737 |            0.134 |
| Corrientes                    |         138 |          1 |              0.003 |              0.007 |                       129 |   3960 |            0.035 |
| Tucumán                       |         119 |          4 |              0.007 |              0.034 |                       130 |  10197 |            0.012 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |       94389 | 270681 |       1531 |               13.1 |              0.012 |              0.016 |            0.349 |           0.124 |                  0.014 |           0.006 |
| CABA                          |       53293 | 134721 |       1040 |               14.5 |              0.016 |              0.020 |            0.396 |           0.210 |                  0.019 |           0.008 |
| Chaco                         |        3326 |  20410 |        134 |               14.7 |              0.031 |              0.040 |            0.163 |           0.105 |                  0.058 |           0.025 |
| Córdoba                       |        1772 |  28378 |         43 |               23.4 |              0.014 |              0.024 |            0.062 |           0.077 |                  0.021 |           0.010 |
| Río Negro                     |        1572 |   6519 |         64 |               13.8 |              0.037 |              0.041 |            0.241 |           0.391 |                  0.027 |           0.018 |
| Jujuy                         |        1439 |   7234 |         31 |               12.6 |              0.006 |              0.022 |            0.199 |           0.010 |                  0.003 |           0.003 |
| SIN ESPECIFICAR               |        1182 |   2758 |          4 |               20.0 |              0.002 |              0.003 |            0.429 |           0.107 |                  0.008 |           0.004 |
| Neuquén                       |        1051 |   4208 |         23 |               18.6 |              0.019 |              0.022 |            0.250 |           0.690 |                  0.011 |           0.006 |
| Santa Fe                      |         939 |  18884 |          9 |               17.9 |              0.006 |              0.010 |            0.050 |           0.121 |                  0.028 |           0.010 |
| Mendoza                       |         818 |   5969 |         24 |               10.7 |              0.021 |              0.029 |            0.137 |           0.483 |                  0.026 |           0.009 |
| Entre Ríos                    |         761 |   4432 |          6 |                8.3 |              0.006 |              0.008 |            0.172 |           0.208 |                  0.008 |           0.003 |
| Santa Cruz                    |         330 |   1147 |          1 |                7.0 |              0.003 |              0.003 |            0.288 |           0.091 |                  0.015 |           0.009 |
| Tierra del Fuego              |         330 |   2334 |          2 |               19.0 |              0.004 |              0.006 |            0.141 |           0.030 |                  0.009 |           0.009 |
| Chubut                        |         263 |   2723 |          2 |               10.5 |              0.004 |              0.008 |            0.097 |           0.053 |                  0.015 |           0.011 |
| La Rioja                      |         240 |   3428 |         15 |               13.2 |              0.050 |              0.062 |            0.070 |           0.100 |                  0.025 |           0.008 |
| Salta                         |         233 |   1737 |          2 |                2.5 |              0.005 |              0.009 |            0.134 |           0.356 |                  0.017 |           0.004 |
| Corrientes                    |         138 |   3960 |          1 |               12.0 |              0.003 |              0.007 |            0.035 |           0.022 |                  0.014 |           0.007 |
| Tucumán                       |         119 |  10197 |          4 |               14.2 |              0.007 |              0.034 |            0.012 |           0.269 |                  0.076 |           0.017 |
| Formosa                       |          78 |    812 |          0 |                NaN |              0.000 |              0.000 |            0.096 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          59 |   1851 |          0 |                NaN |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           |          53 |   4477 |          1 |               15.0 |              0.004 |              0.019 |            0.012 |           0.075 |                  0.038 |           0.019 |
| Misiones                      |          49 |   1970 |          2 |                6.5 |              0.013 |              0.041 |            0.025 |           0.592 |                  0.122 |           0.061 |
| La Pampa                      |          40 |    656 |          0 |                NaN |              0.000 |              0.000 |            0.061 |           0.025 |                  0.000 |           0.000 |
| San Juan                      |          20 |    970 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.300 |                  0.050 |           0.000 |
| San Luis                      |          19 |    729 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.474 |                  0.053 |           0.000 |


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
    #> INFO  [09:28:45.779] Processing {current.group: }
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
|             14 | 2020-07-25              |                       117 |        1759 |  11534 |        964 |        113 |              0.052 |              0.064 |            0.153 |           0.548 |                  0.094 |           0.056 |
|             15 | 2020-07-25              |                       139 |        2416 |  20249 |       1305 |        174 |              0.058 |              0.072 |            0.119 |           0.540 |                  0.090 |           0.050 |
|             16 | 2020-07-26              |                       148 |        3199 |  31850 |       1648 |        229 |              0.056 |              0.072 |            0.100 |           0.515 |                  0.080 |           0.044 |
|             17 | 2020-07-26              |                       151 |        4294 |  45900 |       2162 |        330 |              0.061 |              0.077 |            0.094 |           0.503 |                  0.073 |           0.038 |
|             18 | 2020-07-26              |                       151 |        5279 |  59090 |       2553 |        393 |              0.059 |              0.074 |            0.089 |           0.484 |                  0.066 |           0.035 |
|             19 | 2020-07-26              |                       151 |        6699 |  73217 |       3129 |        470 |              0.056 |              0.070 |            0.091 |           0.467 |                  0.061 |           0.031 |
|             20 | 2020-07-26              |                       151 |        9058 |  90579 |       3960 |        555 |              0.050 |              0.061 |            0.100 |           0.437 |                  0.055 |           0.028 |
|             21 | 2020-07-26              |                       151 |       13363 | 114000 |       5252 |        693 |              0.043 |              0.052 |            0.117 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-07-26              |                       151 |       18548 | 139346 |       6668 |        858 |              0.038 |              0.046 |            0.133 |           0.359 |                  0.044 |           0.022 |
|             23 | 2020-07-26              |                       151 |       24911 | 167594 |       8177 |       1058 |              0.035 |              0.042 |            0.149 |           0.328 |                  0.041 |           0.019 |
|             24 | 2020-07-26              |                       151 |       34407 | 202632 |      10262 |       1277 |              0.031 |              0.037 |            0.170 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-07-26              |                       151 |       47110 | 243926 |      12538 |       1551 |              0.028 |              0.033 |            0.193 |           0.266 |                  0.031 |           0.014 |
|             26 | 2020-07-26              |                       151 |       64637 | 295597 |      15492 |       1888 |              0.025 |              0.029 |            0.219 |           0.240 |                  0.027 |           0.012 |
|             27 | 2020-07-26              |                       151 |       83034 | 345791 |      18089 |       2222 |              0.022 |              0.027 |            0.240 |           0.218 |                  0.025 |           0.011 |
|             28 | 2020-07-26              |                       152 |      105804 | 403740 |      21043 |       2581 |              0.020 |              0.024 |            0.262 |           0.199 |                  0.022 |           0.010 |
|             29 | 2020-07-26              |                       153 |      133071 | 472212 |      23836 |       2829 |              0.017 |              0.021 |            0.282 |           0.179 |                  0.020 |           0.008 |
|             30 | 2020-07-26              |                       153 |      162054 | 540109 |      25760 |       2938 |              0.014 |              0.018 |            0.300 |           0.159 |                  0.017 |           0.007 |
|             31 | 2020-07-26              |                       153 |      162513 | 541185 |      25781 |       2939 |              0.013 |              0.018 |            0.300 |           0.159 |                  0.017 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:29:27.074] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:29:48.810] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:30:00.362] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:30:01.966] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:30:05.911] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:30:07.951] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:30:13.241] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:30:16.124] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:30:18.624] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:30:20.241] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:30:22.874] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:30:25.015] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:30:27.400] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:30:29.986] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:30:32.007] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:30:34.340] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:30:36.881] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:30:39.087] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:30:41.179] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:30:43.345] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:30:45.500] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:30:49.279] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:30:51.795] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:30:53.984] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:30:56.305] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 483
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
| Buenos Aires                  | M    |       48180 |       6356 |        874 |              0.013 |              0.018 |            0.367 |           0.132 |                  0.017 |           0.007 |
| Buenos Aires                  | F    |       45859 |       5317 |        651 |              0.010 |              0.014 |            0.331 |           0.116 |                  0.012 |           0.004 |
| CABA                          | F    |       26808 |       5507 |        457 |              0.014 |              0.017 |            0.378 |           0.205 |                  0.014 |           0.006 |
| CABA                          | M    |       26266 |       5619 |        570 |              0.018 |              0.022 |            0.416 |           0.214 |                  0.024 |           0.011 |
| Chaco                         | F    |        1674 |        170 |         50 |              0.023 |              0.030 |            0.164 |           0.102 |                  0.049 |           0.019 |
| Chaco                         | M    |        1650 |        178 |         84 |              0.039 |              0.051 |            0.162 |           0.108 |                  0.067 |           0.031 |
| Jujuy                         | M    |         963 |         12 |         18 |              0.007 |              0.019 |            0.233 |           0.012 |                  0.003 |           0.003 |
| Córdoba                       | M    |         891 |         60 |         22 |              0.014 |              0.025 |            0.064 |           0.067 |                  0.022 |           0.012 |
| Córdoba                       | F    |         879 |         76 |         21 |              0.013 |              0.024 |            0.061 |           0.086 |                  0.019 |           0.007 |
| Río Negro                     | M    |         787 |        306 |         41 |              0.047 |              0.052 |            0.259 |           0.389 |                  0.038 |           0.028 |
| Río Negro                     | F    |         785 |        308 |         23 |              0.027 |              0.029 |            0.226 |           0.392 |                  0.015 |           0.008 |
| SIN ESPECIFICAR               | F    |         697 |         63 |          0 |              0.000 |              0.000 |            0.413 |           0.090 |                  0.004 |           0.000 |
| Neuquén                       | M    |         530 |        344 |         10 |              0.017 |              0.019 |            0.250 |           0.649 |                  0.011 |           0.006 |
| Neuquén                       | F    |         521 |        381 |         13 |              0.022 |              0.025 |            0.250 |           0.731 |                  0.012 |           0.006 |
| SIN ESPECIFICAR               | M    |         481 |         62 |          3 |              0.005 |              0.006 |            0.455 |           0.129 |                  0.010 |           0.008 |
| Santa Fe                      | F    |         478 |         44 |          2 |              0.003 |              0.004 |            0.049 |           0.092 |                  0.019 |           0.004 |
| Jujuy                         | F    |         474 |          3 |         13 |              0.006 |              0.027 |            0.154 |           0.006 |                  0.002 |           0.002 |
| Santa Fe                      | M    |         461 |         70 |          7 |              0.011 |              0.015 |            0.051 |           0.152 |                  0.037 |           0.015 |
| Mendoza                       | M    |         414 |        198 |         18 |              0.029 |              0.043 |            0.141 |           0.478 |                  0.039 |           0.014 |
| Mendoza                       | F    |         398 |        193 |          4 |              0.007 |              0.010 |            0.132 |           0.485 |                  0.013 |           0.003 |
| Entre Ríos                    | M    |         387 |         88 |          3 |              0.006 |              0.008 |            0.181 |           0.227 |                  0.008 |           0.003 |
| Entre Ríos                    | F    |         373 |         70 |          3 |              0.006 |              0.008 |            0.163 |           0.188 |                  0.008 |           0.003 |
| Buenos Aires                  | NR   |         350 |         36 |          6 |              0.010 |              0.017 |            0.372 |           0.103 |                  0.029 |           0.014 |
| Tierra del Fuego              | M    |         220 |          7 |          2 |              0.007 |              0.009 |            0.172 |           0.032 |                  0.014 |           0.014 |
| CABA                          | NR   |         219 |         68 |         13 |              0.035 |              0.059 |            0.369 |           0.311 |                  0.050 |           0.037 |
| Santa Cruz                    | M    |         182 |         17 |          1 |              0.005 |              0.005 |            0.286 |           0.093 |                  0.022 |           0.011 |
| Santa Cruz                    | F    |         148 |         13 |          0 |              0.000 |              0.000 |            0.290 |           0.088 |                  0.007 |           0.007 |
| Chubut                        | M    |         141 |         10 |          1 |              0.004 |              0.007 |            0.100 |           0.071 |                  0.014 |           0.014 |
| Salta                         | M    |         137 |         50 |          2 |              0.009 |              0.015 |            0.122 |           0.365 |                  0.022 |           0.007 |
| La Rioja                      | F    |         131 |         14 |          7 |              0.044 |              0.053 |            0.079 |           0.107 |                  0.038 |           0.015 |
| Chubut                        | F    |         118 |          4 |          1 |              0.005 |              0.008 |            0.092 |           0.034 |                  0.017 |           0.008 |
| Tierra del Fuego              | F    |         109 |          3 |          0 |              0.000 |              0.000 |            0.104 |           0.028 |                  0.000 |           0.000 |
| La Rioja                      | M    |         108 |         10 |          8 |              0.057 |              0.074 |            0.061 |           0.093 |                  0.009 |           0.000 |
| Salta                         | F    |          96 |         33 |          0 |              0.000 |              0.000 |            0.158 |           0.344 |                  0.010 |           0.000 |
| Corrientes                    | M    |          87 |          3 |          1 |              0.005 |              0.011 |            0.039 |           0.034 |                  0.011 |           0.011 |
| Tucumán                       | M    |          71 |         17 |          2 |              0.006 |              0.028 |            0.011 |           0.239 |                  0.042 |           0.000 |
| Formosa                       | M    |          66 |          1 |          0 |              0.000 |              0.000 |            0.137 |           0.015 |                  0.000 |           0.000 |
| Corrientes                    | F    |          51 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.020 |           0.000 |
| Tucumán                       | F    |          48 |         15 |          2 |              0.009 |              0.042 |            0.012 |           0.312 |                  0.125 |           0.042 |
| Catamarca                     | M    |          37 |          0 |          0 |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          37 |          2 |          0 |              0.000 |              0.000 |            0.012 |           0.054 |                  0.027 |           0.000 |
| Misiones                      | M    |          29 |         16 |          1 |              0.013 |              0.034 |            0.028 |           0.552 |                  0.138 |           0.069 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      | F    |          21 |          0 |          0 |              0.000 |              0.000 |            0.065 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.014 |              0.050 |            0.022 |           0.650 |                  0.100 |           0.050 |
| La Pampa                      | M    |          19 |          1 |          0 |              0.000 |              0.000 |            0.058 |           0.053 |                  0.000 |           0.000 |
| San Juan                      | M    |          16 |          3 |          0 |              0.000 |              0.000 |            0.029 |           0.188 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          16 |          2 |          1 |              0.011 |              0.062 |            0.013 |           0.125 |                  0.062 |           0.062 |
| San Luis                      | M    |          15 |          7 |          0 |              0.000 |              0.000 |            0.036 |           0.467 |                  0.067 |           0.000 |
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
