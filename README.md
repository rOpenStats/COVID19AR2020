
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
    #> INFO  [08:58:25.667] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:58:34.118] Normalize 
    #> INFO  [08:58:37.411] checkSoundness 
    #> INFO  [08:58:38.908] Mutating data 
    #> INFO  [09:02:09.626] Last days rows {date: 2020-09-01, n: 30901}
    #> INFO  [09:02:09.629] Last days rows {date: 2020-09-02, n: 20641}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-09-02"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-09-02"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-09-02"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-09-02              |      439167 |       9118 |              0.016 |              0.021 |                       192 | 1145434 |            0.383 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      270175 |       5466 |              0.016 |              0.020 |                       189 | 612428 |            0.441 |
| CABA                          |       97604 |       2326 |              0.021 |              0.024 |                       187 | 245919 |            0.397 |
| Córdoba                       |        9388 |        134 |              0.011 |              0.014 |                       177 |  51474 |            0.182 |
| Santa Fe                      |        9329 |        101 |              0.008 |              0.011 |                       173 |  40390 |            0.231 |
| Jujuy                         |        8858 |        240 |              0.017 |              0.027 |                       167 |  22353 |            0.396 |
| Mendoza                       |        7601 |        136 |              0.012 |              0.018 |                       176 |  20743 |            0.366 |
| Río Negro                     |        6348 |        187 |              0.026 |              0.029 |                       170 |  15848 |            0.401 |
| Chaco                         |        5576 |        218 |              0.030 |              0.039 |                       175 |  34008 |            0.164 |
| Entre Ríos                    |        3838 |         53 |              0.011 |              0.014 |                       170 |  10878 |            0.353 |
| Salta                         |        3681 |         46 |              0.008 |              0.012 |                       165 |   8002 |            0.460 |
| Neuquén                       |        3262 |         53 |              0.012 |              0.016 |                       172 |   8683 |            0.376 |
| Tucumán                       |        2799 |         14 |              0.002 |              0.005 |                       168 |  18314 |            0.153 |
| Tierra del Fuego              |        2135 |         33 |              0.013 |              0.015 |                       169 |   6116 |            0.349 |
| Santa Cruz                    |        1909 |         16 |              0.007 |              0.008 |                       162 |   4977 |            0.384 |
| SIN ESPECIFICAR               |        1778 |          9 |              0.004 |              0.005 |                       163 |   4014 |            0.443 |
| La Rioja                      |        1695 |         61 |              0.033 |              0.036 |                       162 |   7030 |            0.241 |
| Santiago del Estero           |        1031 |         11 |              0.005 |              0.011 |                       156 |   8852 |            0.116 |
| Chubut                        |         982 |          6 |              0.003 |              0.006 |                       156 |   5459 |            0.180 |
| Corrientes                    |         321 |          2 |              0.003 |              0.006 |                       167 |   7536 |            0.043 |
| San Juan                      |         254 |          1 |              0.003 |              0.004 |                       161 |   1405 |            0.181 |
| La Pampa                      |         213 |          2 |              0.007 |              0.009 |                       150 |   2534 |            0.084 |
| San Luis                      |         177 |          0 |              0.000 |              0.000 |                       149 |   1227 |            0.144 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      270175 | 612428 |       5466 |               14.9 |              0.016 |              0.020 |            0.441 |           0.082 |                  0.011 |           0.005 |
| CABA                          |       97604 | 245919 |       2326 |               15.9 |              0.021 |              0.024 |            0.397 |           0.168 |                  0.018 |           0.008 |
| Córdoba                       |        9388 |  51474 |        134 |               16.3 |              0.011 |              0.014 |            0.182 |           0.026 |                  0.007 |           0.004 |
| Santa Fe                      |        9329 |  40390 |        101 |               12.5 |              0.008 |              0.011 |            0.231 |           0.044 |                  0.011 |           0.006 |
| Jujuy                         |        8858 |  22353 |        240 |               13.4 |              0.017 |              0.027 |            0.396 |           0.007 |                  0.001 |           0.001 |
| Mendoza                       |        7601 |  20743 |        136 |               10.9 |              0.012 |              0.018 |            0.366 |           0.171 |                  0.010 |           0.004 |
| Río Negro                     |        6348 |  15848 |        187 |               12.3 |              0.026 |              0.029 |            0.401 |           0.273 |                  0.013 |           0.008 |
| Chaco                         |        5576 |  34008 |        218 |               14.8 |              0.030 |              0.039 |            0.164 |           0.110 |                  0.060 |           0.027 |
| Entre Ríos                    |        3838 |  10878 |         53 |               11.3 |              0.011 |              0.014 |            0.353 |           0.107 |                  0.010 |           0.003 |
| Salta                         |        3681 |   8002 |         46 |                7.9 |              0.008 |              0.012 |            0.460 |           0.140 |                  0.014 |           0.005 |
| Neuquén                       |        3262 |   8683 |         53 |               16.3 |              0.012 |              0.016 |            0.376 |           0.570 |                  0.013 |           0.009 |
| Tucumán                       |        2799 |  18314 |         14 |               13.0 |              0.002 |              0.005 |            0.153 |           0.069 |                  0.008 |           0.002 |
| Tierra del Fuego              |        2135 |   6116 |         33 |               13.5 |              0.013 |              0.015 |            0.349 |           0.024 |                  0.008 |           0.007 |
| Santa Cruz                    |        1909 |   4977 |         16 |               13.1 |              0.007 |              0.008 |            0.384 |           0.045 |                  0.013 |           0.009 |
| SIN ESPECIFICAR               |        1778 |   4014 |          9 |               20.7 |              0.004 |              0.005 |            0.443 |           0.064 |                  0.007 |           0.003 |
| La Rioja                      |        1695 |   7030 |         61 |               10.3 |              0.033 |              0.036 |            0.241 |           0.019 |                  0.005 |           0.001 |
| Santiago del Estero           |        1031 |   8852 |         11 |                7.8 |              0.005 |              0.011 |            0.116 |           0.007 |                  0.003 |           0.001 |
| Chubut                        |         982 |   5459 |          6 |               16.0 |              0.003 |              0.006 |            0.180 |           0.024 |                  0.007 |           0.006 |
| Corrientes                    |         321 |   7536 |          2 |               12.0 |              0.003 |              0.006 |            0.043 |           0.025 |                  0.009 |           0.003 |
| San Juan                      |         254 |   1405 |          1 |               35.0 |              0.003 |              0.004 |            0.181 |           0.039 |                  0.012 |           0.004 |
| La Pampa                      |         213 |   2534 |          2 |               38.5 |              0.007 |              0.009 |            0.084 |           0.085 |                  0.014 |           0.005 |
| San Luis                      |         177 |   1227 |          0 |                NaN |              0.000 |              0.000 |            0.144 |           0.158 |                  0.006 |           0.000 |
| Formosa                       |          83 |   1131 |          1 |               12.0 |              0.008 |              0.012 |            0.073 |           0.012 |                  0.000 |           0.000 |
| Catamarca                     |          66 |   3113 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          64 |   3000 |          2 |                6.5 |              0.013 |              0.031 |            0.021 |           0.469 |                  0.094 |           0.047 |

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
    #> INFO  [09:03:11.262] Processing {current.group: }
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
|             12 | 2020-09-01              |                        69 |         418 |    2054 |        257 |         17 |              0.034 |              0.041 |            0.204 |           0.615 |                  0.091 |           0.053 |
|             13 | 2020-09-01              |                       107 |        1095 |    5527 |        603 |         64 |              0.051 |              0.058 |            0.198 |           0.551 |                  0.093 |           0.056 |
|             14 | 2020-09-01              |                       145 |        1806 |   11553 |        987 |        115 |              0.054 |              0.064 |            0.156 |           0.547 |                  0.093 |           0.055 |
|             15 | 2020-09-02              |                       172 |        2498 |   20278 |       1345 |        180 |              0.060 |              0.072 |            0.123 |           0.538 |                  0.088 |           0.050 |
|             16 | 2020-09-02              |                       186 |        3338 |   31896 |       1705 |        241 |              0.059 |              0.072 |            0.105 |           0.511 |                  0.078 |           0.043 |
|             17 | 2020-09-02              |                       189 |        4528 |   45962 |       2247 |        351 |              0.064 |              0.078 |            0.099 |           0.496 |                  0.070 |           0.037 |
|             18 | 2020-09-02              |                       189 |        5591 |   59162 |       2663 |        436 |              0.065 |              0.078 |            0.095 |           0.476 |                  0.063 |           0.034 |
|             19 | 2020-09-02              |                       189 |        7118 |   73304 |       3269 |        523 |              0.062 |              0.073 |            0.097 |           0.459 |                  0.059 |           0.031 |
|             20 | 2020-09-02              |                       189 |        9576 |   90746 |       4132 |        635 |              0.056 |              0.066 |            0.106 |           0.431 |                  0.054 |           0.028 |
|             21 | 2020-09-02              |                       189 |       14058 |  114202 |       5489 |        808 |              0.049 |              0.057 |            0.123 |           0.390 |                  0.048 |           0.024 |
|             22 | 2020-09-02              |                       189 |       19410 |  139621 |       6960 |       1027 |              0.046 |              0.053 |            0.139 |           0.359 |                  0.043 |           0.022 |
|             23 | 2020-09-02              |                       189 |       26022 |  167937 |       8535 |       1292 |              0.043 |              0.050 |            0.155 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-09-02              |                       189 |       35844 |  203106 |      10717 |       1617 |              0.039 |              0.045 |            0.176 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-09-02              |                       189 |       48854 |  244579 |      13120 |       2023 |              0.036 |              0.041 |            0.200 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-09-02              |                       189 |       66850 |  296711 |      16233 |       2569 |              0.034 |              0.038 |            0.225 |           0.243 |                  0.028 |           0.013 |
|             27 | 2020-09-02              |                       189 |       85823 |  347804 |      19081 |       3187 |              0.032 |              0.037 |            0.247 |           0.222 |                  0.026 |           0.011 |
|             28 | 2020-09-02              |                       190 |      109392 |  406837 |      22437 |       3964 |              0.032 |              0.036 |            0.269 |           0.205 |                  0.024 |           0.011 |
|             29 | 2020-09-02              |                       192 |      138413 |  478201 |      26078 |       4845 |              0.030 |              0.035 |            0.289 |           0.188 |                  0.022 |           0.010 |
|             30 | 2020-09-02              |                       192 |      176228 |  563879 |      29762 |       5797 |              0.029 |              0.033 |            0.313 |           0.169 |                  0.020 |           0.009 |
|             31 | 2020-09-02              |                       192 |      215181 |  652401 |      32987 |       6631 |              0.027 |              0.031 |            0.330 |           0.153 |                  0.018 |           0.009 |
|             32 | 2020-09-02              |                       192 |      263799 |  759240 |      36616 |       7570 |              0.025 |              0.029 |            0.347 |           0.139 |                  0.017 |           0.008 |
|             33 | 2020-09-02              |                       192 |      309137 |  870011 |      39946 |       8217 |              0.022 |              0.027 |            0.355 |           0.129 |                  0.016 |           0.007 |
|             34 | 2020-09-02              |                       192 |      356619 |  977722 |      42904 |       8750 |              0.021 |              0.025 |            0.365 |           0.120 |                  0.015 |           0.007 |
|             35 | 2020-09-02              |                       192 |      417658 | 1104312 |      45716 |       9078 |              0.018 |              0.022 |            0.378 |           0.109 |                  0.013 |           0.006 |
|             36 | 2020-09-02              |                       192 |      439167 | 1145434 |      46393 |       9118 |              0.016 |              0.021 |            0.383 |           0.106 |                  0.013 |           0.006 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:04:43.675] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:05:31.888] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:05:53.392] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:05:55.427] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:06:00.851] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:06:03.519] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:06:11.050] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:06:14.879] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:06:18.170] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:06:20.367] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:06:24.540] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:06:27.165] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:06:30.407] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:06:33.787] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:06:36.208] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:06:39.042] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:06:42.468] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:06:45.157] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:06:47.517] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:06:49.984] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:06:52.512] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:06:57.692] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:07:00.612] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:07:03.328] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:07:06.437] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
    #> [1] 67
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      138140 |      12113 |       3129 |              0.018 |              0.023 |            0.458 |           0.088 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      131057 |      10036 |       2302 |              0.014 |              0.018 |            0.424 |           0.077 |                  0.009 |           0.003 |
| CABA                          | F    |       49262 |       7966 |       1072 |              0.019 |              0.022 |            0.376 |           0.162 |                  0.013 |           0.006 |
| CABA                          | M    |       47959 |       8331 |       1229 |              0.022 |              0.026 |            0.421 |           0.174 |                  0.022 |           0.011 |
| Jujuy                         | M    |        5255 |         40 |        148 |              0.018 |              0.028 |            0.422 |           0.008 |                  0.001 |           0.001 |
| Córdoba                       | F    |        4719 |        120 |         57 |              0.010 |              0.012 |            0.179 |           0.025 |                  0.007 |           0.003 |
| Santa Fe                      | F    |        4692 |        180 |         39 |              0.006 |              0.008 |            0.220 |           0.038 |                  0.009 |           0.004 |
| Córdoba                       | M    |        4642 |        123 |         76 |              0.013 |              0.016 |            0.185 |           0.026 |                  0.007 |           0.004 |
| Santa Fe                      | M    |        4634 |        231 |         62 |              0.010 |              0.013 |            0.243 |           0.050 |                  0.013 |           0.007 |
| Mendoza                       | F    |        3790 |        648 |         46 |              0.008 |              0.012 |            0.359 |           0.171 |                  0.004 |           0.001 |
| Mendoza                       | M    |        3789 |        643 |         88 |              0.015 |              0.023 |            0.376 |           0.170 |                  0.016 |           0.006 |
| Jujuy                         | F    |        3588 |         18 |         91 |              0.015 |              0.025 |            0.364 |           0.005 |                  0.001 |           0.001 |
| Río Negro                     | F    |        3298 |        875 |         74 |              0.020 |              0.022 |            0.389 |           0.265 |                  0.007 |           0.003 |
| Río Negro                     | M    |        3047 |        859 |        113 |              0.033 |              0.037 |            0.414 |           0.282 |                  0.019 |           0.014 |
| Chaco                         | M    |        2819 |        319 |        139 |              0.038 |              0.049 |            0.167 |           0.113 |                  0.068 |           0.032 |
| Chaco                         | F    |        2755 |        297 |         79 |              0.021 |              0.029 |            0.161 |           0.108 |                  0.052 |           0.021 |
| Salta                         | M    |        2160 |        301 |         36 |              0.011 |              0.017 |            0.464 |           0.139 |                  0.017 |           0.007 |
| Entre Ríos                    | F    |        1957 |        202 |         19 |              0.008 |              0.010 |            0.343 |           0.103 |                  0.007 |           0.002 |
| Entre Ríos                    | M    |        1878 |        208 |         33 |              0.014 |              0.018 |            0.363 |           0.111 |                  0.013 |           0.004 |
| Neuquén                       | M    |        1649 |        938 |         28 |              0.013 |              0.017 |            0.386 |           0.569 |                  0.015 |           0.010 |
| Neuquén                       | F    |        1612 |        921 |         25 |              0.012 |              0.016 |            0.366 |           0.571 |                  0.012 |           0.007 |
| Salta                         | F    |        1514 |        215 |         10 |              0.004 |              0.007 |            0.454 |           0.142 |                  0.010 |           0.002 |
| Tucumán                       | M    |        1452 |        106 |         10 |              0.002 |              0.007 |            0.130 |           0.073 |                  0.008 |           0.002 |
| Tucumán                       | F    |        1347 |         86 |          4 |              0.001 |              0.003 |            0.188 |           0.064 |                  0.008 |           0.001 |
| Tierra del Fuego              | M    |        1183 |         33 |         23 |              0.016 |              0.019 |            0.372 |           0.028 |                  0.013 |           0.011 |
| SIN ESPECIFICAR               | F    |        1043 |         59 |          3 |              0.002 |              0.003 |            0.433 |           0.057 |                  0.005 |           0.000 |
| Buenos Aires                  | NR   |         978 |         92 |         35 |              0.024 |              0.036 |            0.466 |           0.094 |                  0.022 |           0.010 |
| Santa Cruz                    | M    |         971 |         44 |         11 |              0.010 |              0.011 |            0.394 |           0.045 |                  0.015 |           0.010 |
| Tierra del Fuego              | F    |         938 |         19 |         10 |              0.009 |              0.011 |            0.320 |           0.020 |                  0.003 |           0.003 |
| Santa Cruz                    | F    |         937 |         42 |          5 |              0.004 |              0.005 |            0.373 |           0.045 |                  0.011 |           0.007 |
| La Rioja                      | M    |         888 |         17 |         36 |              0.037 |              0.041 |            0.246 |           0.019 |                  0.003 |           0.000 |
| La Rioja                      | F    |         800 |         15 |         25 |              0.029 |              0.031 |            0.237 |           0.019 |                  0.006 |           0.002 |
| SIN ESPECIFICAR               | M    |         730 |         53 |          5 |              0.006 |              0.007 |            0.461 |           0.073 |                  0.008 |           0.007 |
| Santiago del Estero           | M    |         561 |          5 |          5 |              0.004 |              0.009 |            0.097 |           0.009 |                  0.004 |           0.000 |
| Chubut                        | M    |         534 |         17 |          4 |              0.004 |              0.007 |            0.193 |           0.032 |                  0.009 |           0.009 |
| Santiago del Estero           | F    |         466 |          2 |          6 |              0.006 |              0.013 |            0.166 |           0.004 |                  0.002 |           0.002 |
| Chubut                        | F    |         442 |          6 |          2 |              0.002 |              0.005 |            0.167 |           0.014 |                  0.005 |           0.002 |
| CABA                          | NR   |         383 |        105 |         25 |              0.049 |              0.065 |            0.408 |           0.274 |                  0.039 |           0.023 |
| Corrientes                    | M    |         183 |          7 |          2 |              0.006 |              0.011 |            0.043 |           0.038 |                  0.011 |           0.005 |
| Corrientes                    | F    |         138 |          1 |          0 |              0.000 |              0.000 |            0.042 |           0.007 |                  0.007 |           0.000 |
| San Juan                      | M    |         136 |          5 |          1 |              0.005 |              0.007 |            0.174 |           0.037 |                  0.007 |           0.000 |
| La Pampa                      | F    |         120 |         12 |          1 |              0.006 |              0.008 |            0.085 |           0.100 |                  0.017 |           0.008 |
| San Juan                      | F    |         118 |          5 |          0 |              0.000 |              0.000 |            0.190 |           0.042 |                  0.017 |           0.008 |
| San Luis                      | M    |          94 |         14 |          0 |              0.000 |              0.000 |            0.140 |           0.149 |                  0.011 |           0.000 |
| La Pampa                      | M    |          93 |          6 |          1 |              0.008 |              0.011 |            0.084 |           0.065 |                  0.011 |           0.000 |
| San Luis                      | F    |          83 |         14 |          0 |              0.000 |              0.000 |            0.149 |           0.169 |                  0.000 |           0.000 |
| Formosa                       | M    |          67 |          0 |          0 |              0.000 |              0.000 |            0.099 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          43 |          0 |          0 |              0.000 |              0.000 |            0.021 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          42 |         16 |          1 |              0.011 |              0.024 |            0.026 |           0.381 |                  0.095 |           0.048 |
| Córdoba                       | NR   |          27 |          1 |          1 |              0.027 |              0.037 |            0.482 |           0.037 |                  0.000 |           0.000 |
| Catamarca                     | F    |          23 |          0 |          0 |              0.000 |              0.000 |            0.021 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          22 |          5 |          2 |              0.043 |              0.091 |            0.182 |           0.227 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         14 |          1 |              0.015 |              0.045 |            0.016 |           0.636 |                  0.091 |           0.045 |
| Formosa                       | F    |          16 |          1 |          1 |              0.032 |              0.062 |            0.035 |           0.062 |                  0.000 |           0.000 |
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
