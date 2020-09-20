
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
    #> INFO  [08:42:48.455] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:42:57.822] Normalize 
    #> INFO  [08:43:00.011] checkSoundness 
    #> INFO  [08:43:00.958] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-19"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-19"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-19"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-19              |      622930 |      12799 |              0.017 |              0.021 |                       209 | 1508632 |            0.413 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      363463 |       7573 |              0.017 |              0.021 |                       206 | 795380 |            0.457 |
| CABA                          |      115705 |       2889 |              0.022 |              0.025 |                       204 | 297083 |            0.389 |
| Santa Fe                      |       25518 |        266 |              0.009 |              0.010 |                       190 |  62064 |            0.411 |
| Córdoba                       |       18601 |        249 |              0.011 |              0.013 |                       194 |  66017 |            0.282 |
| Mendoza                       |       18254 |        223 |              0.009 |              0.012 |                       193 |  39912 |            0.457 |
| Jujuy                         |       13891 |        339 |              0.018 |              0.024 |                       184 |  31018 |            0.448 |
| Río Negro                     |       10214 |        280 |              0.025 |              0.027 |                       187 |  22809 |            0.448 |
| Tucumán                       |        9245 |         52 |              0.003 |              0.006 |                       185 |  26114 |            0.354 |
| Salta                         |        8926 |        155 |              0.013 |              0.017 |                       182 |  17166 |            0.520 |
| Chaco                         |        7345 |        254 |              0.027 |              0.035 |                       192 |  42968 |            0.171 |
| Entre Ríos                    |        6103 |        104 |              0.014 |              0.017 |                       187 |  15944 |            0.383 |
| Neuquén                       |        5856 |         98 |              0.010 |              0.017 |                       189 |  12139 |            0.482 |
| Santa Cruz                    |        3657 |         43 |              0.010 |              0.012 |                       179 |   8040 |            0.455 |
| La Rioja                      |        3490 |        120 |              0.032 |              0.034 |                       179 |  10980 |            0.318 |
| Tierra del Fuego              |        3117 |         52 |              0.014 |              0.017 |                       186 |   8228 |            0.379 |
| Santiago del Estero           |        2302 |         29 |              0.007 |              0.013 |                       173 |  12188 |            0.189 |
| Chubut                        |        2180 |         24 |              0.006 |              0.011 |                       173 |   7362 |            0.296 |
| SIN ESPECIFICAR               |        2084 |         13 |              0.005 |              0.006 |                       180 |   4734 |            0.440 |
| Corrientes                    |         940 |          8 |              0.004 |              0.009 |                       184 |  10002 |            0.094 |
| San Luis                      |         672 |          0 |              0.000 |              0.000 |                       166 |   2201 |            0.305 |
| La Pampa                      |         547 |          3 |              0.004 |              0.005 |                       167 |   4754 |            0.115 |
| San Juan                      |         463 |         22 |              0.034 |              0.048 |                       175 |   1692 |            0.274 |
| Catamarca                     |         189 |          0 |              0.000 |              0.000 |                       158 |   4692 |            0.040 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      363463 | 795380 |       7573 |               15.2 |              0.017 |              0.021 |            0.457 |           0.074 |                  0.011 |           0.005 |
| CABA                          |      115705 | 297083 |       2889 |               16.5 |              0.022 |              0.025 |            0.389 |           0.158 |                  0.017 |           0.009 |
| Santa Fe                      |       25518 |  62064 |        266 |               12.6 |              0.009 |              0.010 |            0.411 |           0.034 |                  0.009 |           0.005 |
| Córdoba                       |       18601 |  66017 |        249 |               13.4 |              0.011 |              0.013 |            0.282 |           0.018 |                  0.005 |           0.003 |
| Mendoza                       |       18254 |  39912 |        223 |               11.1 |              0.009 |              0.012 |            0.457 |           0.087 |                  0.006 |           0.002 |
| Jujuy                         |       13891 |  31018 |        339 |               14.3 |              0.018 |              0.024 |            0.448 |           0.009 |                  0.001 |           0.000 |
| Río Negro                     |       10214 |  22809 |        280 |               13.3 |              0.025 |              0.027 |            0.448 |           0.219 |                  0.010 |           0.007 |
| Tucumán                       |        9245 |  26114 |         52 |               11.9 |              0.003 |              0.006 |            0.354 |           0.025 |                  0.004 |           0.001 |
| Salta                         |        8926 |  17166 |        155 |               11.1 |              0.013 |              0.017 |            0.520 |           0.097 |                  0.014 |           0.006 |
| Chaco                         |        7345 |  42968 |        254 |               14.4 |              0.027 |              0.035 |            0.171 |           0.097 |                  0.053 |           0.025 |
| Entre Ríos                    |        6103 |  15944 |        104 |               11.3 |              0.014 |              0.017 |            0.383 |           0.095 |                  0.010 |           0.003 |
| Neuquén                       |        5856 |  12139 |         98 |               16.6 |              0.010 |              0.017 |            0.482 |           0.583 |                  0.013 |           0.009 |
| Santa Cruz                    |        3657 |   8040 |         43 |               15.1 |              0.010 |              0.012 |            0.455 |           0.056 |                  0.012 |           0.005 |
| La Rioja                      |        3490 |  10980 |        120 |               12.6 |              0.032 |              0.034 |            0.318 |           0.012 |                  0.003 |           0.001 |
| Tierra del Fuego              |        3117 |   8228 |         52 |               15.9 |              0.014 |              0.017 |            0.379 |           0.025 |                  0.009 |           0.008 |
| Santiago del Estero           |        2302 |  12188 |         29 |                9.1 |              0.007 |              0.013 |            0.189 |           0.009 |                  0.002 |           0.001 |
| Chubut                        |        2180 |   7362 |         24 |               10.0 |              0.006 |              0.011 |            0.296 |           0.019 |                  0.007 |           0.007 |
| SIN ESPECIFICAR               |        2084 |   4734 |         13 |               19.0 |              0.005 |              0.006 |            0.440 |           0.065 |                  0.008 |           0.004 |
| Corrientes                    |         940 |  10002 |          8 |               10.7 |              0.004 |              0.009 |            0.094 |           0.019 |                  0.010 |           0.006 |
| San Luis                      |         672 |   2201 |          0 |                NaN |              0.000 |              0.000 |            0.305 |           0.058 |                  0.001 |           0.000 |
| La Pampa                      |         547 |   4754 |          3 |               29.0 |              0.004 |              0.005 |            0.115 |           0.046 |                  0.011 |           0.002 |
| San Juan                      |         463 |   1692 |         22 |               10.8 |              0.034 |              0.048 |            0.274 |           0.045 |                  0.017 |           0.002 |
| Catamarca                     |         189 |   4692 |          0 |                NaN |              0.000 |              0.000 |            0.040 |           0.000 |                  0.000 |           0.000 |
| Formosa                       |          99 |   1198 |          1 |               12.0 |              0.007 |              0.010 |            0.083 |           0.020 |                  0.000 |           0.000 |
| Misiones                      |          69 |   3947 |          2 |                6.5 |              0.014 |              0.029 |            0.017 |           0.507 |                  0.072 |           0.029 |

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
    #> INFO  [08:48:02.011] Processing {current.group: }
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
|             13 | 2020-09-16              |                       116 |        1111 |    5528 |        610 |         64 |              0.050 |              0.058 |            0.201 |           0.549 |                  0.092 |           0.055 |
|             14 | 2020-09-18              |                       160 |        1835 |   11562 |       1000 |        116 |              0.054 |              0.063 |            0.159 |           0.545 |                  0.092 |           0.054 |
|             15 | 2020-09-19              |                       190 |        2551 |   20289 |       1366 |        181 |              0.060 |              0.071 |            0.126 |           0.535 |                  0.086 |           0.049 |
|             16 | 2020-09-19              |                       203 |        3431 |   31909 |       1741 |        242 |              0.058 |              0.071 |            0.108 |           0.507 |                  0.077 |           0.042 |
|             17 | 2020-09-19              |                       206 |        4648 |   45978 |       2290 |        353 |              0.063 |              0.076 |            0.101 |           0.493 |                  0.069 |           0.036 |
|             18 | 2020-09-19              |                       206 |        5733 |   59183 |       2713 |        439 |              0.064 |              0.077 |            0.097 |           0.473 |                  0.063 |           0.033 |
|             19 | 2020-09-19              |                       206 |        7288 |   73326 |       3327 |        530 |              0.061 |              0.073 |            0.099 |           0.457 |                  0.058 |           0.030 |
|             20 | 2020-09-19              |                       206 |        9780 |   90779 |       4200 |        646 |              0.057 |              0.066 |            0.108 |           0.429 |                  0.053 |           0.028 |
|             21 | 2020-09-19              |                       206 |       14341 |  114252 |       5579 |        825 |              0.050 |              0.058 |            0.126 |           0.389 |                  0.047 |           0.024 |
|             22 | 2020-09-19              |                       206 |       19755 |  139700 |       7058 |       1059 |              0.047 |              0.054 |            0.141 |           0.357 |                  0.043 |           0.021 |
|             23 | 2020-09-19              |                       206 |       26435 |  168032 |       8652 |       1338 |              0.044 |              0.051 |            0.157 |           0.327 |                  0.040 |           0.019 |
|             24 | 2020-09-19              |                       206 |       36342 |  203246 |      10856 |       1689 |              0.041 |              0.046 |            0.179 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-19              |                       206 |       49421 |  244767 |      13292 |       2125 |              0.038 |              0.043 |            0.202 |           0.269 |                  0.031 |           0.015 |
|             26 | 2020-09-19              |                       206 |       67548 |  297011 |      16443 |       2714 |              0.036 |              0.040 |            0.227 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-19              |                       206 |       86658 |  348278 |      19314 |       3362 |              0.034 |              0.039 |            0.249 |           0.223 |                  0.026 |           0.012 |
|             28 | 2020-09-19              |                       207 |      110417 |  407474 |      22711 |       4178 |              0.033 |              0.038 |            0.271 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-09-19              |                       209 |      139732 |  479054 |      26416 |       5121 |              0.032 |              0.037 |            0.292 |           0.189 |                  0.022 |           0.010 |
|             30 | 2020-09-19              |                       209 |      177849 |  564957 |      30181 |       6181 |              0.030 |              0.035 |            0.315 |           0.170 |                  0.020 |           0.009 |
|             31 | 2020-09-19              |                       209 |      217464 |  654497 |      33505 |       7157 |              0.029 |              0.033 |            0.332 |           0.154 |                  0.019 |           0.009 |
|             32 | 2020-09-19              |                       209 |      266688 |  762163 |      37289 |       8283 |              0.027 |              0.031 |            0.350 |           0.140 |                  0.017 |           0.008 |
|             33 | 2020-09-19              |                       209 |      313432 |  875856 |      40939 |       9267 |              0.025 |              0.030 |            0.358 |           0.131 |                  0.016 |           0.008 |
|             34 | 2020-09-19              |                       209 |      362227 |  986119 |      44507 |      10311 |              0.024 |              0.028 |            0.367 |           0.123 |                  0.016 |           0.007 |
|             35 | 2020-09-19              |                       209 |      427096 | 1120168 |      48750 |      11344 |              0.023 |              0.027 |            0.381 |           0.114 |                  0.015 |           0.007 |
|             36 | 2020-09-19              |                       209 |      495710 | 1258396 |      52365 |      12150 |              0.021 |              0.025 |            0.394 |           0.106 |                  0.014 |           0.006 |
|             37 | 2020-09-19              |                       209 |      567963 | 1403695 |      55333 |      12635 |              0.019 |              0.022 |            0.405 |           0.097 |                  0.013 |           0.006 |
|             38 | 2020-09-19              |                       209 |      622930 | 1508632 |      56658 |      12799 |              0.017 |              0.021 |            0.413 |           0.091 |                  0.012 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:50:05.364] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:51:14.541] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:51:45.458] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:51:48.002] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:51:55.312] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:51:58.776] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:52:08.598] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:52:12.569] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:52:16.744] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:52:19.450] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:52:24.053] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:52:26.944] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:52:30.328] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:52:35.030] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:52:37.938] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:52:41.739] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:52:46.410] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:52:49.765] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [08:52:52.521] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [08:52:55.256] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [08:52:58.242] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [08:53:05.236] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [08:53:08.711] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [08:53:11.986] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [08:53:15.507] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |      185223 |      14631 |       4293 |              0.019 |              0.023 |            0.473 |           0.079 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      176926 |      12019 |       3224 |              0.015 |              0.018 |            0.441 |           0.068 |                  0.008 |           0.003 |
| CABA                          | F    |       58402 |       8806 |       1328 |              0.020 |              0.023 |            0.367 |           0.151 |                  0.013 |           0.006 |
| CABA                          | M    |       56860 |       9333 |       1533 |              0.024 |              0.027 |            0.415 |           0.164 |                  0.022 |           0.011 |
| Santa Fe                      | F    |       12896 |        402 |        115 |              0.007 |              0.009 |            0.397 |           0.031 |                  0.007 |           0.004 |
| Santa Fe                      | M    |       12619 |        469 |        151 |              0.010 |              0.012 |            0.427 |           0.037 |                  0.011 |           0.006 |
| Córdoba                       | M    |        9323 |        181 |        141 |              0.013 |              0.015 |            0.287 |           0.019 |                  0.006 |           0.003 |
| Córdoba                       | F    |        9250 |        161 |        105 |              0.009 |              0.011 |            0.276 |           0.017 |                  0.004 |           0.002 |
| Mendoza                       | M    |        9113 |        810 |        140 |              0.011 |              0.015 |            0.471 |           0.089 |                  0.009 |           0.003 |
| Mendoza                       | F    |        9075 |        772 |         81 |              0.007 |              0.009 |            0.446 |           0.085 |                  0.003 |           0.001 |
| Jujuy                         | M    |        7836 |         81 |        209 |              0.020 |              0.027 |            0.461 |           0.010 |                  0.001 |           0.000 |
| Jujuy                         | F    |        6035 |         46 |        129 |              0.015 |              0.021 |            0.432 |           0.008 |                  0.000 |           0.000 |
| Río Negro                     | F    |        5254 |       1126 |        118 |              0.020 |              0.022 |            0.431 |           0.214 |                  0.007 |           0.004 |
| Salta                         | M    |        5187 |        507 |        103 |              0.015 |              0.020 |            0.530 |           0.098 |                  0.015 |           0.008 |
| Río Negro                     | M    |        4957 |       1106 |        162 |              0.030 |              0.033 |            0.467 |           0.223 |                  0.013 |           0.010 |
| Tucumán                       | M    |        4767 |        128 |         37 |              0.004 |              0.008 |            0.315 |           0.027 |                  0.004 |           0.001 |
| Tucumán                       | F    |        4472 |        104 |         15 |              0.002 |              0.003 |            0.408 |           0.023 |                  0.004 |           0.001 |
| Salta                         | F    |        3715 |        359 |         52 |              0.010 |              0.014 |            0.508 |           0.097 |                  0.012 |           0.004 |
| Chaco                         | M    |        3714 |        373 |        159 |              0.034 |              0.043 |            0.176 |           0.100 |                  0.059 |           0.030 |
| Chaco                         | F    |        3627 |        342 |         95 |              0.020 |              0.026 |            0.166 |           0.094 |                  0.047 |           0.021 |
| Entre Ríos                    | F    |        3085 |        286 |         41 |              0.011 |              0.013 |            0.368 |           0.093 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        3014 |        295 |         62 |              0.017 |              0.021 |            0.400 |           0.098 |                  0.013 |           0.004 |
| Neuquén                       | M    |        2969 |       1719 |         57 |              0.012 |              0.019 |            0.498 |           0.579 |                  0.015 |           0.011 |
| Neuquén                       | F    |        2886 |       1694 |         40 |              0.008 |              0.014 |            0.468 |           0.587 |                  0.010 |           0.006 |
| Santa Cruz                    | M    |        1877 |        111 |         29 |              0.014 |              0.015 |            0.471 |           0.059 |                  0.013 |           0.006 |
| La Rioja                      | M    |        1876 |         21 |         71 |              0.036 |              0.038 |            0.329 |           0.011 |                  0.003 |           0.001 |
| Santa Cruz                    | F    |        1779 |         93 |         14 |              0.007 |              0.008 |            0.439 |           0.052 |                  0.010 |           0.004 |
| Tierra del Fuego              | M    |        1714 |         46 |         34 |              0.017 |              0.020 |            0.400 |           0.027 |                  0.013 |           0.012 |
| La Rioja                      | F    |        1600 |         21 |         47 |              0.028 |              0.029 |            0.307 |           0.013 |                  0.004 |           0.001 |
| Tierra del Fuego              | F    |        1389 |         31 |         18 |              0.011 |              0.013 |            0.352 |           0.022 |                  0.004 |           0.004 |
| Buenos Aires                  | NR   |        1314 |        116 |         56 |              0.030 |              0.043 |            0.479 |           0.088 |                  0.018 |           0.008 |
| Santiago del Estero           | M    |        1252 |         17 |         17 |              0.008 |              0.014 |            0.164 |           0.014 |                  0.002 |           0.001 |
| SIN ESPECIFICAR               | F    |        1233 |         72 |          5 |              0.003 |              0.004 |            0.433 |           0.058 |                  0.006 |           0.002 |
| Chubut                        | M    |        1160 |         25 |         14 |              0.007 |              0.012 |            0.314 |           0.022 |                  0.009 |           0.009 |
| Santiago del Estero           | F    |        1046 |          4 |         12 |              0.007 |              0.011 |            0.249 |           0.004 |                  0.001 |           0.001 |
| Chubut                        | F    |        1008 |         16 |          9 |              0.005 |              0.009 |            0.278 |           0.016 |                  0.006 |           0.005 |
| SIN ESPECIFICAR               | M    |         845 |         63 |          7 |              0.007 |              0.008 |            0.453 |           0.075 |                  0.008 |           0.007 |
| Corrientes                    | M    |         526 |         15 |          8 |              0.008 |              0.015 |            0.097 |           0.029 |                  0.015 |           0.011 |
| CABA                          | NR   |         443 |        119 |         28 |              0.048 |              0.063 |            0.409 |           0.269 |                  0.036 |           0.023 |
| Corrientes                    | F    |         414 |          3 |          0 |              0.000 |              0.000 |            0.090 |           0.007 |                  0.002 |           0.000 |
| San Luis                      | M    |         366 |         20 |          0 |              0.000 |              0.000 |            0.306 |           0.055 |                  0.003 |           0.000 |
| San Luis                      | F    |         306 |         19 |          0 |              0.000 |              0.000 |            0.305 |           0.062 |                  0.000 |           0.000 |
| La Pampa                      | F    |         286 |         16 |          1 |              0.003 |              0.003 |            0.110 |           0.056 |                  0.014 |           0.003 |
| La Pampa                      | M    |         258 |          9 |          2 |              0.006 |              0.008 |            0.121 |           0.035 |                  0.008 |           0.000 |
| San Juan                      | F    |         233 |         12 |         10 |              0.031 |              0.043 |            0.299 |           0.052 |                  0.017 |           0.000 |
| San Juan                      | M    |         230 |          9 |         12 |              0.037 |              0.052 |            0.252 |           0.039 |                  0.017 |           0.004 |
| Catamarca                     | M    |         118 |          0 |          0 |              0.000 |              0.000 |            0.040 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | M    |          77 |          0 |          0 |              0.000 |              0.000 |            0.106 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | F    |          71 |          0 |          0 |              0.000 |              0.000 |            0.041 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          66 |          5 |          2 |              0.018 |              0.030 |            0.308 |           0.076 |                  0.000 |           0.000 |
| Misiones                      | M    |          37 |         18 |          1 |              0.013 |              0.027 |            0.017 |           0.486 |                  0.081 |           0.027 |
| Misiones                      | F    |          32 |         17 |          1 |              0.015 |              0.031 |            0.018 |           0.531 |                  0.062 |           0.031 |
| Córdoba                       | NR   |          28 |          1 |          3 |              0.079 |              0.107 |            0.483 |           0.036 |                  0.000 |           0.000 |
| Salta                         | NR   |          24 |          1 |          0 |              0.000 |              0.000 |            0.393 |           0.042 |                  0.000 |           0.000 |
| Formosa                       | F    |          22 |          2 |          1 |              0.023 |              0.045 |            0.047 |           0.091 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          20 |          0 |          1 |              0.026 |              0.050 |            0.339 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          14 |          0 |          2 |              0.133 |              0.143 |            0.246 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          14 |          0 |          0 |              0.000 |              0.000 |            2.800 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          12 |          1 |          1 |              0.045 |              0.083 |            0.235 |           0.083 |                  0.000 |           0.000 |


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
    #> Warning: Removed 33 rows containing missing values (position_stack).

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
