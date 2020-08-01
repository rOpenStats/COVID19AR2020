
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
    #> INFO  [00:47:15.665] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [00:47:21.280] Normalize 
    #> INFO  [00:47:22.110] checkSoundness 
    #> INFO  [00:47:22.587] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-07-31"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-07-31"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-07-31"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-07-31              |      191289 |       3543 |              0.014 |              0.019 |                       158 | 607237 |            0.315 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      113924 |       1912 |              0.012 |              0.017 |                       156 | 309163 |            0.368 |
| CABA                          |       59225 |       1229 |              0.017 |              0.021 |                       154 | 148129 |            0.400 |
| Chaco                         |        3579 |        142 |              0.029 |              0.040 |                       142 |  22099 |            0.162 |
| Jujuy                         |        2258 |         31 |              0.005 |              0.014 |                       133 |   9353 |            0.241 |
| Córdoba                       |        2255 |         46 |              0.012 |              0.020 |                       144 |  31071 |            0.073 |
| Río Negro                     |        1947 |         71 |              0.032 |              0.036 |                       137 |   7300 |            0.267 |
| Santa Fe                      |        1216 |         13 |              0.007 |              0.011 |                       140 |  20570 |            0.059 |
| Mendoza                       |        1212 |         32 |              0.019 |              0.026 |                       143 |   6980 |            0.174 |
| Neuquén                       |        1187 |         23 |              0.016 |              0.019 |                       139 |   4508 |            0.263 |
| SIN ESPECIFICAR               |        1136 |          3 |              0.002 |              0.003 |                       130 |   2588 |            0.439 |
| Entre Ríos                    |         813 |          8 |              0.007 |              0.010 |                       137 |   4788 |            0.170 |
| Santa Cruz                    |         455 |          3 |              0.006 |              0.007 |                       129 |   1306 |            0.348 |
| Tierra del Fuego              |         446 |          2 |              0.003 |              0.004 |                       136 |   2693 |            0.166 |
| La Rioja                      |         338 |         16 |              0.040 |              0.047 |                       128 |   3795 |            0.089 |
| Chubut                        |         274 |          3 |              0.005 |              0.011 |                       123 |   2877 |            0.095 |
| Salta                         |         253 |          2 |              0.004 |              0.008 |                       132 |   1832 |            0.138 |
| Tucumán                       |         204 |          4 |              0.004 |              0.020 |                       135 |  11331 |            0.018 |
| Corrientes                    |         168 |          1 |              0.002 |              0.006 |                       134 |   4158 |            0.040 |
| La Pampa                      |         117 |          0 |              0.000 |              0.000 |                       117 |    834 |            0.140 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      113924 | 309163 |       1912 |               13.4 |              0.012 |              0.017 |            0.368 |           0.116 |                  0.014 |           0.006 |
| CABA                          |       59225 | 148129 |       1229 |               14.6 |              0.017 |              0.021 |            0.400 |           0.204 |                  0.019 |           0.008 |
| Chaco                         |        3579 |  22099 |        142 |               14.5 |              0.029 |              0.040 |            0.162 |           0.110 |                  0.067 |           0.027 |
| Jujuy                         |        2258 |   9353 |         31 |               12.6 |              0.005 |              0.014 |            0.241 |           0.007 |                  0.002 |           0.002 |
| Córdoba                       |        2255 |  31071 |         46 |               22.8 |              0.012 |              0.020 |            0.073 |           0.067 |                  0.018 |           0.009 |
| Río Negro                     |        1947 |   7300 |         71 |               13.7 |              0.032 |              0.036 |            0.267 |           0.345 |                  0.024 |           0.016 |
| Santa Fe                      |        1216 |  20570 |         13 |               15.1 |              0.007 |              0.011 |            0.059 |           0.117 |                  0.025 |           0.008 |
| Mendoza                       |        1212 |   6980 |         32 |               10.0 |              0.019 |              0.026 |            0.174 |           0.427 |                  0.027 |           0.007 |
| Neuquén                       |        1187 |   4508 |         23 |               18.6 |              0.016 |              0.019 |            0.263 |           0.687 |                  0.019 |           0.011 |
| SIN ESPECIFICAR               |        1136 |   2588 |          3 |               26.7 |              0.002 |              0.003 |            0.439 |           0.077 |                  0.009 |           0.005 |
| Entre Ríos                    |         813 |   4788 |          8 |               12.6 |              0.007 |              0.010 |            0.170 |           0.215 |                  0.012 |           0.002 |
| Santa Cruz                    |         455 |   1306 |          3 |               13.7 |              0.006 |              0.007 |            0.348 |           0.073 |                  0.018 |           0.013 |
| Tierra del Fuego              |         446 |   2693 |          2 |               19.0 |              0.003 |              0.004 |            0.166 |           0.025 |                  0.007 |           0.007 |
| La Rioja                      |         338 |   3795 |         16 |               13.2 |              0.040 |              0.047 |            0.089 |           0.074 |                  0.018 |           0.006 |
| Chubut                        |         274 |   2877 |          3 |               20.7 |              0.005 |              0.011 |            0.095 |           0.051 |                  0.015 |           0.011 |
| Salta                         |         253 |   1832 |          2 |                2.5 |              0.004 |              0.008 |            0.138 |           0.368 |                  0.020 |           0.008 |
| Tucumán                       |         204 |  11331 |          4 |               14.2 |              0.004 |              0.020 |            0.018 |           0.162 |                  0.044 |           0.010 |
| Corrientes                    |         168 |   4158 |          1 |               12.0 |              0.002 |              0.006 |            0.040 |           0.024 |                  0.012 |           0.006 |
| La Pampa                      |         117 |    834 |          0 |                NaN |              0.000 |              0.000 |            0.140 |           0.034 |                  0.009 |           0.000 |
| Formosa                       |          79 |    831 |          0 |                NaN |              0.000 |              0.000 |            0.095 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     |          60 |   1999 |          0 |                NaN |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          51 |   2157 |          2 |                6.5 |              0.018 |              0.039 |            0.024 |           0.588 |                  0.137 |           0.059 |
| Santiago del Estero           |          46 |   5067 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.043 |                  0.022 |           0.000 |
| San Luis                      |          26 |    810 |          0 |                NaN |              0.000 |              0.000 |            0.032 |           0.385 |                  0.038 |           0.000 |
| San Juan                      |          20 |    998 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.250 |                  0.050 |           0.000 |


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
    #> INFO  [00:49:00.032] Processing {current.group: }
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
|             11 | 2020-07-29              |                        37 |          96 |    666 |         66 |          9 |              0.066 |              0.094 |            0.144 |           0.688 |                  0.125 |           0.062 |
|             12 | 2020-07-29              |                        60 |         412 |   2049 |        255 |         17 |              0.033 |              0.041 |            0.201 |           0.619 |                  0.092 |           0.053 |
|             13 | 2020-07-31              |                        93 |        1084 |   5517 |        600 |         63 |              0.049 |              0.058 |            0.196 |           0.554 |                  0.094 |           0.056 |
|             14 | 2020-07-31              |                       122 |        1769 |  11537 |        968 |        114 |              0.053 |              0.064 |            0.153 |           0.547 |                  0.094 |           0.057 |
|             15 | 2020-07-31              |                       144 |        2429 |  20253 |       1313 |        177 |              0.058 |              0.073 |            0.120 |           0.541 |                  0.090 |           0.051 |
|             16 | 2020-07-31              |                       153 |        3221 |  31854 |       1659 |        233 |              0.057 |              0.072 |            0.101 |           0.515 |                  0.080 |           0.044 |
|             17 | 2020-07-31              |                       156 |        4327 |  45904 |       2177 |        337 |              0.062 |              0.078 |            0.094 |           0.503 |                  0.072 |           0.038 |
|             18 | 2020-07-31              |                       156 |        5319 |  59096 |       2571 |        404 |              0.060 |              0.076 |            0.090 |           0.483 |                  0.065 |           0.035 |
|             19 | 2020-07-31              |                       156 |        6752 |  73226 |       3157 |        482 |              0.057 |              0.071 |            0.092 |           0.468 |                  0.061 |           0.032 |
|             20 | 2020-07-31              |                       156 |        9131 |  90591 |       3994 |        574 |              0.051 |              0.063 |            0.101 |           0.437 |                  0.056 |           0.029 |
|             21 | 2020-07-31              |                       156 |       13470 | 114019 |       5301 |        721 |              0.044 |              0.054 |            0.118 |           0.394 |                  0.049 |           0.025 |
|             22 | 2020-07-31              |                       156 |       18679 | 139373 |       6733 |        895 |              0.040 |              0.048 |            0.134 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-31              |                       156 |       25083 | 167633 |       8257 |       1107 |              0.037 |              0.044 |            0.150 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-07-31              |                       156 |       34629 | 202700 |      10372 |       1336 |              0.032 |              0.039 |            0.171 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-07-31              |                       156 |       47387 | 244047 |      12680 |       1625 |              0.029 |              0.034 |            0.194 |           0.268 |                  0.031 |           0.014 |
|             26 | 2020-07-31              |                       156 |       65005 | 295909 |      15685 |       1988 |              0.026 |              0.031 |            0.220 |           0.241 |                  0.028 |           0.012 |
|             27 | 2020-07-31              |                       156 |       83508 | 346325 |      18357 |       2378 |              0.024 |              0.028 |            0.241 |           0.220 |                  0.025 |           0.011 |
|             28 | 2020-07-31              |                       157 |      106528 | 404674 |      21448 |       2808 |              0.022 |              0.026 |            0.263 |           0.201 |                  0.023 |           0.010 |
|             29 | 2020-07-31              |                       158 |      134602 | 474545 |      24598 |       3202 |              0.020 |              0.024 |            0.284 |           0.183 |                  0.021 |           0.009 |
|             30 | 2020-07-31              |                       158 |      169811 | 555542 |      27330 |       3482 |              0.017 |              0.021 |            0.306 |           0.161 |                  0.018 |           0.008 |
|             31 | 2020-07-31              |                       158 |      191289 | 607237 |      28478 |       3543 |              0.014 |              0.019 |            0.315 |           0.149 |                  0.017 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [00:49:38.717] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [00:49:58.964] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [00:50:09.750] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [00:50:11.128] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [00:50:14.658] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [00:50:16.572] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [00:50:20.918] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [00:50:23.256] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [00:50:25.541] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [00:50:27.120] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [00:50:29.550] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [00:50:31.587] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [00:50:33.677] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [00:50:36.024] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [00:50:37.966] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [00:50:40.116] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [00:50:42.601] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [00:50:44.658] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [00:50:46.584] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [00:50:48.718] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [00:50:50.699] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [00:50:54.158] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [00:50:56.330] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [00:50:58.363] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [00:51:00.554] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
    #> [1] 62
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |       58343 |       7167 |       1082 |              0.013 |              0.019 |            0.387 |           0.123 |                  0.016 |           0.007 |
| Buenos Aires                  | F    |       55154 |       5978 |        821 |              0.011 |              0.015 |            0.351 |           0.108 |                  0.011 |           0.004 |
| CABA                          | F    |       29802 |       5916 |        540 |              0.015 |              0.018 |            0.382 |           0.199 |                  0.014 |           0.006 |
| CABA                          | M    |       29181 |       6069 |        674 |              0.020 |              0.023 |            0.420 |           0.208 |                  0.024 |           0.011 |
| Chaco                         | F    |        1803 |        192 |         51 |              0.021 |              0.028 |            0.163 |           0.106 |                  0.058 |           0.020 |
| Chaco                         | M    |        1774 |        202 |         91 |              0.038 |              0.051 |            0.161 |           0.114 |                  0.077 |           0.034 |
| Jujuy                         | M    |        1421 |         12 |         18 |              0.006 |              0.013 |            0.273 |           0.008 |                  0.002 |           0.002 |
| Córdoba                       | M    |        1129 |         71 |         23 |              0.013 |              0.020 |            0.074 |           0.063 |                  0.019 |           0.011 |
| Córdoba                       | F    |        1123 |         80 |         23 |              0.012 |              0.020 |            0.071 |           0.071 |                  0.018 |           0.008 |
| Río Negro                     | F    |        1010 |        340 |         26 |              0.023 |              0.026 |            0.258 |           0.337 |                  0.014 |           0.007 |
| Río Negro                     | M    |         937 |        331 |         45 |              0.042 |              0.048 |            0.278 |           0.353 |                  0.034 |           0.027 |
| Jujuy                         | F    |         832 |          3 |         13 |              0.005 |              0.016 |            0.202 |           0.004 |                  0.001 |           0.001 |
| SIN ESPECIFICAR               | F    |         672 |         44 |          0 |              0.000 |              0.000 |            0.430 |           0.065 |                  0.004 |           0.000 |
| Santa Fe                      | F    |         616 |         55 |          5 |              0.005 |              0.008 |            0.058 |           0.089 |                  0.019 |           0.003 |
| Mendoza                       | F    |         610 |        258 |         10 |              0.012 |              0.016 |            0.173 |           0.423 |                  0.013 |           0.002 |
| Neuquén                       | M    |         608 |        393 |         10 |              0.014 |              0.016 |            0.268 |           0.646 |                  0.016 |           0.012 |
| Santa Fe                      | M    |         600 |         87 |          8 |              0.009 |              0.013 |            0.061 |           0.145 |                  0.032 |           0.013 |
| Mendoza                       | M    |         595 |        256 |         20 |              0.024 |              0.034 |            0.174 |           0.430 |                  0.042 |           0.012 |
| Neuquén                       | F    |         579 |        423 |         13 |              0.018 |              0.022 |            0.259 |           0.731 |                  0.021 |           0.010 |
| SIN ESPECIFICAR               | M    |         460 |         43 |          2 |              0.003 |              0.004 |            0.454 |           0.093 |                  0.013 |           0.011 |
| Buenos Aires                  | NR   |         427 |         40 |          9 |              0.013 |              0.021 |            0.387 |           0.094 |                  0.023 |           0.012 |
| Entre Ríos                    | M    |         416 |         99 |          5 |              0.009 |              0.012 |            0.180 |           0.238 |                  0.010 |           0.002 |
| Entre Ríos                    | F    |         396 |         76 |          3 |              0.006 |              0.008 |            0.161 |           0.192 |                  0.015 |           0.003 |
| Tierra del Fuego              | M    |         273 |          7 |          2 |              0.005 |              0.007 |            0.187 |           0.026 |                  0.011 |           0.011 |
| CABA                          | NR   |         242 |         73 |         15 |              0.036 |              0.062 |            0.379 |           0.302 |                  0.054 |           0.037 |
| Santa Cruz                    | M    |         235 |         18 |          2 |              0.008 |              0.009 |            0.331 |           0.077 |                  0.021 |           0.013 |
| Santa Cruz                    | F    |         219 |         15 |          1 |              0.004 |              0.005 |            0.369 |           0.068 |                  0.014 |           0.014 |
| La Rioja                      | F    |         181 |         14 |          7 |              0.033 |              0.039 |            0.099 |           0.077 |                  0.028 |           0.011 |
| Tierra del Fuego              | F    |         172 |          4 |          0 |              0.000 |              0.000 |            0.140 |           0.023 |                  0.000 |           0.000 |
| Salta                         | M    |         158 |         56 |          2 |              0.006 |              0.013 |            0.133 |           0.354 |                  0.025 |           0.013 |
| La Rioja                      | M    |         155 |         11 |          9 |              0.048 |              0.058 |            0.080 |           0.071 |                  0.006 |           0.000 |
| Chubut                        | M    |         150 |         10 |          1 |              0.003 |              0.007 |            0.101 |           0.067 |                  0.013 |           0.013 |
| Tucumán                       | M    |         131 |         18 |          2 |              0.003 |              0.015 |            0.019 |           0.137 |                  0.023 |           0.000 |
| Chubut                        | F    |         120 |          4 |          2 |              0.008 |              0.017 |            0.088 |           0.033 |                  0.017 |           0.008 |
| Corrientes                    | M    |          99 |          4 |          1 |              0.004 |              0.010 |            0.043 |           0.040 |                  0.010 |           0.010 |
| Salta                         | F    |          95 |         37 |          0 |              0.000 |              0.000 |            0.149 |           0.389 |                  0.011 |           0.000 |
| Tucumán                       | F    |          73 |         15 |          2 |              0.005 |              0.027 |            0.017 |           0.205 |                  0.082 |           0.027 |
| Corrientes                    | F    |          69 |          0 |          0 |              0.000 |              0.000 |            0.038 |           0.000 |                  0.014 |           0.000 |
| La Pampa                      | F    |          66 |          2 |          0 |              0.000 |              0.000 |            0.155 |           0.030 |                  0.000 |           0.000 |
| Formosa                       | M    |          65 |          0 |          0 |              0.000 |              0.000 |            0.132 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      | M    |          51 |          2 |          0 |              0.000 |              0.000 |            0.126 |           0.039 |                  0.020 |           0.000 |
| Catamarca                     | M    |          38 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          34 |          2 |          0 |              0.000 |              0.000 |            0.010 |           0.059 |                  0.029 |           0.000 |
| Misiones                      | M    |          30 |         16 |          1 |              0.016 |              0.033 |            0.026 |           0.533 |                  0.133 |           0.067 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          21 |         14 |          1 |              0.020 |              0.048 |            0.021 |           0.667 |                  0.143 |           0.048 |
| San Luis                      | M    |          20 |          8 |          0 |              0.000 |              0.000 |            0.044 |           0.400 |                  0.050 |           0.000 |
| San Juan                      | M    |          15 |          2 |          0 |              0.000 |              0.000 |            0.026 |           0.133 |                  0.000 |           0.000 |
| Formosa                       | F    |          14 |          0 |          0 |              0.000 |              0.000 |            0.041 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          12 |          0 |          0 |              0.000 |              0.000 |            0.009 |           0.000 |                  0.000 |           0.000 |


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
