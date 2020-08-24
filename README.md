
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
    #> INFO  [19:06:33.285] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [19:06:39.002] Normalize 
    #> INFO  [19:06:40.429] checkSoundness 
    #> INFO  [19:06:40.916] Mutating data 
    #> INFO  [19:09:12.499] Last days rows {date: 2020-08-22, n: 19671}
    #> INFO  [19:09:12.502] Last days rows {date: 2020-08-23, n: 6991}
    #> INFO  [19:09:12.505] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-23"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-23"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-23"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      342150 |       6985 |              0.016 |               0.02 |                       183 | 949240 |             0.36 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      211836 |       4122 |              0.015 |              0.019 |                       180 | 503448 |            0.421 |
| CABA                          |       84297 |       1922 |              0.019 |              0.023 |                       177 | 211037 |            0.399 |
| Jujuy                         |        6269 |        174 |              0.016 |              0.028 |                       157 |  17908 |            0.350 |
| Córdoba                       |        5905 |        100 |              0.013 |              0.017 |                       167 |  44339 |            0.133 |
| Chaco                         |        4861 |        193 |              0.030 |              0.040 |                       165 |  29889 |            0.163 |
| Santa Fe                      |        4817 |         53 |              0.008 |              0.011 |                       163 |  32049 |            0.150 |
| Río Negro                     |        4703 |        132 |              0.025 |              0.028 |                       160 |  12821 |            0.367 |
| Mendoza                       |        4634 |        106 |              0.017 |              0.023 |                       166 |  14918 |            0.311 |
| Neuquén                       |        2278 |         38 |              0.015 |              0.017 |                       162 |   7198 |            0.316 |
| Entre Ríos                    |        2258 |         28 |              0.010 |              0.012 |                       160 |   8332 |            0.271 |
| Salta                         |        1832 |         29 |              0.011 |              0.016 |                       155 |   4526 |            0.405 |
| Tierra del Fuego              |        1698 |         20 |              0.010 |              0.012 |                       159 |   5196 |            0.327 |
| SIN ESPECIFICAR               |        1547 |          7 |              0.004 |              0.005 |                       153 |   3528 |            0.438 |
| Santa Cruz                    |        1328 |         10 |              0.007 |              0.008 |                       152 |   3721 |            0.357 |
| Tucumán                       |        1050 |          6 |              0.001 |              0.006 |                       158 |  16125 |            0.065 |
| La Rioja                      |        1040 |         31 |              0.027 |              0.030 |                       152 |   5752 |            0.181 |
| Chubut                        |         533 |          6 |              0.006 |              0.011 |                       146 |   4262 |            0.125 |
| Santiago del Estero           |         517 |          1 |              0.001 |              0.002 |                       146 |   7268 |            0.071 |
| Corrientes                    |         252 |          4 |              0.008 |              0.016 |                       157 |   6105 |            0.041 |
| La Pampa                      |         195 |          0 |              0.000 |              0.000 |                       140 |   2183 |            0.089 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      211836 | 503448 |       4122 |               14.5 |              0.015 |              0.019 |            0.421 |           0.090 |                  0.012 |           0.005 |
| CABA                          |       84297 | 211037 |       1922 |               15.6 |              0.019 |              0.023 |            0.399 |           0.178 |                  0.018 |           0.009 |
| Jujuy                         |        6269 |  17908 |        174 |               12.8 |              0.016 |              0.028 |            0.350 |           0.007 |                  0.001 |           0.001 |
| Córdoba                       |        5905 |  44339 |        100 |               18.2 |              0.013 |              0.017 |            0.133 |           0.036 |                  0.010 |           0.006 |
| Chaco                         |        4861 |  29889 |        193 |               14.8 |              0.030 |              0.040 |            0.163 |           0.111 |                  0.062 |           0.027 |
| Santa Fe                      |        4817 |  32049 |         53 |               12.0 |              0.008 |              0.011 |            0.150 |           0.058 |                  0.013 |           0.006 |
| Río Negro                     |        4703 |  12821 |        132 |               12.8 |              0.025 |              0.028 |            0.367 |           0.283 |                  0.016 |           0.010 |
| Mendoza                       |        4634 |  14918 |        106 |               11.6 |              0.017 |              0.023 |            0.311 |           0.244 |                  0.013 |           0.004 |
| Neuquén                       |        2278 |   7198 |         38 |               16.4 |              0.015 |              0.017 |            0.316 |           0.608 |                  0.014 |           0.008 |
| Entre Ríos                    |        2258 |   8332 |         28 |               10.9 |              0.010 |              0.012 |            0.271 |           0.131 |                  0.009 |           0.002 |
| Salta                         |        1832 |   4526 |         29 |                7.3 |              0.011 |              0.016 |            0.405 |           0.198 |                  0.017 |           0.006 |
| Tierra del Fuego              |        1698 |   5196 |         20 |               12.1 |              0.010 |              0.012 |            0.327 |           0.021 |                  0.008 |           0.008 |
| SIN ESPECIFICAR               |        1547 |   3528 |          7 |               20.0 |              0.004 |              0.005 |            0.438 |           0.064 |                  0.007 |           0.004 |
| Santa Cruz                    |        1328 |   3721 |         10 |               10.8 |              0.007 |              0.008 |            0.357 |           0.050 |                  0.016 |           0.011 |
| Tucumán                       |        1050 |  16125 |          6 |               13.2 |              0.001 |              0.006 |            0.065 |           0.152 |                  0.017 |           0.003 |
| La Rioja                      |        1040 |   5752 |         31 |               10.8 |              0.027 |              0.030 |            0.181 |           0.027 |                  0.006 |           0.002 |
| Chubut                        |         533 |   4262 |          6 |               16.0 |              0.006 |              0.011 |            0.125 |           0.047 |                  0.013 |           0.011 |
| Santiago del Estero           |         517 |   7268 |          1 |                6.0 |              0.001 |              0.002 |            0.071 |           0.010 |                  0.004 |           0.000 |
| Corrientes                    |         252 |   6105 |          4 |               11.0 |              0.008 |              0.016 |            0.041 |           0.028 |                  0.012 |           0.008 |
| La Pampa                      |         195 |   2183 |          0 |                NaN |              0.000 |              0.000 |            0.089 |           0.087 |                  0.015 |           0.005 |
| Formosa                       |          82 |   1036 |          1 |               12.0 |              0.009 |              0.012 |            0.079 |           0.012 |                  0.000 |           0.000 |
| Catamarca                     |          62 |   2750 |          0 |                NaN |              0.000 |              0.000 |            0.023 |           0.000 |                  0.000 |           0.000 |
| San Juan                      |          57 |   1158 |          0 |                NaN |              0.000 |              0.000 |            0.049 |           0.140 |                  0.018 |           0.000 |
| Misiones                      |          56 |   2693 |          2 |                6.5 |              0.016 |              0.036 |            0.021 |           0.536 |                  0.107 |           0.054 |
| San Luis                      |          43 |    998 |          0 |                NaN |              0.000 |              0.000 |            0.043 |           0.279 |                  0.023 |           0.000 |

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
    #> INFO  [19:10:03.125] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 26
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-08-12              |                        20 |          15 |     86 |          9 |          1 |              0.048 |              0.067 |            0.174 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-12              |                        40 |          98 |    667 |         66 |          9 |              0.065 |              0.092 |            0.147 |           0.673 |                  0.122 |           0.061 |
|             12 | 2020-08-22              |                        65 |         415 |   2051 |        256 |         17 |              0.033 |              0.041 |            0.202 |           0.617 |                  0.092 |           0.053 |
|             13 | 2020-08-22              |                       101 |        1091 |   5521 |        601 |         63 |              0.049 |              0.058 |            0.198 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-08-22              |                       139 |        1797 |  11543 |        982 |        114 |              0.053 |              0.063 |            0.156 |           0.546 |                  0.093 |           0.056 |
|             15 | 2020-08-22              |                       164 |        2478 |  20266 |       1337 |        179 |              0.059 |              0.072 |            0.122 |           0.540 |                  0.089 |           0.050 |
|             16 | 2020-08-22              |                       175 |        3307 |  31876 |       1696 |        239 |              0.058 |              0.072 |            0.104 |           0.513 |                  0.079 |           0.043 |
|             17 | 2020-08-22              |                       178 |        4471 |  45937 |       2232 |        346 |              0.063 |              0.077 |            0.097 |           0.499 |                  0.071 |           0.037 |
|             18 | 2020-08-22              |                       178 |        5506 |  59135 |       2641 |        426 |              0.063 |              0.077 |            0.093 |           0.480 |                  0.064 |           0.034 |
|             19 | 2020-08-23              |                       179 |        6990 |  73275 |       3244 |        509 |              0.060 |              0.073 |            0.095 |           0.464 |                  0.060 |           0.031 |
|             20 | 2020-08-23              |                       179 |        9431 |  90654 |       4105 |        612 |              0.054 |              0.065 |            0.104 |           0.435 |                  0.055 |           0.028 |
|             21 | 2020-08-23              |                       179 |       13868 | 114107 |       5453 |        773 |              0.047 |              0.056 |            0.122 |           0.393 |                  0.048 |           0.024 |
|             22 | 2020-08-23              |                       179 |       19169 | 139518 |       6914 |        975 |              0.043 |              0.051 |            0.137 |           0.361 |                  0.044 |           0.022 |
|             23 | 2020-08-23              |                       179 |       25696 | 167817 |       8468 |       1225 |              0.040 |              0.048 |            0.153 |           0.330 |                  0.041 |           0.019 |
|             24 | 2020-08-23              |                       179 |       35430 | 202972 |      10637 |       1516 |              0.036 |              0.043 |            0.175 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-23              |                       179 |       48367 | 244429 |      13023 |       1896 |              0.034 |              0.039 |            0.198 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-08-23              |                       179 |       66254 | 296534 |      16124 |       2399 |              0.031 |              0.036 |            0.223 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-08-23              |                       179 |       85097 | 347576 |      18944 |       2973 |              0.030 |              0.035 |            0.245 |           0.223 |                  0.026 |           0.011 |
|             28 | 2020-08-23              |                       180 |      108540 | 406546 |      22266 |       3680 |              0.029 |              0.034 |            0.267 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-08-23              |                       182 |      137352 | 477659 |      25812 |       4447 |              0.027 |              0.032 |            0.288 |           0.188 |                  0.022 |           0.010 |
|             30 | 2020-08-23              |                       182 |      174767 | 562883 |      29410 |       5251 |              0.026 |              0.030 |            0.310 |           0.168 |                  0.020 |           0.009 |
|             31 | 2020-08-29              |                       183 |      213304 | 650623 |      32495 |       5861 |              0.023 |              0.027 |            0.328 |           0.152 |                  0.018 |           0.008 |
|             32 | 2020-08-29              |                       183 |      260931 | 755438 |      35809 |       6500 |              0.021 |              0.025 |            0.345 |           0.137 |                  0.016 |           0.007 |
|             33 | 2020-08-29              |                       183 |      304425 | 862386 |      38462 |       6845 |              0.018 |              0.022 |            0.353 |           0.126 |                  0.015 |           0.007 |
|             34 | 2020-08-29              |                       183 |      341263 | 947540 |      40015 |       6984 |              0.016 |              0.020 |            0.360 |           0.117 |                  0.014 |           0.006 |
|             35 | 2020-08-29              |                       183 |      342150 | 949240 |      40030 |       6985 |              0.016 |              0.020 |            0.360 |           0.117 |                  0.014 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [19:11:19.191] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [19:11:59.496] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [19:12:18.269] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [19:12:20.179] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [19:12:25.007] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [19:12:27.613] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [19:12:34.008] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [19:12:36.923] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [19:12:39.946] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [19:12:41.885] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [19:12:45.532] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [19:12:47.938] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [19:12:50.802] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [19:12:53.807] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [19:12:56.102] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [19:12:58.658] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [19:13:01.759] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [19:13:04.264] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [19:13:06.486] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [19:13:08.970] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [19:13:11.475] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [19:13:16.189] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [19:13:18.962] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [19:13:21.452] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [19:13:24.151] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 585
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
| Buenos Aires                  | M    |      108471 |      10334 |       2350 |              0.016 |              0.022 |            0.439 |           0.095 |                  0.014 |           0.006 |
| Buenos Aires                  | F    |      102588 |       8562 |       1746 |              0.013 |              0.017 |            0.403 |           0.083 |                  0.009 |           0.004 |
| CABA                          | F    |       42520 |       7355 |        881 |              0.017 |              0.021 |            0.379 |           0.173 |                  0.013 |           0.006 |
| CABA                          | M    |       41444 |       7550 |       1022 |              0.021 |              0.025 |            0.423 |           0.182 |                  0.023 |           0.011 |
| Jujuy                         | M    |        3783 |         31 |        106 |              0.017 |              0.028 |            0.379 |           0.008 |                  0.001 |           0.001 |
| Córdoba                       | M    |        2949 |        103 |         53 |              0.014 |              0.018 |            0.137 |           0.035 |                  0.011 |           0.006 |
| Córdoba                       | F    |        2948 |        110 |         47 |              0.013 |              0.016 |            0.130 |           0.037 |                  0.009 |           0.005 |
| Jujuy                         | F    |        2478 |         12 |         67 |              0.014 |              0.027 |            0.314 |           0.005 |                  0.001 |           0.001 |
| Río Negro                     | F    |        2455 |        680 |         52 |              0.019 |              0.021 |            0.358 |           0.277 |                  0.009 |           0.004 |
| Chaco                         | M    |        2448 |        276 |        122 |              0.039 |              0.050 |            0.165 |           0.113 |                  0.068 |           0.032 |
| Santa Fe                      | F    |        2446 |        121 |         20 |              0.006 |              0.008 |            0.144 |           0.049 |                  0.011 |           0.004 |
| Chaco                         | F    |        2411 |        262 |         71 |              0.022 |              0.029 |            0.161 |           0.109 |                  0.056 |           0.022 |
| Santa Fe                      | M    |        2370 |        157 |         33 |              0.011 |              0.014 |            0.157 |           0.066 |                  0.016 |           0.009 |
| Mendoza                       | F    |        2341 |        575 |         34 |              0.011 |              0.015 |            0.307 |           0.246 |                  0.006 |           0.001 |
| Mendoza                       | M    |        2274 |        550 |         70 |              0.022 |              0.031 |            0.316 |           0.242 |                  0.019 |           0.007 |
| Río Negro                     | M    |        2247 |        649 |         80 |              0.032 |              0.036 |            0.377 |           0.289 |                  0.023 |           0.017 |
| Entre Ríos                    | F    |        1173 |        150 |          9 |              0.006 |              0.008 |            0.269 |           0.128 |                  0.008 |           0.001 |
| Neuquén                       | M    |        1145 |        692 |         21 |              0.016 |              0.018 |            0.323 |           0.604 |                  0.013 |           0.009 |
| Neuquén                       | F    |        1133 |        692 |         17 |              0.013 |              0.015 |            0.310 |           0.611 |                  0.014 |           0.008 |
| Entre Ríos                    | M    |        1083 |        144 |         19 |              0.014 |              0.018 |            0.273 |           0.133 |                  0.010 |           0.004 |
| Salta                         | M    |        1068 |        217 |         21 |              0.013 |              0.020 |            0.396 |           0.203 |                  0.022 |           0.010 |
| Tierra del Fuego              | M    |         942 |         22 |         11 |              0.010 |              0.012 |            0.348 |           0.023 |                  0.012 |           0.011 |
| SIN ESPECIFICAR               | F    |         910 |         49 |          2 |              0.002 |              0.002 |            0.429 |           0.054 |                  0.004 |           0.000 |
| Buenos Aires                  | NR   |         777 |         71 |         26 |              0.021 |              0.033 |            0.446 |           0.091 |                  0.024 |           0.010 |
| Salta                         | F    |         761 |        144 |          8 |              0.007 |              0.011 |            0.419 |           0.189 |                  0.011 |           0.000 |
| Tierra del Fuego              | F    |         742 |         13 |          9 |              0.010 |              0.012 |            0.298 |           0.018 |                  0.004 |           0.004 |
| Santa Cruz                    | M    |         675 |         34 |          8 |              0.011 |              0.012 |            0.367 |           0.050 |                  0.019 |           0.013 |
| Santa Cruz                    | F    |         652 |         32 |          2 |              0.003 |              0.003 |            0.346 |           0.049 |                  0.012 |           0.008 |
| SIN ESPECIFICAR               | M    |         632 |         49 |          4 |              0.005 |              0.006 |            0.455 |           0.078 |                  0.009 |           0.008 |
| Tucumán                       | M    |         558 |         86 |          3 |              0.001 |              0.005 |            0.056 |           0.154 |                  0.013 |           0.002 |
| La Rioja                      | M    |         551 |         13 |         22 |              0.036 |              0.040 |            0.185 |           0.024 |                  0.002 |           0.000 |
| Tucumán                       | F    |         492 |         74 |          3 |              0.001 |              0.006 |            0.079 |           0.150 |                  0.022 |           0.004 |
| La Rioja                      | F    |         486 |         15 |          9 |              0.017 |              0.019 |            0.178 |           0.031 |                  0.010 |           0.004 |
| CABA                          | NR   |         333 |         91 |         19 |              0.034 |              0.057 |            0.397 |           0.273 |                  0.039 |           0.027 |
| Chubut                        | M    |         293 |         18 |          4 |              0.007 |              0.014 |            0.135 |           0.061 |                  0.017 |           0.017 |
| Santiago del Estero           | M    |         289 |          4 |          0 |              0.000 |              0.000 |            0.059 |           0.014 |                  0.007 |           0.000 |
| Chubut                        | F    |         234 |          6 |          2 |              0.004 |              0.009 |            0.115 |           0.026 |                  0.009 |           0.004 |
| Santiago del Estero           | F    |         225 |          1 |          1 |              0.002 |              0.004 |            0.106 |           0.004 |                  0.000 |           0.000 |
| Corrientes                    | M    |         151 |          6 |          4 |              0.014 |              0.026 |            0.044 |           0.040 |                  0.013 |           0.013 |
| La Pampa                      | F    |         110 |         11 |          0 |              0.000 |              0.000 |            0.091 |           0.100 |                  0.018 |           0.009 |
| Corrientes                    | F    |         101 |          1 |          0 |              0.000 |              0.000 |            0.038 |           0.010 |                  0.010 |           0.000 |
| La Pampa                      | M    |          85 |          6 |          0 |              0.000 |              0.000 |            0.088 |           0.071 |                  0.012 |           0.000 |
| Formosa                       | M    |          67 |          0 |          0 |              0.000 |              0.000 |            0.109 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          40 |          0 |          0 |              0.000 |              0.000 |            0.023 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          34 |         16 |          1 |              0.014 |              0.029 |            0.023 |           0.471 |                  0.118 |           0.059 |
| San Juan                      | M    |          34 |          4 |          0 |              0.000 |              0.000 |            0.052 |           0.118 |                  0.000 |           0.000 |
| San Luis                      | M    |          31 |          8 |          0 |              0.000 |              0.000 |            0.056 |           0.258 |                  0.032 |           0.000 |
| San Juan                      | F    |          23 |          4 |          0 |              0.000 |              0.000 |            0.046 |           0.174 |                  0.043 |           0.000 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.023 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         14 |          1 |              0.020 |              0.045 |            0.018 |           0.636 |                  0.091 |           0.045 |
| Mendoza                       | NR   |          19 |          5 |          2 |              0.051 |              0.105 |            0.209 |           0.263 |                  0.000 |           0.000 |
| Formosa                       | F    |          15 |          1 |          1 |              0.038 |              0.067 |            0.036 |           0.067 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | F    |          12 |          4 |          0 |              0.000 |              0.000 |            0.027 |           0.333 |                  0.000 |           0.000 |


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
