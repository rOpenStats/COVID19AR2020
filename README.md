
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
    #> INFO  [08:30:37.050] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:30:48.796] Normalize 
    #> INFO  [08:30:52.359] checkSoundness 
    #> INFO  [08:30:53.497] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-10-01"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-10-01"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-10-01"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-10-01              |      764998 |      20288 |              0.022 |              0.027 |                       223 | 1754670 |            0.436 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      421804 |      13137 |              0.026 |              0.031 |                       218 | 904056 |            0.467 |
| CABA                          |      125924 |       3485 |              0.025 |              0.028 |                       216 | 322755 |            0.390 |
| Santa Fe                      |       44471 |        467 |              0.009 |              0.011 |                       202 |  83729 |            0.531 |
| Córdoba                       |       36161 |        415 |              0.010 |              0.011 |                       208 |  86859 |            0.416 |
| Mendoza                       |       25841 |        326 |              0.010 |              0.013 |                       205 |  53648 |            0.482 |
| Jujuy                         |       15841 |        554 |              0.027 |              0.035 |                       196 |  35851 |            0.442 |
| Tucumán                       |       15538 |        133 |              0.005 |              0.009 |                       197 |  33434 |            0.465 |
| Río Negro                     |       13126 |        385 |              0.027 |              0.029 |                       199 |  27350 |            0.480 |
| Salta                         |       12770 |        349 |              0.022 |              0.027 |                       194 |  23622 |            0.541 |
| Chaco                         |        8742 |        290 |              0.026 |              0.033 |                       204 |  48335 |            0.181 |
| Neuquén                       |        8078 |        146 |              0.011 |              0.018 |                       201 |  15608 |            0.518 |
| Entre Ríos                    |        7669 |        138 |              0.015 |              0.018 |                       199 |  19193 |            0.400 |
| Santa Cruz                    |        4979 |         64 |              0.011 |              0.013 |                       191 |  10419 |            0.478 |
| La Rioja                      |        4848 |        127 |              0.025 |              0.026 |                       191 |  13928 |            0.348 |
| Tierra del Fuego              |        4524 |         66 |              0.012 |              0.015 |                       198 |  10578 |            0.428 |
| Chubut                        |        4142 |         55 |              0.008 |              0.013 |                       185 |   9099 |            0.455 |
| Santiago del Estero           |        3545 |         61 |              0.011 |              0.017 |                       185 |  14019 |            0.253 |
| SIN ESPECIFICAR               |        2293 |         19 |              0.007 |              0.008 |                       192 |   5152 |            0.445 |
| San Luis                      |        1575 |          7 |              0.002 |              0.004 |                       178 |   5253 |            0.300 |
| Corrientes                    |        1100 |         18 |              0.009 |              0.016 |                       196 |  11390 |            0.097 |
| La Pampa                      |         790 |          5 |              0.005 |              0.006 |                       179 |   6657 |            0.119 |
| San Juan                      |         750 |         37 |              0.040 |              0.049 |                       188 |   2005 |            0.374 |
| Catamarca                     |         291 |          0 |              0.000 |              0.000 |                       170 |   5896 |            0.049 |
| Formosa                       |         102 |          1 |              0.007 |              0.010 |                       170 |   1288 |            0.079 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      421804 | 904056 |      13137 |               16.3 |              0.026 |              0.031 |            0.467 |           0.071 |                  0.011 |           0.005 |
| CABA                          |      125924 | 322755 |       3485 |               16.7 |              0.025 |              0.028 |            0.390 |           0.153 |                  0.017 |           0.009 |
| Santa Fe                      |       44471 |  83729 |        467 |               12.5 |              0.009 |              0.011 |            0.531 |           0.027 |                  0.007 |           0.004 |
| Córdoba                       |       36161 |  86859 |        415 |               12.1 |              0.010 |              0.011 |            0.416 |           0.012 |                  0.004 |           0.002 |
| Mendoza                       |       25841 |  53648 |        326 |               10.9 |              0.010 |              0.013 |            0.482 |           0.072 |                  0.006 |           0.002 |
| Jujuy                         |       15841 |  35851 |        554 |               16.6 |              0.027 |              0.035 |            0.442 |           0.010 |                  0.001 |           0.001 |
| Tucumán                       |       15538 |  33434 |        133 |               10.1 |              0.005 |              0.009 |            0.465 |           0.017 |                  0.003 |           0.001 |
| Río Negro                     |       13126 |  27350 |        385 |               14.2 |              0.027 |              0.029 |            0.480 |           0.202 |                  0.009 |           0.006 |
| Salta                         |       12770 |  23622 |        349 |               11.6 |              0.022 |              0.027 |            0.541 |           0.100 |                  0.016 |           0.009 |
| Chaco                         |        8742 |  48335 |        290 |               14.4 |              0.026 |              0.033 |            0.181 |           0.095 |                  0.050 |           0.025 |
| Neuquén                       |        8078 |  15608 |        146 |               17.3 |              0.011 |              0.018 |            0.518 |           0.593 |                  0.013 |           0.010 |
| Entre Ríos                    |        7669 |  19193 |        138 |               12.1 |              0.015 |              0.018 |            0.400 |           0.087 |                  0.009 |           0.004 |
| Santa Cruz                    |        4979 |  10419 |         64 |               15.9 |              0.011 |              0.013 |            0.478 |           0.057 |                  0.012 |           0.008 |
| La Rioja                      |        4848 |  13928 |        127 |               12.9 |              0.025 |              0.026 |            0.348 |           0.009 |                  0.002 |           0.001 |
| Tierra del Fuego              |        4524 |  10578 |         66 |               17.3 |              0.012 |              0.015 |            0.428 |           0.022 |                  0.008 |           0.007 |
| Chubut                        |        4142 |   9099 |         55 |                9.9 |              0.008 |              0.013 |            0.455 |           0.017 |                  0.006 |           0.005 |
| Santiago del Estero           |        3545 |  14019 |         61 |               12.5 |              0.011 |              0.017 |            0.253 |           0.007 |                  0.001 |           0.001 |
| SIN ESPECIFICAR               |        2293 |   5152 |         19 |               18.7 |              0.007 |              0.008 |            0.445 |           0.066 |                  0.008 |           0.004 |
| San Luis                      |        1575 |   5253 |          7 |               13.2 |              0.002 |              0.004 |            0.300 |           0.039 |                  0.003 |           0.001 |
| Corrientes                    |        1100 |  11390 |         18 |                8.6 |              0.009 |              0.016 |            0.097 |           0.020 |                  0.016 |           0.009 |
| La Pampa                      |         790 |   6657 |          5 |               23.8 |              0.005 |              0.006 |            0.119 |           0.037 |                  0.010 |           0.003 |
| San Juan                      |         750 |   2005 |         37 |               11.0 |              0.040 |              0.049 |            0.374 |           0.053 |                  0.017 |           0.004 |
| Catamarca                     |         291 |   5896 |          0 |                NaN |              0.000 |              0.000 |            0.049 |           0.007 |                  0.000 |           0.000 |
| Formosa                       |         102 |   1288 |          1 |               12.0 |              0.007 |              0.010 |            0.079 |           0.196 |                  0.000 |           0.000 |
| Misiones                      |          94 |   4546 |          3 |                6.5 |              0.018 |              0.032 |            0.021 |           0.426 |                  0.064 |           0.021 |

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
    #> INFO  [08:38:18.764] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 31
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |      86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-09-28              |                        45 |         101 |     670 |         68 |          9 |              0.066 |              0.089 |            0.151 |           0.673 |                  0.119 |           0.059 |
|             12 | 2020-09-28              |                        78 |         426 |    2057 |        261 |         17 |              0.033 |              0.040 |            0.207 |           0.613 |                  0.089 |           0.052 |
|             13 | 2020-09-30              |                       125 |        1120 |    5534 |        614 |         65 |              0.050 |              0.058 |            0.202 |           0.548 |                  0.091 |           0.054 |
|             14 | 2020-09-30              |                       170 |        1852 |   11571 |       1005 |        118 |              0.054 |              0.064 |            0.160 |           0.543 |                  0.091 |           0.054 |
|             15 | 2020-09-30              |                       201 |        2586 |   20303 |       1373 |        184 |              0.060 |              0.071 |            0.127 |           0.531 |                  0.085 |           0.048 |
|             16 | 2020-09-30              |                       214 |        3491 |   31924 |       1751 |        251 |              0.059 |              0.072 |            0.109 |           0.502 |                  0.076 |           0.041 |
|             17 | 2020-09-30              |                       217 |        4731 |   45997 |       2304 |        373 |              0.066 |              0.079 |            0.103 |           0.487 |                  0.068 |           0.036 |
|             18 | 2020-10-01              |                       218 |        5832 |   59209 |       2731 |        477 |              0.068 |              0.082 |            0.098 |           0.468 |                  0.062 |           0.032 |
|             19 | 2020-10-01              |                       218 |        7416 |   73357 |       3349 |        586 |              0.067 |              0.079 |            0.101 |           0.452 |                  0.057 |           0.030 |
|             20 | 2020-10-01              |                       218 |        9936 |   90815 |       4229 |        707 |              0.061 |              0.071 |            0.109 |           0.426 |                  0.053 |           0.027 |
|             21 | 2020-10-01              |                       218 |       14534 |  114299 |       5619 |        910 |              0.054 |              0.063 |            0.127 |           0.387 |                  0.047 |           0.024 |
|             22 | 2020-10-01              |                       218 |       19982 |  139765 |       7109 |       1173 |              0.051 |              0.059 |            0.143 |           0.356 |                  0.043 |           0.021 |
|             23 | 2020-10-01              |                       218 |       26702 |  168114 |       8709 |       1491 |              0.049 |              0.056 |            0.159 |           0.326 |                  0.040 |           0.019 |
|             24 | 2020-10-01              |                       218 |       36658 |  203343 |      10926 |       1904 |              0.046 |              0.052 |            0.180 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-10-01              |                       218 |       49792 |  244900 |      13368 |       2427 |              0.043 |              0.049 |            0.203 |           0.268 |                  0.031 |           0.014 |
|             26 | 2020-10-01              |                       218 |       68006 |  297230 |      16538 |       3144 |              0.041 |              0.046 |            0.229 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-10-01              |                       218 |       87192 |  348593 |      19424 |       3923 |              0.040 |              0.045 |            0.250 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-10-01              |                       219 |      111066 |  407900 |      22845 |       4935 |              0.039 |              0.044 |            0.272 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-10-01              |                       221 |      140554 |  479746 |      26587 |       6159 |              0.038 |              0.044 |            0.293 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-10-01              |                       221 |      178831 |  565752 |      30371 |       7559 |              0.037 |              0.042 |            0.316 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-10-01              |                       221 |      218590 |  655585 |      33736 |       8854 |              0.035 |              0.041 |            0.333 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-10-01              |                       221 |      268173 |  763945 |      37598 |      10451 |              0.034 |              0.039 |            0.351 |           0.140 |                  0.017 |           0.008 |
|             33 | 2020-10-01              |                       221 |      315341 |  878377 |      41356 |      11920 |              0.033 |              0.038 |            0.359 |           0.131 |                  0.017 |           0.008 |
|             34 | 2020-10-01              |                       221 |      364499 |  989229 |      45088 |      13519 |              0.032 |              0.037 |            0.368 |           0.124 |                  0.016 |           0.008 |
|             35 | 2020-10-01              |                       221 |      429856 | 1124182 |      49592 |      15381 |              0.031 |              0.036 |            0.382 |           0.115 |                  0.015 |           0.007 |
|             36 | 2020-10-01              |                       221 |      499157 | 1263994 |      53695 |      17098 |              0.030 |              0.034 |            0.395 |           0.108 |                  0.014 |           0.007 |
|             37 | 2020-10-01              |                       221 |      573515 | 1414015 |      57909 |      18583 |              0.028 |              0.032 |            0.406 |           0.101 |                  0.013 |           0.006 |
|             38 | 2020-10-01              |                       221 |      645353 | 1554814 |      61088 |      19630 |              0.026 |              0.030 |            0.415 |           0.095 |                  0.012 |           0.006 |
|             39 | 2020-10-01              |                       222 |      719378 | 1686300 |      63455 |      20162 |              0.024 |              0.028 |            0.427 |           0.088 |                  0.012 |           0.006 |
|             40 | 2020-10-01              |                       223 |      764998 | 1754670 |      64328 |      20288 |              0.022 |              0.027 |            0.436 |           0.084 |                  0.011 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:41:16.735] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:42:44.534] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:43:23.057] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:43:26.217] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:43:34.841] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:43:40.262] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:43:51.247] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:43:55.393] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:44:00.086] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:44:02.730] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:44:09.240] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:44:13.019] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:44:16.955] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:44:23.056] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:44:26.300] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:44:30.557] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:44:35.405] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:44:39.379] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:44:42.465] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:44:45.600] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:44:49.127] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:44:58.659] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:45:03.274] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:45:06.907] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:45:14.309] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 714
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
| Buenos Aires                  | M    |      214294 |      16368 |       7270 |              0.029 |              0.034 |            0.482 |           0.076 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      205981 |      13510 |       5768 |              0.024 |              0.028 |            0.452 |           0.066 |                  0.008 |           0.003 |
| CABA                          | F    |       63531 |       9268 |       1617 |              0.023 |              0.025 |            0.368 |           0.146 |                  0.013 |           0.006 |
| CABA                          | M    |       61907 |       9875 |       1834 |              0.027 |              0.030 |            0.416 |           0.160 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       22534 |        550 |        206 |              0.008 |              0.009 |            0.517 |           0.024 |                  0.006 |           0.003 |
| Santa Fe                      | M    |       21923 |        667 |        260 |              0.010 |              0.012 |            0.547 |           0.030 |                  0.008 |           0.005 |
| Córdoba                       | F    |       18155 |        196 |        174 |              0.008 |              0.010 |            0.413 |           0.011 |                  0.003 |           0.001 |
| Córdoba                       | M    |       17975 |        236 |        238 |              0.012 |              0.013 |            0.419 |           0.013 |                  0.004 |           0.002 |
| Mendoza                       | M    |       12999 |        964 |        203 |              0.012 |              0.016 |            0.496 |           0.074 |                  0.008 |           0.003 |
| Mendoza                       | F    |       12745 |        900 |        121 |              0.007 |              0.009 |            0.469 |           0.071 |                  0.003 |           0.001 |
| Jujuy                         | M    |        8878 |         98 |        351 |              0.031 |              0.040 |            0.455 |           0.011 |                  0.001 |           0.001 |
| Tucumán                       | M    |        7947 |        158 |         86 |              0.006 |              0.011 |            0.422 |           0.020 |                  0.003 |           0.001 |
| Tucumán                       | F    |        7582 |        113 |         47 |              0.003 |              0.006 |            0.521 |           0.015 |                  0.003 |           0.000 |
| Salta                         | M    |        7316 |        758 |        231 |              0.026 |              0.032 |            0.549 |           0.104 |                  0.020 |           0.012 |
| Jujuy                         | F    |        6943 |         53 |        201 |              0.022 |              0.029 |            0.427 |           0.008 |                  0.000 |           0.000 |
| Río Negro                     | F    |        6733 |       1327 |        158 |              0.021 |              0.023 |            0.463 |           0.197 |                  0.006 |           0.004 |
| Río Negro                     | M    |        6388 |       1325 |        227 |              0.032 |              0.036 |            0.499 |           0.207 |                  0.013 |           0.009 |
| Salta                         | F    |        5415 |        516 |        118 |              0.017 |              0.022 |            0.530 |           0.095 |                  0.012 |           0.006 |
| Chaco                         | M    |        4414 |        434 |        180 |              0.032 |              0.041 |            0.186 |           0.098 |                  0.056 |           0.029 |
| Chaco                         | F    |        4323 |        397 |        110 |              0.019 |              0.025 |            0.176 |           0.092 |                  0.043 |           0.021 |
| Neuquén                       | M    |        4057 |       2366 |         88 |              0.013 |              0.022 |            0.530 |           0.583 |                  0.017 |           0.014 |
| Neuquén                       | F    |        4019 |       2427 |         57 |              0.008 |              0.014 |            0.506 |           0.604 |                  0.008 |           0.005 |
| Entre Ríos                    | F    |        3869 |        326 |         51 |              0.011 |              0.013 |            0.382 |           0.084 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        3795 |        339 |         86 |              0.019 |              0.023 |            0.419 |           0.089 |                  0.012 |           0.004 |
| La Rioja                      | M    |        2587 |         24 |         77 |              0.029 |              0.030 |            0.358 |           0.009 |                  0.002 |           0.001 |
| Santa Cruz                    | M    |        2550 |        155 |         42 |              0.015 |              0.016 |            0.496 |           0.061 |                  0.015 |           0.009 |
| Santa Cruz                    | F    |        2424 |        128 |         22 |              0.008 |              0.009 |            0.460 |           0.053 |                  0.010 |           0.006 |
| Tierra del Fuego              | M    |        2423 |         61 |         44 |              0.016 |              0.018 |            0.448 |           0.025 |                  0.012 |           0.010 |
| Chubut                        | M    |        2284 |         35 |         30 |              0.008 |              0.013 |            0.487 |           0.015 |                  0.007 |           0.006 |
| La Rioja                      | F    |        2247 |         21 |         48 |              0.021 |              0.021 |            0.338 |           0.009 |                  0.003 |           0.001 |
| Tierra del Fuego              | F    |        2087 |         39 |         22 |              0.009 |              0.011 |            0.404 |           0.019 |                  0.003 |           0.003 |
| Santiago del Estero           | M    |        1950 |         20 |         39 |              0.013 |              0.020 |            0.225 |           0.010 |                  0.002 |           0.001 |
| Chubut                        | F    |        1843 |         33 |         24 |              0.008 |              0.013 |            0.423 |           0.018 |                  0.005 |           0.004 |
| Santiago del Estero           | F    |        1590 |          5 |         22 |              0.008 |              0.014 |            0.317 |           0.003 |                  0.001 |           0.001 |
| Buenos Aires                  | NR   |        1529 |        131 |         99 |              0.046 |              0.065 |            0.485 |           0.086 |                  0.016 |           0.007 |
| SIN ESPECIFICAR               | F    |        1359 |         79 |          8 |              0.005 |              0.006 |            0.440 |           0.058 |                  0.007 |           0.002 |
| SIN ESPECIFICAR               | M    |         929 |         71 |         10 |              0.009 |              0.011 |            0.456 |           0.076 |                  0.009 |           0.006 |
| San Luis                      | M    |         853 |         35 |          5 |              0.003 |              0.006 |            0.312 |           0.041 |                  0.004 |           0.000 |
| San Luis                      | F    |         722 |         26 |          2 |              0.001 |              0.003 |            0.287 |           0.036 |                  0.001 |           0.001 |
| Corrientes                    | M    |         556 |         18 |         15 |              0.015 |              0.027 |            0.092 |           0.032 |                  0.025 |           0.016 |
| Corrientes                    | F    |         544 |          4 |          3 |              0.003 |              0.006 |            0.101 |           0.007 |                  0.007 |           0.002 |
| CABA                          | NR   |         486 |        125 |         34 |              0.055 |              0.070 |            0.413 |           0.257 |                  0.039 |           0.025 |
| San Juan                      | M    |         424 |         15 |         17 |              0.033 |              0.040 |            0.378 |           0.035 |                  0.012 |           0.005 |
| La Pampa                      | F    |         420 |         17 |          4 |              0.008 |              0.010 |            0.115 |           0.040 |                  0.012 |           0.002 |
| La Pampa                      | M    |         367 |         12 |          1 |              0.002 |              0.003 |            0.122 |           0.033 |                  0.008 |           0.003 |
| San Juan                      | F    |         326 |         25 |         20 |              0.048 |              0.061 |            0.370 |           0.077 |                  0.025 |           0.003 |
| Catamarca                     | M    |         197 |          2 |          0 |              0.000 |              0.000 |            0.052 |           0.010 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          97 |          5 |          2 |              0.014 |              0.021 |            0.376 |           0.052 |                  0.000 |           0.000 |
| Catamarca                     | F    |          94 |          0 |          0 |              0.000 |              0.000 |            0.045 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          79 |         10 |          0 |              0.000 |              0.000 |            0.102 |           0.127 |                  0.000 |           0.000 |
| Misiones                      | M    |          54 |         22 |          2 |              0.021 |              0.037 |            0.021 |           0.407 |                  0.074 |           0.019 |
| Misiones                      | F    |          40 |         18 |          1 |              0.014 |              0.025 |            0.021 |           0.450 |                  0.050 |           0.025 |
| Salta                         | NR   |          39 |          2 |          0 |              0.000 |              0.000 |            0.459 |           0.051 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          31 |          1 |          3 |              0.064 |              0.097 |            0.508 |           0.032 |                  0.000 |           0.000 |
| Formosa                       | F    |          23 |         10 |          1 |              0.023 |              0.043 |            0.045 |           0.435 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          20 |          0 |          2 |              0.053 |              0.100 |            0.323 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          15 |          1 |          1 |              0.036 |              0.067 |            0.283 |           0.067 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          14 |          0 |          2 |              0.133 |              0.143 |            0.230 |           0.000 |                  0.000 |           0.000 |
| Santa Fe                      | NR   |          14 |          1 |          1 |              0.042 |              0.071 |            0.286 |           0.071 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.333 |           0.000 |                  0.000 |           0.000 |


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
