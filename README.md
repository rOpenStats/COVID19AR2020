
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
    #> INFO  [10:00:05.544] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [10:00:13.879] Normalize 
    #> INFO  [10:00:16.075] checkSoundness 
    #> INFO  [10:00:17.088] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-14"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-14"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-14"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-14              |      565442 |      11667 |              0.017 |              0.021 |                       204 | 1395062 |            0.405 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      335526 |       6951 |              0.017 |              0.021 |                       201 | 740166 |            0.453 |
| CABA                          |      111009 |       2756 |              0.022 |              0.025 |                       199 | 282815 |            0.393 |
| Santa Fe                      |       19467 |        213 |              0.009 |              0.011 |                       185 |  54360 |            0.358 |
| Mendoza                       |       15127 |        205 |              0.010 |              0.014 |                       188 |  34100 |            0.444 |
| Córdoba                       |       14967 |        206 |              0.011 |              0.014 |                       189 |  60455 |            0.248 |
| Jujuy                         |       12395 |        299 |              0.017 |              0.024 |                       179 |  28170 |            0.440 |
| Río Negro                     |        8854 |        246 |              0.025 |              0.028 |                       182 |  20244 |            0.437 |
| Tucumán                       |        7243 |         19 |              0.001 |              0.003 |                       180 |  23234 |            0.312 |
| Salta                         |        6988 |         94 |              0.010 |              0.013 |                       177 |  13954 |            0.501 |
| Chaco                         |        6792 |        244 |              0.028 |              0.036 |                       187 |  40170 |            0.169 |
| Entre Ríos                    |        5310 |         88 |              0.013 |              0.017 |                       182 |  14210 |            0.374 |
| Neuquén                       |        5039 |         80 |              0.011 |              0.016 |                       184 |  11099 |            0.454 |
| Santa Cruz                    |        3101 |         37 |              0.011 |              0.012 |                       174 |   7022 |            0.442 |
| La Rioja                      |        2882 |        104 |              0.034 |              0.036 |                       174 |   9663 |            0.298 |
| Tierra del Fuego              |        2776 |         48 |              0.015 |              0.017 |                       181 |   7506 |            0.370 |
| SIN ESPECIFICAR               |        2000 |         12 |              0.005 |              0.006 |                       175 |   4529 |            0.442 |
| Santiago del Estero           |        1913 |         26 |              0.008 |              0.014 |                       168 |  11350 |            0.169 |
| Chubut                        |        1756 |         18 |              0.006 |              0.010 |                       168 |   6833 |            0.257 |
| Corrientes                    |         718 |          3 |              0.002 |              0.004 |                       179 |   9198 |            0.078 |
| La Pampa                      |         442 |          3 |              0.005 |              0.007 |                       162 |   3659 |            0.121 |
| San Luis                      |         432 |          0 |              0.000 |              0.000 |                       161 |   1569 |            0.275 |
| San Juan                      |         416 |         12 |              0.020 |              0.029 |                       170 |   1613 |            0.258 |
| Catamarca                     |         128 |          0 |              0.000 |              0.000 |                       153 |   4238 |            0.030 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      335526 | 740166 |       6951 |               15.1 |              0.017 |              0.021 |            0.453 |           0.076 |                  0.011 |           0.005 |
| CABA                          |      111009 | 282815 |       2756 |               16.2 |              0.022 |              0.025 |            0.393 |           0.160 |                  0.017 |           0.009 |
| Santa Fe                      |       19467 |  54360 |        213 |               12.4 |              0.009 |              0.011 |            0.358 |           0.037 |                  0.010 |           0.005 |
| Mendoza                       |       15127 |  34100 |        205 |               11.2 |              0.010 |              0.014 |            0.444 |           0.100 |                  0.007 |           0.002 |
| Córdoba                       |       14967 |  60455 |        206 |               13.9 |              0.011 |              0.014 |            0.248 |           0.021 |                  0.006 |           0.003 |
| Jujuy                         |       12395 |  28170 |        299 |               14.2 |              0.017 |              0.024 |            0.440 |           0.009 |                  0.001 |           0.000 |
| Río Negro                     |        8854 |  20244 |        246 |               13.0 |              0.025 |              0.028 |            0.437 |           0.235 |                  0.011 |           0.007 |
| Tucumán                       |        7243 |  23234 |         19 |               14.4 |              0.001 |              0.003 |            0.312 |           0.030 |                  0.005 |           0.001 |
| Salta                         |        6988 |  13954 |         94 |               10.5 |              0.010 |              0.013 |            0.501 |           0.103 |                  0.012 |           0.005 |
| Chaco                         |        6792 |  40170 |        244 |               14.3 |              0.028 |              0.036 |            0.169 |           0.098 |                  0.054 |           0.026 |
| Entre Ríos                    |        5310 |  14210 |         88 |               11.2 |              0.013 |              0.017 |            0.374 |           0.101 |                  0.010 |           0.003 |
| Neuquén                       |        5039 |  11099 |         80 |               15.9 |              0.011 |              0.016 |            0.454 |           0.538 |                  0.012 |           0.008 |
| Santa Cruz                    |        3101 |   7022 |         37 |               15.3 |              0.011 |              0.012 |            0.442 |           0.054 |                  0.012 |           0.006 |
| La Rioja                      |        2882 |   9663 |        104 |               11.8 |              0.034 |              0.036 |            0.298 |           0.013 |                  0.003 |           0.001 |
| Tierra del Fuego              |        2776 |   7506 |         48 |               14.5 |              0.015 |              0.017 |            0.370 |           0.025 |                  0.009 |           0.008 |
| SIN ESPECIFICAR               |        2000 |   4529 |         12 |               19.9 |              0.005 |              0.006 |            0.442 |           0.067 |                  0.008 |           0.004 |
| Santiago del Estero           |        1913 |  11350 |         26 |                9.1 |              0.008 |              0.014 |            0.169 |           0.009 |                  0.002 |           0.001 |
| Chubut                        |        1756 |   6833 |         18 |               10.8 |              0.006 |              0.010 |            0.257 |           0.019 |                  0.006 |           0.006 |
| Corrientes                    |         718 |   9198 |          3 |               10.7 |              0.002 |              0.004 |            0.078 |           0.018 |                  0.006 |           0.003 |
| La Pampa                      |         442 |   3659 |          3 |               29.0 |              0.005 |              0.007 |            0.121 |           0.057 |                  0.016 |           0.002 |
| San Luis                      |         432 |   1569 |          0 |                NaN |              0.000 |              0.000 |            0.275 |           0.081 |                  0.002 |           0.000 |
| San Juan                      |         416 |   1613 |         12 |               11.1 |              0.020 |              0.029 |            0.258 |           0.031 |                  0.010 |           0.000 |
| Catamarca                     |         128 |   4238 |          0 |                NaN |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Formosa                       |          93 |   1181 |          1 |               12.0 |              0.007 |              0.011 |            0.079 |           0.022 |                  0.000 |           0.000 |
| Misiones                      |          68 |   3724 |          2 |                6.5 |              0.013 |              0.029 |            0.018 |           0.426 |                  0.074 |           0.029 |

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
    #> INFO  [10:05:11.339] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 29
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |      86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-09-09              |                        43 |         100 |     668 |         67 |          9 |              0.066 |              0.090 |            0.150 |           0.670 |                  0.120 |           0.060 |
|             12 | 2020-09-11              |                        76 |         425 |    2055 |        260 |         17 |              0.033 |              0.040 |            0.207 |           0.612 |                  0.089 |           0.052 |
|             13 | 2020-09-14              |                       116 |        1109 |    5528 |        609 |         64 |              0.050 |              0.058 |            0.201 |           0.549 |                  0.092 |           0.055 |
|             14 | 2020-09-14              |                       156 |        1829 |   11560 |        996 |        116 |              0.054 |              0.063 |            0.158 |           0.545 |                  0.092 |           0.055 |
|             15 | 2020-09-14              |                       185 |        2534 |   20287 |       1358 |        181 |              0.060 |              0.071 |            0.125 |           0.536 |                  0.087 |           0.049 |
|             16 | 2020-09-14              |                       198 |        3401 |   31907 |       1730 |        242 |              0.059 |              0.071 |            0.107 |           0.509 |                  0.077 |           0.042 |
|             17 | 2020-09-14              |                       201 |        4606 |   45975 |       2277 |        353 |              0.064 |              0.077 |            0.100 |           0.494 |                  0.070 |           0.036 |
|             18 | 2020-09-14              |                       201 |        5689 |   59178 |       2699 |        439 |              0.065 |              0.077 |            0.096 |           0.474 |                  0.063 |           0.033 |
|             19 | 2020-09-14              |                       201 |        7232 |   73321 |       3310 |        528 |              0.061 |              0.073 |            0.099 |           0.458 |                  0.059 |           0.030 |
|             20 | 2020-09-14              |                       201 |        9718 |   90772 |       4182 |        643 |              0.057 |              0.066 |            0.107 |           0.430 |                  0.054 |           0.028 |
|             21 | 2020-09-14              |                       201 |       14251 |  114239 |       5556 |        822 |              0.050 |              0.058 |            0.125 |           0.390 |                  0.048 |           0.024 |
|             22 | 2020-09-14              |                       201 |       19650 |  139685 |       7032 |       1054 |              0.047 |              0.054 |            0.141 |           0.358 |                  0.043 |           0.022 |
|             23 | 2020-09-14              |                       201 |       26316 |  168012 |       8621 |       1329 |              0.044 |              0.051 |            0.157 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-09-14              |                       201 |       36203 |  203196 |      10820 |       1676 |              0.040 |              0.046 |            0.178 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-14              |                       201 |       49263 |  244708 |      13239 |       2110 |              0.038 |              0.043 |            0.201 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-09-14              |                       201 |       67357 |  296910 |      16380 |       2694 |              0.035 |              0.040 |            0.227 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-14              |                       201 |       86426 |  348084 |      19247 |       3336 |              0.034 |              0.039 |            0.248 |           0.223 |                  0.026 |           0.012 |
|             28 | 2020-09-14              |                       202 |      110124 |  407234 |      22630 |       4140 |              0.033 |              0.038 |            0.270 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-09-14              |                       204 |      139351 |  478744 |      26320 |       5071 |              0.032 |              0.036 |            0.291 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-14              |                       204 |      177386 |  564565 |      30065 |       6114 |              0.030 |              0.034 |            0.314 |           0.169 |                  0.020 |           0.009 |
|             31 | 2020-09-14              |                       204 |      216891 |  653982 |      33361 |       7064 |              0.028 |              0.033 |            0.332 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-09-14              |                       204 |      265868 |  761248 |      37118 |       8158 |              0.027 |              0.031 |            0.349 |           0.140 |                  0.017 |           0.008 |
|             33 | 2020-09-14              |                       204 |      312371 |  874505 |      40707 |       9081 |              0.025 |              0.029 |            0.357 |           0.130 |                  0.016 |           0.008 |
|             34 | 2020-09-14              |                       204 |      360983 |  984446 |      44188 |      10023 |              0.024 |              0.028 |            0.367 |           0.122 |                  0.016 |           0.007 |
|             35 | 2020-09-14              |                       204 |      425493 | 1117927 |      48204 |      10848 |              0.022 |              0.025 |            0.381 |           0.113 |                  0.014 |           0.007 |
|             36 | 2020-09-14              |                       204 |      493248 | 1254035 |      51196 |      11410 |              0.020 |              0.023 |            0.393 |           0.104 |                  0.013 |           0.006 |
|             37 | 2020-09-14              |                       204 |      557971 | 1383103 |      53225 |      11654 |              0.017 |              0.021 |            0.403 |           0.095 |                  0.012 |           0.006 |
|             38 | 2020-09-14              |                       204 |      565442 | 1395062 |      53323 |      11667 |              0.017 |              0.021 |            0.405 |           0.094 |                  0.012 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [10:07:31.163] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [10:08:49.963] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [10:09:23.455] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [10:09:26.305] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [10:09:33.631] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [10:09:37.328] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [10:09:47.521] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [10:09:52.037] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [10:09:56.509] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [10:09:59.343] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [10:10:05.033] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [10:10:08.302] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [10:10:12.214] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [10:10:17.166] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [10:10:20.672] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [10:10:24.756] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [10:10:29.328] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [10:10:32.923] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [10:10:36.110] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [10:10:39.289] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [10:10:42.572] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [10:10:50.016] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [10:10:53.821] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [10:10:57.328] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [10:11:01.236] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 662
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
    #> [1] 69
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      171255 |      13876 |       3969 |              0.019 |              0.023 |            0.470 |           0.081 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      163056 |      11427 |       2932 |              0.015 |              0.018 |            0.437 |           0.070 |                  0.008 |           0.003 |
| CABA                          | F    |       55991 |       8568 |       1275 |              0.020 |              0.023 |            0.371 |           0.153 |                  0.013 |           0.006 |
| CABA                          | M    |       54590 |       9065 |       1454 |              0.024 |              0.027 |            0.418 |           0.166 |                  0.022 |           0.011 |
| Santa Fe                      | F    |        9856 |        328 |         90 |              0.007 |              0.009 |            0.345 |           0.033 |                  0.008 |           0.004 |
| Santa Fe                      | M    |        9603 |        394 |        122 |              0.010 |              0.013 |            0.372 |           0.041 |                  0.011 |           0.007 |
| Mendoza                       | F    |        7579 |        741 |         76 |              0.008 |              0.010 |            0.435 |           0.098 |                  0.003 |           0.001 |
| Mendoza                       | M    |        7499 |        762 |        127 |              0.013 |              0.017 |            0.454 |           0.102 |                  0.010 |           0.004 |
| Córdoba                       | F    |        7498 |        149 |         85 |              0.009 |              0.011 |            0.243 |           0.020 |                  0.005 |           0.003 |
| Córdoba                       | M    |        7442 |        170 |        119 |              0.013 |              0.016 |            0.252 |           0.023 |                  0.006 |           0.003 |
| Jujuy                         | M    |        7073 |         74 |        187 |              0.019 |              0.026 |            0.455 |           0.010 |                  0.001 |           0.000 |
| Jujuy                         | F    |        5305 |         38 |        111 |              0.014 |              0.021 |            0.422 |           0.007 |                  0.001 |           0.001 |
| Río Negro                     | F    |        4574 |       1049 |         98 |              0.019 |              0.021 |            0.422 |           0.229 |                  0.007 |           0.004 |
| Río Negro                     | M    |        4277 |       1028 |        148 |              0.031 |              0.035 |            0.455 |           0.240 |                  0.015 |           0.011 |
| Salta                         | M    |        4084 |        417 |         71 |              0.013 |              0.017 |            0.509 |           0.102 |                  0.014 |           0.007 |
| Tucumán                       | M    |        3799 |        121 |         14 |              0.002 |              0.004 |            0.276 |           0.032 |                  0.004 |           0.001 |
| Tucumán                       | F    |        3440 |         96 |          5 |              0.001 |              0.001 |            0.364 |           0.028 |                  0.005 |           0.001 |
| Chaco                         | M    |        3422 |        340 |        153 |              0.035 |              0.045 |            0.173 |           0.099 |                  0.060 |           0.030 |
| Chaco                         | F    |        3367 |        326 |         91 |              0.020 |              0.027 |            0.166 |           0.097 |                  0.049 |           0.021 |
| Salta                         | F    |        2883 |        300 |         23 |              0.005 |              0.008 |            0.490 |           0.104 |                  0.010 |           0.003 |
| Entre Ríos                    | F    |        2677 |        262 |         35 |              0.010 |              0.013 |            0.358 |           0.098 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        2629 |        271 |         52 |              0.016 |              0.020 |            0.392 |           0.103 |                  0.013 |           0.004 |
| Neuquén                       | M    |        2550 |       1359 |         44 |              0.012 |              0.017 |            0.468 |           0.533 |                  0.014 |           0.010 |
| Neuquén                       | F    |        2488 |       1353 |         35 |              0.009 |              0.014 |            0.441 |           0.544 |                  0.010 |           0.006 |
| Santa Cruz                    | M    |        1594 |         90 |         24 |              0.013 |              0.015 |            0.458 |           0.056 |                  0.016 |           0.008 |
| Tierra del Fuego              | M    |        1540 |         41 |         31 |              0.017 |              0.020 |            0.392 |           0.027 |                  0.013 |           0.012 |
| La Rioja                      | M    |        1534 |         19 |         58 |              0.035 |              0.038 |            0.308 |           0.012 |                  0.003 |           0.001 |
| Santa Cruz                    | F    |        1506 |         77 |         13 |              0.008 |              0.009 |            0.426 |           0.051 |                  0.009 |           0.005 |
| La Rioja                      | F    |        1337 |         19 |         44 |              0.031 |              0.033 |            0.288 |           0.014 |                  0.004 |           0.001 |
| Tierra del Fuego              | F    |        1222 |         28 |         17 |              0.012 |              0.014 |            0.342 |           0.023 |                  0.004 |           0.003 |
| Buenos Aires                  | NR   |        1215 |        106 |         50 |              0.028 |              0.041 |            0.476 |           0.087 |                  0.019 |           0.008 |
| SIN ESPECIFICAR               | F    |        1176 |         71 |          5 |              0.004 |              0.004 |            0.432 |           0.060 |                  0.007 |           0.002 |
| Santiago del Estero           | M    |        1045 |         14 |         15 |              0.008 |              0.014 |            0.145 |           0.013 |                  0.003 |           0.001 |
| Chubut                        | M    |         933 |         22 |         12 |              0.007 |              0.013 |            0.274 |           0.024 |                  0.010 |           0.010 |
| Santiago del Estero           | F    |         864 |          3 |         11 |              0.007 |              0.013 |            0.225 |           0.003 |                  0.001 |           0.001 |
| SIN ESPECIFICAR               | M    |         818 |         62 |          6 |              0.006 |              0.007 |            0.459 |           0.076 |                  0.009 |           0.007 |
| Chubut                        | F    |         814 |         10 |          5 |              0.003 |              0.006 |            0.241 |           0.012 |                  0.002 |           0.001 |
| CABA                          | NR   |         428 |        116 |         27 |              0.049 |              0.063 |            0.413 |           0.271 |                  0.035 |           0.021 |
| Corrientes                    | M    |         408 |         10 |          3 |              0.004 |              0.007 |            0.081 |           0.025 |                  0.007 |           0.005 |
| Corrientes                    | F    |         310 |          3 |          0 |              0.000 |              0.000 |            0.075 |           0.010 |                  0.003 |           0.000 |
| La Pampa                      | F    |         236 |         15 |          1 |              0.003 |              0.004 |            0.116 |           0.064 |                  0.017 |           0.004 |
| San Luis                      | M    |         229 |         18 |          0 |              0.000 |              0.000 |            0.268 |           0.079 |                  0.004 |           0.000 |
| San Juan                      | F    |         215 |          7 |          5 |              0.016 |              0.023 |            0.289 |           0.033 |                  0.009 |           0.000 |
| La Pampa                      | M    |         204 |         10 |          2 |              0.007 |              0.010 |            0.127 |           0.049 |                  0.015 |           0.000 |
| San Luis                      | F    |         203 |         17 |          0 |              0.000 |              0.000 |            0.284 |           0.084 |                  0.000 |           0.000 |
| San Juan                      | M    |         201 |          6 |          7 |              0.024 |              0.035 |            0.232 |           0.030 |                  0.010 |           0.000 |
| Catamarca                     | M    |          85 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          71 |          0 |          0 |              0.000 |              0.000 |            0.100 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          49 |          5 |          2 |              0.022 |              0.041 |            0.275 |           0.102 |                  0.000 |           0.000 |
| Catamarca                     | F    |          43 |          0 |          0 |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          41 |         15 |          1 |              0.011 |              0.024 |            0.020 |           0.366 |                  0.073 |           0.024 |
| Córdoba                       | NR   |          27 |          1 |          2 |              0.054 |              0.074 |            0.474 |           0.037 |                  0.000 |           0.000 |
| Misiones                      | F    |          27 |         14 |          1 |              0.016 |              0.037 |            0.016 |           0.519 |                  0.074 |           0.037 |
| Formosa                       | F    |          22 |          2 |          1 |              0.022 |              0.045 |            0.047 |           0.091 |                  0.000 |           0.000 |
| Salta                         | NR   |          21 |          1 |          0 |              0.000 |              0.000 |            0.389 |           0.048 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          17 |          0 |          1 |              0.030 |              0.059 |            0.309 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          11 |          0 |          2 |              0.167 |              0.182 |            0.229 |           0.000 |                  0.000 |           0.000 |


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
    #> Warning: Removed 31 rows containing missing values (position_stack).

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
