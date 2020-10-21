
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
    #> INFO  [17:28:05.151] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [17:28:19.018] Normalize 
    #> INFO  [17:28:22.394] checkSoundness 
    #> INFO  [17:28:23.597] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-10-19"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-10-19"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-10-19"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-10-19              |     1002658 |      26716 |              0.023 |              0.027 |                       242 | 2109589 |            0.475 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| Buenos Aires                  |      501049 |      15918 |              0.027 |              0.032 |                       236 | 1051211 |            0.477 |
| CABA                          |      139492 |       4387 |              0.029 |              0.031 |                       234 |  361101 |            0.386 |
| Santa Fe                      |       80873 |        876 |              0.010 |              0.011 |                       220 |  115035 |            0.703 |
| Córdoba                       |       64567 |        898 |              0.012 |              0.014 |                       226 |  108740 |            0.594 |
| Mendoza                       |       37837 |        635 |              0.014 |              0.017 |                       224 |   70774 |            0.535 |
| Tucumán                       |       36113 |        471 |              0.009 |              0.013 |                       215 |   49762 |            0.726 |
| Río Negro                     |       19417 |        510 |              0.023 |              0.026 |                       217 |   34827 |            0.558 |
| Jujuy                         |       17279 |        738 |              0.034 |              0.043 |                       214 |   40445 |            0.427 |
| Salta                         |       16458 |        622 |              0.031 |              0.038 |                       212 |   30445 |            0.541 |
| Neuquén                       |       15352 |        274 |              0.012 |              0.018 |                       219 |   22744 |            0.675 |
| Chaco                         |       11846 |        368 |              0.023 |              0.031 |                       222 |   56458 |            0.210 |
| Entre Ríos                    |       11692 |        210 |              0.015 |              0.018 |                       217 |   24940 |            0.469 |
| Chubut                        |        9260 |        124 |              0.010 |              0.013 |                       203 |   13792 |            0.671 |
| Tierra del Fuego              |        8381 |        101 |              0.010 |              0.012 |                       216 |   14796 |            0.566 |
| Santa Cruz                    |        7398 |        100 |              0.011 |              0.014 |                       209 |   13751 |            0.538 |
| Santiago del Estero           |        6958 |         94 |              0.010 |              0.014 |                       203 |   24988 |            0.278 |
| La Rioja                      |        6620 |        227 |              0.033 |              0.034 |                       209 |   18157 |            0.365 |
| San Luis                      |        3611 |         36 |              0.006 |              0.010 |                       194 |   11347 |            0.318 |
| SIN ESPECIFICAR               |        2515 |         22 |              0.008 |              0.009 |                       210 |    5625 |            0.447 |
| Corrientes                    |        2100 |         31 |              0.009 |              0.015 |                       214 |   13221 |            0.159 |
| La Pampa                      |        1710 |         15 |              0.006 |              0.009 |                       197 |    9937 |            0.172 |
| San Juan                      |        1301 |         54 |              0.024 |              0.042 |                       206 |    2621 |            0.496 |
| Catamarca                     |         491 |          0 |              0.000 |              0.000 |                       187 |    7461 |            0.066 |
| Misiones                      |         197 |          4 |              0.009 |              0.020 |                       194 |    5944 |            0.033 |
| Formosa                       |         141 |          1 |              0.005 |              0.007 |                       188 |    1467 |            0.096 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |   tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|--------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      501049 | 1051211 |      15918 |               16.5 |              0.027 |              0.032 |            0.477 |           0.068 |                  0.010 |           0.005 |
| CABA                          |      139492 |  361101 |       4387 |               17.0 |              0.029 |              0.031 |            0.386 |           0.147 |                  0.017 |           0.009 |
| Santa Fe                      |       80873 |  115035 |        876 |               13.2 |              0.010 |              0.011 |            0.703 |           0.023 |                  0.006 |           0.003 |
| Córdoba                       |       64567 |  108740 |        898 |               12.7 |              0.012 |              0.014 |            0.594 |           0.016 |                  0.008 |           0.002 |
| Mendoza                       |       37837 |   70774 |        635 |               11.5 |              0.014 |              0.017 |            0.535 |           0.063 |                  0.006 |           0.003 |
| Tucumán                       |       36113 |   49762 |        471 |               10.9 |              0.009 |              0.013 |            0.726 |           0.010 |                  0.002 |           0.001 |
| Río Negro                     |       19417 |   34827 |        510 |               14.6 |              0.023 |              0.026 |            0.558 |           0.174 |                  0.008 |           0.005 |
| Jujuy                         |       17279 |   40445 |        738 |               18.2 |              0.034 |              0.043 |            0.427 |           0.014 |                  0.003 |           0.001 |
| Salta                         |       16458 |   30445 |        622 |               13.4 |              0.031 |              0.038 |            0.541 |           0.102 |                  0.018 |           0.010 |
| Neuquén                       |       15352 |   22744 |        274 |               18.4 |              0.012 |              0.018 |            0.675 |           0.475 |                  0.009 |           0.008 |
| Chaco                         |       11846 |   56458 |        368 |               14.7 |              0.023 |              0.031 |            0.210 |           0.084 |                  0.045 |           0.022 |
| Entre Ríos                    |       11692 |   24940 |        210 |               13.7 |              0.015 |              0.018 |            0.469 |           0.072 |                  0.008 |           0.003 |
| Chubut                        |        9260 |   13792 |        124 |               10.1 |              0.010 |              0.013 |            0.671 |           0.010 |                  0.004 |           0.003 |
| Tierra del Fuego              |        8381 |   14796 |        101 |               15.9 |              0.010 |              0.012 |            0.566 |           0.019 |                  0.006 |           0.005 |
| Santa Cruz                    |        7398 |   13751 |        100 |               14.9 |              0.011 |              0.014 |            0.538 |           0.057 |                  0.013 |           0.009 |
| Santiago del Estero           |        6958 |   24988 |         94 |               11.1 |              0.010 |              0.014 |            0.278 |           0.018 |                  0.001 |           0.001 |
| La Rioja                      |        6620 |   18157 |        227 |               14.9 |              0.033 |              0.034 |            0.365 |           0.007 |                  0.002 |           0.001 |
| San Luis                      |        3611 |   11347 |         36 |               14.2 |              0.006 |              0.010 |            0.318 |           0.029 |                  0.004 |           0.002 |
| SIN ESPECIFICAR               |        2515 |    5625 |         22 |               18.9 |              0.008 |              0.009 |            0.447 |           0.066 |                  0.008 |           0.004 |
| Corrientes                    |        2100 |   13221 |         31 |                9.8 |              0.009 |              0.015 |            0.159 |           0.018 |                  0.014 |           0.008 |
| La Pampa                      |        1710 |    9937 |         15 |               19.1 |              0.006 |              0.009 |            0.172 |           0.022 |                  0.005 |           0.002 |
| San Juan                      |        1301 |    2621 |         54 |               11.0 |              0.024 |              0.042 |            0.496 |           0.049 |                  0.020 |           0.006 |
| Catamarca                     |         491 |    7461 |          0 |                NaN |              0.000 |              0.000 |            0.066 |           0.016 |                  0.000 |           0.000 |
| Misiones                      |         197 |    5944 |          4 |                5.7 |              0.009 |              0.020 |            0.033 |           0.315 |                  0.036 |           0.015 |
| Formosa                       |         141 |    1467 |          1 |               12.0 |              0.005 |              0.007 |            0.096 |           0.333 |                  0.000 |           0.000 |

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
    #> INFO  [17:35:42.798] Processing {current.group: }
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
|             13 | 2020-10-17              |                       132 |        1127 |    5536 |        619 |         65 |              0.050 |              0.058 |            0.204 |           0.549 |                  0.091 |           0.054 |
|             14 | 2020-10-17              |                       183 |        1876 |   11574 |       1014 |        118 |              0.054 |              0.063 |            0.162 |           0.541 |                  0.090 |           0.053 |
|             15 | 2020-10-17              |                       216 |        2631 |   20312 |       1388 |        185 |              0.059 |              0.070 |            0.130 |           0.528 |                  0.085 |           0.048 |
|             16 | 2020-10-19              |                       232 |        3565 |   31935 |       1773 |        253 |              0.059 |              0.071 |            0.112 |           0.497 |                  0.075 |           0.041 |
|             17 | 2020-10-19              |                       236 |        4837 |   46011 |       2333 |        378 |              0.065 |              0.078 |            0.105 |           0.482 |                  0.067 |           0.035 |
|             18 | 2020-10-19              |                       236 |        5970 |   59232 |       2769 |        483 |              0.068 |              0.081 |            0.101 |           0.464 |                  0.061 |           0.032 |
|             19 | 2020-10-19              |                       236 |        7586 |   73387 |       3393 |        594 |              0.066 |              0.078 |            0.103 |           0.447 |                  0.057 |           0.029 |
|             20 | 2020-10-19              |                       236 |       10133 |   90850 |       4280 |        720 |              0.061 |              0.071 |            0.112 |           0.422 |                  0.053 |           0.027 |
|             21 | 2020-10-19              |                       236 |       14779 |  114341 |       5679 |        931 |              0.055 |              0.063 |            0.129 |           0.384 |                  0.047 |           0.023 |
|             22 | 2020-10-19              |                       236 |       20270 |  139815 |       7181 |       1202 |              0.052 |              0.059 |            0.145 |           0.354 |                  0.043 |           0.021 |
|             23 | 2020-10-19              |                       236 |       27053 |  168175 |       8793 |       1527 |              0.050 |              0.056 |            0.161 |           0.325 |                  0.040 |           0.019 |
|             24 | 2020-10-19              |                       236 |       37070 |  203424 |      11030 |       1950 |              0.046 |              0.053 |            0.182 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-10-19              |                       236 |       50279 |  245008 |      13501 |       2505 |              0.044 |              0.050 |            0.205 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-10-19              |                       236 |       68634 |  297475 |      16719 |       3256 |              0.042 |              0.047 |            0.231 |           0.244 |                  0.028 |           0.013 |
|             27 | 2020-10-19              |                       236 |       87914 |  348946 |      19638 |       4087 |              0.041 |              0.046 |            0.252 |           0.223 |                  0.026 |           0.012 |
|             28 | 2020-10-19              |                       237 |      111916 |  408406 |      23098 |       5170 |              0.041 |              0.046 |            0.274 |           0.206 |                  0.024 |           0.011 |
|             29 | 2020-10-19              |                       239 |      141620 |  480752 |      26895 |       6470 |              0.040 |              0.046 |            0.295 |           0.190 |                  0.023 |           0.010 |
|             30 | 2020-10-19              |                       239 |      180134 |  567229 |      30720 |       7929 |              0.039 |              0.044 |            0.318 |           0.171 |                  0.021 |           0.010 |
|             31 | 2020-10-19              |                       239 |      220282 |  657974 |      34137 |       9283 |              0.037 |              0.042 |            0.335 |           0.155 |                  0.019 |           0.009 |
|             32 | 2020-10-19              |                       239 |      270327 |  767097 |      38076 |      10946 |              0.036 |              0.040 |            0.352 |           0.141 |                  0.018 |           0.008 |
|             33 | 2020-10-19              |                       239 |      317902 |  882064 |      41888 |      12492 |              0.034 |              0.039 |            0.360 |           0.132 |                  0.017 |           0.008 |
|             34 | 2020-10-19              |                       239 |      367367 |  993357 |      45709 |      14219 |              0.034 |              0.039 |            0.370 |           0.124 |                  0.016 |           0.008 |
|             35 | 2020-10-19              |                       239 |      433102 | 1129592 |      50343 |      16259 |              0.033 |              0.038 |            0.383 |           0.116 |                  0.015 |           0.007 |
|             36 | 2020-10-19              |                       239 |      503183 | 1271306 |      54686 |      18321 |              0.032 |              0.036 |            0.396 |           0.109 |                  0.015 |           0.007 |
|             37 | 2020-10-19              |                       239 |      578468 | 1423519 |      59288 |      20400 |              0.031 |              0.035 |            0.406 |           0.102 |                  0.014 |           0.007 |
|             38 | 2020-10-19              |                       239 |      651774 | 1567337 |      63392 |      22264 |              0.030 |              0.034 |            0.416 |           0.097 |                  0.013 |           0.007 |
|             39 | 2020-10-19              |                       240 |      729523 | 1706017 |      67369 |      24010 |              0.029 |              0.033 |            0.428 |           0.092 |                  0.013 |           0.006 |
|             40 | 2020-10-19              |                       241 |      813550 | 1843208 |      70924 |      25419 |              0.027 |              0.031 |            0.441 |           0.087 |                  0.012 |           0.006 |
|             41 | 2020-10-19              |                       242 |      902332 | 1978357 |      73845 |      26367 |              0.025 |              0.029 |            0.456 |           0.082 |                  0.011 |           0.006 |
|             42 | 2020-10-19              |                       242 |      990107 | 2097134 |      75626 |      26702 |              0.023 |              0.027 |            0.472 |           0.076 |                  0.011 |           0.005 |
|             43 | 2020-10-19              |                       242 |     1002658 | 2109589 |      75713 |      26716 |              0.023 |              0.027 |            0.475 |           0.076 |                  0.010 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [17:39:50.750] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [17:41:56.346] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [17:42:48.633] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [17:42:52.768] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [17:43:05.759] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [17:43:14.492] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [17:43:38.198] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [17:43:43.399] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [17:43:49.807] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [17:43:53.458] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [17:44:03.004] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [17:44:07.611] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [17:44:15.018] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [17:44:25.657] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [17:44:30.554] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [17:44:35.724] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [17:44:42.310] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [17:44:48.286] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [17:44:51.775] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [17:44:55.831] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [17:45:00.314] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [17:45:13.309] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [17:45:18.738] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [17:45:22.671] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [17:45:27.734] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |      254123 |      18503 |       8805 |              0.030 |              0.035 |            0.491 |           0.073 |                  0.013 |           0.006 |
| Buenos Aires                  | F    |      245142 |      15176 |       7000 |              0.024 |              0.029 |            0.462 |           0.062 |                  0.008 |           0.003 |
| CABA                          | F    |       70515 |       9848 |       2050 |              0.026 |              0.029 |            0.365 |           0.140 |                  0.013 |           0.006 |
| CABA                          | M    |       68427 |      10477 |       2294 |              0.031 |              0.034 |            0.411 |           0.153 |                  0.022 |           0.012 |
| Santa Fe                      | F    |       41066 |        838 |        396 |              0.009 |              0.010 |            0.690 |           0.020 |                  0.005 |           0.003 |
| Santa Fe                      | M    |       39772 |       1028 |        478 |              0.011 |              0.012 |            0.717 |           0.026 |                  0.008 |           0.004 |
| Córdoba                       | F    |       32603 |        461 |        389 |              0.010 |              0.012 |            0.592 |           0.014 |                  0.007 |           0.002 |
| Córdoba                       | M    |       31924 |        549 |        506 |              0.013 |              0.016 |            0.596 |           0.017 |                  0.009 |           0.002 |
| Mendoza                       | M    |       18837 |       1263 |        363 |              0.016 |              0.019 |            0.546 |           0.067 |                  0.009 |           0.004 |
| Mendoza                       | F    |       18834 |       1122 |        269 |              0.011 |              0.014 |            0.524 |           0.060 |                  0.004 |           0.002 |
| Tucumán                       | M    |       18775 |        204 |        311 |              0.011 |              0.017 |            0.683 |           0.011 |                  0.002 |           0.001 |
| Tucumán                       | F    |       17320 |        145 |        160 |              0.006 |              0.009 |            0.779 |           0.008 |                  0.002 |           0.001 |
| Río Negro                     | F    |        9942 |       1702 |        208 |              0.018 |              0.021 |            0.540 |           0.171 |                  0.005 |           0.003 |
| Jujuy                         | M    |        9629 |        155 |        476 |              0.040 |              0.049 |            0.436 |           0.016 |                  0.004 |           0.001 |
| Río Negro                     | M    |        9465 |       1672 |        302 |              0.028 |              0.032 |            0.577 |           0.177 |                  0.010 |           0.007 |
| Salta                         | M    |        9245 |        996 |        407 |              0.036 |              0.044 |            0.546 |           0.108 |                  0.021 |           0.013 |
| Neuquén                       | M    |        7720 |       3588 |        168 |              0.015 |              0.022 |            0.690 |           0.465 |                  0.013 |           0.011 |
| Jujuy                         | F    |        7627 |         87 |        260 |              0.027 |              0.034 |            0.417 |           0.011 |                  0.002 |           0.001 |
| Neuquén                       | F    |        7626 |       3698 |        105 |              0.009 |              0.014 |            0.661 |           0.485 |                  0.006 |           0.004 |
| Salta                         | F    |        7163 |        681 |        212 |              0.024 |              0.030 |            0.534 |           0.095 |                  0.015 |           0.007 |
| Chaco                         | M    |        5964 |        522 |        230 |              0.029 |              0.039 |            0.216 |           0.088 |                  0.051 |           0.026 |
| Chaco                         | F    |        5874 |        476 |        138 |              0.017 |              0.023 |            0.204 |           0.081 |                  0.038 |           0.017 |
| Entre Ríos                    | F    |        5861 |        406 |         82 |              0.012 |              0.014 |            0.449 |           0.069 |                  0.006 |           0.002 |
| Entre Ríos                    | M    |        5825 |        439 |        127 |              0.019 |              0.022 |            0.491 |           0.075 |                  0.009 |           0.004 |
| Chubut                        | M    |        5083 |         49 |         71 |              0.011 |              0.014 |            0.691 |           0.010 |                  0.004 |           0.004 |
| Tierra del Fuego              | M    |        4403 |        107 |         68 |              0.013 |              0.015 |            0.583 |           0.024 |                  0.010 |           0.008 |
| Chubut                        | F    |        4150 |         45 |         52 |              0.009 |              0.013 |            0.651 |           0.011 |                  0.003 |           0.002 |
| Tierra del Fuego              | F    |        3963 |         54 |         33 |              0.007 |              0.008 |            0.547 |           0.014 |                  0.003 |           0.003 |
| Santa Cruz                    | M    |        3846 |        246 |         66 |              0.014 |              0.017 |            0.569 |           0.064 |                  0.016 |           0.011 |
| Santiago del Estero           | M    |        3753 |         78 |         58 |              0.012 |              0.015 |            0.260 |           0.021 |                  0.002 |           0.001 |
| Santa Cruz                    | F    |        3545 |        178 |         34 |              0.008 |              0.010 |            0.508 |           0.050 |                  0.009 |           0.006 |
| La Rioja                      | M    |        3473 |         28 |        143 |              0.040 |              0.041 |            0.373 |           0.008 |                  0.002 |           0.001 |
| Santiago del Estero           | F    |        3200 |         45 |         36 |              0.008 |              0.011 |            0.317 |           0.014 |                  0.001 |           0.001 |
| La Rioja                      | F    |        3121 |         21 |         81 |              0.025 |              0.026 |            0.356 |           0.007 |                  0.002 |           0.001 |
| San Luis                      | M    |        1856 |         57 |         22 |              0.007 |              0.012 |            0.334 |           0.031 |                  0.004 |           0.001 |
| Buenos Aires                  | NR   |        1784 |        143 |        113 |              0.047 |              0.063 |            0.483 |           0.080 |                  0.016 |           0.007 |
| San Luis                      | F    |        1752 |         48 |         14 |              0.004 |              0.008 |            0.303 |           0.027 |                  0.004 |           0.003 |
| SIN ESPECIFICAR               | F    |        1488 |         88 |         10 |              0.006 |              0.007 |            0.441 |           0.059 |                  0.006 |           0.002 |
| Corrientes                    | M    |        1074 |         28 |         23 |              0.014 |              0.021 |            0.154 |           0.026 |                  0.020 |           0.013 |
| Corrientes                    | F    |        1026 |         10 |          8 |              0.005 |              0.008 |            0.164 |           0.010 |                  0.008 |           0.003 |
| SIN ESPECIFICAR               | M    |        1020 |         75 |         11 |              0.009 |              0.011 |            0.459 |           0.074 |                  0.010 |           0.006 |
| La Pampa                      | F    |         885 |         21 |          7 |              0.005 |              0.008 |            0.164 |           0.024 |                  0.006 |           0.001 |
| La Pampa                      | M    |         816 |         16 |          8 |              0.007 |              0.010 |            0.181 |           0.020 |                  0.004 |           0.002 |
| San Juan                      | M    |         780 |         29 |         27 |              0.022 |              0.035 |            0.515 |           0.037 |                  0.015 |           0.006 |
| CABA                          | NR   |         550 |        133 |         43 |              0.060 |              0.078 |            0.398 |           0.242 |                  0.036 |           0.022 |
| San Juan                      | F    |         521 |         35 |         27 |              0.026 |              0.052 |            0.472 |           0.067 |                  0.027 |           0.006 |
| Catamarca                     | M    |         318 |          5 |          0 |              0.000 |              0.000 |            0.068 |           0.016 |                  0.000 |           0.000 |
| Catamarca                     | F    |         173 |          3 |          0 |              0.000 |              0.000 |            0.063 |           0.017 |                  0.000 |           0.000 |
| Mendoza                       | NR   |         166 |          7 |          3 |              0.013 |              0.018 |            0.461 |           0.042 |                  0.006 |           0.006 |
| Misiones                      | M    |         112 |         35 |          2 |              0.009 |              0.018 |            0.033 |           0.312 |                  0.036 |           0.018 |
| Formosa                       | M    |         105 |         25 |          0 |              0.000 |              0.000 |            0.119 |           0.238 |                  0.000 |           0.000 |
| Misiones                      | F    |          85 |         27 |          2 |              0.010 |              0.024 |            0.034 |           0.318 |                  0.035 |           0.012 |
| Salta                         | NR   |          50 |          5 |          3 |              0.048 |              0.060 |            0.476 |           0.100 |                  0.040 |           0.020 |
| Córdoba                       | NR   |          40 |          1 |          3 |              0.051 |              0.075 |            0.597 |           0.025 |                  0.000 |           0.000 |
| Formosa                       | F    |          36 |         22 |          1 |              0.016 |              0.028 |            0.062 |           0.611 |                  0.000 |           0.000 |
| Santa Fe                      | NR   |          35 |          3 |          2 |              0.044 |              0.057 |            0.443 |           0.086 |                  0.000 |           0.000 |
| Chubut                        | NR   |          27 |          1 |          1 |              0.022 |              0.037 |            0.458 |           0.037 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          26 |          0 |          3 |              0.111 |              0.115 |            0.329 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          23 |          1 |          2 |              0.048 |              0.087 |            0.319 |           0.043 |                  0.000 |           0.000 |
| Tucumán                       | NR   |          18 |          0 |          0 |              0.000 |              0.000 |            0.514 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          15 |          0 |          0 |              0.000 |              0.000 |            2.500 |           0.000 |                  0.000 |           0.000 |
| Río Negro                     | NR   |          10 |          2 |          0 |              0.000 |              0.000 |            0.455 |           0.200 |                  0.000 |           0.000 |


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
