
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
    #> INFO  [08:55:29.534] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [08:55:34.542] Normalize 
    #> INFO  [08:55:35.723] checkSoundness 
    #> INFO  [08:55:36.291] Mutating data 
    #> INFO  [08:57:22.458] Last days rows {date: 2020-08-07, n: 23637}
    #> INFO  [08:57:22.460] Last days rows {date: 2020-08-08, n: 11014}
    #> INFO  [08:57:22.462] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-08"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-08"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-08"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      241798 |       4523 |              0.014 |              0.019 |                       167 | 716187 |            0.338 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      147556 |       2553 |              0.012 |              0.017 |                       165 | 371849 |            0.397 |
| CABA                          |       68639 |       1458 |              0.018 |              0.021 |                       162 | 169280 |            0.405 |
| Chaco                         |        4003 |        165 |              0.031 |              0.041 |                       150 |  24696 |            0.162 |
| Jujuy                         |        3355 |         32 |              0.004 |              0.010 |                       141 |  11594 |            0.289 |
| Córdoba                       |        3306 |         64 |              0.014 |              0.019 |                       152 |  35325 |            0.094 |
| Río Negro                     |        2841 |         85 |              0.026 |              0.030 |                       145 |   9031 |            0.315 |
| Santa Fe                      |        2049 |         21 |              0.007 |              0.010 |                       148 |  23700 |            0.086 |
| Mendoza                       |        2039 |         52 |              0.019 |              0.026 |                       151 |   9052 |            0.225 |
| Neuquén                       |        1436 |         29 |              0.017 |              0.020 |                       147 |   5162 |            0.278 |
| SIN ESPECIFICAR               |        1355 |          4 |              0.002 |              0.003 |                       138 |   3025 |            0.448 |
| Entre Ríos                    |        1087 |         12 |              0.008 |              0.011 |                       145 |   5666 |            0.192 |
| Tierra del Fuego              |         938 |          6 |              0.005 |              0.006 |                       144 |   3651 |            0.257 |
| Santa Cruz                    |         707 |          4 |              0.005 |              0.006 |                       137 |   1808 |            0.391 |
| Salta                         |         533 |          6 |              0.008 |              0.011 |                       140 |   2291 |            0.233 |
| La Rioja                      |         514 |         20 |              0.035 |              0.039 |                       137 |   4506 |            0.114 |
| Tucumán                       |         366 |          5 |              0.002 |              0.014 |                       143 |  12927 |            0.028 |
| Chubut                        |         326 |          3 |              0.004 |              0.009 |                       131 |   3185 |            0.102 |
| Corrientes                    |         207 |          2 |              0.004 |              0.010 |                       142 |   4713 |            0.044 |
| La Pampa                      |         178 |          0 |              0.000 |              0.000 |                       125 |   1605 |            0.111 |
| Santiago del Estero           |         116 |          0 |              0.000 |              0.000 |                       130 |   5719 |            0.020 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      147556 | 371849 |       2553 |               13.8 |              0.012 |              0.017 |            0.397 |           0.104 |                  0.013 |           0.005 |
| CABA                          |       68639 | 169280 |       1458 |               15.0 |              0.018 |              0.021 |            0.405 |           0.192 |                  0.018 |           0.008 |
| Chaco                         |        4003 |  24696 |        165 |               14.6 |              0.031 |              0.041 |            0.162 |           0.114 |                  0.068 |           0.027 |
| Jujuy                         |        3355 |  11594 |         32 |               12.6 |              0.004 |              0.010 |            0.289 |           0.006 |                  0.001 |           0.001 |
| Córdoba                       |        3306 |  35325 |         64 |               20.1 |              0.014 |              0.019 |            0.094 |           0.050 |                  0.015 |           0.008 |
| Río Negro                     |        2841 |   9031 |         85 |               13.9 |              0.026 |              0.030 |            0.315 |           0.285 |                  0.016 |           0.011 |
| Santa Fe                      |        2049 |  23700 |         21 |               12.5 |              0.007 |              0.010 |            0.086 |           0.082 |                  0.018 |           0.007 |
| Mendoza                       |        2039 |   9052 |         52 |               12.0 |              0.019 |              0.026 |            0.225 |           0.342 |                  0.021 |           0.005 |
| Neuquén                       |        1436 |   5162 |         29 |               17.1 |              0.017 |              0.020 |            0.278 |           0.655 |                  0.019 |           0.011 |
| SIN ESPECIFICAR               |        1355 |   3025 |          4 |               23.0 |              0.002 |              0.003 |            0.448 |           0.071 |                  0.007 |           0.004 |
| Entre Ríos                    |        1087 |   5666 |         12 |               13.3 |              0.008 |              0.011 |            0.192 |           0.189 |                  0.010 |           0.003 |
| Tierra del Fuego              |         938 |   3651 |          6 |               11.5 |              0.005 |              0.006 |            0.257 |           0.016 |                  0.005 |           0.005 |
| Santa Cruz                    |         707 |   1808 |          4 |               11.2 |              0.005 |              0.006 |            0.391 |           0.072 |                  0.021 |           0.013 |
| Salta                         |         533 |   2291 |          6 |                8.2 |              0.008 |              0.011 |            0.233 |           0.283 |                  0.019 |           0.011 |
| La Rioja                      |         514 |   4506 |         20 |               13.0 |              0.035 |              0.039 |            0.114 |           0.053 |                  0.012 |           0.004 |
| Tucumán                       |         366 |  12927 |          5 |               12.8 |              0.002 |              0.014 |            0.028 |           0.120 |                  0.027 |           0.008 |
| Chubut                        |         326 |   3185 |          3 |               20.7 |              0.004 |              0.009 |            0.102 |           0.058 |                  0.015 |           0.012 |
| Corrientes                    |         207 |   4713 |          2 |               12.0 |              0.004 |              0.010 |            0.044 |           0.024 |                  0.010 |           0.005 |
| La Pampa                      |         178 |   1605 |          0 |                NaN |              0.000 |              0.000 |            0.111 |           0.079 |                  0.011 |           0.000 |
| Santiago del Estero           |         116 |   5719 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.017 |                  0.009 |           0.000 |
| Formosa                       |          82 |    865 |          0 |                NaN |              0.000 |              0.000 |            0.095 |           0.012 |                  0.000 |           0.000 |
| Catamarca                     |          61 |   2230 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          49 |   2373 |          2 |                6.5 |              0.021 |              0.041 |            0.021 |           0.612 |                  0.122 |           0.061 |
| San Luis                      |          33 |    875 |          0 |                NaN |              0.000 |              0.000 |            0.038 |           0.333 |                  0.030 |           0.000 |
| San Juan                      |          22 |   1059 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.227 |                  0.045 |           0.000 |

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
    #> INFO  [08:57:59.792] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 23
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.048 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-01              |                        38 |          97 |    666 |         66 |          9 |              0.066 |              0.093 |            0.146 |           0.680 |                  0.124 |           0.062 |
|             12 | 2020-08-07              |                        62 |         414 |   2049 |        256 |         17 |              0.034 |              0.041 |            0.202 |           0.618 |                  0.092 |           0.053 |
|             13 | 2020-08-08              |                        96 |        1088 |   5517 |        601 |         63 |              0.049 |              0.058 |            0.197 |           0.552 |                  0.094 |           0.056 |
|             14 | 2020-08-08              |                       128 |        1782 |  11538 |        976 |        114 |              0.053 |              0.064 |            0.154 |           0.548 |                  0.094 |           0.056 |
|             15 | 2020-08-08              |                       151 |        2447 |  20257 |       1325 |        179 |              0.060 |              0.073 |            0.121 |           0.541 |                  0.090 |           0.051 |
|             16 | 2020-08-08              |                       161 |        3250 |  31862 |       1677 |        236 |              0.058 |              0.073 |            0.102 |           0.516 |                  0.080 |           0.044 |
|             17 | 2020-08-08              |                       164 |        4373 |  45915 |       2202 |        341 |              0.063 |              0.078 |            0.095 |           0.504 |                  0.072 |           0.038 |
|             18 | 2020-08-08              |                       164 |        5383 |  59108 |       2603 |        417 |              0.062 |              0.077 |            0.091 |           0.484 |                  0.065 |           0.035 |
|             19 | 2020-08-08              |                       164 |        6834 |  73241 |       3192 |        498 |              0.059 |              0.073 |            0.093 |           0.467 |                  0.061 |           0.031 |
|             20 | 2020-08-08              |                       164 |        9239 |  90606 |       4035 |        595 |              0.053 |              0.064 |            0.102 |           0.437 |                  0.056 |           0.029 |
|             21 | 2020-08-08              |                       164 |       13621 | 114042 |       5359 |        747 |              0.045 |              0.055 |            0.119 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-08-08              |                       164 |       18863 | 139405 |       6800 |        933 |              0.041 |              0.049 |            0.135 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-08-08              |                       164 |       25311 | 167671 |       8332 |       1152 |              0.038 |              0.046 |            0.151 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-08              |                       164 |       34938 | 202763 |      10466 |       1407 |              0.034 |              0.040 |            0.172 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-08              |                       164 |       47774 | 244141 |      12807 |       1729 |              0.031 |              0.036 |            0.196 |           0.268 |                  0.031 |           0.014 |
|             26 | 2020-08-08              |                       164 |       65482 | 296042 |      15855 |       2146 |              0.028 |              0.033 |            0.221 |           0.242 |                  0.028 |           0.012 |
|             27 | 2020-08-08              |                       164 |       84108 | 346608 |      18596 |       2603 |              0.026 |              0.031 |            0.243 |           0.221 |                  0.025 |           0.011 |
|             28 | 2020-08-08              |                       165 |      107333 | 405173 |      21811 |       3145 |              0.025 |              0.029 |            0.265 |           0.203 |                  0.023 |           0.010 |
|             29 | 2020-08-08              |                       166 |      135806 | 475612 |      25182 |       3683 |              0.023 |              0.027 |            0.286 |           0.185 |                  0.021 |           0.009 |
|             30 | 2020-08-08              |                       166 |      172301 | 558948 |      28429 |       4147 |              0.020 |              0.024 |            0.308 |           0.165 |                  0.019 |           0.008 |
|             31 | 2020-08-29              |                       167 |      209461 | 643123 |      30808 |       4414 |              0.017 |              0.021 |            0.326 |           0.147 |                  0.017 |           0.007 |
|             32 | 2020-08-29              |                       167 |      241798 | 716187 |      32382 |       4523 |              0.014 |              0.019 |            0.338 |           0.134 |                  0.015 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [08:58:46.418] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [08:59:10.232] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [08:59:22.359] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [08:59:23.842] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [08:59:27.477] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [08:59:29.476] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [08:59:34.549] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [08:59:36.945] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [08:59:39.280] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [08:59:40.915] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [08:59:43.526] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [08:59:45.534] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [08:59:47.715] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [08:59:50.240] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [08:59:52.272] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [08:59:54.556] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [08:59:57.218] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [08:59:59.499] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:00:01.511] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:00:03.544] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:00:05.595] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:00:09.327] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:00:11.474] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:00:13.508] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:00:15.845] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 511
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
    #> [1] 64
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |       75553 |       8321 |       1449 |              0.014 |              0.019 |            0.415 |           0.110 |                  0.015 |           0.007 |
| Buenos Aires                  | F    |       71463 |       6927 |       1088 |              0.011 |              0.015 |            0.379 |           0.097 |                  0.010 |           0.004 |
| CABA                          | F    |       34614 |       6453 |        648 |              0.016 |              0.019 |            0.387 |           0.186 |                  0.013 |           0.006 |
| CABA                          | M    |       33757 |       6619 |        795 |              0.020 |              0.024 |            0.427 |           0.196 |                  0.023 |           0.011 |
| Jujuy                         | M    |        2077 |         16 |         18 |              0.004 |              0.009 |            0.325 |           0.008 |                  0.001 |           0.001 |
| Chaco                         | F    |        2001 |        229 |         62 |              0.023 |              0.031 |            0.162 |           0.114 |                  0.061 |           0.022 |
| Chaco                         | M    |        2000 |        228 |        103 |              0.039 |              0.052 |            0.162 |           0.114 |                  0.076 |           0.032 |
| Córdoba                       | M    |        1655 |         80 |         33 |              0.015 |              0.020 |            0.096 |           0.048 |                  0.016 |           0.009 |
| Córdoba                       | F    |        1648 |         84 |         31 |              0.013 |              0.019 |            0.092 |           0.051 |                  0.013 |           0.007 |
| Río Negro                     | F    |        1478 |        403 |         31 |              0.018 |              0.021 |            0.305 |           0.273 |                  0.009 |           0.005 |
| Río Negro                     | M    |        1362 |        406 |         54 |              0.034 |              0.040 |            0.325 |           0.298 |                  0.023 |           0.018 |
| Jujuy                         | F    |        1273 |          5 |         14 |              0.004 |              0.011 |            0.246 |           0.004 |                  0.001 |           0.001 |
| Santa Fe                      | F    |        1037 |         66 |          8 |              0.005 |              0.008 |            0.084 |           0.064 |                  0.013 |           0.003 |
| Mendoza                       | F    |        1032 |        356 |         16 |              0.012 |              0.016 |            0.225 |           0.345 |                  0.011 |           0.002 |
| Santa Fe                      | M    |        1012 |        103 |         13 |              0.009 |              0.013 |            0.089 |           0.102 |                  0.023 |           0.011 |
| Mendoza                       | M    |         995 |        337 |         34 |              0.025 |              0.034 |            0.226 |           0.339 |                  0.031 |           0.009 |
| SIN ESPECIFICAR               | F    |         810 |         49 |          1 |              0.001 |              0.001 |            0.441 |           0.060 |                  0.004 |           0.000 |
| Neuquén                       | F    |         718 |        481 |         16 |              0.019 |              0.022 |            0.277 |           0.670 |                  0.022 |           0.013 |
| Neuquén                       | M    |         718 |        460 |         13 |              0.016 |              0.018 |            0.280 |           0.641 |                  0.015 |           0.010 |
| Tierra del Fuego              | M    |         555 |          9 |          4 |              0.006 |              0.007 |            0.286 |           0.016 |                  0.007 |           0.007 |
| Entre Ríos                    | M    |         552 |        111 |          7 |              0.009 |              0.013 |            0.201 |           0.201 |                  0.009 |           0.004 |
| SIN ESPECIFICAR               | M    |         541 |         46 |          2 |              0.003 |              0.004 |            0.460 |           0.085 |                  0.011 |           0.009 |
| Buenos Aires                  | NR   |         540 |         49 |         16 |              0.018 |              0.030 |            0.413 |           0.091 |                  0.024 |           0.013 |
| Entre Ríos                    | F    |         534 |         94 |          5 |              0.007 |              0.009 |            0.183 |           0.176 |                  0.011 |           0.002 |
| Tierra del Fuego              | F    |         382 |          6 |          2 |              0.004 |              0.005 |            0.224 |           0.016 |                  0.003 |           0.003 |
| Santa Cruz                    | M    |         368 |         25 |          2 |              0.005 |              0.005 |            0.384 |           0.068 |                  0.022 |           0.011 |
| Santa Cruz                    | F    |         338 |         26 |          2 |              0.005 |              0.006 |            0.399 |           0.077 |                  0.021 |           0.015 |
| Salta                         | M    |         319 |         85 |          6 |              0.013 |              0.019 |            0.221 |           0.266 |                  0.025 |           0.019 |
| CABA                          | NR   |         268 |         77 |         15 |              0.032 |              0.056 |            0.386 |           0.287 |                  0.049 |           0.034 |
| La Rioja                      | F    |         264 |         15 |          7 |              0.024 |              0.027 |            0.122 |           0.057 |                  0.019 |           0.008 |
| La Rioja                      | M    |         247 |         12 |         13 |              0.046 |              0.053 |            0.107 |           0.049 |                  0.004 |           0.000 |
| Salta                         | F    |         214 |         66 |          0 |              0.000 |              0.000 |            0.255 |           0.308 |                  0.009 |           0.000 |
| Tucumán                       | M    |         201 |         26 |          3 |              0.003 |              0.015 |            0.025 |           0.129 |                  0.020 |           0.005 |
| Chubut                        | M    |         184 |         15 |          1 |              0.002 |              0.005 |            0.111 |           0.082 |                  0.016 |           0.016 |
| Tucumán                       | F    |         164 |         18 |          2 |              0.002 |              0.012 |            0.034 |           0.110 |                  0.037 |           0.012 |
| Chubut                        | F    |         138 |          4 |          2 |              0.007 |              0.014 |            0.093 |           0.029 |                  0.014 |           0.007 |
| Corrientes                    | M    |         115 |          5 |          2 |              0.008 |              0.017 |            0.043 |           0.043 |                  0.009 |           0.009 |
| La Pampa                      | F    |         103 |          9 |          0 |              0.000 |              0.000 |            0.117 |           0.087 |                  0.010 |           0.000 |
| Corrientes                    | F    |          92 |          0 |          0 |              0.000 |              0.000 |            0.045 |           0.000 |                  0.011 |           0.000 |
| La Pampa                      | M    |          75 |          5 |          0 |              0.000 |              0.000 |            0.105 |           0.067 |                  0.013 |           0.000 |
| Santiago del Estero           | M    |          67 |          2 |          0 |              0.000 |              0.000 |            0.017 |           0.030 |                  0.015 |           0.000 |
| Formosa                       | M    |          66 |          0 |          0 |              0.000 |              0.000 |            0.129 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          49 |          0 |          0 |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          39 |          0 |          0 |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          30 |         16 |          1 |              0.018 |              0.033 |            0.024 |           0.533 |                  0.133 |           0.067 |
| San Luis                      | M    |          23 |          7 |          0 |              0.000 |              0.000 |            0.047 |           0.304 |                  0.043 |           0.000 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.027 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          19 |         14 |          1 |              0.026 |              0.053 |            0.017 |           0.737 |                  0.105 |           0.053 |
| Formosa                       | F    |          16 |          1 |          0 |              0.000 |              0.000 |            0.045 |           0.062 |                  0.000 |           0.000 |
| San Juan                      | M    |          15 |          2 |          0 |              0.000 |              0.000 |            0.025 |           0.133 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          12 |          4 |          2 |              0.105 |              0.167 |            0.200 |           0.333 |                  0.000 |           0.000 |
| San Luis                      | F    |          10 |          4 |          0 |              0.000 |              0.000 |            0.026 |           0.400 |                  0.000 |           0.000 |


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
    #> Warning: Removed 32 rows containing missing values (position_stack).

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
