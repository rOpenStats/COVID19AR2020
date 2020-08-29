
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
    #> INFO  [09:12:29.602] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:12:36.361] Normalize 
    #> INFO  [09:12:38.233] checkSoundness 
    #> INFO  [09:12:39.129] Mutating data 
    #> INFO  [09:15:31.395] Last days rows {date: 2020-08-27, n: 32193}
    #> INFO  [09:15:31.399] Last days rows {date: 2020-08-28, n: 20257}
    #> INFO  [09:15:31.402] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-28"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-28"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-28"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-08-29              |      392005 |       8271 |              0.016 |              0.021 |                       188 | 1053625 |            0.372 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      243256 |       4980 |              0.016 |              0.020 |                       185 | 562922 |            0.432 |
| CABA                          |       91108 |       2128 |              0.020 |              0.023 |                       182 | 230124 |            0.396 |
| Jujuy                         |        7619 |        229 |              0.018 |              0.030 |                       162 |  20149 |            0.378 |
| Córdoba                       |        7503 |        113 |              0.012 |              0.015 |                       172 |  48024 |            0.156 |
| Santa Fe                      |        6741 |         77 |              0.008 |              0.011 |                       168 |  36100 |            0.187 |
| Mendoza                       |        5940 |        122 |              0.014 |              0.021 |                       171 |  17592 |            0.338 |
| Río Negro                     |        5591 |        161 |              0.026 |              0.029 |                       165 |  14399 |            0.388 |
| Chaco                         |        5183 |        206 |              0.031 |              0.040 |                       170 |  31952 |            0.162 |
| Entre Ríos                    |        2936 |         37 |              0.010 |              0.013 |                       165 |   9551 |            0.307 |
| Neuquén                       |        2768 |         47 |              0.014 |              0.017 |                       167 |   7969 |            0.347 |
| Salta                         |        2723 |         39 |              0.009 |              0.014 |                       160 |   6140 |            0.443 |
| Tierra del Fuego              |        1908 |         27 |              0.012 |              0.014 |                       163 |   5587 |            0.342 |
| SIN ESPECIFICAR               |        1665 |          9 |              0.004 |              0.005 |                       158 |   3776 |            0.441 |
| Santa Cruz                    |        1612 |         14 |              0.007 |              0.009 |                       157 |   4381 |            0.368 |
| Tucumán                       |        1600 |         13 |              0.002 |              0.008 |                       163 |  16960 |            0.094 |
| La Rioja                      |        1332 |         53 |              0.037 |              0.040 |                       157 |   6362 |            0.209 |
| Santiago del Estero           |         789 |          4 |              0.002 |              0.005 |                       151 |   8267 |            0.095 |
| Chubut                        |         764 |          6 |              0.004 |              0.008 |                       151 |   4928 |            0.155 |
| Corrientes                    |         313 |          2 |              0.003 |              0.006 |                       162 |   6783 |            0.046 |
| La Pampa                      |         194 |          1 |              0.004 |              0.005 |                       145 |   2365 |            0.082 |
| San Juan                      |         192 |          0 |              0.000 |              0.000 |                       156 |   1336 |            0.144 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      243256 | 562922 |       4980 |               14.7 |              0.016 |              0.020 |            0.432 |           0.085 |                  0.011 |           0.005 |
| CABA                          |       91108 | 230124 |       2128 |               15.9 |              0.020 |              0.023 |            0.396 |           0.173 |                  0.018 |           0.009 |
| Jujuy                         |        7619 |  20149 |        229 |               13.6 |              0.018 |              0.030 |            0.378 |           0.007 |                  0.001 |           0.001 |
| Córdoba                       |        7503 |  48024 |        113 |               17.4 |              0.012 |              0.015 |            0.156 |           0.030 |                  0.008 |           0.005 |
| Santa Fe                      |        6741 |  36100 |         77 |               12.6 |              0.008 |              0.011 |            0.187 |           0.049 |                  0.011 |           0.005 |
| Mendoza                       |        5940 |  17592 |        122 |               11.5 |              0.014 |              0.021 |            0.338 |           0.205 |                  0.011 |           0.004 |
| Río Negro                     |        5591 |  14399 |        161 |               12.3 |              0.026 |              0.029 |            0.388 |           0.280 |                  0.013 |           0.009 |
| Chaco                         |        5183 |  31952 |        206 |               14.8 |              0.031 |              0.040 |            0.162 |           0.113 |                  0.063 |           0.027 |
| Entre Ríos                    |        2936 |   9551 |         37 |               10.6 |              0.010 |              0.013 |            0.307 |           0.117 |                  0.009 |           0.002 |
| Neuquén                       |        2768 |   7969 |         47 |               16.5 |              0.014 |              0.017 |            0.347 |           0.583 |                  0.014 |           0.010 |
| Salta                         |        2723 |   6140 |         39 |                8.0 |              0.009 |              0.014 |            0.443 |           0.165 |                  0.015 |           0.006 |
| Tierra del Fuego              |        1908 |   5587 |         27 |               12.6 |              0.012 |              0.014 |            0.342 |           0.021 |                  0.008 |           0.007 |
| SIN ESPECIFICAR               |        1665 |   3776 |          9 |               20.7 |              0.004 |              0.005 |            0.441 |           0.063 |                  0.007 |           0.004 |
| Santa Cruz                    |        1612 |   4381 |         14 |               13.4 |              0.007 |              0.009 |            0.368 |           0.050 |                  0.015 |           0.011 |
| Tucumán                       |        1600 |  16960 |         13 |               14.0 |              0.002 |              0.008 |            0.094 |           0.108 |                  0.013 |           0.003 |
| La Rioja                      |        1332 |   6362 |         53 |               11.1 |              0.037 |              0.040 |            0.209 |           0.023 |                  0.005 |           0.002 |
| Santiago del Estero           |         789 |   8267 |          4 |                2.7 |              0.002 |              0.005 |            0.095 |           0.006 |                  0.003 |           0.000 |
| Chubut                        |         764 |   4928 |          6 |               16.0 |              0.004 |              0.008 |            0.155 |           0.033 |                  0.009 |           0.008 |
| Corrientes                    |         313 |   6783 |          2 |               12.0 |              0.003 |              0.006 |            0.046 |           0.022 |                  0.010 |           0.003 |
| La Pampa                      |         194 |   2365 |          1 |               27.0 |              0.004 |              0.005 |            0.082 |           0.082 |                  0.015 |           0.005 |
| San Juan                      |         192 |   1336 |          0 |                NaN |              0.000 |              0.000 |            0.144 |           0.047 |                  0.010 |           0.000 |
| Formosa                       |          84 |   1055 |          1 |               12.0 |              0.009 |              0.012 |            0.080 |           0.012 |                  0.000 |           0.000 |
| Catamarca                     |          64 |   2932 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| San Luis                      |          61 |   1074 |          0 |                NaN |              0.000 |              0.000 |            0.057 |           0.246 |                  0.016 |           0.000 |
| Misiones                      |          59 |   2897 |          2 |                6.5 |              0.014 |              0.034 |            0.020 |           0.508 |                  0.102 |           0.051 |

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
    #> INFO  [09:16:26.883] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 26
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |      86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-25              |                        41 |          98 |     668 |         66 |          9 |              0.065 |              0.092 |            0.147 |           0.673 |                  0.122 |           0.061 |
|             12 | 2020-08-25              |                        68 |         417 |    2053 |        257 |         17 |              0.033 |              0.041 |            0.203 |           0.616 |                  0.091 |           0.053 |
|             13 | 2020-08-25              |                       103 |        1093 |    5524 |        602 |         64 |              0.050 |              0.059 |            0.198 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-08-28              |                       143 |        1801 |   11547 |        984 |        115 |              0.053 |              0.064 |            0.156 |           0.546 |                  0.093 |           0.056 |
|             15 | 2020-08-28              |                       168 |        2486 |   20270 |       1339 |        180 |              0.060 |              0.072 |            0.123 |           0.539 |                  0.088 |           0.050 |
|             16 | 2020-08-28              |                       181 |        3321 |   31882 |       1698 |        241 |              0.058 |              0.073 |            0.104 |           0.511 |                  0.079 |           0.043 |
|             17 | 2020-08-28              |                       184 |        4499 |   45947 |       2235 |        351 |              0.063 |              0.078 |            0.098 |           0.497 |                  0.071 |           0.037 |
|             18 | 2020-08-28              |                       184 |        5545 |   59145 |       2648 |        433 |              0.064 |              0.078 |            0.094 |           0.478 |                  0.064 |           0.034 |
|             19 | 2020-08-28              |                       184 |        7046 |   73286 |       3253 |        518 |              0.060 |              0.074 |            0.096 |           0.462 |                  0.059 |           0.031 |
|             20 | 2020-08-28              |                       184 |        9498 |   90727 |       4116 |        628 |              0.055 |              0.066 |            0.105 |           0.433 |                  0.054 |           0.028 |
|             21 | 2020-08-28              |                       184 |       13956 |  114181 |       5467 |        800 |              0.048 |              0.057 |            0.122 |           0.392 |                  0.048 |           0.024 |
|             22 | 2020-08-28              |                       184 |       19283 |  139594 |       6935 |       1008 |              0.044 |              0.052 |            0.138 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-08-28              |                       184 |       25853 |  167903 |       8501 |       1260 |              0.041 |              0.049 |            0.154 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-28              |                       184 |       35649 |  203068 |      10677 |       1558 |              0.037 |              0.044 |            0.176 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-28              |                       184 |       48629 |  244535 |      13073 |       1950 |              0.035 |              0.040 |            0.199 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-08-28              |                       184 |       66571 |  296661 |      16178 |       2478 |              0.032 |              0.037 |            0.224 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-08-28              |                       184 |       85485 |  347739 |      19013 |       3077 |              0.031 |              0.036 |            0.246 |           0.222 |                  0.026 |           0.011 |
|             28 | 2020-08-28              |                       185 |      109009 |  406742 |      22360 |       3832 |              0.030 |              0.035 |            0.268 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-08-28              |                       187 |      137949 |  478035 |      25972 |       4685 |              0.029 |              0.034 |            0.289 |           0.188 |                  0.022 |           0.010 |
|             30 | 2020-08-28              |                       187 |      175666 |  563648 |      29621 |       5605 |              0.027 |              0.032 |            0.312 |           0.169 |                  0.020 |           0.009 |
|             31 | 2020-08-29              |                       188 |      214399 |  651825 |      32803 |       6401 |              0.025 |              0.030 |            0.329 |           0.153 |                  0.018 |           0.008 |
|             32 | 2020-08-29              |                       188 |      262586 |  757765 |      36329 |       7253 |              0.023 |              0.028 |            0.347 |           0.138 |                  0.017 |           0.008 |
|             33 | 2020-08-29              |                       188 |      307441 |  867689 |      39481 |       7806 |              0.021 |              0.025 |            0.354 |           0.128 |                  0.015 |           0.007 |
|             34 | 2020-08-29              |                       188 |      353583 |  972609 |      41950 |       8165 |              0.019 |              0.023 |            0.364 |           0.119 |                  0.014 |           0.007 |
|             35 | 2020-08-29              |                       188 |      392005 | 1053625 |      43447 |       8271 |              0.016 |              0.021 |            0.372 |           0.111 |                  0.013 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:17:44.414] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:18:26.266] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:18:46.082] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:18:47.972] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:18:52.764] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:18:55.205] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:19:01.668] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:19:04.637] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:19:07.674] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:19:09.823] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:19:13.470] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:19:15.992] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:19:18.731] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:19:22.111] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:19:24.621] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:19:27.523] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:19:30.896] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:19:33.747] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:19:36.019] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:19:38.355] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:19:40.744] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:19:45.651] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:19:48.461] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:19:50.910] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:19:53.666] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 590
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
    #> [1] 66
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      124440 |      11327 |       2854 |              0.018 |              0.023 |            0.450 |           0.091 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |      117928 |       9364 |       2095 |              0.014 |              0.018 |            0.415 |           0.079 |                  0.009 |           0.003 |
| CABA                          | F    |       45902 |       7670 |        976 |              0.018 |              0.021 |            0.375 |           0.167 |                  0.013 |           0.006 |
| CABA                          | M    |       44851 |       7992 |       1130 |              0.021 |              0.025 |            0.420 |           0.178 |                  0.022 |           0.011 |
| Jujuy                         | M    |        4513 |         37 |        140 |              0.020 |              0.031 |            0.403 |           0.008 |                  0.001 |           0.001 |
| Córdoba                       | F    |        3766 |        115 |         50 |              0.010 |              0.013 |            0.153 |           0.031 |                  0.008 |           0.004 |
| Córdoba                       | M    |        3723 |        108 |         63 |              0.013 |              0.017 |            0.159 |           0.029 |                  0.008 |           0.005 |
| Santa Fe                      | F    |        3418 |        145 |         30 |              0.006 |              0.009 |            0.179 |           0.042 |                  0.010 |           0.004 |
| Santa Fe                      | M    |        3322 |        185 |         47 |              0.011 |              0.014 |            0.196 |           0.056 |                  0.013 |           0.008 |
| Jujuy                         | F    |        3095 |         16 |         88 |              0.016 |              0.028 |            0.347 |           0.005 |                  0.001 |           0.001 |
| Mendoza                       | F    |        3005 |        619 |         40 |              0.009 |              0.013 |            0.334 |           0.206 |                  0.005 |           0.001 |
| Mendoza                       | M    |        2914 |        595 |         80 |              0.018 |              0.027 |            0.344 |           0.204 |                  0.018 |           0.008 |
| Río Negro                     | F    |        2906 |        789 |         65 |              0.020 |              0.022 |            0.378 |           0.272 |                  0.008 |           0.004 |
| Río Negro                     | M    |        2684 |        773 |         96 |              0.032 |              0.036 |            0.400 |           0.288 |                  0.020 |           0.014 |
| Chaco                         | M    |        2619 |        305 |        132 |              0.040 |              0.050 |            0.165 |           0.116 |                  0.071 |           0.033 |
| Chaco                         | F    |        2562 |        280 |         74 |              0.022 |              0.029 |            0.159 |           0.109 |                  0.053 |           0.021 |
| Salta                         | M    |        1591 |        259 |         30 |              0.013 |              0.019 |            0.442 |           0.163 |                  0.019 |           0.009 |
| Entre Ríos                    | F    |        1524 |        175 |         15 |              0.008 |              0.010 |            0.303 |           0.115 |                  0.007 |           0.001 |
| Neuquén                       | M    |        1415 |        818 |         26 |              0.015 |              0.018 |            0.359 |           0.578 |                  0.016 |           0.012 |
| Entre Ríos                    | M    |        1410 |        167 |         22 |              0.012 |              0.016 |            0.312 |           0.118 |                  0.012 |           0.004 |
| Neuquén                       | F    |        1353 |        795 |         21 |              0.013 |              0.016 |            0.336 |           0.588 |                  0.013 |           0.007 |
| Salta                         | F    |        1125 |        188 |          9 |              0.005 |              0.008 |            0.445 |           0.167 |                  0.010 |           0.002 |
| Tierra del Fuego              | M    |        1059 |         27 |         18 |              0.015 |              0.017 |            0.365 |           0.025 |                  0.011 |           0.010 |
| SIN ESPECIFICAR               | F    |         977 |         53 |          3 |              0.003 |              0.003 |            0.431 |           0.054 |                  0.004 |           0.000 |
| Buenos Aires                  | NR   |         888 |         81 |         31 |              0.023 |              0.035 |            0.456 |           0.091 |                  0.023 |           0.010 |
| Tierra del Fuego              | F    |         835 |         14 |          9 |              0.009 |              0.011 |            0.312 |           0.017 |                  0.004 |           0.004 |
| Tucumán                       | M    |         834 |         94 |          9 |              0.003 |              0.011 |            0.080 |           0.113 |                  0.011 |           0.004 |
| Santa Cruz                    | M    |         811 |         40 |         10 |              0.010 |              0.012 |            0.376 |           0.049 |                  0.017 |           0.012 |
| Santa Cruz                    | F    |         800 |         41 |          4 |              0.004 |              0.005 |            0.360 |           0.051 |                  0.013 |           0.009 |
| Tucumán                       | F    |         766 |         79 |          4 |              0.001 |              0.005 |            0.117 |           0.103 |                  0.014 |           0.003 |
| La Rioja                      | M    |         712 |         15 |         34 |              0.044 |              0.048 |            0.217 |           0.021 |                  0.001 |           0.000 |
| SIN ESPECIFICAR               | M    |         683 |         51 |          5 |              0.006 |              0.007 |            0.459 |           0.075 |                  0.009 |           0.007 |
| La Rioja                      | F    |         615 |         15 |         19 |              0.028 |              0.031 |            0.202 |           0.024 |                  0.008 |           0.003 |
| Santiago del Estero           | M    |         445 |          4 |          3 |              0.003 |              0.007 |            0.081 |           0.009 |                  0.004 |           0.000 |
| Chubut                        | M    |         410 |         18 |          4 |              0.005 |              0.010 |            0.164 |           0.044 |                  0.012 |           0.012 |
| CABA                          | NR   |         355 |         97 |         22 |              0.038 |              0.062 |            0.401 |           0.273 |                  0.039 |           0.025 |
| Chubut                        | F    |         348 |          6 |          2 |              0.003 |              0.006 |            0.146 |           0.017 |                  0.006 |           0.003 |
| Santiago del Estero           | F    |         340 |          1 |          1 |              0.001 |              0.003 |            0.134 |           0.003 |                  0.000 |           0.000 |
| Corrientes                    | M    |         184 |          7 |          2 |              0.006 |              0.011 |            0.048 |           0.038 |                  0.011 |           0.005 |
| Corrientes                    | F    |         129 |          0 |          0 |              0.000 |              0.000 |            0.043 |           0.000 |                  0.008 |           0.000 |
| La Pampa                      | F    |         111 |         11 |          0 |              0.000 |              0.000 |            0.084 |           0.099 |                  0.018 |           0.009 |
| San Juan                      | M    |         105 |          4 |          0 |              0.000 |              0.000 |            0.141 |           0.038 |                  0.000 |           0.000 |
| San Juan                      | F    |          87 |          5 |          0 |              0.000 |              0.000 |            0.148 |           0.057 |                  0.023 |           0.000 |
| La Pampa                      | M    |          83 |          5 |          1 |              0.009 |              0.012 |            0.081 |           0.060 |                  0.012 |           0.000 |
| Formosa                       | M    |          67 |          0 |          0 |              0.000 |              0.000 |            0.107 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          41 |          0 |          0 |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | M    |          39 |          9 |          0 |              0.000 |              0.000 |            0.066 |           0.231 |                  0.026 |           0.000 |
| Misiones                      | M    |          37 |         16 |          1 |              0.012 |              0.027 |            0.024 |           0.432 |                  0.108 |           0.054 |
| Catamarca                     | F    |          23 |          0 |          0 |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         14 |          1 |              0.016 |              0.045 |            0.016 |           0.636 |                  0.091 |           0.045 |
| San Luis                      | F    |          22 |          6 |          0 |              0.000 |              0.000 |            0.046 |           0.273 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          21 |          5 |          2 |              0.043 |              0.095 |            0.194 |           0.238 |                  0.000 |           0.000 |
| Formosa                       | F    |          17 |          1 |          1 |              0.034 |              0.059 |            0.040 |           0.059 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          14 |          1 |          0 |              0.000 |              0.000 |            0.326 |           0.071 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          11 |          0 |          1 |              0.033 |              0.091 |            0.239 |           0.000 |                  0.000 |           0.000 |


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))
    #> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_, : no
    #> non-missing arguments to max; returning -Inf

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
