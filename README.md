
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
    #> INFO  [09:19:06.991] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:19:14.481] Normalize 
    #> INFO  [09:19:16.820] checkSoundness 
    #> INFO  [09:19:18.617] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-04"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-04"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-04"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-04              |      461878 |       9623 |              0.016 |              0.021 |                       194 | 1190388 |            0.388 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      282824 |       5824 |              0.016 |              0.021 |                       191 | 635892 |            0.445 |
| CABA                          |      100271 |       2400 |              0.021 |              0.024 |                       189 | 252989 |            0.396 |
| Santa Fe                      |       10806 |        113 |              0.008 |              0.010 |                       175 |  42740 |            0.253 |
| Córdoba                       |       10335 |        146 |              0.011 |              0.014 |                       179 |  53184 |            0.194 |
| Jujuy                         |        9547 |        248 |              0.017 |              0.026 |                       169 |  23415 |            0.408 |
| Mendoza                       |        8798 |        139 |              0.011 |              0.016 |                       178 |  22928 |            0.384 |
| Río Negro                     |        6768 |        200 |              0.026 |              0.030 |                       172 |  16663 |            0.406 |
| Chaco                         |        5771 |        223 |              0.030 |              0.039 |                       177 |  35057 |            0.165 |
| Salta                         |        4191 |         55 |              0.009 |              0.013 |                       167 |   9013 |            0.465 |
| Entre Ríos                    |        4113 |         54 |              0.010 |              0.013 |                       172 |  11516 |            0.357 |
| Neuquén                       |        3470 |         57 |              0.012 |              0.016 |                       174 |   9002 |            0.385 |
| Tucumán                       |        3381 |         14 |              0.001 |              0.004 |                       170 |  18995 |            0.178 |
| Tierra del Fuego              |        2271 |         36 |              0.013 |              0.016 |                       170 |   6283 |            0.361 |
| Santa Cruz                    |        2023 |         17 |              0.007 |              0.008 |                       164 |   5259 |            0.385 |
| La Rioja                      |        1887 |         61 |              0.030 |              0.032 |                       164 |   7422 |            0.254 |
| SIN ESPECIFICAR               |        1825 |          9 |              0.004 |              0.005 |                       165 |   4126 |            0.442 |
| Santiago del Estero           |        1152 |         11 |              0.005 |              0.010 |                       158 |   9327 |            0.124 |
| Chubut                        |        1100 |          7 |              0.003 |              0.006 |                       158 |   5662 |            0.194 |
| San Juan                      |         357 |          1 |              0.002 |              0.003 |                       163 |   1527 |            0.234 |
| Corrientes                    |         333 |          2 |              0.003 |              0.006 |                       169 |   7842 |            0.042 |
| La Pampa                      |         221 |          3 |              0.010 |              0.014 |                       152 |   2627 |            0.084 |
| San Luis                      |         210 |          0 |              0.000 |              0.000 |                       151 |   1273 |            0.165 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      282824 | 635892 |       5824 |               14.9 |              0.016 |              0.021 |            0.445 |           0.081 |                  0.011 |           0.005 |
| CABA                          |      100271 | 252989 |       2400 |               15.9 |              0.021 |              0.024 |            0.396 |           0.166 |                  0.017 |           0.008 |
| Santa Fe                      |       10806 |  42740 |        113 |               12.6 |              0.008 |              0.010 |            0.253 |           0.042 |                  0.010 |           0.005 |
| Córdoba                       |       10335 |  53184 |        146 |               15.9 |              0.011 |              0.014 |            0.194 |           0.025 |                  0.007 |           0.004 |
| Jujuy                         |        9547 |  23415 |        248 |               13.4 |              0.017 |              0.026 |            0.408 |           0.007 |                  0.001 |           0.001 |
| Mendoza                       |        8798 |  22928 |        139 |               10.8 |              0.011 |              0.016 |            0.384 |           0.152 |                  0.009 |           0.003 |
| Río Negro                     |        6768 |  16663 |        200 |               12.8 |              0.026 |              0.030 |            0.406 |           0.264 |                  0.012 |           0.008 |
| Chaco                         |        5771 |  35057 |        223 |               14.6 |              0.030 |              0.039 |            0.165 |           0.109 |                  0.059 |           0.027 |
| Salta                         |        4191 |   9013 |         55 |                9.0 |              0.009 |              0.013 |            0.465 |           0.136 |                  0.016 |           0.006 |
| Entre Ríos                    |        4113 |  11516 |         54 |               11.3 |              0.010 |              0.013 |            0.357 |           0.105 |                  0.010 |           0.002 |
| Neuquén                       |        3470 |   9002 |         57 |               17.7 |              0.012 |              0.016 |            0.385 |           0.593 |                  0.013 |           0.009 |
| Tucumán                       |        3381 |  18995 |         14 |               13.0 |              0.001 |              0.004 |            0.178 |           0.057 |                  0.007 |           0.001 |
| Tierra del Fuego              |        2271 |   6283 |         36 |               14.1 |              0.013 |              0.016 |            0.361 |           0.025 |                  0.009 |           0.008 |
| Santa Cruz                    |        2023 |   5259 |         17 |               12.7 |              0.007 |              0.008 |            0.385 |           0.043 |                  0.012 |           0.008 |
| La Rioja                      |        1887 |   7422 |         61 |               10.3 |              0.030 |              0.032 |            0.254 |           0.017 |                  0.004 |           0.001 |
| SIN ESPECIFICAR               |        1825 |   4126 |          9 |               20.7 |              0.004 |              0.005 |            0.442 |           0.064 |                  0.007 |           0.003 |
| Santiago del Estero           |        1152 |   9327 |         11 |                7.8 |              0.005 |              0.010 |            0.124 |           0.008 |                  0.003 |           0.001 |
| Chubut                        |        1100 |   5662 |          7 |               15.9 |              0.003 |              0.006 |            0.194 |           0.023 |                  0.006 |           0.005 |
| San Juan                      |         357 |   1527 |          1 |               35.0 |              0.002 |              0.003 |            0.234 |           0.028 |                  0.008 |           0.003 |
| Corrientes                    |         333 |   7842 |          2 |               12.0 |              0.003 |              0.006 |            0.042 |           0.024 |                  0.009 |           0.003 |
| La Pampa                      |         221 |   2627 |          3 |               29.0 |              0.010 |              0.014 |            0.084 |           0.081 |                  0.014 |           0.005 |
| San Luis                      |         210 |   1273 |          0 |                NaN |              0.000 |              0.000 |            0.165 |           0.143 |                  0.005 |           0.000 |
| Formosa                       |          89 |   1147 |          1 |               12.0 |              0.008 |              0.011 |            0.078 |           0.022 |                  0.000 |           0.000 |
| Catamarca                     |          70 |   3319 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          65 |   3180 |          2 |                6.5 |              0.014 |              0.031 |            0.020 |           0.462 |                  0.092 |           0.046 |

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
    #> INFO  [09:23:34.887] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 27
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |      86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-25              |                        41 |          98 |     668 |         66 |          9 |              0.067 |              0.092 |            0.147 |           0.673 |                  0.122 |           0.061 |
|             12 | 2020-09-04              |                        72 |         421 |    2055 |        259 |         17 |              0.034 |              0.040 |            0.205 |           0.615 |                  0.090 |           0.052 |
|             13 | 2020-09-04              |                       110 |        1098 |    5528 |        605 |         64 |              0.051 |              0.058 |            0.199 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-09-04              |                       148 |        1810 |   11554 |        989 |        116 |              0.054 |              0.064 |            0.157 |           0.546 |                  0.093 |           0.055 |
|             15 | 2020-09-04              |                       175 |        2506 |   20280 |       1349 |        181 |              0.060 |              0.072 |            0.124 |           0.538 |                  0.088 |           0.049 |
|             16 | 2020-09-04              |                       188 |        3350 |   31899 |       1712 |        242 |              0.059 |              0.072 |            0.105 |           0.511 |                  0.078 |           0.043 |
|             17 | 2020-09-04              |                       191 |        4544 |   45965 |       2255 |        352 |              0.064 |              0.077 |            0.099 |           0.496 |                  0.070 |           0.037 |
|             18 | 2020-09-04              |                       191 |        5612 |   59165 |       2673 |        437 |              0.065 |              0.078 |            0.095 |           0.476 |                  0.063 |           0.033 |
|             19 | 2020-09-04              |                       191 |        7143 |   73307 |       3279 |        524 |              0.062 |              0.073 |            0.097 |           0.459 |                  0.059 |           0.031 |
|             20 | 2020-09-04              |                       191 |        9607 |   90749 |       4145 |        637 |              0.056 |              0.066 |            0.106 |           0.431 |                  0.054 |           0.028 |
|             21 | 2020-09-04              |                       191 |       14099 |  114209 |       5504 |        811 |              0.050 |              0.058 |            0.123 |           0.390 |                  0.048 |           0.024 |
|             22 | 2020-09-04              |                       191 |       19456 |  139631 |       6976 |       1032 |              0.046 |              0.053 |            0.139 |           0.359 |                  0.043 |           0.022 |
|             23 | 2020-09-04              |                       191 |       26086 |  167949 |       8553 |       1297 |              0.043 |              0.050 |            0.155 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-09-04              |                       191 |       35918 |  203120 |      10738 |       1630 |              0.040 |              0.045 |            0.177 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-04              |                       191 |       48942 |  244596 |      13144 |       2042 |              0.037 |              0.042 |            0.200 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-09-04              |                       191 |       66956 |  296741 |      16265 |       2591 |              0.034 |              0.039 |            0.226 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-04              |                       191 |       85946 |  347836 |      19115 |       3213 |              0.033 |              0.037 |            0.247 |           0.222 |                  0.026 |           0.011 |
|             28 | 2020-09-04              |                       192 |      109533 |  406872 |      22478 |       3995 |              0.032 |              0.036 |            0.269 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-09-04              |                       194 |      138591 |  478264 |      26129 |       4881 |              0.031 |              0.035 |            0.290 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-04              |                       194 |      176462 |  563969 |      29827 |       5854 |              0.029 |              0.033 |            0.313 |           0.169 |                  0.020 |           0.009 |
|             31 | 2020-09-04              |                       194 |      215540 |  652733 |      33072 |       6716 |              0.027 |              0.031 |            0.330 |           0.153 |                  0.019 |           0.009 |
|             32 | 2020-09-04              |                       194 |      264245 |  759673 |      36742 |       7697 |              0.025 |              0.029 |            0.348 |           0.139 |                  0.017 |           0.008 |
|             33 | 2020-09-04              |                       194 |      309693 |  870684 |      40158 |       8416 |              0.023 |              0.027 |            0.356 |           0.130 |                  0.016 |           0.007 |
|             34 | 2020-09-04              |                       194 |      357462 |  978929 |      43356 |       9063 |              0.021 |              0.025 |            0.365 |           0.121 |                  0.015 |           0.007 |
|             35 | 2020-09-04              |                       194 |      420071 | 1108899 |      46495 |       9522 |              0.019 |              0.023 |            0.379 |           0.111 |                  0.014 |           0.006 |
|             36 | 2020-09-04              |                       194 |      461878 | 1190388 |      47817 |       9623 |              0.016 |              0.021 |            0.388 |           0.104 |                  0.013 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:25:05.193] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:25:55.610] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:26:22.058] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:26:24.520] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:26:30.591] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:26:33.517] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:26:41.696] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:26:44.585] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:26:47.657] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:26:49.696] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:26:53.330] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:26:55.723] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:26:58.382] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:27:01.837] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:27:04.314] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:27:07.265] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:27:10.644] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:27:13.361] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:27:15.810] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:27:18.355] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:27:20.994] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:27:26.474] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:27:29.450] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:27:32.149] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:27:35.279] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 611
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
    #> [1] 67
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      144569 |      12493 |       3318 |              0.018 |              0.023 |            0.462 |           0.086 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |      137226 |      10353 |       2467 |              0.014 |              0.018 |            0.428 |           0.075 |                  0.009 |           0.003 |
| CABA                          | F    |       50578 |       8095 |       1113 |              0.019 |              0.022 |            0.375 |           0.160 |                  0.013 |           0.006 |
| CABA                          | M    |       49303 |       8473 |       1262 |              0.022 |              0.026 |            0.421 |           0.172 |                  0.022 |           0.011 |
| Jujuy                         | M    |        5613 |         46 |        154 |              0.018 |              0.027 |            0.430 |           0.008 |                  0.001 |           0.001 |
| Santa Fe                      | M    |        5406 |        252 |         69 |              0.010 |              0.013 |            0.267 |           0.047 |                  0.012 |           0.007 |
| Santa Fe                      | F    |        5396 |        197 |         44 |              0.006 |              0.008 |            0.240 |           0.037 |                  0.009 |           0.004 |
| Córdoba                       | F    |        5219 |        124 |         59 |              0.009 |              0.011 |            0.192 |           0.024 |                  0.006 |           0.003 |
| Córdoba                       | M    |        5089 |        135 |         85 |              0.013 |              0.017 |            0.196 |           0.027 |                  0.008 |           0.004 |
| Mendoza                       | M    |        4414 |        663 |         90 |              0.014 |              0.020 |            0.396 |           0.150 |                  0.014 |           0.005 |
| Mendoza                       | F    |        4361 |        669 |         47 |              0.007 |              0.011 |            0.374 |           0.153 |                  0.004 |           0.001 |
| Jujuy                         | F    |        3918 |         21 |         93 |              0.014 |              0.024 |            0.380 |           0.005 |                  0.001 |           0.001 |
| Río Negro                     | F    |        3504 |        905 |         77 |              0.019 |              0.022 |            0.393 |           0.258 |                  0.007 |           0.003 |
| Río Negro                     | M    |        3261 |        882 |        123 |              0.033 |              0.038 |            0.422 |           0.270 |                  0.018 |           0.013 |
| Chaco                         | M    |        2919 |        324 |        142 |              0.039 |              0.049 |            0.168 |           0.111 |                  0.067 |           0.032 |
| Chaco                         | F    |        2849 |        305 |         81 |              0.022 |              0.028 |            0.161 |           0.107 |                  0.052 |           0.021 |
| Salta                         | M    |        2448 |        328 |         42 |              0.012 |              0.017 |            0.471 |           0.134 |                  0.019 |           0.009 |
| Entre Ríos                    | F    |        2078 |        208 |         20 |              0.007 |              0.010 |            0.344 |           0.100 |                  0.007 |           0.001 |
| Entre Ríos                    | M    |        2032 |        221 |         33 |              0.013 |              0.016 |            0.372 |           0.109 |                  0.013 |           0.003 |
| Tucumán                       | M    |        1759 |        106 |         10 |              0.002 |              0.006 |            0.153 |           0.060 |                  0.007 |           0.002 |
| Neuquén                       | M    |        1751 |       1041 |         30 |              0.013 |              0.017 |            0.396 |           0.595 |                  0.014 |           0.010 |
| Salta                         | F    |        1734 |        240 |         13 |              0.005 |              0.007 |            0.457 |           0.138 |                  0.011 |           0.002 |
| Neuquén                       | F    |        1718 |       1016 |         26 |              0.011 |              0.015 |            0.376 |           0.591 |                  0.012 |           0.007 |
| Tucumán                       | F    |        1622 |         86 |          4 |              0.001 |              0.002 |            0.218 |           0.053 |                  0.007 |           0.001 |
| Tierra del Fuego              | M    |        1253 |         36 |         25 |              0.016 |              0.020 |            0.384 |           0.029 |                  0.014 |           0.012 |
| SIN ESPECIFICAR               | F    |        1072 |         61 |          3 |              0.002 |              0.003 |            0.431 |           0.057 |                  0.005 |           0.000 |
| Buenos Aires                  | NR   |        1029 |         93 |         39 |              0.025 |              0.038 |            0.471 |           0.090 |                  0.021 |           0.010 |
| Santa Cruz                    | M    |        1023 |         44 |         11 |              0.009 |              0.011 |            0.396 |           0.043 |                  0.015 |           0.010 |
| Tierra del Fuego              | F    |        1004 |         21 |         11 |              0.009 |              0.011 |            0.333 |           0.021 |                  0.003 |           0.003 |
| Santa Cruz                    | F    |         999 |         43 |          6 |              0.005 |              0.006 |            0.374 |           0.043 |                  0.010 |           0.007 |
| La Rioja                      | M    |         987 |         17 |         36 |              0.034 |              0.036 |            0.260 |           0.017 |                  0.003 |           0.000 |
| La Rioja                      | F    |         892 |         15 |         25 |              0.026 |              0.028 |            0.249 |           0.017 |                  0.006 |           0.002 |
| SIN ESPECIFICAR               | M    |         748 |         55 |          5 |              0.006 |              0.007 |            0.462 |           0.074 |                  0.009 |           0.007 |
| Santiago del Estero           | M    |         628 |          6 |          5 |              0.004 |              0.008 |            0.104 |           0.010 |                  0.003 |           0.000 |
| Chubut                        | M    |         591 |         17 |          4 |              0.003 |              0.007 |            0.207 |           0.029 |                  0.008 |           0.008 |
| Santiago del Estero           | F    |         520 |          3 |          6 |              0.006 |              0.012 |            0.173 |           0.006 |                  0.002 |           0.002 |
| Chubut                        | F    |         503 |          7 |          3 |              0.003 |              0.006 |            0.182 |           0.014 |                  0.004 |           0.002 |
| CABA                          | NR   |         390 |        105 |         25 |              0.049 |              0.064 |            0.408 |           0.269 |                  0.038 |           0.023 |
| Corrientes                    | M    |         188 |          7 |          2 |              0.005 |              0.011 |            0.043 |           0.037 |                  0.011 |           0.005 |
| San Juan                      | M    |         179 |          5 |          1 |              0.004 |              0.006 |            0.214 |           0.028 |                  0.006 |           0.000 |
| San Juan                      | F    |         178 |          5 |          0 |              0.000 |              0.000 |            0.259 |           0.028 |                  0.011 |           0.006 |
| Corrientes                    | F    |         145 |          1 |          0 |              0.000 |              0.000 |            0.042 |           0.007 |                  0.007 |           0.000 |
| La Pampa                      | F    |         124 |         12 |          1 |              0.006 |              0.008 |            0.084 |           0.097 |                  0.016 |           0.008 |
| San Luis                      | M    |         111 |         14 |          0 |              0.000 |              0.000 |            0.160 |           0.126 |                  0.009 |           0.000 |
| San Luis                      | F    |          99 |         16 |          0 |              0.000 |              0.000 |            0.172 |           0.162 |                  0.000 |           0.000 |
| La Pampa                      | M    |          97 |          6 |          2 |              0.015 |              0.021 |            0.085 |           0.062 |                  0.010 |           0.000 |
| Formosa                       | M    |          69 |          0 |          0 |              0.000 |              0.000 |            0.100 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          46 |          0 |          0 |              0.000 |              0.000 |            0.021 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          43 |         16 |          1 |              0.012 |              0.023 |            0.025 |           0.372 |                  0.093 |           0.047 |
| Córdoba                       | NR   |          27 |          1 |          2 |              0.056 |              0.074 |            0.474 |           0.037 |                  0.000 |           0.000 |
| Catamarca                     | F    |          24 |          0 |          0 |              0.000 |              0.000 |            0.020 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          23 |          5 |          2 |              0.041 |              0.087 |            0.187 |           0.217 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         14 |          1 |              0.018 |              0.045 |            0.015 |           0.636 |                  0.091 |           0.045 |
| Formosa                       | F    |          20 |          2 |          1 |              0.029 |              0.050 |            0.044 |           0.100 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          16 |          0 |          1 |              0.032 |              0.062 |            0.314 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |


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
