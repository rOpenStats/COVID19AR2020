
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/COVID19AR.png" height="139" align="right" />

# COVID19AR

A package for analysing COVID-19 Argentina’s outbreak

<!-- . -->

# Package

| Release                                                                                                | Usage                                                                                                    | Development                                                                                                                                                                                            |
|:-------------------------------------------------------------------------------------------------------|:---------------------------------------------------------------------------------------------------------|:-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|                                                                                                        | [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)](https://cran.r-project.org/) | [![Travis](https://travis-ci.org/rOpenStats/COVID19AR.svg?branch=master)](https://travis-ci.org/rOpenStats/COVID19AR)                                                                                  |
| [![CRAN](http://www.r-pkg.org/badges/version/COVID19AR)](https://cran.r-project.org/package=COVID19AR) |                                                                                                          | [![codecov](https://codecov.io/gh/rOpenStats/COVID19AR/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenStats/COVID19AR)                                                                     |
|                                                                                                        |                                                                                                          | [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) |

# Argentina COVID19 open data

-   [Casos daily
    file](https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.csv)
-   [Determinaciones daily
    file](https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Determinaciones.csv)

# How to get started (Development version)

Install the R package using the following commands on the R console:

    # install.packages("devtools")
    devtools::install_github("rOpenStats/COVID19AR")

# How to use it

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

# COVID19AR datos abiertos del Ministerio de Salud de la Nación

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
    #> INFO  [14:48:58.878] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [14:49:11.589] Normalize 
    #> INFO  [14:49:15.108] checkSoundness 
    #> INFO  [14:49:16.393] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-10-22"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-10-22"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-10-22"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-10-22              |     1053635 |      27957 |              0.022 |              0.027 |                       246 | 2183772 |            0.482 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| Buenos Aires                  |      516040 |      16357 |              0.027 |              0.032 |                       239 | 1079790 |            0.478 |
| CABA                          |      141455 |       4549 |              0.029 |              0.032 |                       237 |  369704 |            0.383 |
| Santa Fe                      |       88656 |       1027 |              0.011 |              0.012 |                       223 |  120515 |            0.736 |
| Córdoba                       |       70611 |       1031 |              0.012 |              0.015 |                       229 |  112358 |            0.628 |
| Mendoza                       |       40895 |        683 |              0.014 |              0.017 |                       228 |   74673 |            0.548 |
| Tucumán                       |       40571 |        585 |              0.010 |              0.014 |                       218 |   52918 |            0.767 |
| Río Negro                     |       20856 |        532 |              0.022 |              0.026 |                       220 |   36337 |            0.574 |
| Neuquén                       |       18188 |        310 |              0.013 |              0.017 |                       222 |   26074 |            0.698 |
| Jujuy                         |       17465 |        751 |              0.035 |              0.043 |                       217 |   41487 |            0.421 |
| Salta                         |       17199 |        660 |              0.031 |              0.038 |                       215 |   31752 |            0.542 |
| Entre Ríos                    |       12954 |        222 |              0.015 |              0.017 |                       220 |   26092 |            0.496 |
| Chaco                         |       12549 |        384 |              0.023 |              0.031 |                       225 |   58066 |            0.216 |
| Chubut                        |       10926 |        137 |              0.010 |              0.013 |                       206 |   14987 |            0.729 |
| Tierra del Fuego              |        9135 |        111 |              0.010 |              0.012 |                       219 |   15647 |            0.584 |
| Santa Cruz                    |        7948 |        109 |              0.011 |              0.014 |                       212 |   14414 |            0.551 |
| Santiago del Estero           |        7494 |        100 |              0.010 |              0.013 |                       206 |   27666 |            0.271 |
| La Rioja                      |        6857 |        236 |              0.033 |              0.034 |                       212 |   18589 |            0.369 |
| San Luis                      |        4753 |         37 |              0.005 |              0.008 |                       197 |   14301 |            0.332 |
| SIN ESPECIFICAR               |        2549 |         22 |              0.008 |              0.009 |                       213 |    5728 |            0.445 |
| Corrientes                    |        2188 |         31 |              0.009 |              0.014 |                       217 |   13471 |            0.162 |
| La Pampa                      |        2130 |         23 |              0.007 |              0.011 |                       200 |   10941 |            0.195 |
| San Juan                      |        1321 |         55 |              0.022 |              0.042 |                       209 |    2665 |            0.496 |
| Catamarca                     |         551 |          0 |              0.000 |              0.000 |                       190 |    7945 |            0.069 |
| Misiones                      |         207 |          4 |              0.008 |              0.019 |                       197 |    6165 |            0.034 |
| Formosa                       |         137 |          1 |              0.005 |              0.007 |                       190 |    1487 |            0.092 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |   tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|--------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      516040 | 1079790 |      16357 |               16.5 |              0.027 |              0.032 |            0.478 |           0.067 |                  0.010 |           0.005 |
| CABA                          |      141455 |  369704 |       4549 |               17.0 |              0.029 |              0.032 |            0.383 |           0.146 |                  0.017 |           0.009 |
| Santa Fe                      |       88656 |  120515 |       1027 |               13.1 |              0.011 |              0.012 |            0.736 |           0.024 |                  0.006 |           0.004 |
| Córdoba                       |       70611 |  112358 |       1031 |               12.9 |              0.012 |              0.015 |            0.628 |           0.017 |                  0.008 |           0.002 |
| Mendoza                       |       40895 |   74673 |        683 |               12.1 |              0.014 |              0.017 |            0.548 |           0.061 |                  0.006 |           0.003 |
| Tucumán                       |       40571 |   52918 |        585 |               11.0 |              0.010 |              0.014 |            0.767 |           0.009 |                  0.002 |           0.001 |
| Río Negro                     |       20856 |   36337 |        532 |               14.6 |              0.022 |              0.026 |            0.574 |           0.166 |                  0.007 |           0.005 |
| Neuquén                       |       18188 |   26074 |        310 |               18.0 |              0.013 |              0.017 |            0.698 |           0.430 |                  0.009 |           0.007 |
| Jujuy                         |       17465 |   41487 |        751 |               18.3 |              0.035 |              0.043 |            0.421 |           0.016 |                  0.005 |           0.001 |
| Salta                         |       17199 |   31752 |        660 |               13.6 |              0.031 |              0.038 |            0.542 |           0.103 |                  0.019 |           0.010 |
| Entre Ríos                    |       12954 |   26092 |        222 |               13.6 |              0.015 |              0.017 |            0.496 |           0.070 |                  0.007 |           0.003 |
| Chaco                         |       12549 |   58066 |        384 |               14.8 |              0.023 |              0.031 |            0.216 |           0.083 |                  0.044 |           0.021 |
| Chubut                        |       10926 |   14987 |        137 |               10.2 |              0.010 |              0.013 |            0.729 |           0.010 |                  0.003 |           0.003 |
| Tierra del Fuego              |        9135 |   15647 |        111 |               15.8 |              0.010 |              0.012 |            0.584 |           0.019 |                  0.006 |           0.005 |
| Santa Cruz                    |        7948 |   14414 |        109 |               14.8 |              0.011 |              0.014 |            0.551 |           0.057 |                  0.012 |           0.009 |
| Santiago del Estero           |        7494 |   27666 |        100 |               10.9 |              0.010 |              0.013 |            0.271 |           0.017 |                  0.001 |           0.001 |
| La Rioja                      |        6857 |   18589 |        236 |               16.0 |              0.033 |              0.034 |            0.369 |           0.007 |                  0.002 |           0.001 |
| San Luis                      |        4753 |   14301 |         37 |               13.9 |              0.005 |              0.008 |            0.332 |           0.023 |                  0.003 |           0.001 |
| SIN ESPECIFICAR               |        2549 |    5728 |         22 |               18.9 |              0.008 |              0.009 |            0.445 |           0.065 |                  0.008 |           0.004 |
| Corrientes                    |        2188 |   13471 |         31 |                9.8 |              0.009 |              0.014 |            0.162 |           0.017 |                  0.013 |           0.008 |
| La Pampa                      |        2130 |   10941 |         23 |               16.5 |              0.007 |              0.011 |            0.195 |           0.024 |                  0.006 |           0.002 |
| San Juan                      |        1321 |    2665 |         55 |               10.9 |              0.022 |              0.042 |            0.496 |           0.051 |                  0.022 |           0.007 |
| Catamarca                     |         551 |    7945 |          0 |                NaN |              0.000 |              0.000 |            0.069 |           0.016 |                  0.000 |           0.000 |
| Misiones                      |         207 |    6165 |          4 |                5.7 |              0.008 |              0.019 |            0.034 |           0.304 |                  0.039 |           0.014 |
| Formosa                       |         137 |    1487 |          1 |               12.0 |              0.005 |              0.007 |            0.092 |           0.343 |                  0.000 |           0.000 |

    rg <- ReportGeneratorCOVID19AR$new(covid19ar.curator = covid19.curator)
    rg$preprocess()
    #> 
    #> ── Column specification ────────────────────────────────────────────────────────
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
    #> ℹ Use `spec()` for the full column specifications.
    rg$getDepartamentosExponentialGrowthPlot()
    #> Scale for 'y' is already present. Adding another scale for 'y', which will
    #> replace the existing scale.

<img src="man/figures/README-exponential_growth-1.png" width="100%" />

    rg$getDepartamentosCrossSectionConfirmedPostivityPlot()

<img src="man/figures/README-exponential_growth-2.png" width="100%" />

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
    #> INFO  [14:55:54.554] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 34
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-10-17              |                        21 |          16 |      86 |          9 |          1 |              0.045 |              0.062 |            0.186 |           0.562 |                  0.125 |           0.125 |
|             11 | 2020-10-17              |                        46 |         102 |     670 |         68 |          9 |              0.065 |              0.088 |            0.152 |           0.667 |                  0.118 |           0.059 |
|             12 | 2020-10-17              |                        81 |         428 |    2058 |        263 |         17 |              0.033 |              0.040 |            0.208 |           0.614 |                  0.089 |           0.051 |
|             13 | 2020-10-19              |                       134 |        1131 |    5536 |        619 |         65 |              0.050 |              0.057 |            0.204 |           0.547 |                  0.090 |           0.054 |
|             14 | 2020-10-19              |                       186 |        1880 |   11574 |       1014 |        118 |              0.054 |              0.063 |            0.162 |           0.539 |                  0.090 |           0.053 |
|             15 | 2020-10-19              |                       218 |        2635 |   20312 |       1388 |        186 |              0.060 |              0.071 |            0.130 |           0.527 |                  0.085 |           0.048 |
|             16 | 2020-10-22              |                       233 |        3569 |   31946 |       1773 |        254 |              0.059 |              0.071 |            0.112 |           0.497 |                  0.075 |           0.041 |
|             17 | 2020-10-22              |                       239 |        4846 |   46030 |       2340 |        379 |              0.066 |              0.078 |            0.105 |           0.483 |                  0.067 |           0.035 |
|             18 | 2020-10-22              |                       239 |        5984 |   59254 |       2777 |        485 |              0.068 |              0.081 |            0.101 |           0.464 |                  0.061 |           0.032 |
|             19 | 2020-10-22              |                       239 |        7605 |   73417 |       3404 |        598 |              0.067 |              0.079 |            0.104 |           0.448 |                  0.057 |           0.029 |
|             20 | 2020-10-22              |                       239 |       10160 |   90885 |       4294 |        724 |              0.062 |              0.071 |            0.112 |           0.423 |                  0.052 |           0.027 |
|             21 | 2020-10-22              |                       239 |       14822 |  114392 |       5695 |        936 |              0.055 |              0.063 |            0.130 |           0.384 |                  0.047 |           0.023 |
|             22 | 2020-10-22              |                       239 |       20319 |  139890 |       7201 |       1208 |              0.052 |              0.059 |            0.145 |           0.354 |                  0.043 |           0.021 |
|             23 | 2020-10-22              |                       239 |       27110 |  168259 |       8814 |       1536 |              0.050 |              0.057 |            0.161 |           0.325 |                  0.040 |           0.019 |
|             24 | 2020-10-22              |                       239 |       37137 |  203520 |      11051 |       1960 |              0.047 |              0.053 |            0.182 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-10-22              |                       239 |       50350 |  245110 |      13525 |       2517 |              0.045 |              0.050 |            0.205 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-10-22              |                       239 |       68716 |  297585 |      16748 |       3272 |              0.042 |              0.048 |            0.231 |           0.244 |                  0.028 |           0.013 |
|             27 | 2020-10-22              |                       239 |       88008 |  349070 |      19673 |       4110 |              0.041 |              0.047 |            0.252 |           0.224 |                  0.026 |           0.012 |
|             28 | 2020-10-22              |                       240 |      112021 |  408536 |      23139 |       5203 |              0.041 |              0.046 |            0.274 |           0.207 |                  0.024 |           0.011 |
|             29 | 2020-10-22              |                       242 |      141749 |  481017 |      26943 |       6515 |              0.041 |              0.046 |            0.295 |           0.190 |                  0.023 |           0.010 |
|             30 | 2020-10-22              |                       242 |      180296 |  567568 |      30783 |       7986 |              0.039 |              0.044 |            0.318 |           0.171 |                  0.021 |           0.010 |
|             31 | 2020-10-22              |                       242 |      220486 |  658366 |      34204 |       9355 |              0.038 |              0.042 |            0.335 |           0.155 |                  0.019 |           0.009 |
|             32 | 2020-10-22              |                       242 |      270567 |  767527 |      38161 |      11032 |              0.036 |              0.041 |            0.353 |           0.141 |                  0.018 |           0.008 |
|             33 | 2020-10-22              |                       242 |      318178 |  882527 |      41992 |      12592 |              0.035 |              0.040 |            0.361 |           0.132 |                  0.017 |           0.008 |
|             34 | 2020-10-22              |                       242 |      367708 |  993925 |      45836 |      14338 |              0.034 |              0.039 |            0.370 |           0.125 |                  0.016 |           0.008 |
|             35 | 2020-10-22              |                       242 |      433485 | 1130288 |      50488 |      16398 |              0.033 |              0.038 |            0.384 |           0.116 |                  0.015 |           0.007 |
|             36 | 2020-10-22              |                       242 |      503715 | 1272463 |      54866 |      18485 |              0.032 |              0.037 |            0.396 |           0.109 |                  0.015 |           0.007 |
|             37 | 2020-10-22              |                       242 |      579215 | 1425286 |      59517 |      20599 |              0.031 |              0.036 |            0.406 |           0.103 |                  0.014 |           0.007 |
|             38 | 2020-10-22              |                       242 |      652698 | 1569520 |      63676 |      22522 |              0.030 |              0.035 |            0.416 |           0.098 |                  0.013 |           0.007 |
|             39 | 2020-10-22              |                       243 |      730777 | 1709037 |      67825 |      24374 |              0.029 |              0.033 |            0.428 |           0.093 |                  0.013 |           0.006 |
|             40 | 2020-10-22              |                       245 |      815413 | 1847706 |      71673 |      25968 |              0.028 |              0.032 |            0.441 |           0.088 |                  0.012 |           0.006 |
|             41 | 2020-10-22              |                       246 |      905219 | 1984987 |      74988 |      27215 |              0.026 |              0.030 |            0.456 |           0.083 |                  0.012 |           0.006 |
|             42 | 2020-10-22              |                       246 |      997307 | 2112873 |      77272 |      27837 |              0.024 |              0.028 |            0.472 |           0.077 |                  0.011 |           0.005 |
|             43 | 2020-10-22              |                       246 |     1053635 | 2183772 |      78114 |      27957 |              0.022 |              0.027 |            0.482 |           0.074 |                  0.010 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [14:59:42.345] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [15:01:39.717] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [15:02:29.491] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [15:02:32.895] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [15:02:42.140] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [15:02:46.623] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [15:03:01.190] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [15:03:05.911] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [15:03:11.201] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [15:03:13.908] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [15:03:20.385] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [15:03:23.901] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [15:03:28.288] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [15:03:36.358] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [15:03:39.969] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [15:03:44.943] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [15:03:50.895] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [15:03:55.946] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [15:03:59.155] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [15:04:02.839] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [15:04:06.821] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [15:04:18.757] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [15:04:23.603] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [15:04:27.319] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [15:04:31.738] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 792
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
    #> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_, : no
    #> non-missing arguments to max; returning -Inf
    nrow(covid19.ar.summary)
    #> [1] 70
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      261628 |      18885 |       9044 |              0.030 |              0.035 |            0.492 |           0.072 |                  0.012 |           0.006 |
| Buenos Aires                  | F    |      252591 |      15472 |       7199 |              0.024 |              0.029 |            0.464 |           0.061 |                  0.008 |           0.003 |
| CABA                          | F    |       71477 |       9947 |       2129 |              0.027 |              0.030 |            0.361 |           0.139 |                  0.013 |           0.006 |
| CABA                          | M    |       69420 |      10605 |       2376 |              0.031 |              0.034 |            0.408 |           0.153 |                  0.022 |           0.012 |
| Santa Fe                      | F    |       45019 |        936 |        464 |              0.009 |              0.010 |            0.723 |           0.021 |                  0.005 |           0.003 |
| Santa Fe                      | M    |       43597 |       1178 |        561 |              0.012 |              0.013 |            0.749 |           0.027 |                  0.008 |           0.005 |
| Córdoba                       | F    |       35740 |        553 |        443 |              0.010 |              0.012 |            0.628 |           0.015 |                  0.007 |           0.002 |
| Córdoba                       | M    |       34830 |        637 |        585 |              0.014 |              0.017 |            0.629 |           0.018 |                  0.009 |           0.002 |
| Tucumán                       | M    |       20946 |        212 |        384 |              0.013 |              0.018 |            0.722 |           0.010 |                  0.002 |           0.001 |
| Mendoza                       | M    |       20366 |       1340 |        395 |              0.016 |              0.019 |            0.561 |           0.066 |                  0.009 |           0.004 |
| Mendoza                       | F    |       20353 |       1163 |        284 |              0.011 |              0.014 |            0.536 |           0.057 |                  0.004 |           0.002 |
| Tucumán                       | F    |       19607 |        150 |        201 |              0.007 |              0.010 |            0.821 |           0.008 |                  0.002 |           0.001 |
| Río Negro                     | F    |       10710 |       1755 |        217 |              0.018 |              0.020 |            0.557 |           0.164 |                  0.005 |           0.003 |
| Río Negro                     | M    |       10136 |       1706 |        315 |              0.028 |              0.031 |            0.593 |           0.168 |                  0.010 |           0.007 |
| Jujuy                         | M    |        9720 |        178 |        485 |              0.040 |              0.050 |            0.428 |           0.018 |                  0.006 |           0.002 |
| Salta                         | M    |        9624 |       1050 |        433 |              0.037 |              0.045 |            0.547 |           0.109 |                  0.022 |           0.013 |
| Neuquén                       | F    |        9152 |       3980 |        114 |              0.010 |              0.012 |            0.686 |           0.435 |                  0.005 |           0.003 |
| Neuquén                       | M    |        9030 |       3846 |        195 |              0.017 |              0.022 |            0.710 |           0.426 |                  0.012 |           0.010 |
| Jujuy                         | F    |        7722 |         97 |        264 |              0.028 |              0.034 |            0.412 |           0.013 |                  0.003 |           0.001 |
| Salta                         | F    |        7523 |        709 |        224 |              0.024 |              0.030 |            0.535 |           0.094 |                  0.014 |           0.007 |
| Entre Ríos                    | M    |        6482 |        470 |        132 |              0.017 |              0.020 |            0.522 |           0.073 |                  0.009 |           0.003 |
| Entre Ríos                    | F    |        6464 |        436 |         89 |              0.012 |              0.014 |            0.474 |           0.067 |                  0.006 |           0.002 |
| Chaco                         | M    |        6296 |        548 |        240 |              0.029 |              0.038 |            0.222 |           0.087 |                  0.050 |           0.025 |
| Chaco                         | F    |        6245 |        491 |        144 |              0.017 |              0.023 |            0.210 |           0.079 |                  0.037 |           0.016 |
| Chubut                        | M    |        6063 |         53 |         80 |              0.010 |              0.013 |            0.751 |           0.009 |                  0.004 |           0.003 |
| Chubut                        | F    |        4834 |         51 |         56 |              0.009 |              0.012 |            0.706 |           0.011 |                  0.003 |           0.002 |
| Tierra del Fuego              | M    |        4785 |        115 |         76 |              0.014 |              0.016 |            0.601 |           0.024 |                  0.010 |           0.008 |
| Tierra del Fuego              | F    |        4335 |         56 |         35 |              0.007 |              0.008 |            0.565 |           0.013 |                  0.003 |           0.003 |
| Santa Cruz                    | M    |        4149 |        260 |         71 |              0.014 |              0.017 |            0.585 |           0.063 |                  0.016 |           0.011 |
| Santiago del Estero           | M    |        4023 |         84 |         60 |              0.011 |              0.015 |            0.255 |           0.021 |                  0.002 |           0.001 |
| Santa Cruz                    | F    |        3792 |        195 |         38 |              0.008 |              0.010 |            0.518 |           0.051 |                  0.009 |           0.006 |
| La Rioja                      | M    |        3605 |         28 |        150 |              0.040 |              0.042 |            0.378 |           0.008 |                  0.002 |           0.001 |
| Santiago del Estero           | F    |        3466 |         47 |         40 |              0.009 |              0.012 |            0.305 |           0.014 |                  0.001 |           0.001 |
| La Rioja                      | F    |        3225 |         21 |         83 |              0.025 |              0.026 |            0.360 |           0.007 |                  0.002 |           0.001 |
| San Luis                      | M    |        2419 |         61 |         23 |              0.006 |              0.010 |            0.348 |           0.025 |                  0.003 |           0.000 |
| San Luis                      | F    |        2331 |         50 |         14 |              0.004 |              0.006 |            0.318 |           0.021 |                  0.003 |           0.003 |
| Buenos Aires                  | NR   |        1821 |        147 |        114 |              0.046 |              0.063 |            0.482 |           0.081 |                  0.016 |           0.007 |
| SIN ESPECIFICAR               | F    |        1505 |         89 |         10 |              0.006 |              0.007 |            0.437 |           0.059 |                  0.006 |           0.002 |
| Corrientes                    | M    |        1118 |         28 |         23 |              0.013 |              0.021 |            0.157 |           0.025 |                  0.019 |           0.013 |
| La Pampa                      | F    |        1106 |         26 |          8 |              0.005 |              0.007 |            0.186 |           0.024 |                  0.005 |           0.001 |
| Corrientes                    | F    |        1070 |         10 |          8 |              0.005 |              0.007 |            0.168 |           0.009 |                  0.007 |           0.003 |
| SIN ESPECIFICAR               | M    |        1037 |         75 |         11 |              0.009 |              0.011 |            0.460 |           0.072 |                  0.010 |           0.006 |
| La Pampa                      | M    |        1013 |         25 |         15 |              0.010 |              0.015 |            0.204 |           0.025 |                  0.007 |           0.003 |
| San Juan                      | M    |         791 |         32 |         28 |              0.021 |              0.035 |            0.512 |           0.040 |                  0.019 |           0.008 |
| CABA                          | NR   |         558 |        135 |         44 |              0.062 |              0.079 |            0.390 |           0.242 |                  0.036 |           0.022 |
| San Juan                      | F    |         530 |         35 |         27 |              0.024 |              0.051 |            0.474 |           0.066 |                  0.026 |           0.006 |
| Catamarca                     | M    |         348 |          5 |          0 |              0.000 |              0.000 |            0.070 |           0.014 |                  0.000 |           0.000 |
| Catamarca                     | F    |         203 |          4 |          0 |              0.000 |              0.000 |            0.069 |           0.020 |                  0.000 |           0.000 |
| Mendoza                       | NR   |         176 |          7 |          4 |              0.017 |              0.023 |            0.458 |           0.040 |                  0.006 |           0.006 |
| Misiones                      | M    |         118 |         35 |          2 |              0.008 |              0.017 |            0.033 |           0.297 |                  0.034 |           0.017 |
| Formosa                       | M    |         102 |         25 |          0 |              0.000 |              0.000 |            0.114 |           0.245 |                  0.000 |           0.000 |
| Misiones                      | F    |          89 |         28 |          2 |              0.009 |              0.022 |            0.034 |           0.315 |                  0.045 |           0.011 |
| Salta                         | NR   |          52 |          5 |          3 |              0.045 |              0.058 |            0.486 |           0.096 |                  0.038 |           0.019 |
| Córdoba                       | NR   |          41 |          1 |          3 |              0.048 |              0.073 |            0.612 |           0.024 |                  0.000 |           0.000 |
| Santa Fe                      | NR   |          40 |          5 |          2 |              0.040 |              0.050 |            0.455 |           0.125 |                  0.000 |           0.000 |
| Formosa                       | F    |          35 |         22 |          1 |              0.015 |              0.029 |            0.059 |           0.629 |                  0.000 |           0.000 |
| Chubut                        | NR   |          29 |          1 |          1 |              0.023 |              0.034 |            0.468 |           0.034 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          27 |          0 |          3 |              0.107 |              0.111 |            0.329 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          23 |          1 |          2 |              0.047 |              0.087 |            0.319 |           0.043 |                  0.000 |           0.000 |
| Tucumán                       | NR   |          18 |          0 |          0 |              0.000 |              0.000 |            0.514 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          15 |          0 |          0 |              0.000 |              0.000 |            2.500 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      | NR   |          11 |          1 |          0 |              0.000 |              0.000 |            0.256 |           0.091 |                  0.000 |           0.000 |
| Río Negro                     | NR   |          10 |          2 |          0 |              0.000 |              0.000 |            0.435 |           0.200 |                  0.000 |           0.000 |


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))
    #> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_, : no
    #> non-missing arguments to max; returning -Inf
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
    #> Warning: Removed 17 rows containing missing values (position_stack).

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

# Generar diferentes agregaciones y guardar csv / Generate different aggregations

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

# How to Cite This Work

Citation

    Alejandro Baranek, COVID19AR, 2020. URL: https://github.com/rOpenStats/COVID19AR

    BibTex
    @techreport{baranek2020Covid19AR,
    Author = {Alejandro Baranek},
    Institution = {rOpenStats},
    Title = {COVID19AR: a package for analysing Argentina COVID-19 outbreak},
    Url = {https://github.com/rOpenStats/COVID19AR},
    Year = {2020}}
