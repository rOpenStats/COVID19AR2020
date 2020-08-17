
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
    covid19.curator <- COVID19ARCurator$new(report.date = Sys.Date() -1 , 
                                            download.new.data = FALSE)

    dummy <- covid19.curator$loadData()
    #> INFO  [09:16:59.736] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:17:06.254] Normalize 
    #> INFO  [09:17:07.809] checkSoundness 
    #> INFO  [09:17:08.808] Mutating data 
    #> INFO  [09:20:05.237] Last days rows {date: 2020-08-15, n: 18721}
    #> INFO  [09:20:05.240] Last days rows {date: 2020-08-16, n: 7352}
    #> INFO  [09:20:05.242] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-16"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-16"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-16"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      294540 |       5703 |              0.015 |              0.019 |                       175 | 838189 |            0.351 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      182237 |       3316 |              0.013 |              0.018 |                       173 | 442355 |            0.412 |
| CABA                          |       76886 |       1693 |              0.018 |              0.022 |                       170 | 190629 |            0.403 |
| Jujuy                         |        4766 |         89 |              0.010 |              0.019 |                       149 |  14806 |            0.322 |
| Córdoba                       |        4591 |         81 |              0.013 |              0.018 |                       160 |  39487 |            0.116 |
| Chaco                         |        4436 |        181 |              0.032 |              0.041 |                       158 |  27581 |            0.161 |
| Río Negro                     |        3854 |        108 |              0.025 |              0.028 |                       153 |  11176 |            0.345 |
| Mendoza                       |        3327 |         77 |              0.018 |              0.023 |                       159 |  11980 |            0.278 |
| Santa Fe                      |        3293 |         32 |              0.007 |              0.010 |                       156 |  27641 |            0.119 |
| Neuquén                       |        1834 |         31 |              0.014 |              0.017 |                       155 |   6129 |            0.299 |
| Entre Ríos                    |        1631 |         23 |              0.011 |              0.014 |                       153 |   6981 |            0.234 |
| SIN ESPECIFICAR               |        1454 |          5 |              0.003 |              0.003 |                       146 |   3301 |            0.440 |
| Tierra del Fuego              |        1408 |         17 |              0.010 |              0.012 |                       152 |   4601 |            0.306 |
| Salta                         |        1082 |         12 |              0.008 |              0.011 |                       148 |   3132 |            0.345 |
| Santa Cruz                    |        1033 |          4 |              0.004 |              0.004 |                       145 |   2895 |            0.357 |
| La Rioja                      |         751 |         21 |              0.024 |              0.028 |                       144 |   5092 |            0.147 |
| Tucumán                       |         603 |          5 |              0.002 |              0.008 |                       151 |  14775 |            0.041 |
| Chubut                        |         402 |          4 |              0.005 |              0.010 |                       138 |   3767 |            0.107 |
| Santiago del Estero           |         284 |          0 |              0.000 |              0.000 |                       139 |   6390 |            0.044 |
| Corrientes                    |         228 |          2 |              0.004 |              0.009 |                       150 |   5471 |            0.042 |
| La Pampa                      |         184 |          0 |              0.000 |              0.000 |                       133 |   1932 |            0.095 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      182237 | 442355 |       3316 |               14.2 |              0.013 |              0.018 |            0.412 |           0.094 |                  0.012 |           0.005 |
| CABA                          |       76886 | 190629 |       1693 |               15.2 |              0.018 |              0.022 |            0.403 |           0.184 |                  0.018 |           0.009 |
| Jujuy                         |        4766 |  14806 |         89 |               12.1 |              0.010 |              0.019 |            0.322 |           0.006 |                  0.001 |           0.001 |
| Córdoba                       |        4591 |  39487 |         81 |               18.3 |              0.013 |              0.018 |            0.116 |           0.041 |                  0.012 |           0.007 |
| Chaco                         |        4436 |  27581 |        181 |               14.9 |              0.032 |              0.041 |            0.161 |           0.112 |                  0.065 |           0.028 |
| Río Negro                     |        3854 |  11176 |        108 |               13.5 |              0.025 |              0.028 |            0.345 |           0.285 |                  0.015 |           0.010 |
| Mendoza                       |        3327 |  11980 |         77 |               12.0 |              0.018 |              0.023 |            0.278 |           0.276 |                  0.014 |           0.004 |
| Santa Fe                      |        3293 |  27641 |         32 |               13.0 |              0.007 |              0.010 |            0.119 |           0.063 |                  0.014 |           0.006 |
| Neuquén                       |        1834 |   6129 |         31 |               16.7 |              0.014 |              0.017 |            0.299 |           0.623 |                  0.016 |           0.009 |
| Entre Ríos                    |        1631 |   6981 |         23 |               11.3 |              0.011 |              0.014 |            0.234 |           0.153 |                  0.010 |           0.003 |
| SIN ESPECIFICAR               |        1454 |   3301 |          5 |               25.6 |              0.003 |              0.003 |            0.440 |           0.065 |                  0.007 |           0.004 |
| Tierra del Fuego              |        1408 |   4601 |         17 |               13.0 |              0.010 |              0.012 |            0.306 |           0.021 |                  0.009 |           0.008 |
| Salta                         |        1082 |   3132 |         12 |                7.6 |              0.008 |              0.011 |            0.345 |           0.230 |                  0.018 |           0.009 |
| Santa Cruz                    |        1033 |   2895 |          4 |               11.2 |              0.004 |              0.004 |            0.357 |           0.050 |                  0.015 |           0.009 |
| La Rioja                      |         751 |   5092 |         21 |               13.0 |              0.024 |              0.028 |            0.147 |           0.036 |                  0.008 |           0.003 |
| Tucumán                       |         603 |  14775 |          5 |               12.8 |              0.002 |              0.008 |            0.041 |           0.204 |                  0.027 |           0.005 |
| Chubut                        |         402 |   3767 |          4 |               21.5 |              0.005 |              0.010 |            0.107 |           0.050 |                  0.012 |           0.010 |
| Santiago del Estero           |         284 |   6390 |          0 |                NaN |              0.000 |              0.000 |            0.044 |           0.007 |                  0.004 |           0.000 |
| Corrientes                    |         228 |   5471 |          2 |               12.0 |              0.004 |              0.009 |            0.042 |           0.031 |                  0.013 |           0.009 |
| La Pampa                      |         184 |   1932 |          0 |                NaN |              0.000 |              0.000 |            0.095 |           0.082 |                  0.011 |           0.000 |
| Formosa                       |          80 |    997 |          0 |                NaN |              0.000 |              0.000 |            0.080 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          62 |   2445 |          0 |                NaN |              0.000 |              0.000 |            0.025 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          59 |   2592 |          2 |                6.5 |              0.019 |              0.034 |            0.023 |           0.508 |                  0.102 |           0.051 |
| San Luis                      |          34 |    947 |          0 |                NaN |              0.000 |              0.000 |            0.036 |           0.294 |                  0.029 |           0.000 |
| San Juan                      |          21 |   1087 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.238 |                  0.048 |           0.000 |

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
    #> INFO  [09:20:48.438] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |     86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-12              |                        40 |          98 |    667 |         66 |          9 |              0.065 |              0.092 |            0.147 |           0.673 |                  0.122 |           0.061 |
|             12 | 2020-08-12              |                        64 |         415 |   2050 |        256 |         17 |              0.033 |              0.041 |            0.202 |           0.617 |                  0.092 |           0.053 |
|             13 | 2020-08-12              |                        98 |        1091 |   5518 |        601 |         63 |              0.049 |              0.058 |            0.198 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-08-15              |                       133 |        1790 |  11539 |        979 |        114 |              0.053 |              0.064 |            0.155 |           0.547 |                  0.094 |           0.056 |
|             15 | 2020-08-16              |                       158 |        2464 |  20260 |       1331 |        179 |              0.060 |              0.073 |            0.122 |           0.540 |                  0.089 |           0.050 |
|             16 | 2020-08-16              |                       169 |        3281 |  31868 |       1685 |        238 |              0.058 |              0.073 |            0.103 |           0.514 |                  0.080 |           0.044 |
|             17 | 2020-08-16              |                       172 |        4426 |  45925 |       2213 |        344 |              0.063 |              0.078 |            0.096 |           0.500 |                  0.072 |           0.038 |
|             18 | 2020-08-16              |                       172 |        5450 |  59121 |       2618 |        421 |              0.062 |              0.077 |            0.092 |           0.480 |                  0.064 |           0.034 |
|             19 | 2020-08-16              |                       172 |        6919 |  73258 |       3215 |        504 |              0.059 |              0.073 |            0.094 |           0.465 |                  0.060 |           0.031 |
|             20 | 2020-08-16              |                       172 |        9344 |  90633 |       4067 |        606 |              0.054 |              0.065 |            0.103 |           0.435 |                  0.055 |           0.028 |
|             21 | 2020-08-16              |                       172 |       13763 | 114074 |       5406 |        763 |              0.046 |              0.055 |            0.121 |           0.393 |                  0.048 |           0.024 |
|             22 | 2020-08-16              |                       172 |       19038 | 139464 |       6859 |        959 |              0.042 |              0.050 |            0.137 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-08-16              |                       172 |       25539 | 167743 |       8399 |       1196 |              0.040 |              0.047 |            0.152 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-16              |                       172 |       35218 | 202854 |      10552 |       1476 |              0.036 |              0.042 |            0.174 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-16              |                       172 |       48108 | 244259 |      12917 |       1839 |              0.033 |              0.038 |            0.197 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-08-16              |                       172 |       65901 | 296249 |      15991 |       2322 |              0.030 |              0.035 |            0.222 |           0.243 |                  0.028 |           0.012 |
|             27 | 2020-08-16              |                       172 |       84648 | 346973 |      18770 |       2858 |              0.029 |              0.034 |            0.244 |           0.222 |                  0.026 |           0.011 |
|             28 | 2020-08-16              |                       173 |      107999 | 405696 |      22034 |       3508 |              0.028 |              0.032 |            0.266 |           0.204 |                  0.023 |           0.010 |
|             29 | 2020-08-16              |                       174 |      136665 | 476417 |      25518 |       4184 |              0.026 |              0.031 |            0.287 |           0.187 |                  0.021 |           0.010 |
|             30 | 2020-08-16              |                       174 |      173771 | 560972 |      29009 |       4818 |              0.023 |              0.028 |            0.310 |           0.167 |                  0.019 |           0.009 |
|             31 | 2020-08-29              |                       175 |      211996 | 647701 |      31908 |       5241 |              0.021 |              0.025 |            0.327 |           0.151 |                  0.017 |           0.008 |
|             32 | 2020-08-29              |                       175 |      257930 | 749565 |      34723 |       5601 |              0.018 |              0.022 |            0.344 |           0.135 |                  0.016 |           0.007 |
|             33 | 2020-08-29              |                       175 |      293553 | 836118 |      36341 |       5699 |              0.015 |              0.019 |            0.351 |           0.124 |                  0.014 |           0.006 |
|             34 | 2020-08-29              |                       175 |      294540 | 838189 |      36355 |       5703 |              0.015 |              0.019 |            0.351 |           0.123 |                  0.014 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:21:52.927] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:22:31.206] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:22:50.632] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:22:53.395] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:22:58.462] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:23:01.161] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:23:07.675] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:23:10.856] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:23:14.043] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:23:16.169] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:23:19.795] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:23:22.393] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:23:25.395] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:23:29.218] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:23:32.016] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:23:35.092] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:23:38.753] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:23:41.328] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:23:43.638] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:23:46.133] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:23:48.658] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:23:53.320] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:23:56.123] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:23:58.784] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:24:01.636] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 560
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
    #> [1] 65
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |       93363 |       9352 |       1873 |              0.015 |              0.020 |            0.430 |           0.100 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |       88215 |       7794 |       1421 |              0.012 |              0.016 |            0.394 |           0.088 |                  0.009 |           0.004 |
| CABA                          | F    |       38831 |       6960 |        768 |              0.016 |              0.020 |            0.384 |           0.179 |                  0.014 |           0.006 |
| CABA                          | M    |       37758 |       7108 |        907 |              0.020 |              0.024 |            0.425 |           0.188 |                  0.023 |           0.011 |
| Jujuy                         | M    |        2950 |         22 |         55 |              0.011 |              0.019 |            0.357 |           0.007 |                  0.001 |           0.001 |
| Córdoba                       | M    |        2294 |         90 |         42 |              0.014 |              0.018 |            0.119 |           0.039 |                  0.012 |           0.007 |
| Córdoba                       | F    |        2289 |         95 |         39 |              0.012 |              0.017 |            0.114 |           0.042 |                  0.011 |           0.006 |
| Chaco                         | M    |        2219 |        248 |        111 |              0.039 |              0.050 |            0.162 |           0.112 |                  0.072 |           0.033 |
| Chaco                         | F    |        2215 |        249 |         70 |              0.024 |              0.032 |            0.160 |           0.112 |                  0.058 |           0.022 |
| Río Negro                     | F    |        1989 |        554 |         42 |              0.019 |              0.021 |            0.335 |           0.279 |                  0.009 |           0.004 |
| Río Negro                     | M    |        1864 |        545 |         66 |              0.032 |              0.035 |            0.357 |           0.292 |                  0.022 |           0.017 |
| Jujuy                         | F    |        1811 |          7 |         34 |              0.009 |              0.019 |            0.278 |           0.004 |                  0.001 |           0.001 |
| Mendoza                       | F    |        1694 |        466 |         26 |              0.012 |              0.015 |            0.278 |           0.275 |                  0.007 |           0.001 |
| Santa Fe                      | F    |        1684 |         86 |         14 |              0.006 |              0.008 |            0.116 |           0.051 |                  0.011 |           0.004 |
| Mendoza                       | M    |        1616 |        447 |         49 |              0.023 |              0.030 |            0.278 |           0.277 |                  0.021 |           0.007 |
| Santa Fe                      | M    |        1609 |        120 |         18 |              0.008 |              0.011 |            0.123 |           0.075 |                  0.017 |           0.009 |
| Neuquén                       | F    |         923 |        553 |         17 |              0.016 |              0.018 |            0.296 |           0.599 |                  0.017 |           0.010 |
| Neuquén                       | M    |         911 |        590 |         14 |              0.013 |              0.015 |            0.303 |           0.648 |                  0.014 |           0.009 |
| SIN ESPECIFICAR               | F    |         854 |         46 |          1 |              0.001 |              0.001 |            0.430 |           0.054 |                  0.004 |           0.000 |
| Entre Ríos                    | F    |         823 |        121 |          7 |              0.007 |              0.009 |            0.228 |           0.147 |                  0.010 |           0.001 |
| Entre Ríos                    | M    |         807 |        129 |         16 |              0.016 |              0.020 |            0.240 |           0.160 |                  0.011 |           0.005 |
| Tierra del Fuego              | M    |         805 |         20 |         11 |              0.012 |              0.014 |            0.333 |           0.025 |                  0.012 |           0.011 |
| Buenos Aires                  | NR   |         659 |         66 |         22 |              0.021 |              0.033 |            0.431 |           0.100 |                  0.026 |           0.012 |
| Salta                         | M    |         627 |        146 |         11 |              0.012 |              0.018 |            0.328 |           0.233 |                  0.026 |           0.016 |
| Tierra del Fuego              | F    |         602 |         10 |          6 |              0.008 |              0.010 |            0.276 |           0.017 |                  0.003 |           0.003 |
| SIN ESPECIFICAR               | M    |         596 |         48 |          3 |              0.004 |              0.005 |            0.460 |           0.081 |                  0.010 |           0.008 |
| Santa Cruz                    | M    |         527 |         25 |          2 |              0.004 |              0.004 |            0.364 |           0.047 |                  0.015 |           0.008 |
| Santa Cruz                    | F    |         505 |         27 |          2 |              0.004 |              0.004 |            0.349 |           0.053 |                  0.014 |           0.010 |
| Salta                         | F    |         454 |        103 |          1 |              0.002 |              0.002 |            0.375 |           0.227 |                  0.007 |           0.000 |
| La Rioja                      | M    |         390 |         12 |         13 |              0.029 |              0.033 |            0.147 |           0.031 |                  0.003 |           0.000 |
| La Rioja                      | F    |         358 |         15 |          8 |              0.020 |              0.022 |            0.148 |           0.042 |                  0.014 |           0.006 |
| Tucumán                       | M    |         323 |         66 |          3 |              0.002 |              0.009 |            0.035 |           0.204 |                  0.019 |           0.003 |
| CABA                          | NR   |         297 |         80 |         18 |              0.035 |              0.061 |            0.392 |           0.269 |                  0.044 |           0.030 |
| Tucumán                       | F    |         280 |         57 |          2 |              0.002 |              0.007 |            0.050 |           0.204 |                  0.036 |           0.007 |
| Chubut                        | M    |         221 |         14 |          2 |              0.005 |              0.009 |            0.115 |           0.063 |                  0.014 |           0.014 |
| Chubut                        | F    |         175 |          5 |          2 |              0.006 |              0.011 |            0.097 |           0.029 |                  0.011 |           0.006 |
| Santiago del Estero           | M    |         159 |          2 |          0 |              0.000 |              0.000 |            0.036 |           0.013 |                  0.006 |           0.000 |
| Corrientes                    | M    |         131 |          6 |          2 |              0.007 |              0.015 |            0.042 |           0.046 |                  0.015 |           0.015 |
| Santiago del Estero           | F    |         124 |          0 |          0 |              0.000 |              0.000 |            0.069 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      | F    |         105 |         10 |          0 |              0.000 |              0.000 |            0.099 |           0.095 |                  0.010 |           0.000 |
| Corrientes                    | F    |          97 |          1 |          0 |              0.000 |              0.000 |            0.041 |           0.010 |                  0.010 |           0.000 |
| La Pampa                      | M    |          79 |          5 |          0 |              0.000 |              0.000 |            0.091 |           0.063 |                  0.013 |           0.000 |
| Formosa                       | M    |          66 |          0 |          0 |              0.000 |              0.000 |            0.110 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          40 |          0 |          0 |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          36 |         16 |          1 |              0.015 |              0.028 |            0.026 |           0.444 |                  0.111 |           0.056 |
| San Luis                      | M    |          24 |          7 |          0 |              0.000 |              0.000 |            0.046 |           0.292 |                  0.042 |           0.000 |
| Misiones                      | F    |          23 |         14 |          1 |              0.024 |              0.043 |            0.019 |           0.609 |                  0.087 |           0.043 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.025 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          17 |          5 |          2 |              0.065 |              0.118 |            0.202 |           0.294 |                  0.000 |           0.000 |
| San Juan                      | M    |          15 |          2 |          0 |              0.000 |              0.000 |            0.024 |           0.133 |                  0.000 |           0.000 |
| Formosa                       | F    |          14 |          1 |          0 |              0.000 |              0.000 |            0.035 |           0.071 |                  0.000 |           0.000 |
| San Luis                      | F    |          10 |          3 |          0 |              0.000 |              0.000 |            0.024 |           0.300 |                  0.000 |           0.000 |


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))

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
    #> Warning: Removed 33 rows containing missing values (position_stack).

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
