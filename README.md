
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
    #> INFO  [09:36:07.430] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:36:11.676] Normalize 
    #> INFO  [09:36:13.228] checkSoundness 
    #> INFO  [09:36:13.868] Mutating data 
    #> INFO  [09:37:58.298] Last days rows {date: 2020-08-05, n: 23651}
    #> INFO  [09:37:58.301] Last days rows {date: 2020-08-06, n: 16622}
    #> INFO  [09:37:58.303] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-06"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-06"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-06"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      228173 |       4251 |              0.014 |              0.019 |                       165 | 686800 |            0.332 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      138322 |       2369 |              0.012 |              0.017 |                       163 | 354751 |            0.390 |
| CABA                          |       66454 |       1408 |              0.018 |              0.021 |                       160 | 163936 |            0.405 |
| Chaco                         |        3872 |        159 |              0.031 |              0.041 |                       148 |  23950 |            0.162 |
| Córdoba                       |        2994 |         52 |              0.011 |              0.017 |                       150 |  34335 |            0.087 |
| Jujuy                         |        2957 |         31 |              0.004 |              0.010 |                       139 |  10815 |            0.273 |
| Río Negro                     |        2666 |         81 |              0.027 |              0.030 |                       143 |   8594 |            0.310 |
| Mendoza                       |        1791 |         49 |              0.020 |              0.027 |                       149 |   8410 |            0.213 |
| Santa Fe                      |        1778 |         18 |              0.007 |              0.010 |                       146 |  22801 |            0.078 |
| Neuquén                       |        1376 |         28 |              0.017 |              0.020 |                       145 |   4944 |            0.278 |
| SIN ESPECIFICAR               |        1317 |          4 |              0.002 |              0.003 |                       136 |   2921 |            0.451 |
| Entre Ríos                    |         999 |         11 |              0.008 |              0.011 |                       143 |   5420 |            0.184 |
| Tierra del Fuego              |         801 |          5 |              0.005 |              0.006 |                       142 |   3410 |            0.235 |
| Santa Cruz                    |         635 |          4 |              0.005 |              0.006 |                       135 |   1612 |            0.394 |
| La Rioja                      |         449 |         18 |              0.035 |              0.040 |                       135 |   4303 |            0.104 |
| Salta                         |         411 |          2 |              0.003 |              0.005 |                       138 |   2137 |            0.192 |
| Tucumán                       |         348 |          5 |              0.003 |              0.014 |                       141 |  12592 |            0.028 |
| Chubut                        |         308 |          3 |              0.004 |              0.010 |                       129 |   3077 |            0.100 |
| Corrientes                    |         200 |          2 |              0.004 |              0.010 |                       140 |   4619 |            0.043 |
| La Pampa                      |         170 |          0 |              0.000 |              0.000 |                       123 |   1395 |            0.122 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      138322 | 354751 |       2369 |               13.7 |              0.012 |              0.017 |            0.390 |           0.107 |                  0.013 |           0.005 |
| CABA                          |       66454 | 163936 |       1408 |               14.9 |              0.018 |              0.021 |            0.405 |           0.194 |                  0.018 |           0.008 |
| Chaco                         |        3872 |  23950 |        159 |               14.5 |              0.031 |              0.041 |            0.162 |           0.115 |                  0.069 |           0.027 |
| Córdoba                       |        2994 |  34335 |         52 |               22.0 |              0.011 |              0.017 |            0.087 |           0.052 |                  0.014 |           0.007 |
| Jujuy                         |        2957 |  10815 |         31 |               12.6 |              0.004 |              0.010 |            0.273 |           0.007 |                  0.001 |           0.001 |
| Río Negro                     |        2666 |   8594 |         81 |               14.0 |              0.027 |              0.030 |            0.310 |           0.284 |                  0.017 |           0.012 |
| Mendoza                       |        1791 |   8410 |         49 |               12.2 |              0.020 |              0.027 |            0.213 |           0.370 |                  0.022 |           0.006 |
| Santa Fe                      |        1778 |  22801 |         18 |               12.6 |              0.007 |              0.010 |            0.078 |           0.090 |                  0.020 |           0.007 |
| Neuquén                       |        1376 |   4944 |         28 |               17.8 |              0.017 |              0.020 |            0.278 |           0.672 |                  0.019 |           0.011 |
| SIN ESPECIFICAR               |        1317 |   2921 |          4 |               23.0 |              0.002 |              0.003 |            0.451 |           0.070 |                  0.008 |           0.005 |
| Entre Ríos                    |         999 |   5420 |         11 |               13.5 |              0.008 |              0.011 |            0.184 |           0.201 |                  0.011 |           0.002 |
| Tierra del Fuego              |         801 |   3410 |          5 |               12.8 |              0.005 |              0.006 |            0.235 |           0.019 |                  0.005 |           0.005 |
| Santa Cruz                    |         635 |   1612 |          4 |               11.2 |              0.005 |              0.006 |            0.394 |           0.080 |                  0.024 |           0.014 |
| La Rioja                      |         449 |   4303 |         18 |               13.2 |              0.035 |              0.040 |            0.104 |           0.060 |                  0.013 |           0.004 |
| Salta                         |         411 |   2137 |          2 |                2.5 |              0.003 |              0.005 |            0.192 |           0.309 |                  0.022 |           0.012 |
| Tucumán                       |         348 |  12592 |          5 |               12.8 |              0.003 |              0.014 |            0.028 |           0.101 |                  0.029 |           0.009 |
| Chubut                        |         308 |   3077 |          3 |               20.7 |              0.004 |              0.010 |            0.100 |           0.052 |                  0.013 |           0.010 |
| Corrientes                    |         200 |   4619 |          2 |               12.0 |              0.004 |              0.010 |            0.043 |           0.025 |                  0.010 |           0.005 |
| La Pampa                      |         170 |   1395 |          0 |                NaN |              0.000 |              0.000 |            0.122 |           0.047 |                  0.012 |           0.000 |
| Formosa                       |          81 |    853 |          0 |                NaN |              0.000 |              0.000 |            0.095 |           0.012 |                  0.000 |           0.000 |
| Santiago del Estero           |          78 |   5535 |          0 |                NaN |              0.000 |              0.000 |            0.014 |           0.026 |                  0.013 |           0.000 |
| Catamarca                     |          60 |   2168 |          0 |                NaN |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          52 |   2304 |          2 |                6.5 |              0.015 |              0.038 |            0.023 |           0.577 |                  0.115 |           0.058 |
| San Luis                      |          32 |    870 |          0 |                NaN |              0.000 |              0.000 |            0.037 |           0.281 |                  0.031 |           0.000 |
| San Juan                      |          22 |   1048 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.227 |                  0.045 |           0.000 |

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
    #> INFO  [09:38:35.481] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 23
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-01              |                        38 |          97 |    666 |         66 |          9 |              0.065 |              0.093 |            0.146 |           0.680 |                  0.124 |           0.062 |
|             12 | 2020-08-01              |                        61 |         413 |   2049 |        255 |         17 |              0.033 |              0.041 |            0.202 |           0.617 |                  0.092 |           0.053 |
|             13 | 2020-08-01              |                        94 |        1085 |   5517 |        600 |         63 |              0.049 |              0.058 |            0.197 |           0.553 |                  0.094 |           0.056 |
|             14 | 2020-08-06              |                       126 |        1777 |  11538 |        974 |        114 |              0.052 |              0.064 |            0.154 |           0.548 |                  0.095 |           0.056 |
|             15 | 2020-08-06              |                       149 |        2442 |  20257 |       1323 |        179 |              0.059 |              0.073 |            0.121 |           0.542 |                  0.090 |           0.051 |
|             16 | 2020-08-06              |                       159 |        3243 |  31862 |       1674 |        236 |              0.057 |              0.073 |            0.102 |           0.516 |                  0.080 |           0.044 |
|             17 | 2020-08-06              |                       162 |        4359 |  45914 |       2195 |        341 |              0.062 |              0.078 |            0.095 |           0.504 |                  0.072 |           0.038 |
|             18 | 2020-08-06              |                       162 |        5363 |  59107 |       2594 |        417 |              0.062 |              0.078 |            0.091 |           0.484 |                  0.065 |           0.035 |
|             19 | 2020-08-06              |                       162 |        6807 |  73240 |       3181 |        498 |              0.059 |              0.073 |            0.093 |           0.467 |                  0.061 |           0.032 |
|             20 | 2020-08-06              |                       162 |        9209 |  90605 |       4024 |        593 |              0.053 |              0.064 |            0.102 |           0.437 |                  0.056 |           0.029 |
|             21 | 2020-08-06              |                       162 |       13579 | 114040 |       5342 |        745 |              0.045 |              0.055 |            0.119 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-08-06              |                       162 |       18816 | 139401 |       6783 |        930 |              0.041 |              0.049 |            0.135 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-08-06              |                       162 |       25250 | 167665 |       8314 |       1148 |              0.038 |              0.045 |            0.151 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-06              |                       162 |       34858 | 202754 |      10446 |       1398 |              0.034 |              0.040 |            0.172 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-06              |                       162 |       47676 | 244118 |      12782 |       1713 |              0.031 |              0.036 |            0.195 |           0.268 |                  0.031 |           0.014 |
|             26 | 2020-08-06              |                       162 |       65351 | 296003 |      15818 |       2110 |              0.027 |              0.032 |            0.221 |           0.242 |                  0.028 |           0.012 |
|             27 | 2020-08-06              |                       162 |       83947 | 346546 |      18550 |       2551 |              0.026 |              0.030 |            0.242 |           0.221 |                  0.025 |           0.011 |
|             28 | 2020-08-06              |                       163 |      107133 | 405089 |      21745 |       3066 |              0.024 |              0.029 |            0.264 |           0.203 |                  0.023 |           0.010 |
|             29 | 2020-08-06              |                       164 |      135535 | 475494 |      25086 |       3579 |              0.022 |              0.026 |            0.285 |           0.185 |                  0.021 |           0.009 |
|             30 | 2020-08-06              |                       164 |      171894 | 558492 |      28246 |       3996 |              0.019 |              0.023 |            0.308 |           0.164 |                  0.019 |           0.008 |
|             31 | 2020-08-29              |                       165 |      208234 | 641288 |      30477 |       4199 |              0.016 |              0.020 |            0.325 |           0.146 |                  0.017 |           0.007 |
|             32 | 2020-08-29              |                       165 |      228173 | 686800 |      31425 |       4251 |              0.014 |              0.019 |            0.332 |           0.138 |                  0.016 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:39:26.177] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:39:48.835] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:40:01.532] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:40:03.626] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:40:07.616] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:40:09.691] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:40:15.366] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:40:17.881] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:40:20.401] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:40:23.116] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:40:26.495] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:40:28.698] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:40:31.118] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:40:34.485] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:40:36.916] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:40:40.089] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:40:44.284] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:40:46.989] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:40:49.383] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:40:52.189] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:40:54.386] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:40:58.589] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:41:01.173] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:41:03.483] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:41:05.907] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 511
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
    #> [1] 64
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |       70929 |       8039 |       1338 |              0.013 |              0.019 |            0.409 |           0.113 |                  0.015 |           0.007 |
| Buenos Aires                  | F    |       66886 |       6694 |       1018 |              0.011 |              0.015 |            0.372 |           0.100 |                  0.011 |           0.004 |
| CABA                          | F    |       33532 |       6330 |        627 |              0.015 |              0.019 |            0.387 |           0.189 |                  0.014 |           0.006 |
| CABA                          | M    |       32667 |       6490 |        766 |              0.020 |              0.023 |            0.426 |           0.199 |                  0.023 |           0.011 |
| Chaco                         | F    |        1935 |        225 |         58 |              0.022 |              0.030 |            0.161 |           0.116 |                  0.061 |           0.021 |
| Chaco                         | M    |        1935 |        220 |        101 |              0.039 |              0.052 |            0.162 |           0.114 |                  0.076 |           0.033 |
| Jujuy                         | M    |        1823 |         15 |         18 |              0.004 |              0.010 |            0.306 |           0.008 |                  0.002 |           0.002 |
| Córdoba                       | M    |        1500 |         73 |         26 |              0.012 |              0.017 |            0.089 |           0.049 |                  0.015 |           0.009 |
| Córdoba                       | F    |        1491 |         82 |         26 |              0.011 |              0.017 |            0.085 |           0.055 |                  0.013 |           0.006 |
| Río Negro                     | F    |        1391 |        380 |         30 |              0.019 |              0.022 |            0.302 |           0.273 |                  0.010 |           0.005 |
| Río Negro                     | M    |        1274 |        377 |         51 |              0.035 |              0.040 |            0.320 |           0.296 |                  0.025 |           0.020 |
| Jujuy                         | F    |        1129 |          5 |         13 |              0.004 |              0.012 |            0.234 |           0.004 |                  0.001 |           0.001 |
| Mendoza                       | F    |         908 |        337 |         16 |              0.014 |              0.018 |            0.213 |           0.371 |                  0.012 |           0.002 |
| Santa Fe                      | F    |         902 |         62 |          6 |              0.005 |              0.007 |            0.076 |           0.069 |                  0.014 |           0.003 |
| Santa Fe                      | M    |         876 |         98 |         12 |              0.010 |              0.014 |            0.080 |           0.112 |                  0.025 |           0.011 |
| Mendoza                       | M    |         872 |        322 |         31 |              0.025 |              0.036 |            0.213 |           0.369 |                  0.033 |           0.009 |
| SIN ESPECIFICAR               | F    |         789 |         46 |          1 |              0.001 |              0.001 |            0.446 |           0.058 |                  0.004 |           0.000 |
| Neuquén                       | M    |         692 |        450 |         12 |              0.015 |              0.017 |            0.280 |           0.650 |                  0.016 |           0.010 |
| Neuquén                       | F    |         684 |        474 |         16 |              0.019 |              0.023 |            0.277 |           0.693 |                  0.022 |           0.012 |
| SIN ESPECIFICAR               | M    |         524 |         45 |          2 |              0.003 |              0.004 |            0.460 |           0.086 |                  0.011 |           0.010 |
| Buenos Aires                  | NR   |         507 |         48 |         13 |              0.015 |              0.026 |            0.406 |           0.095 |                  0.026 |           0.014 |
| Entre Ríos                    | M    |         506 |        109 |          6 |              0.009 |              0.012 |            0.193 |           0.215 |                  0.010 |           0.002 |
| Entre Ríos                    | F    |         492 |         92 |          5 |              0.007 |              0.010 |            0.176 |           0.187 |                  0.012 |           0.002 |
| Tierra del Fuego              | M    |         475 |          8 |          3 |              0.005 |              0.006 |            0.262 |           0.017 |                  0.006 |           0.006 |
| Santa Cruz                    | M    |         325 |         25 |          2 |              0.005 |              0.006 |            0.379 |           0.077 |                  0.025 |           0.012 |
| Tierra del Fuego              | F    |         325 |          7 |          2 |              0.005 |              0.006 |            0.204 |           0.022 |                  0.003 |           0.003 |
| Santa Cruz                    | F    |         309 |         26 |          2 |              0.006 |              0.006 |            0.410 |           0.084 |                  0.023 |           0.016 |
| CABA                          | NR   |         255 |         75 |         15 |              0.034 |              0.059 |            0.379 |           0.294 |                  0.051 |           0.035 |
| Salta                         | M    |         246 |         76 |          2 |              0.005 |              0.008 |            0.181 |           0.309 |                  0.028 |           0.020 |
| La Rioja                      | F    |         235 |         15 |          7 |              0.027 |              0.030 |            0.113 |           0.064 |                  0.021 |           0.009 |
| La Rioja                      | M    |         211 |         12 |         11 |              0.045 |              0.052 |            0.096 |           0.057 |                  0.005 |           0.000 |
| Tucumán                       | M    |         192 |         20 |          3 |              0.003 |              0.016 |            0.024 |           0.104 |                  0.021 |           0.005 |
| Chubut                        | M    |         168 |         12 |          1 |              0.003 |              0.006 |            0.106 |           0.071 |                  0.012 |           0.012 |
| Salta                         | F    |         165 |         51 |          0 |              0.000 |              0.000 |            0.213 |           0.309 |                  0.012 |           0.000 |
| Tucumán                       | F    |         155 |         15 |          2 |              0.002 |              0.013 |            0.033 |           0.097 |                  0.039 |           0.013 |
| Chubut                        | F    |         136 |          4 |          2 |              0.007 |              0.015 |            0.094 |           0.029 |                  0.015 |           0.007 |
| Corrientes                    | M    |         112 |          5 |          2 |              0.008 |              0.018 |            0.043 |           0.045 |                  0.009 |           0.009 |
| La Pampa                      | F    |         100 |          6 |          0 |              0.000 |              0.000 |            0.130 |           0.060 |                  0.010 |           0.000 |
| Corrientes                    | F    |          88 |          0 |          0 |              0.000 |              0.000 |            0.044 |           0.000 |                  0.011 |           0.000 |
| La Pampa                      | M    |          70 |          2 |          0 |              0.000 |              0.000 |            0.112 |           0.029 |                  0.014 |           0.000 |
| Formosa                       | M    |          65 |          0 |          0 |              0.000 |              0.000 |            0.129 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          48 |          2 |          0 |              0.000 |              0.000 |            0.012 |           0.042 |                  0.021 |           0.000 |
| Catamarca                     | M    |          38 |          0 |          0 |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          32 |         16 |          1 |              0.015 |              0.031 |            0.026 |           0.500 |                  0.125 |           0.062 |
| Santiago del Estero           | F    |          30 |          0 |          0 |              0.000 |              0.000 |            0.020 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | M    |          24 |          7 |          0 |              0.000 |              0.000 |            0.050 |           0.292 |                  0.042 |           0.000 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         14 |          1 |              0.016 |              0.050 |            0.019 |           0.700 |                  0.100 |           0.050 |
| Formosa                       | F    |          16 |          1 |          0 |              0.000 |              0.000 |            0.046 |           0.062 |                  0.000 |           0.000 |
| San Juan                      | M    |          16 |          2 |          0 |              0.000 |              0.000 |            0.027 |           0.125 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          11 |          4 |          2 |              0.118 |              0.182 |            0.190 |           0.364 |                  0.000 |           0.000 |


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
