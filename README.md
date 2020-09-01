
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
    #> INFO  [08:36:45.764] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:36:52.891] Normalize 
    #> INFO  [08:36:56.390] checkSoundness 
    #> INFO  [08:36:58.424] Mutating data 
    #> INFO  [08:41:24.414] Last days rows {date: 2020-08-30, n: 17595}
    #> INFO  [08:41:24.417] Last days rows {date: 2020-08-31, n: 18366}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-31"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-31"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-31"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-08-31              |      417731 |       8660 |              0.016 |              0.021 |                       190 | 1103661 |            0.378 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      257809 |       5182 |              0.016 |              0.020 |                       187 | 589606 |            0.437 |
| CABA                          |       94892 |       2225 |              0.020 |              0.023 |                       185 | 239147 |            0.397 |
| Córdoba                       |        8516 |        127 |              0.012 |              0.015 |                       175 |  49651 |            0.172 |
| Jujuy                         |        8416 |        229 |              0.017 |              0.027 |                       165 |  21562 |            0.390 |
| Santa Fe                      |        7905 |         91 |              0.009 |              0.012 |                       171 |  38319 |            0.206 |
| Mendoza                       |        6827 |        129 |              0.013 |              0.019 |                       174 |  19376 |            0.352 |
| Río Negro                     |        5996 |        177 |              0.026 |              0.030 |                       168 |  15136 |            0.396 |
| Chaco                         |        5417 |        217 |              0.031 |              0.040 |                       173 |  32965 |            0.164 |
| Entre Ríos                    |        3338 |         46 |              0.011 |              0.014 |                       168 |  10265 |            0.325 |
| Salta                         |        3314 |         45 |              0.009 |              0.014 |                       163 |   7236 |            0.458 |
| Neuquén                       |        3036 |         50 |              0.013 |              0.016 |                       170 |   8338 |            0.364 |
| Tucumán                       |        2239 |         14 |              0.002 |              0.006 |                       166 |  17684 |            0.127 |
| Tierra del Fuego              |        2020 |         30 |              0.013 |              0.015 |                       167 |   5918 |            0.341 |
| Santa Cruz                    |        1765 |         14 |              0.007 |              0.008 |                       160 |   4719 |            0.374 |
| SIN ESPECIFICAR               |        1723 |          9 |              0.004 |              0.005 |                       161 |   3895 |            0.442 |
| La Rioja                      |        1588 |         53 |              0.031 |              0.033 |                       159 |   6762 |            0.235 |
| Santiago del Estero           |         938 |          9 |              0.005 |              0.010 |                       154 |   8548 |            0.110 |
| Chubut                        |         898 |          6 |              0.003 |              0.007 |                       154 |   5279 |            0.170 |
| Corrientes                    |         311 |          2 |              0.003 |              0.006 |                       165 |   7203 |            0.043 |
| San Juan                      |         222 |          1 |              0.003 |              0.005 |                       159 |   1369 |            0.162 |
| La Pampa                      |         204 |          1 |              0.004 |              0.005 |                       148 |   2446 |            0.083 |
| San Luis                      |         147 |          0 |              0.000 |              0.000 |                       147 |   1176 |            0.125 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      257809 | 589606 |       5182 |               14.8 |              0.016 |              0.020 |            0.437 |           0.083 |                  0.011 |           0.005 |
| CABA                          |       94892 | 239147 |       2225 |               15.8 |              0.020 |              0.023 |            0.397 |           0.170 |                  0.018 |           0.008 |
| Córdoba                       |        8516 |  49651 |        127 |               16.5 |              0.012 |              0.015 |            0.172 |           0.028 |                  0.008 |           0.004 |
| Jujuy                         |        8416 |  21562 |        229 |               13.6 |              0.017 |              0.027 |            0.390 |           0.007 |                  0.001 |           0.001 |
| Santa Fe                      |        7905 |  38319 |         91 |               12.3 |              0.009 |              0.012 |            0.206 |           0.047 |                  0.012 |           0.006 |
| Mendoza                       |        6827 |  19376 |        129 |               11.2 |              0.013 |              0.019 |            0.352 |           0.185 |                  0.011 |           0.004 |
| Río Negro                     |        5996 |  15136 |        177 |               12.4 |              0.026 |              0.030 |            0.396 |           0.279 |                  0.013 |           0.009 |
| Chaco                         |        5417 |  32965 |        217 |               14.8 |              0.031 |              0.040 |            0.164 |           0.112 |                  0.061 |           0.028 |
| Entre Ríos                    |        3338 |  10265 |         46 |               10.4 |              0.011 |              0.014 |            0.325 |           0.112 |                  0.010 |           0.002 |
| Salta                         |        3314 |   7236 |         45 |                7.9 |              0.009 |              0.014 |            0.458 |           0.146 |                  0.014 |           0.005 |
| Neuquén                       |        3036 |   8338 |         50 |               16.3 |              0.013 |              0.016 |            0.364 |           0.565 |                  0.014 |           0.009 |
| Tucumán                       |        2239 |  17684 |         14 |               13.0 |              0.002 |              0.006 |            0.127 |           0.082 |                  0.010 |           0.002 |
| Tierra del Fuego              |        2020 |   5918 |         30 |               13.3 |              0.013 |              0.015 |            0.341 |           0.025 |                  0.008 |           0.008 |
| Santa Cruz                    |        1765 |   4719 |         14 |               13.4 |              0.007 |              0.008 |            0.374 |           0.046 |                  0.014 |           0.010 |
| SIN ESPECIFICAR               |        1723 |   3895 |          9 |               20.7 |              0.004 |              0.005 |            0.442 |           0.062 |                  0.006 |           0.003 |
| La Rioja                      |        1588 |   6762 |         53 |               11.1 |              0.031 |              0.033 |            0.235 |           0.020 |                  0.004 |           0.001 |
| Santiago del Estero           |         938 |   8548 |          9 |                7.8 |              0.005 |              0.010 |            0.110 |           0.007 |                  0.003 |           0.001 |
| Chubut                        |         898 |   5279 |          6 |               16.0 |              0.003 |              0.007 |            0.170 |           0.027 |                  0.008 |           0.007 |
| Corrientes                    |         311 |   7203 |          2 |               12.0 |              0.003 |              0.006 |            0.043 |           0.026 |                  0.010 |           0.003 |
| San Juan                      |         222 |   1369 |          1 |               35.0 |              0.003 |              0.005 |            0.162 |           0.045 |                  0.014 |           0.000 |
| La Pampa                      |         204 |   2446 |          1 |               27.0 |              0.004 |              0.005 |            0.083 |           0.078 |                  0.015 |           0.005 |
| San Luis                      |         147 |   1176 |          0 |                NaN |              0.000 |              0.000 |            0.125 |           0.109 |                  0.007 |           0.000 |
| Formosa                       |          83 |   1100 |          1 |               12.0 |              0.009 |              0.012 |            0.075 |           0.012 |                  0.000 |           0.000 |
| Catamarca                     |          65 |   3001 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          62 |   2960 |          2 |                6.5 |              0.015 |              0.032 |            0.021 |           0.500 |                  0.097 |           0.048 |

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
    #> INFO  [08:42:27.396] Processing {current.group: }
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
|             14 | 2020-08-29              |                       144 |        1805 |   11550 |        987 |        115 |              0.054 |              0.064 |            0.156 |           0.547 |                  0.093 |           0.055 |
|             15 | 2020-08-30              |                       170 |        2495 |   20274 |       1343 |        180 |              0.060 |              0.072 |            0.123 |           0.538 |                  0.088 |           0.050 |
|             16 | 2020-08-30              |                       183 |        3333 |   31889 |       1703 |        241 |              0.059 |              0.072 |            0.105 |           0.511 |                  0.079 |           0.043 |
|             17 | 2020-08-31              |                       187 |        4520 |   45955 |       2244 |        351 |              0.064 |              0.078 |            0.098 |           0.496 |                  0.071 |           0.037 |
|             18 | 2020-08-31              |                       187 |        5569 |   59153 |       2659 |        435 |              0.065 |              0.078 |            0.094 |           0.477 |                  0.064 |           0.034 |
|             19 | 2020-08-31              |                       187 |        7093 |   73294 |       3264 |        521 |              0.061 |              0.073 |            0.097 |           0.460 |                  0.059 |           0.031 |
|             20 | 2020-08-31              |                       187 |        9550 |   90736 |       4127 |        631 |              0.056 |              0.066 |            0.105 |           0.432 |                  0.054 |           0.028 |
|             21 | 2020-08-31              |                       187 |       14020 |  114190 |       5482 |        804 |              0.049 |              0.057 |            0.123 |           0.391 |                  0.048 |           0.024 |
|             22 | 2020-08-31              |                       187 |       19362 |  139605 |       6952 |       1014 |              0.045 |              0.052 |            0.139 |           0.359 |                  0.043 |           0.022 |
|             23 | 2020-08-31              |                       187 |       25952 |  167917 |       8523 |       1273 |              0.043 |              0.049 |            0.155 |           0.328 |                  0.041 |           0.019 |
|             24 | 2020-08-31              |                       187 |       35765 |  203085 |      10701 |       1584 |              0.038 |              0.044 |            0.176 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-08-31              |                       187 |       48758 |  244557 |      13103 |       1983 |              0.036 |              0.041 |            0.199 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-08-31              |                       187 |       66735 |  296688 |      16213 |       2521 |              0.033 |              0.038 |            0.225 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-08-31              |                       187 |       85680 |  347771 |      19053 |       3128 |              0.032 |              0.037 |            0.246 |           0.222 |                  0.026 |           0.011 |
|             28 | 2020-08-31              |                       188 |      109228 |  406779 |      22406 |       3893 |              0.031 |              0.036 |            0.269 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-08-31              |                       190 |      138225 |  478118 |      26033 |       4755 |              0.029 |              0.034 |            0.289 |           0.188 |                  0.022 |           0.010 |
|             30 | 2020-08-31              |                       190 |      175994 |  563771 |      29702 |       5689 |              0.028 |              0.032 |            0.312 |           0.169 |                  0.020 |           0.009 |
|             31 | 2020-08-31              |                       190 |      214840 |  652134 |      32906 |       6497 |              0.026 |              0.030 |            0.329 |           0.153 |                  0.018 |           0.009 |
|             32 | 2020-08-31              |                       190 |      263185 |  758381 |      36492 |       7390 |              0.024 |              0.028 |            0.347 |           0.139 |                  0.017 |           0.008 |
|             33 | 2020-08-31              |                       190 |      308351 |  868791 |      39735 |       7984 |              0.022 |              0.026 |            0.355 |           0.129 |                  0.016 |           0.007 |
|             34 | 2020-08-31              |                       190 |      355341 |  975298 |      42447 |       8433 |              0.020 |              0.024 |            0.364 |           0.119 |                  0.015 |           0.007 |
|             35 | 2020-08-31              |                       190 |      411924 | 1092872 |      44813 |       8653 |              0.017 |              0.021 |            0.377 |           0.109 |                  0.013 |           0.006 |
|             36 | 2020-08-31              |                       190 |      417731 | 1103661 |      44957 |       8660 |              0.016 |              0.021 |            0.378 |           0.108 |                  0.013 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:44:05.724] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:44:58.886] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:45:21.020] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:45:23.091] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:45:28.493] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:45:31.273] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:45:38.628] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:45:41.931] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:45:45.284] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:45:47.563] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:45:52.201] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:45:54.941] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:45:58.351] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:46:02.619] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:46:05.538] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:46:08.934] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:46:13.028] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:46:17.291] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:46:21.575] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:46:24.661] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:46:27.917] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:46:35.485] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:46:39.251] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:46:43.135] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:46:47.362] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |      131782 |      11709 |       2973 |              0.018 |              0.023 |            0.455 |           0.089 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |      125095 |       9709 |       2174 |              0.014 |              0.017 |            0.420 |           0.078 |                  0.009 |           0.003 |
| CABA                          | F    |       47851 |       7834 |       1020 |              0.018 |              0.021 |            0.375 |           0.164 |                  0.013 |           0.006 |
| CABA                          | M    |       46672 |       8171 |       1181 |              0.022 |              0.025 |            0.421 |           0.175 |                  0.022 |           0.011 |
| Jujuy                         | M    |        4980 |         38 |        140 |              0.019 |              0.028 |            0.416 |           0.008 |                  0.001 |           0.001 |
| Córdoba                       | F    |        4293 |        119 |         55 |              0.010 |              0.013 |            0.169 |           0.028 |                  0.007 |           0.004 |
| Córdoba                       | M    |        4196 |        117 |         72 |              0.014 |              0.017 |            0.174 |           0.028 |                  0.008 |           0.005 |
| Santa Fe                      | F    |        3978 |        165 |         34 |              0.006 |              0.009 |            0.197 |           0.041 |                  0.010 |           0.004 |
| Santa Fe                      | M    |        3925 |        210 |         57 |              0.011 |              0.015 |            0.217 |           0.054 |                  0.014 |           0.008 |
| Jujuy                         | F    |        3421 |         17 |         88 |              0.016 |              0.026 |            0.359 |           0.005 |                  0.001 |           0.001 |
| Mendoza                       | F    |        3412 |        635 |         43 |              0.009 |              0.013 |            0.345 |           0.186 |                  0.005 |           0.001 |
| Mendoza                       | M    |        3394 |        620 |         84 |              0.017 |              0.025 |            0.362 |           0.183 |                  0.017 |           0.007 |
| Río Negro                     | F    |        3115 |        849 |         71 |              0.020 |              0.023 |            0.385 |           0.273 |                  0.007 |           0.004 |
| Río Negro                     | M    |        2878 |        823 |        106 |              0.033 |              0.037 |            0.409 |           0.286 |                  0.019 |           0.014 |
| Chaco                         | M    |        2738 |        314 |        138 |              0.040 |              0.050 |            0.168 |           0.115 |                  0.070 |           0.033 |
| Chaco                         | F    |        2677 |        293 |         79 |              0.022 |              0.030 |            0.161 |           0.109 |                  0.053 |           0.022 |
| Salta                         | M    |        1955 |        282 |         35 |              0.013 |              0.018 |            0.461 |           0.144 |                  0.017 |           0.008 |
| Entre Ríos                    | F    |        1721 |        185 |         17 |              0.008 |              0.010 |            0.319 |           0.107 |                  0.006 |           0.001 |
| Entre Ríos                    | M    |        1613 |        187 |         29 |              0.014 |              0.018 |            0.332 |           0.116 |                  0.014 |           0.004 |
| Neuquén                       | M    |        1544 |        872 |         27 |              0.014 |              0.017 |            0.375 |           0.565 |                  0.016 |           0.011 |
| Neuquén                       | F    |        1492 |        843 |         23 |              0.012 |              0.015 |            0.354 |           0.565 |                  0.013 |           0.007 |
| Salta                         | F    |        1352 |        202 |         10 |              0.005 |              0.007 |            0.454 |           0.149 |                  0.010 |           0.001 |
| Tucumán                       | M    |        1170 |        102 |         10 |              0.002 |              0.009 |            0.108 |           0.087 |                  0.009 |           0.003 |
| Tierra del Fuego              | M    |        1122 |         32 |         21 |              0.016 |              0.019 |            0.364 |           0.029 |                  0.012 |           0.012 |
| Tucumán                       | F    |        1069 |         82 |          4 |              0.001 |              0.004 |            0.156 |           0.077 |                  0.010 |           0.002 |
| SIN ESPECIFICAR               | F    |        1008 |         54 |          3 |              0.002 |              0.003 |            0.431 |           0.054 |                  0.004 |           0.000 |
| Buenos Aires                  | NR   |         932 |         89 |         35 |              0.024 |              0.038 |            0.463 |           0.095 |                  0.025 |           0.012 |
| Santa Cruz                    | M    |         895 |         40 |         10 |              0.010 |              0.011 |            0.383 |           0.045 |                  0.016 |           0.011 |
| Tierra del Fuego              | F    |         884 |         18 |          9 |              0.009 |              0.010 |            0.312 |           0.020 |                  0.003 |           0.003 |
| Santa Cruz                    | F    |         869 |         41 |          4 |              0.004 |              0.005 |            0.365 |           0.047 |                  0.012 |           0.008 |
| La Rioja                      | M    |         835 |         16 |         34 |              0.038 |              0.041 |            0.240 |           0.019 |                  0.002 |           0.000 |
| La Rioja                      | F    |         748 |         15 |         19 |              0.024 |              0.025 |            0.231 |           0.020 |                  0.007 |           0.003 |
| SIN ESPECIFICAR               | M    |         710 |         52 |          5 |              0.006 |              0.007 |            0.462 |           0.073 |                  0.008 |           0.007 |
| Santiago del Estero           | M    |         514 |          5 |          4 |              0.004 |              0.008 |            0.092 |           0.010 |                  0.004 |           0.000 |
| Chubut                        | M    |         497 |         17 |          4 |              0.004 |              0.008 |            0.186 |           0.034 |                  0.010 |           0.010 |
| Santiago del Estero           | F    |         420 |          2 |          5 |              0.006 |              0.012 |            0.157 |           0.005 |                  0.002 |           0.002 |
| Chubut                        | F    |         395 |          6 |          2 |              0.002 |              0.005 |            0.155 |           0.015 |                  0.005 |           0.003 |
| CABA                          | NR   |         369 |         98 |         24 |              0.043 |              0.065 |            0.406 |           0.266 |                  0.038 |           0.024 |
| Corrientes                    | M    |         178 |          7 |          2 |              0.006 |              0.011 |            0.044 |           0.039 |                  0.011 |           0.006 |
| Corrientes                    | F    |         133 |          1 |          0 |              0.000 |              0.000 |            0.042 |           0.008 |                  0.008 |           0.000 |
| San Juan                      | M    |         122 |          5 |          1 |              0.005 |              0.008 |            0.159 |           0.041 |                  0.008 |           0.000 |
| La Pampa                      | F    |         116 |         11 |          0 |              0.000 |              0.000 |            0.085 |           0.095 |                  0.017 |           0.009 |
| San Juan                      | F    |         100 |          5 |          0 |              0.000 |              0.000 |            0.167 |           0.050 |                  0.020 |           0.000 |
| La Pampa                      | M    |          88 |          5 |          1 |              0.009 |              0.011 |            0.082 |           0.057 |                  0.011 |           0.000 |
| San Luis                      | M    |          79 |         10 |          0 |              0.000 |              0.000 |            0.123 |           0.127 |                  0.013 |           0.000 |
| San Luis                      | F    |          68 |          6 |          0 |              0.000 |              0.000 |            0.127 |           0.088 |                  0.000 |           0.000 |
| Formosa                       | M    |          66 |          0 |          0 |              0.000 |              0.000 |            0.100 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          42 |          0 |          0 |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          40 |         16 |          1 |              0.013 |              0.025 |            0.025 |           0.400 |                  0.100 |           0.050 |
| Córdoba                       | NR   |          27 |          1 |          0 |              0.000 |              0.000 |            0.482 |           0.037 |                  0.000 |           0.000 |
| Catamarca                     | F    |          23 |          0 |          0 |              0.000 |              0.000 |            0.022 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         15 |          1 |              0.019 |              0.045 |            0.016 |           0.682 |                  0.091 |           0.045 |
| Mendoza                       | NR   |          21 |          5 |          2 |              0.038 |              0.095 |            0.189 |           0.238 |                  0.000 |           0.000 |
| Formosa                       | F    |          17 |          1 |          1 |              0.036 |              0.059 |            0.039 |           0.059 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          15 |          0 |          1 |              0.034 |              0.067 |            0.294 |           0.000 |                  0.000 |           0.000 |
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
