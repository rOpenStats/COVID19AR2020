
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
    #> INFO  [09:04:41.283] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [09:04:53.414] Normalize 
    #> INFO  [09:04:56.916] checkSoundness 
    #> INFO  [09:04:58.147] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-10-17"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-10-17"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-10-17"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-10-17              |      979115 |      26107 |              0.023 |              0.027 |                       240 | 2077803 |            0.471 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| Buenos Aires                  |      494465 |      15707 |              0.027 |              0.032 |                       234 | 1039452 |            0.476 |
| CABA                          |      138421 |       4302 |              0.028 |              0.031 |                       232 |  357736 |            0.387 |
| Santa Fe                      |       76808 |        847 |              0.010 |              0.011 |                       218 |  112357 |            0.684 |
| Córdoba                       |       61050 |        825 |              0.011 |              0.014 |                       224 |  106451 |            0.574 |
| Mendoza                       |       36580 |        590 |              0.013 |              0.016 |                       222 |   69095 |            0.529 |
| Tucumán                       |       33955 |        454 |              0.009 |              0.013 |                       213 |   47956 |            0.708 |
| Río Negro                     |       18937 |        494 |              0.023 |              0.026 |                       215 |   34305 |            0.552 |
| Jujuy                         |       17183 |        708 |              0.033 |              0.041 |                       212 |   40123 |            0.428 |
| Salta                         |       16210 |        589 |              0.030 |              0.036 |                       210 |   30003 |            0.540 |
| Neuquén                       |       14793 |        246 |              0.011 |              0.017 |                       217 |   22169 |            0.667 |
| Chaco                         |       11429 |        358 |              0.023 |              0.031 |                       220 |   55639 |            0.205 |
| Entre Ríos                    |       11155 |        204 |              0.016 |              0.018 |                       215 |   24434 |            0.457 |
| Chubut                        |        8890 |        114 |              0.010 |              0.013 |                       201 |   13483 |            0.659 |
| Tierra del Fuego              |        7935 |         99 |              0.010 |              0.012 |                       214 |   14336 |            0.554 |
| Santa Cruz                    |        7176 |         96 |              0.011 |              0.013 |                       207 |   13417 |            0.535 |
| Santiago del Estero           |        6551 |         93 |              0.011 |              0.014 |                       201 |   23665 |            0.277 |
| La Rioja                      |        6374 |        224 |              0.034 |              0.035 |                       207 |   17681 |            0.360 |
| San Luis                      |        3152 |         35 |              0.006 |              0.011 |                       193 |   10308 |            0.306 |
| SIN ESPECIFICAR               |        2505 |         22 |              0.008 |              0.009 |                       208 |    5587 |            0.448 |
| Corrientes                    |        1937 |         28 |              0.009 |              0.014 |                       212 |   12969 |            0.149 |
| La Pampa                      |        1531 |         15 |              0.007 |              0.010 |                       195 |    9494 |            0.161 |
| San Juan                      |        1290 |         52 |              0.024 |              0.040 |                       204 |    2614 |            0.493 |
| Catamarca                     |         452 |          0 |              0.000 |              0.000 |                       185 |    7225 |            0.063 |
| Misiones                      |         199 |          4 |              0.010 |              0.020 |                       192 |    5857 |            0.034 |
| Formosa                       |         137 |          1 |              0.005 |              0.007 |                       186 |    1447 |            0.095 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |   tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|--------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      494465 | 1039452 |      15707 |               16.5 |              0.027 |              0.032 |            0.476 |           0.068 |                  0.010 |           0.005 |
| CABA                          |      138421 |  357736 |       4302 |               16.9 |              0.028 |              0.031 |            0.387 |           0.147 |                  0.017 |           0.009 |
| Santa Fe                      |       76808 |  112357 |        847 |               13.1 |              0.010 |              0.011 |            0.684 |           0.023 |                  0.006 |           0.004 |
| Córdoba                       |       61050 |  106451 |        825 |               12.6 |              0.011 |              0.014 |            0.574 |           0.015 |                  0.008 |           0.002 |
| Mendoza                       |       36580 |   69095 |        590 |               11.5 |              0.013 |              0.016 |            0.529 |           0.063 |                  0.006 |           0.003 |
| Tucumán                       |       33955 |   47956 |        454 |               10.9 |              0.009 |              0.013 |            0.708 |           0.010 |                  0.002 |           0.001 |
| Río Negro                     |       18937 |   34305 |        494 |               14.5 |              0.023 |              0.026 |            0.552 |           0.177 |                  0.008 |           0.005 |
| Jujuy                         |       17183 |   40123 |        708 |               18.2 |              0.033 |              0.041 |            0.428 |           0.013 |                  0.002 |           0.001 |
| Salta                         |       16210 |   30003 |        589 |               13.2 |              0.030 |              0.036 |            0.540 |           0.101 |                  0.018 |           0.010 |
| Neuquén                       |       14793 |   22169 |        246 |               18.5 |              0.011 |              0.017 |            0.667 |           0.480 |                  0.009 |           0.007 |
| Chaco                         |       11429 |   55639 |        358 |               14.6 |              0.023 |              0.031 |            0.205 |           0.086 |                  0.046 |           0.022 |
| Entre Ríos                    |       11155 |   24434 |        204 |               13.4 |              0.016 |              0.018 |            0.457 |           0.074 |                  0.008 |           0.003 |
| Chubut                        |        8890 |   13483 |        114 |                9.9 |              0.010 |              0.013 |            0.659 |           0.010 |                  0.004 |           0.003 |
| Tierra del Fuego              |        7935 |   14336 |         99 |               16.0 |              0.010 |              0.012 |            0.554 |           0.020 |                  0.007 |           0.006 |
| Santa Cruz                    |        7176 |   13417 |         96 |               14.7 |              0.011 |              0.013 |            0.535 |           0.057 |                  0.012 |           0.008 |
| Santiago del Estero           |        6551 |   23665 |         93 |               11.2 |              0.011 |              0.014 |            0.277 |           0.018 |                  0.002 |           0.001 |
| La Rioja                      |        6374 |   17681 |        224 |               15.0 |              0.034 |              0.035 |            0.360 |           0.008 |                  0.002 |           0.001 |
| San Luis                      |        3152 |   10308 |         35 |               13.9 |              0.006 |              0.011 |            0.306 |           0.031 |                  0.005 |           0.002 |
| SIN ESPECIFICAR               |        2505 |    5587 |         22 |               18.9 |              0.008 |              0.009 |            0.448 |           0.066 |                  0.008 |           0.004 |
| Corrientes                    |        1937 |   12969 |         28 |               10.2 |              0.009 |              0.014 |            0.149 |           0.018 |                  0.014 |           0.009 |
| La Pampa                      |        1531 |    9494 |         15 |               19.1 |              0.007 |              0.010 |            0.161 |           0.024 |                  0.005 |           0.002 |
| San Juan                      |        1290 |    2614 |         52 |               10.6 |              0.024 |              0.040 |            0.493 |           0.048 |                  0.020 |           0.006 |
| Catamarca                     |         452 |    7225 |          0 |                NaN |              0.000 |              0.000 |            0.063 |           0.015 |                  0.000 |           0.000 |
| Misiones                      |         199 |    5857 |          4 |                5.7 |              0.010 |              0.020 |            0.034 |           0.312 |                  0.035 |           0.015 |
| Formosa                       |         137 |    1447 |          1 |               12.0 |              0.005 |              0.007 |            0.095 |           0.328 |                  0.000 |           0.000 |

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
    #> INFO  [09:12:33.643] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 33
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
|             13 | 2020-10-17              |                       132 |        1126 |    5536 |        619 |         65 |              0.050 |              0.058 |            0.203 |           0.550 |                  0.091 |           0.054 |
|             14 | 2020-10-17              |                       183 |        1875 |   11574 |       1014 |        118 |              0.054 |              0.063 |            0.162 |           0.541 |                  0.090 |           0.053 |
|             15 | 2020-10-17              |                       216 |        2627 |   20312 |       1388 |        185 |              0.059 |              0.070 |            0.129 |           0.528 |                  0.085 |           0.048 |
|             16 | 2020-10-17              |                       230 |        3558 |   31935 |       1773 |        253 |              0.059 |              0.071 |            0.111 |           0.498 |                  0.075 |           0.041 |
|             17 | 2020-10-17              |                       234 |        4828 |   46011 |       2333 |        378 |              0.065 |              0.078 |            0.105 |           0.483 |                  0.067 |           0.035 |
|             18 | 2020-10-17              |                       234 |        5959 |   59232 |       2769 |        482 |              0.068 |              0.081 |            0.101 |           0.465 |                  0.061 |           0.032 |
|             19 | 2020-10-17              |                       234 |        7572 |   73387 |       3392 |        593 |              0.066 |              0.078 |            0.103 |           0.448 |                  0.057 |           0.029 |
|             20 | 2020-10-17              |                       234 |       10119 |   90849 |       4279 |        719 |              0.061 |              0.071 |            0.111 |           0.423 |                  0.052 |           0.027 |
|             21 | 2020-10-17              |                       234 |       14761 |  114340 |       5677 |        929 |              0.055 |              0.063 |            0.129 |           0.385 |                  0.047 |           0.024 |
|             22 | 2020-10-17              |                       234 |       20247 |  139814 |       7179 |       1199 |              0.052 |              0.059 |            0.145 |           0.355 |                  0.043 |           0.021 |
|             23 | 2020-10-17              |                       234 |       27027 |  168173 |       8791 |       1524 |              0.050 |              0.056 |            0.161 |           0.325 |                  0.040 |           0.019 |
|             24 | 2020-10-17              |                       234 |       37038 |  203418 |      11027 |       1946 |              0.046 |              0.053 |            0.182 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-10-17              |                       234 |       50241 |  245000 |      13495 |       2498 |              0.044 |              0.050 |            0.205 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-10-17              |                       234 |       68584 |  297461 |      16703 |       3244 |              0.042 |              0.047 |            0.231 |           0.244 |                  0.028 |           0.013 |
|             27 | 2020-10-17              |                       234 |       87860 |  348929 |      19615 |       4071 |              0.041 |              0.046 |            0.252 |           0.223 |                  0.026 |           0.012 |
|             28 | 2020-10-17              |                       235 |      111854 |  408387 |      23070 |       5151 |              0.041 |              0.046 |            0.274 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-10-17              |                       237 |      141549 |  480730 |      26860 |       6444 |              0.040 |              0.046 |            0.294 |           0.190 |                  0.023 |           0.010 |
|             30 | 2020-10-17              |                       237 |      180045 |  567204 |      30682 |       7898 |              0.039 |              0.044 |            0.317 |           0.170 |                  0.021 |           0.010 |
|             31 | 2020-10-17              |                       237 |      220179 |  657942 |      34096 |       9241 |              0.037 |              0.042 |            0.335 |           0.155 |                  0.019 |           0.009 |
|             32 | 2020-10-17              |                       237 |      270205 |  767051 |      38032 |      10893 |              0.036 |              0.040 |            0.352 |           0.141 |                  0.018 |           0.008 |
|             33 | 2020-10-17              |                       237 |      317749 |  882008 |      41841 |      12428 |              0.034 |              0.039 |            0.360 |           0.132 |                  0.017 |           0.008 |
|             34 | 2020-10-17              |                       237 |      367197 |  993291 |      45657 |      14146 |              0.034 |              0.039 |            0.370 |           0.124 |                  0.016 |           0.008 |
|             35 | 2020-10-17              |                       237 |      432902 | 1129447 |      50280 |      16179 |              0.033 |              0.037 |            0.383 |           0.116 |                  0.015 |           0.007 |
|             36 | 2020-10-17              |                       237 |      502944 | 1271028 |      54609 |      18229 |              0.032 |              0.036 |            0.396 |           0.109 |                  0.015 |           0.007 |
|             37 | 2020-10-17              |                       237 |      578154 | 1423045 |      59194 |      20292 |              0.031 |              0.035 |            0.406 |           0.102 |                  0.014 |           0.007 |
|             38 | 2020-10-17              |                       237 |      651395 | 1566743 |      63275 |      22125 |              0.030 |              0.034 |            0.416 |           0.097 |                  0.013 |           0.006 |
|             39 | 2020-10-17              |                       238 |      729069 | 1705280 |      67203 |      23796 |              0.029 |              0.033 |            0.428 |           0.092 |                  0.013 |           0.006 |
|             40 | 2020-10-17              |                       239 |      812931 | 1842186 |      70637 |      25084 |              0.027 |              0.031 |            0.441 |           0.087 |                  0.012 |           0.006 |
|             41 | 2020-10-17              |                       240 |      901207 | 1976398 |      73325 |      25883 |              0.025 |              0.029 |            0.456 |           0.081 |                  0.011 |           0.005 |
|             42 | 2020-10-17              |                       240 |      979115 | 2077803 |      74700 |      26107 |              0.023 |              0.027 |            0.471 |           0.076 |                  0.010 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:16:01.631] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:17:44.436] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:18:26.925] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:18:30.074] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:18:39.181] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:18:42.809] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:18:54.500] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:18:58.494] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:19:03.185] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:19:05.785] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:19:12.120] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:19:15.414] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:19:19.489] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:19:27.024] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:19:30.583] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:19:34.752] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:19:39.882] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:19:44.266] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:19:47.194] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:19:50.613] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:19:54.241] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:20:04.448] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:20:08.872] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:20:12.228] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:20:16.198] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 767
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
| Buenos Aires                  | M    |      250920 |      18321 |       8696 |              0.030 |              0.035 |            0.491 |           0.073 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      241776 |      15022 |       6899 |              0.024 |              0.029 |            0.461 |           0.062 |                  0.008 |           0.003 |
| CABA                          | F    |       69942 |       9803 |       2007 |              0.026 |              0.029 |            0.365 |           0.140 |                  0.013 |           0.006 |
| CABA                          | M    |       67932 |      10422 |       2253 |              0.030 |              0.033 |            0.412 |           0.153 |                  0.022 |           0.012 |
| Santa Fe                      | F    |       38979 |        802 |        383 |              0.009 |              0.010 |            0.671 |           0.021 |                  0.005 |           0.003 |
| Santa Fe                      | M    |       37795 |        991 |        462 |              0.011 |              0.012 |            0.697 |           0.026 |                  0.007 |           0.004 |
| Córdoba                       | F    |       30803 |        430 |        352 |              0.009 |              0.011 |            0.571 |           0.014 |                  0.007 |           0.002 |
| Córdoba                       | M    |       30209 |        512 |        470 |              0.013 |              0.016 |            0.576 |           0.017 |                  0.009 |           0.002 |
| Mendoza                       | M    |       18244 |       1214 |        337 |              0.015 |              0.018 |            0.541 |           0.067 |                  0.009 |           0.004 |
| Mendoza                       | F    |       18176 |       1091 |        250 |              0.011 |              0.014 |            0.519 |           0.060 |                  0.004 |           0.002 |
| Tucumán                       | M    |       17674 |        202 |        298 |              0.011 |              0.017 |            0.667 |           0.011 |                  0.002 |           0.001 |
| Tucumán                       | F    |       16263 |        142 |        156 |              0.006 |              0.010 |            0.759 |           0.009 |                  0.002 |           0.001 |
| Río Negro                     | F    |        9706 |       1691 |        200 |              0.018 |              0.021 |            0.535 |           0.174 |                  0.005 |           0.003 |
| Jujuy                         | M    |        9580 |        143 |        457 |              0.039 |              0.048 |            0.437 |           0.015 |                  0.003 |           0.001 |
| Río Negro                     | M    |        9222 |       1659 |        294 |              0.028 |              0.032 |            0.572 |           0.180 |                  0.010 |           0.007 |
| Salta                         | M    |        9110 |        969 |        379 |              0.034 |              0.042 |            0.546 |           0.106 |                  0.021 |           0.013 |
| Jujuy                         | F    |        7580 |         73 |        249 |              0.026 |              0.033 |            0.418 |           0.010 |                  0.001 |           0.001 |
| Neuquén                       | M    |        7452 |       3497 |        149 |              0.014 |              0.020 |            0.683 |           0.469 |                  0.012 |           0.010 |
| Neuquén                       | F    |        7336 |       3600 |         96 |              0.009 |              0.013 |            0.653 |           0.491 |                  0.006 |           0.004 |
| Salta                         | F    |        7050 |        668 |        207 |              0.024 |              0.029 |            0.534 |           0.095 |                  0.014 |           0.007 |
| Chaco                         | M    |        5749 |        518 |        225 |              0.030 |              0.039 |            0.212 |           0.090 |                  0.052 |           0.027 |
| Chaco                         | F    |        5673 |        470 |        133 |              0.017 |              0.023 |            0.200 |           0.083 |                  0.039 |           0.018 |
| Entre Ríos                    | F    |        5576 |        400 |         81 |              0.012 |              0.015 |            0.435 |           0.072 |                  0.006 |           0.002 |
| Entre Ríos                    | M    |        5573 |        429 |        122 |              0.019 |              0.022 |            0.480 |           0.077 |                  0.009 |           0.004 |
| Chubut                        | M    |        4883 |         48 |         65 |              0.010 |              0.013 |            0.678 |           0.010 |                  0.004 |           0.004 |
| Tierra del Fuego              | M    |        4166 |        105 |         66 |              0.013 |              0.016 |            0.570 |           0.025 |                  0.010 |           0.008 |
| Chubut                        | F    |        3983 |         43 |         48 |              0.009 |              0.012 |            0.640 |           0.011 |                  0.003 |           0.002 |
| Tierra del Fuego              | F    |        3754 |         54 |         33 |              0.007 |              0.009 |            0.535 |           0.014 |                  0.003 |           0.003 |
| Santa Cruz                    | M    |        3713 |        233 |         63 |              0.015 |              0.017 |            0.562 |           0.063 |                  0.015 |           0.011 |
| Santiago del Estero           | M    |        3544 |         76 |         57 |              0.012 |              0.016 |            0.258 |           0.021 |                  0.002 |           0.001 |
| Santa Cruz                    | F    |        3456 |        175 |         33 |              0.008 |              0.010 |            0.508 |           0.051 |                  0.009 |           0.006 |
| La Rioja                      | M    |        3335 |         27 |        140 |              0.041 |              0.042 |            0.367 |           0.008 |                  0.002 |           0.001 |
| La Rioja                      | F    |        3013 |         21 |         81 |              0.026 |              0.027 |            0.353 |           0.007 |                  0.002 |           0.001 |
| Santiago del Estero           | F    |        3002 |         43 |         36 |              0.009 |              0.012 |            0.317 |           0.014 |                  0.001 |           0.001 |
| Buenos Aires                  | NR   |        1769 |        142 |        112 |              0.047 |              0.063 |            0.485 |           0.080 |                  0.016 |           0.007 |
| San Luis                      | M    |        1627 |         53 |         21 |              0.008 |              0.013 |            0.322 |           0.033 |                  0.005 |           0.001 |
| San Luis                      | F    |        1522 |         46 |         14 |              0.005 |              0.009 |            0.290 |           0.030 |                  0.005 |           0.004 |
| SIN ESPECIFICAR               | F    |        1482 |         88 |         10 |              0.006 |              0.007 |            0.442 |           0.059 |                  0.006 |           0.002 |
| SIN ESPECIFICAR               | M    |        1016 |         75 |         11 |              0.010 |              0.011 |            0.460 |           0.074 |                  0.010 |           0.006 |
| Corrientes                    | M    |         991 |         25 |         20 |              0.012 |              0.020 |            0.145 |           0.025 |                  0.020 |           0.014 |
| Corrientes                    | F    |         946 |         10 |          8 |              0.005 |              0.008 |            0.154 |           0.011 |                  0.008 |           0.003 |
| La Pampa                      | F    |         799 |         20 |          7 |              0.006 |              0.009 |            0.155 |           0.025 |                  0.006 |           0.001 |
| San Juan                      | M    |         773 |         27 |         25 |              0.021 |              0.032 |            0.512 |           0.035 |                  0.016 |           0.006 |
| La Pampa                      | M    |         726 |         15 |          8 |              0.008 |              0.011 |            0.169 |           0.021 |                  0.004 |           0.003 |
| CABA                          | NR   |         547 |        131 |         42 |              0.059 |              0.077 |            0.401 |           0.239 |                  0.035 |           0.022 |
| San Juan                      | F    |         517 |         35 |         27 |              0.028 |              0.052 |            0.469 |           0.068 |                  0.027 |           0.006 |
| Catamarca                     | M    |         291 |          5 |          0 |              0.000 |              0.000 |            0.064 |           0.017 |                  0.000 |           0.000 |
| Catamarca                     | F    |         161 |          2 |          0 |              0.000 |              0.000 |            0.061 |           0.012 |                  0.000 |           0.000 |
| Mendoza                       | NR   |         160 |          6 |          3 |              0.014 |              0.019 |            0.456 |           0.038 |                  0.000 |           0.000 |
| Misiones                      | M    |         114 |         35 |          2 |              0.009 |              0.018 |            0.034 |           0.307 |                  0.035 |           0.018 |
| Formosa                       | M    |         100 |         23 |          0 |              0.000 |              0.000 |            0.115 |           0.230 |                  0.000 |           0.000 |
| Misiones                      | F    |          85 |         27 |          2 |              0.011 |              0.024 |            0.034 |           0.318 |                  0.035 |           0.012 |
| Salta                         | NR   |          50 |          5 |          3 |              0.047 |              0.060 |            0.481 |           0.100 |                  0.040 |           0.020 |
| Córdoba                       | NR   |          38 |          1 |          3 |              0.053 |              0.079 |            0.567 |           0.026 |                  0.000 |           0.000 |
| Formosa                       | F    |          37 |         22 |          1 |              0.016 |              0.027 |            0.064 |           0.595 |                  0.000 |           0.000 |
| Santa Fe                      | NR   |          34 |          3 |          2 |              0.048 |              0.059 |            0.442 |           0.088 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          26 |          0 |          3 |              0.111 |              0.115 |            0.329 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          24 |          1 |          1 |              0.024 |              0.042 |            0.429 |           0.042 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          23 |          1 |          2 |              0.048 |              0.087 |            0.319 |           0.043 |                  0.000 |           0.000 |
| Tucumán                       | NR   |          18 |          0 |          0 |              0.000 |              0.000 |            0.514 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          15 |          0 |          0 |              0.000 |              0.000 |            2.500 |           0.000 |                  0.000 |           0.000 |


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
