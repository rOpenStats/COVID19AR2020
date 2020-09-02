
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
    #> INFO  [08:36:58.810] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:37:05.849] Normalize 
    #> INFO  [08:37:07.390] checkSoundness 
    #> INFO  [08:37:08.174] Mutating data 
    #> INFO  [08:40:23.333] Last days rows {date: 2020-08-31, n: 30557}
    #> INFO  [08:40:23.337] Last days rows {date: 2020-09-01, n: 19873}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-01"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-01"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-01"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-01              |      428235 |       8919 |              0.016 |              0.021 |                       191 | 1124064 |            0.381 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      263956 |       5357 |              0.016 |              0.020 |                       188 | 600844 |            0.439 |
| CABA                          |       96271 |       2279 |              0.021 |              0.024 |                       186 | 242726 |            0.397 |
| Córdoba                       |        8908 |        129 |              0.011 |              0.014 |                       176 |  50356 |            0.177 |
| Santa Fe                      |        8582 |         96 |              0.009 |              0.011 |                       172 |  39365 |            0.218 |
| Jujuy                         |        8540 |        229 |              0.017 |              0.027 |                       166 |  21775 |            0.392 |
| Mendoza                       |        7188 |        132 |              0.012 |              0.018 |                       175 |  19976 |            0.360 |
| Río Negro                     |        6175 |        180 |              0.026 |              0.029 |                       169 |  15487 |            0.399 |
| Chaco                         |        5492 |        217 |              0.030 |              0.040 |                       174 |  33469 |            0.164 |
| Entre Ríos                    |        3650 |         48 |              0.010 |              0.013 |                       169 |  10633 |            0.343 |
| Salta                         |        3497 |         45 |              0.009 |              0.013 |                       164 |   7576 |            0.462 |
| Neuquén                       |        3171 |         53 |              0.013 |              0.017 |                       171 |   8512 |            0.373 |
| Tucumán                       |        2475 |         14 |              0.002 |              0.006 |                       167 |  17944 |            0.138 |
| Tierra del Fuego              |        2102 |         30 |              0.012 |              0.014 |                       168 |   6061 |            0.347 |
| Santa Cruz                    |        1802 |         15 |              0.007 |              0.008 |                       161 |   4837 |            0.373 |
| SIN ESPECIFICAR               |        1750 |          9 |              0.004 |              0.005 |                       162 |   3962 |            0.442 |
| La Rioja                      |        1628 |         61 |              0.035 |              0.037 |                       160 |   6850 |            0.238 |
| Santiago del Estero           |         976 |         11 |              0.005 |              0.011 |                       155 |   8686 |            0.112 |
| Chubut                        |         954 |          6 |              0.003 |              0.006 |                       155 |   5373 |            0.178 |
| Corrientes                    |         314 |          2 |              0.003 |              0.006 |                       166 |   7406 |            0.042 |
| San Juan                      |         222 |          1 |              0.003 |              0.005 |                       159 |   1371 |            0.162 |
| La Pampa                      |         212 |          2 |              0.007 |              0.009 |                       149 |   2496 |            0.085 |
| San Luis                      |         156 |          0 |              0.000 |              0.000 |                       148 |   1193 |            0.131 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      263956 | 600844 |       5357 |               14.8 |              0.016 |              0.020 |            0.439 |           0.083 |                  0.011 |           0.005 |
| CABA                          |       96271 | 242726 |       2279 |               15.9 |              0.021 |              0.024 |            0.397 |           0.169 |                  0.017 |           0.008 |
| Córdoba                       |        8908 |  50356 |        129 |               16.4 |              0.011 |              0.014 |            0.177 |           0.027 |                  0.007 |           0.004 |
| Santa Fe                      |        8582 |  39365 |         96 |               12.3 |              0.009 |              0.011 |            0.218 |           0.046 |                  0.012 |           0.006 |
| Jujuy                         |        8540 |  21775 |        229 |               13.6 |              0.017 |              0.027 |            0.392 |           0.007 |                  0.001 |           0.001 |
| Mendoza                       |        7188 |  19976 |        132 |               11.0 |              0.012 |              0.018 |            0.360 |           0.177 |                  0.010 |           0.004 |
| Río Negro                     |        6175 |  15487 |        180 |               12.4 |              0.026 |              0.029 |            0.399 |           0.275 |                  0.013 |           0.009 |
| Chaco                         |        5492 |  33469 |        217 |               14.8 |              0.030 |              0.040 |            0.164 |           0.111 |                  0.060 |           0.027 |
| Entre Ríos                    |        3650 |  10633 |         48 |               10.3 |              0.010 |              0.013 |            0.343 |           0.106 |                  0.010 |           0.002 |
| Salta                         |        3497 |   7576 |         45 |                7.9 |              0.009 |              0.013 |            0.462 |           0.145 |                  0.014 |           0.005 |
| Neuquén                       |        3171 |   8512 |         53 |               16.3 |              0.013 |              0.017 |            0.373 |           0.556 |                  0.014 |           0.009 |
| Tucumán                       |        2475 |  17944 |         14 |               13.0 |              0.002 |              0.006 |            0.138 |           0.075 |                  0.009 |           0.002 |
| Tierra del Fuego              |        2102 |   6061 |         30 |               13.3 |              0.012 |              0.014 |            0.347 |           0.024 |                  0.008 |           0.008 |
| Santa Cruz                    |        1802 |   4837 |         15 |               13.1 |              0.007 |              0.008 |            0.373 |           0.047 |                  0.014 |           0.009 |
| SIN ESPECIFICAR               |        1750 |   3962 |          9 |               20.7 |              0.004 |              0.005 |            0.442 |           0.062 |                  0.006 |           0.003 |
| La Rioja                      |        1628 |   6850 |         61 |               10.3 |              0.035 |              0.037 |            0.238 |           0.020 |                  0.005 |           0.001 |
| Santiago del Estero           |         976 |   8686 |         11 |                7.8 |              0.005 |              0.011 |            0.112 |           0.007 |                  0.003 |           0.001 |
| Chubut                        |         954 |   5373 |          6 |               16.0 |              0.003 |              0.006 |            0.178 |           0.025 |                  0.007 |           0.006 |
| Corrientes                    |         314 |   7406 |          2 |               12.0 |              0.003 |              0.006 |            0.042 |           0.025 |                  0.010 |           0.003 |
| San Juan                      |         222 |   1371 |          1 |               35.0 |              0.003 |              0.005 |            0.162 |           0.045 |                  0.014 |           0.000 |
| La Pampa                      |         212 |   2496 |          2 |               38.5 |              0.007 |              0.009 |            0.085 |           0.080 |                  0.014 |           0.005 |
| San Luis                      |         156 |   1193 |          0 |                NaN |              0.000 |              0.000 |            0.131 |           0.109 |                  0.006 |           0.000 |
| Formosa                       |          82 |   1127 |          1 |               12.0 |              0.009 |              0.012 |            0.073 |           0.012 |                  0.000 |           0.000 |
| Catamarca                     |          66 |   3056 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          66 |   2983 |          2 |                6.5 |              0.013 |              0.030 |            0.022 |           0.455 |                  0.091 |           0.045 |

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
    #> INFO  [08:41:26.276] Processing {current.group: }
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
|             11 | 2020-08-25              |                        41 |          98 |     668 |         66 |          9 |              0.066 |              0.092 |            0.147 |           0.673 |                  0.122 |           0.061 |
|             12 | 2020-08-25              |                        68 |         417 |    2053 |        257 |         17 |              0.034 |              0.041 |            0.203 |           0.616 |                  0.091 |           0.053 |
|             13 | 2020-08-29              |                       106 |        1094 |    5526 |        603 |         64 |              0.051 |              0.059 |            0.198 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-09-01              |                       145 |        1805 |   11551 |        987 |        115 |              0.054 |              0.064 |            0.156 |           0.547 |                  0.093 |           0.055 |
|             15 | 2020-09-01              |                       171 |        2495 |   20276 |       1343 |        180 |              0.060 |              0.072 |            0.123 |           0.538 |                  0.088 |           0.050 |
|             16 | 2020-09-01              |                       185 |        3334 |   31893 |       1703 |        241 |              0.059 |              0.072 |            0.105 |           0.511 |                  0.079 |           0.043 |
|             17 | 2020-09-01              |                       188 |        4523 |   45959 |       2245 |        351 |              0.064 |              0.078 |            0.098 |           0.496 |                  0.071 |           0.037 |
|             18 | 2020-09-01              |                       188 |        5576 |   59158 |       2661 |        436 |              0.065 |              0.078 |            0.094 |           0.477 |                  0.063 |           0.034 |
|             19 | 2020-09-01              |                       188 |        7102 |   73299 |       3267 |        523 |              0.062 |              0.074 |            0.097 |           0.460 |                  0.059 |           0.031 |
|             20 | 2020-09-01              |                       188 |        9560 |   90741 |       4130 |        634 |              0.056 |              0.066 |            0.105 |           0.432 |                  0.054 |           0.028 |
|             21 | 2020-09-01              |                       188 |       14035 |  114195 |       5486 |        807 |              0.049 |              0.057 |            0.123 |           0.391 |                  0.048 |           0.024 |
|             22 | 2020-09-01              |                       188 |       19382 |  139612 |       6957 |       1024 |              0.046 |              0.053 |            0.139 |           0.359 |                  0.043 |           0.022 |
|             23 | 2020-09-01              |                       188 |       25982 |  167926 |       8530 |       1286 |              0.043 |              0.049 |            0.155 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-09-01              |                       188 |       35801 |  203094 |      10710 |       1608 |              0.039 |              0.045 |            0.176 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-01              |                       188 |       48802 |  244566 |      13112 |       2013 |              0.036 |              0.041 |            0.200 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-09-01              |                       188 |       66787 |  296697 |      16225 |       2558 |              0.034 |              0.038 |            0.225 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-01              |                       188 |       85744 |  347783 |      19068 |       3174 |              0.032 |              0.037 |            0.247 |           0.222 |                  0.026 |           0.011 |
|             28 | 2020-09-01              |                       189 |      109302 |  406811 |      22422 |       3950 |              0.032 |              0.036 |            0.269 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-09-01              |                       191 |      138308 |  478158 |      26051 |       4826 |              0.030 |              0.035 |            0.289 |           0.188 |                  0.022 |           0.010 |
|             30 | 2020-09-01              |                       191 |      176102 |  563824 |      29725 |       5769 |              0.028 |              0.033 |            0.312 |           0.169 |                  0.020 |           0.009 |
|             31 | 2020-09-01              |                       191 |      214988 |  652239 |      32938 |       6589 |              0.026 |              0.031 |            0.330 |           0.153 |                  0.018 |           0.009 |
|             32 | 2020-09-01              |                       191 |      263473 |  758838 |      36539 |       7507 |              0.024 |              0.028 |            0.347 |           0.139 |                  0.017 |           0.008 |
|             33 | 2020-09-01              |                       191 |      308726 |  869445 |      39813 |       8130 |              0.022 |              0.026 |            0.355 |           0.129 |                  0.016 |           0.007 |
|             34 | 2020-09-01              |                       191 |      356014 |  976659 |      42632 |       8629 |              0.020 |              0.024 |            0.365 |           0.120 |                  0.015 |           0.007 |
|             35 | 2020-09-01              |                       191 |      415394 | 1099821 |      45242 |       8898 |              0.018 |              0.021 |            0.378 |           0.109 |                  0.013 |           0.006 |
|             36 | 2020-09-01              |                       191 |      428235 | 1124064 |      45636 |       8919 |              0.016 |              0.021 |            0.381 |           0.107 |                  0.013 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:42:58.334] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:43:46.818] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:44:09.371] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:44:11.624] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:44:16.980] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:44:19.636] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:44:26.776] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:44:29.899] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:44:33.660] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:44:35.622] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:44:39.181] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:44:41.541] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:44:44.257] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:44:47.650] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:44:49.996] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:44:52.796] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:44:56.084] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:44:58.677] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:45:01.039] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:45:03.415] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:45:05.942] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:45:11.041] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:45:13.925] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:45:16.499] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:45:19.359] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 612
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
| Buenos Aires                  | M    |      134915 |      11914 |       3063 |              0.018 |              0.023 |            0.457 |           0.088 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |      128086 |       9886 |       2260 |              0.014 |              0.018 |            0.422 |           0.077 |                  0.009 |           0.003 |
| CABA                          | F    |       48561 |       7886 |       1047 |              0.019 |              0.022 |            0.375 |           0.162 |                  0.013 |           0.006 |
| CABA                          | M    |       47334 |       8258 |       1207 |              0.022 |              0.025 |            0.421 |           0.174 |                  0.022 |           0.011 |
| Jujuy                         | M    |        5068 |         38 |        140 |              0.018 |              0.028 |            0.418 |           0.007 |                  0.001 |           0.001 |
| Córdoba                       | F    |        4486 |        119 |         55 |              0.010 |              0.012 |            0.174 |           0.027 |                  0.007 |           0.004 |
| Córdoba                       | M    |        4395 |        119 |         74 |              0.013 |              0.017 |            0.179 |           0.027 |                  0.008 |           0.005 |
| Santa Fe                      | F    |        4320 |        174 |         37 |              0.006 |              0.009 |            0.208 |           0.040 |                  0.010 |           0.004 |
| Santa Fe                      | M    |        4259 |        217 |         59 |              0.011 |              0.014 |            0.229 |           0.051 |                  0.013 |           0.007 |
| Mendoza                       | F    |        3589 |        639 |         44 |              0.008 |              0.012 |            0.352 |           0.178 |                  0.005 |           0.001 |
| Mendoza                       | M    |        3577 |        627 |         86 |              0.016 |              0.024 |            0.370 |           0.175 |                  0.016 |           0.006 |
| Jujuy                         | F    |        3457 |         18 |         88 |              0.015 |              0.025 |            0.360 |           0.005 |                  0.001 |           0.001 |
| Río Negro                     | F    |        3211 |        860 |         74 |              0.020 |              0.023 |            0.388 |           0.268 |                  0.007 |           0.003 |
| Río Negro                     | M    |        2961 |        839 |        106 |              0.032 |              0.036 |            0.412 |           0.283 |                  0.019 |           0.014 |
| Chaco                         | M    |        2775 |        314 |        138 |              0.038 |              0.050 |            0.167 |           0.113 |                  0.069 |           0.033 |
| Chaco                         | F    |        2715 |        295 |         79 |              0.022 |              0.029 |            0.161 |           0.109 |                  0.052 |           0.021 |
| Salta                         | M    |        2062 |        295 |         35 |              0.012 |              0.017 |            0.466 |           0.143 |                  0.017 |           0.007 |
| Entre Ríos                    | F    |        1871 |        192 |         18 |              0.008 |              0.010 |            0.335 |           0.103 |                  0.006 |           0.001 |
| Entre Ríos                    | M    |        1776 |        194 |         29 |              0.013 |              0.016 |            0.352 |           0.109 |                  0.014 |           0.004 |
| Neuquén                       | M    |        1607 |        889 |         28 |              0.014 |              0.017 |            0.383 |           0.553 |                  0.015 |           0.011 |
| Neuquén                       | F    |        1564 |        875 |         25 |              0.012 |              0.016 |            0.363 |           0.559 |                  0.012 |           0.007 |
| Salta                         | F    |        1428 |        210 |         10 |              0.004 |              0.007 |            0.456 |           0.147 |                  0.011 |           0.002 |
| Tucumán                       | M    |        1286 |        102 |         10 |              0.002 |              0.008 |            0.117 |           0.079 |                  0.009 |           0.002 |
| Tucumán                       | F    |        1189 |         84 |          4 |              0.001 |              0.003 |            0.170 |           0.071 |                  0.009 |           0.002 |
| Tierra del Fuego              | M    |        1167 |         32 |         21 |              0.016 |              0.018 |            0.370 |           0.027 |                  0.012 |           0.011 |
| SIN ESPECIFICAR               | F    |        1026 |         56 |          3 |              0.002 |              0.003 |            0.431 |           0.055 |                  0.004 |           0.000 |
| Buenos Aires                  | NR   |         955 |         89 |         34 |              0.024 |              0.036 |            0.464 |           0.093 |                  0.023 |           0.010 |
| Tierra del Fuego              | F    |         921 |         18 |          9 |              0.008 |              0.010 |            0.317 |           0.020 |                  0.003 |           0.003 |
| Santa Cruz                    | M    |         916 |         44 |         11 |              0.010 |              0.012 |            0.383 |           0.048 |                  0.016 |           0.011 |
| Santa Cruz                    | F    |         885 |         41 |          4 |              0.004 |              0.005 |            0.362 |           0.046 |                  0.011 |           0.008 |
| La Rioja                      | M    |         859 |         17 |         36 |              0.039 |              0.042 |            0.244 |           0.020 |                  0.003 |           0.000 |
| La Rioja                      | F    |         763 |         15 |         25 |              0.030 |              0.033 |            0.233 |           0.020 |                  0.007 |           0.003 |
| SIN ESPECIFICAR               | M    |         719 |         52 |          5 |              0.006 |              0.007 |            0.461 |           0.072 |                  0.008 |           0.007 |
| Santiago del Estero           | M    |         532 |          5 |          5 |              0.005 |              0.009 |            0.094 |           0.009 |                  0.004 |           0.000 |
| Chubut                        | M    |         522 |         17 |          4 |              0.004 |              0.008 |            0.192 |           0.033 |                  0.010 |           0.010 |
| Santiago del Estero           | F    |         440 |          2 |          6 |              0.007 |              0.014 |            0.160 |           0.005 |                  0.002 |           0.002 |
| Chubut                        | F    |         426 |          6 |          2 |              0.002 |              0.005 |            0.164 |           0.014 |                  0.005 |           0.002 |
| CABA                          | NR   |         376 |        103 |         25 |              0.048 |              0.066 |            0.407 |           0.274 |                  0.037 |           0.024 |
| Corrientes                    | M    |         179 |          7 |          2 |              0.006 |              0.011 |            0.043 |           0.039 |                  0.011 |           0.006 |
| Corrientes                    | F    |         135 |          1 |          0 |              0.000 |              0.000 |            0.041 |           0.007 |                  0.007 |           0.000 |
| San Juan                      | M    |         122 |          5 |          1 |              0.005 |              0.008 |            0.159 |           0.041 |                  0.008 |           0.000 |
| La Pampa                      | F    |         120 |         11 |          1 |              0.006 |              0.008 |            0.086 |           0.092 |                  0.017 |           0.008 |
| San Juan                      | F    |         100 |          5 |          0 |              0.000 |              0.000 |            0.166 |           0.050 |                  0.020 |           0.000 |
| La Pampa                      | M    |          92 |          6 |          1 |              0.008 |              0.011 |            0.084 |           0.065 |                  0.011 |           0.000 |
| San Luis                      | M    |          84 |         10 |          0 |              0.000 |              0.000 |            0.129 |           0.119 |                  0.012 |           0.000 |
| San Luis                      | F    |          72 |          7 |          0 |              0.000 |              0.000 |            0.133 |           0.097 |                  0.000 |           0.000 |
| Formosa                       | M    |          66 |          0 |          0 |              0.000 |              0.000 |            0.098 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          44 |         16 |          1 |              0.012 |              0.023 |            0.028 |           0.364 |                  0.091 |           0.045 |
| Catamarca                     | M    |          43 |          0 |          0 |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          27 |          1 |          0 |              0.000 |              0.000 |            0.482 |           0.037 |                  0.000 |           0.000 |
| Catamarca                     | F    |          23 |          0 |          0 |              0.000 |              0.000 |            0.021 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          22 |          5 |          2 |              0.042 |              0.091 |            0.186 |           0.227 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         14 |          1 |              0.015 |              0.045 |            0.016 |           0.636 |                  0.091 |           0.045 |
| Formosa                       | F    |          16 |          1 |          1 |              0.033 |              0.062 |            0.035 |           0.062 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          15 |          0 |          1 |              0.033 |              0.067 |            0.300 |           0.000 |                  0.000 |           0.000 |
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
    #> Warning: Removed 15 rows containing missing values (position_stack).

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
