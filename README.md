
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
    #> INFO  [18:04:56.658] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [18:05:06.847] Normalize 
    #> INFO  [18:05:11.213] checkSoundness 
    #> INFO  [18:05:12.862] Mutating data 
    #> INFO  [18:07:47.269] Future rows {date: 2020-08-05, n: 1035}
    #> INFO  [18:07:47.277] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-04"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-04"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-04"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      216669 |       4009 |              0.014 |              0.019 |                       164 | 662150 |            0.327 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      130616 |       2214 |              0.012 |              0.017 |                       162 | 340800 |            0.383 |
| CABA                          |       64317 |       1347 |              0.018 |              0.021 |                       159 | 159364 |            0.404 |
| Chaco                         |        3823 |        153 |              0.030 |              0.040 |                       146 |  23461 |            0.163 |
| Jujuy                         |        2810 |         31 |              0.005 |              0.011 |                       137 |  10411 |            0.270 |
| Córdoba                       |        2713 |         50 |              0.011 |              0.018 |                       149 |  33029 |            0.082 |
| Río Negro                     |        2370 |         77 |              0.028 |              0.032 |                       141 |   8058 |            0.294 |
| Mendoza                       |        1651 |         46 |              0.021 |              0.028 |                       147 |   8016 |            0.206 |
| Santa Fe                      |        1562 |         17 |              0.008 |              0.011 |                       144 |  21943 |            0.071 |
| Neuquén                       |        1302 |         26 |              0.017 |              0.020 |                       143 |   4802 |            0.271 |
| SIN ESPECIFICAR               |        1270 |          3 |              0.002 |              0.002 |                       135 |   2827 |            0.449 |
| Entre Ríos                    |         899 |          9 |              0.007 |              0.010 |                       142 |   5121 |            0.176 |
| Tierra del Fuego              |         717 |          2 |              0.002 |              0.003 |                       141 |   3232 |            0.222 |
| Santa Cruz                    |         605 |          3 |              0.004 |              0.005 |                       133 |   1524 |            0.397 |
| La Rioja                      |         400 |         18 |              0.039 |              0.045 |                       133 |   4146 |            0.096 |
| Salta                         |         349 |          2 |              0.003 |              0.006 |                       137 |   2032 |            0.172 |
| Chubut                        |         299 |          3 |              0.005 |              0.010 |                       127 |   3039 |            0.098 |
| Tucumán                       |         290 |          4 |              0.002 |              0.014 |                       139 |  12274 |            0.024 |
| Corrientes                    |         193 |          2 |              0.005 |              0.010 |                       138 |   4469 |            0.043 |
| La Pampa                      |         165 |          0 |              0.000 |              0.000 |                       121 |   1221 |            0.135 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      130616 | 340800 |       2214 |               13.5 |              0.012 |              0.017 |            0.383 |           0.109 |                  0.013 |           0.005 |
| CABA                          |       64317 | 159364 |       1347 |               14.8 |              0.018 |              0.021 |            0.404 |           0.196 |                  0.018 |           0.008 |
| Chaco                         |        3823 |  23461 |        153 |               14.5 |              0.030 |              0.040 |            0.163 |           0.115 |                  0.069 |           0.027 |
| Jujuy                         |        2810 |  10411 |         31 |               12.6 |              0.005 |              0.011 |            0.270 |           0.007 |                  0.001 |           0.001 |
| Córdoba                       |        2713 |  33029 |         50 |               22.2 |              0.011 |              0.018 |            0.082 |           0.057 |                  0.015 |           0.008 |
| Río Negro                     |        2370 |   8058 |         77 |               13.8 |              0.028 |              0.032 |            0.294 |           0.297 |                  0.019 |           0.014 |
| Mendoza                       |        1651 |   8016 |         46 |               12.6 |              0.021 |              0.028 |            0.206 |           0.376 |                  0.022 |           0.005 |
| Santa Fe                      |        1562 |  21943 |         17 |               13.3 |              0.008 |              0.011 |            0.071 |           0.100 |                  0.022 |           0.008 |
| Neuquén                       |        1302 |   4802 |         26 |               18.6 |              0.017 |              0.020 |            0.271 |           0.681 |                  0.019 |           0.011 |
| SIN ESPECIFICAR               |        1270 |   2827 |          3 |               26.7 |              0.002 |              0.002 |            0.449 |           0.071 |                  0.008 |           0.005 |
| Entre Ríos                    |         899 |   5121 |          9 |               13.9 |              0.007 |              0.010 |            0.176 |           0.215 |                  0.012 |           0.002 |
| Tierra del Fuego              |         717 |   3232 |          2 |               19.0 |              0.002 |              0.003 |            0.222 |           0.018 |                  0.004 |           0.004 |
| Santa Cruz                    |         605 |   1524 |          3 |               13.7 |              0.004 |              0.005 |            0.397 |           0.061 |                  0.017 |           0.010 |
| La Rioja                      |         400 |   4146 |         18 |               13.2 |              0.039 |              0.045 |            0.096 |           0.068 |                  0.015 |           0.005 |
| Salta                         |         349 |   2032 |          2 |                2.5 |              0.003 |              0.006 |            0.172 |           0.318 |                  0.020 |           0.009 |
| Chubut                        |         299 |   3039 |          3 |               20.7 |              0.005 |              0.010 |            0.098 |           0.047 |                  0.013 |           0.010 |
| Tucumán                       |         290 |  12274 |          4 |               14.2 |              0.002 |              0.014 |            0.024 |           0.117 |                  0.031 |           0.007 |
| Corrientes                    |         193 |   4469 |          2 |               12.0 |              0.005 |              0.010 |            0.043 |           0.026 |                  0.010 |           0.005 |
| La Pampa                      |         165 |   1221 |          0 |                NaN |              0.000 |              0.000 |            0.135 |           0.036 |                  0.006 |           0.000 |
| Formosa                       |          82 |    848 |          0 |                NaN |              0.000 |              0.000 |            0.097 |           0.012 |                  0.000 |           0.000 |
| Santiago del Estero           |          68 |   5359 |          0 |                NaN |              0.000 |              0.000 |            0.013 |           0.029 |                  0.015 |           0.000 |
| Catamarca                     |          62 |   2093 |          0 |                NaN |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          52 |   2199 |          2 |                6.5 |              0.012 |              0.038 |            0.024 |           0.577 |                  0.115 |           0.058 |
| San Luis                      |          32 |    850 |          0 |                NaN |              0.000 |              0.000 |            0.038 |           0.312 |                  0.031 |           0.000 |
| San Juan                      |          22 |   1032 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.227 |                  0.045 |           0.000 |

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
    #> INFO  [18:09:07.437] Processing {current.group: }
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
|             14 | 2020-08-04              |                       124 |        1774 |  11537 |        972 |        114 |              0.053 |              0.064 |            0.154 |           0.548 |                  0.095 |           0.056 |
|             15 | 2020-08-04              |                       146 |        2436 |  20256 |       1318 |        179 |              0.059 |              0.073 |            0.120 |           0.541 |                  0.090 |           0.050 |
|             16 | 2020-08-04              |                       157 |        3233 |  31861 |       1667 |        236 |              0.057 |              0.073 |            0.101 |           0.516 |                  0.080 |           0.044 |
|             17 | 2020-08-04              |                       160 |        4346 |  45912 |       2186 |        341 |              0.062 |              0.078 |            0.095 |           0.503 |                  0.072 |           0.038 |
|             18 | 2020-08-04              |                       160 |        5346 |  59105 |       2583 |        413 |              0.061 |              0.077 |            0.090 |           0.483 |                  0.065 |           0.035 |
|             19 | 2020-08-04              |                       160 |        6785 |  73237 |       3170 |        493 |              0.058 |              0.073 |            0.093 |           0.467 |                  0.061 |           0.032 |
|             20 | 2020-08-04              |                       160 |        9183 |  90602 |       4012 |        588 |              0.052 |              0.064 |            0.101 |           0.437 |                  0.056 |           0.029 |
|             21 | 2020-08-04              |                       160 |       13543 | 114034 |       5328 |        739 |              0.045 |              0.055 |            0.119 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-08-04              |                       160 |       18768 | 139395 |       6767 |        921 |              0.041 |              0.049 |            0.135 |           0.361 |                  0.044 |           0.022 |
|             23 | 2020-08-04              |                       160 |       25192 | 167658 |       8295 |       1136 |              0.038 |              0.045 |            0.150 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-04              |                       160 |       34786 | 202747 |      10423 |       1378 |              0.033 |              0.040 |            0.172 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-05              |                       161 |       47587 | 244109 |      12749 |       1684 |              0.030 |              0.035 |            0.195 |           0.268 |                  0.031 |           0.014 |
|             26 | 2020-08-05              |                       161 |       65250 | 295988 |      15778 |       2067 |              0.027 |              0.032 |            0.220 |           0.242 |                  0.028 |           0.012 |
|             27 | 2020-08-05              |                       161 |       83823 | 346520 |      18493 |       2492 |              0.025 |              0.030 |            0.242 |           0.221 |                  0.025 |           0.011 |
|             28 | 2020-08-05              |                       162 |      106965 | 404995 |      21669 |       2982 |              0.023 |              0.028 |            0.264 |           0.203 |                  0.023 |           0.010 |
|             29 | 2020-08-05              |                       163 |      135303 | 475266 |      24959 |       3464 |              0.021 |              0.026 |            0.285 |           0.184 |                  0.021 |           0.009 |
|             30 | 2020-08-05              |                       163 |      171467 | 557972 |      27976 |       3833 |              0.018 |              0.022 |            0.307 |           0.163 |                  0.019 |           0.008 |
|             31 | 2020-08-29              |                       164 |      206457 | 638422 |      29986 |       3989 |              0.015 |              0.019 |            0.323 |           0.145 |                  0.017 |           0.007 |
|             32 | 2020-08-29              |                       164 |      216669 | 662150 |      30434 |       4009 |              0.014 |              0.019 |            0.327 |           0.140 |                  0.016 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [18:11:11.790] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [18:11:40.062] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [18:11:53.368] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [18:11:55.053] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [18:11:59.105] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [18:12:01.375] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [18:12:07.786] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [18:12:10.219] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [18:12:12.638] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [18:12:14.351] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [18:12:17.317] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [18:12:19.510] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [18:12:21.780] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [18:12:24.374] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [18:12:26.911] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [18:12:36.467] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [18:12:41.831] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [18:12:45.431] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [18:12:48.143] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [18:12:50.434] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [18:12:52.765] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [18:12:56.904] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [18:12:59.714] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [18:13:02.065] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [18:13:04.484] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       66892 |       7739 |       1245 |              0.013 |              0.019 |            0.402 |           0.116 |                  0.016 |           0.007 |
| Buenos Aires                  | F    |       63250 |       6485 |        958 |              0.011 |              0.015 |            0.365 |           0.103 |                  0.011 |           0.004 |
| CABA                          | F    |       32437 |       6181 |        595 |              0.015 |              0.018 |            0.385 |           0.191 |                  0.013 |           0.006 |
| CABA                          | M    |       31629 |       6353 |        737 |              0.020 |              0.023 |            0.424 |           0.201 |                  0.023 |           0.011 |
| Chaco                         | F    |        1912 |        220 |         57 |              0.022 |              0.030 |            0.163 |           0.115 |                  0.061 |           0.021 |
| Chaco                         | M    |        1909 |        219 |         96 |              0.038 |              0.050 |            0.163 |           0.115 |                  0.078 |           0.033 |
| Jujuy                         | M    |        1737 |         15 |         18 |              0.005 |              0.010 |            0.303 |           0.009 |                  0.002 |           0.002 |
| Córdoba                       | M    |        1359 |         73 |         25 |              0.012 |              0.018 |            0.084 |           0.054 |                  0.016 |           0.010 |
| Córdoba                       | F    |        1351 |         80 |         25 |              0.011 |              0.019 |            0.080 |           0.059 |                  0.015 |           0.007 |
| Río Negro                     | F    |        1235 |        358 |         28 |              0.020 |              0.023 |            0.285 |           0.290 |                  0.011 |           0.006 |
| Río Negro                     | M    |        1134 |        345 |         49 |              0.037 |              0.043 |            0.305 |           0.304 |                  0.028 |           0.022 |
| Jujuy                         | F    |        1068 |          4 |         13 |              0.004 |              0.012 |            0.230 |           0.004 |                  0.001 |           0.001 |
| Mendoza                       | F    |         846 |        310 |         14 |              0.013 |              0.017 |            0.208 |           0.366 |                  0.011 |           0.001 |
| Mendoza                       | M    |         794 |        306 |         30 |              0.027 |              0.038 |            0.204 |           0.385 |                  0.035 |           0.010 |
| Santa Fe                      | F    |         793 |         60 |          6 |              0.005 |              0.008 |            0.069 |           0.076 |                  0.015 |           0.003 |
| Santa Fe                      | M    |         769 |         96 |         11 |              0.010 |              0.014 |            0.073 |           0.125 |                  0.029 |           0.013 |
| SIN ESPECIFICAR               | F    |         761 |         45 |          0 |              0.000 |              0.000 |            0.445 |           0.059 |                  0.004 |           0.000 |
| Neuquén                       | M    |         659 |        428 |         12 |              0.015 |              0.018 |            0.274 |           0.649 |                  0.017 |           0.011 |
| Neuquén                       | F    |         643 |        459 |         14 |              0.018 |              0.022 |            0.268 |           0.714 |                  0.022 |           0.011 |
| SIN ESPECIFICAR               | M    |         505 |         44 |          2 |              0.003 |              0.004 |            0.458 |           0.087 |                  0.012 |           0.010 |
| Buenos Aires                  | NR   |         474 |         46 |         11 |              0.014 |              0.023 |            0.396 |           0.097 |                  0.027 |           0.015 |
| Entre Ríos                    | M    |         458 |        108 |          5 |              0.008 |              0.011 |            0.185 |           0.236 |                  0.011 |           0.002 |
| Entre Ríos                    | F    |         440 |         85 |          4 |              0.006 |              0.009 |            0.166 |           0.193 |                  0.014 |           0.002 |
| Tierra del Fuego              | M    |         430 |          8 |          2 |              0.003 |              0.005 |            0.249 |           0.019 |                  0.007 |           0.007 |
| Santa Cruz                    | M    |         308 |         19 |          2 |              0.006 |              0.006 |            0.379 |           0.062 |                  0.016 |           0.010 |
| Santa Cruz                    | F    |         296 |         18 |          1 |              0.003 |              0.003 |            0.417 |           0.061 |                  0.017 |           0.010 |
| Tierra del Fuego              | F    |         286 |          5 |          0 |              0.000 |              0.000 |            0.190 |           0.017 |                  0.000 |           0.000 |
| CABA                          | NR   |         251 |         74 |         15 |              0.035 |              0.060 |            0.377 |           0.295 |                  0.052 |           0.036 |
| La Rioja                      | F    |         215 |         15 |          7 |              0.029 |              0.033 |            0.107 |           0.070 |                  0.023 |           0.009 |
| Salta                         | M    |         210 |         66 |          2 |              0.005 |              0.010 |            0.162 |           0.314 |                  0.024 |           0.014 |
| La Rioja                      | M    |         183 |         12 |         11 |              0.050 |              0.060 |            0.086 |           0.066 |                  0.005 |           0.000 |
| Tucumán                       | M    |         170 |         19 |          2 |              0.002 |              0.012 |            0.022 |           0.112 |                  0.018 |           0.000 |
| Chubut                        | M    |         161 |         10 |          1 |              0.003 |              0.006 |            0.103 |           0.062 |                  0.012 |           0.012 |
| Salta                         | F    |         139 |         45 |          0 |              0.000 |              0.000 |            0.192 |           0.324 |                  0.014 |           0.000 |
| Chubut                        | F    |         134 |          4 |          2 |              0.008 |              0.015 |            0.093 |           0.030 |                  0.015 |           0.007 |
| Tucumán                       | F    |         119 |         15 |          2 |              0.003 |              0.017 |            0.026 |           0.126 |                  0.050 |           0.017 |
| Corrientes                    | M    |         108 |          5 |          2 |              0.008 |              0.019 |            0.043 |           0.046 |                  0.009 |           0.009 |
| La Pampa                      | F    |          96 |          4 |          0 |              0.000 |              0.000 |            0.145 |           0.042 |                  0.000 |           0.000 |
| Corrientes                    | F    |          85 |          0 |          0 |              0.000 |              0.000 |            0.043 |           0.000 |                  0.012 |           0.000 |
| La Pampa                      | M    |          69 |          2 |          0 |              0.000 |              0.000 |            0.123 |           0.029 |                  0.014 |           0.000 |
| Formosa                       | M    |          67 |          0 |          0 |              0.000 |              0.000 |            0.133 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          43 |          2 |          0 |              0.000 |              0.000 |            0.012 |           0.047 |                  0.023 |           0.000 |
| Catamarca                     | M    |          38 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          30 |         16 |          1 |              0.010 |              0.033 |            0.026 |           0.533 |                  0.133 |           0.067 |
| San Luis                      | M    |          25 |          8 |          0 |              0.000 |              0.000 |            0.053 |           0.320 |                  0.040 |           0.000 |
| Santiago del Estero           | F    |          25 |          0 |          0 |              0.000 |              0.000 |            0.017 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | F    |          24 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         14 |          1 |              0.014 |              0.045 |            0.021 |           0.636 |                  0.091 |           0.045 |
| San Juan                      | M    |          16 |          2 |          0 |              0.000 |              0.000 |            0.027 |           0.125 |                  0.000 |           0.000 |
| Formosa                       | F    |          15 |          1 |          0 |              0.000 |              0.000 |            0.043 |           0.067 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          11 |          4 |          2 |              0.125 |              0.182 |            0.239 |           0.364 |                  0.000 |           0.000 |


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
