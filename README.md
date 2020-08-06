
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
    #> INFO  [01:38:18.323] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [01:38:22.338] Normalize 
    #> INFO  [01:38:23.361] checkSoundness 
    #> INFO  [01:38:23.781] Mutating data 
    #> INFO  [01:40:00.463] Last days rows {date: 2020-08-04, n: 24007}
    #> INFO  [01:40:00.465] Last days rows {date: 2020-08-05, n: 15760}
    #> INFO  [01:40:00.467] Future rows {date: 2020-08-29, n: 1}
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-08-05"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-08-05"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-08-05"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-08-29              |      220669 |       4106 |              0.014 |              0.019 |                       164 | 671066 |            0.329 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      133357 |       2273 |              0.012 |              0.017 |                       162 | 345795 |            0.386 |
| CABA                          |       65018 |       1377 |              0.018 |              0.021 |                       159 | 160923 |            0.404 |
| Chaco                         |        3825 |        154 |              0.030 |              0.040 |                       147 |  23609 |            0.162 |
| Jujuy                         |        2886 |         31 |              0.004 |              0.011 |                       138 |  10591 |            0.272 |
| Córdoba                       |        2850 |         52 |              0.012 |              0.018 |                       149 |  33680 |            0.085 |
| Río Negro                     |        2444 |         77 |              0.027 |              0.032 |                       142 |   8227 |            0.297 |
| Mendoza                       |        1674 |         47 |              0.021 |              0.028 |                       148 |   8110 |            0.206 |
| Santa Fe                      |        1637 |         18 |              0.008 |              0.011 |                       145 |  22271 |            0.074 |
| Neuquén                       |        1323 |         26 |              0.016 |              0.020 |                       144 |   4864 |            0.272 |
| SIN ESPECIFICAR               |        1294 |          4 |              0.002 |              0.003 |                       135 |   2866 |            0.452 |
| Entre Ríos                    |         940 |         11 |              0.008 |              0.012 |                       142 |   5250 |            0.179 |
| Tierra del Fuego              |         734 |          2 |              0.002 |              0.003 |                       141 |   3272 |            0.224 |
| Santa Cruz                    |         614 |          3 |              0.004 |              0.005 |                       134 |   1556 |            0.395 |
| La Rioja                      |         409 |         18 |              0.038 |              0.044 |                       134 |   4190 |            0.098 |
| Salta                         |         369 |          2 |              0.003 |              0.005 |                       137 |   2057 |            0.179 |
| Tucumán                       |         318 |          4 |              0.002 |              0.013 |                       140 |  12428 |            0.026 |
| Chubut                        |         301 |          3 |              0.005 |              0.010 |                       128 |   3050 |            0.099 |
| Corrientes                    |         196 |          2 |              0.005 |              0.010 |                       139 |   4519 |            0.043 |
| La Pampa                      |         165 |          0 |              0.000 |              0.000 |                       122 |   1257 |            0.131 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      133357 | 345795 |       2273 |               13.6 |              0.012 |              0.017 |            0.386 |           0.109 |                  0.013 |           0.005 |
| CABA                          |       65018 | 160923 |       1377 |               14.9 |              0.018 |              0.021 |            0.404 |           0.196 |                  0.018 |           0.008 |
| Chaco                         |        3825 |  23609 |        154 |               14.4 |              0.030 |              0.040 |            0.162 |           0.116 |                  0.069 |           0.027 |
| Jujuy                         |        2886 |  10591 |         31 |               12.6 |              0.004 |              0.011 |            0.272 |           0.007 |                  0.001 |           0.001 |
| Córdoba                       |        2850 |  33680 |         52 |               22.0 |              0.012 |              0.018 |            0.085 |           0.054 |                  0.015 |           0.008 |
| Río Negro                     |        2444 |   8227 |         77 |               13.8 |              0.027 |              0.032 |            0.297 |           0.294 |                  0.019 |           0.013 |
| Mendoza                       |        1674 |   8110 |         47 |               12.5 |              0.021 |              0.028 |            0.206 |           0.376 |                  0.023 |           0.005 |
| Santa Fe                      |        1637 |  22271 |         18 |               12.6 |              0.008 |              0.011 |            0.074 |           0.097 |                  0.021 |           0.008 |
| Neuquén                       |        1323 |   4864 |         26 |               18.6 |              0.016 |              0.020 |            0.272 |           0.671 |                  0.019 |           0.011 |
| SIN ESPECIFICAR               |        1294 |   2866 |          4 |               23.0 |              0.002 |              0.003 |            0.452 |           0.070 |                  0.008 |           0.005 |
| Entre Ríos                    |         940 |   5250 |         11 |               13.5 |              0.008 |              0.012 |            0.179 |           0.209 |                  0.012 |           0.002 |
| Tierra del Fuego              |         734 |   3272 |          2 |               19.0 |              0.002 |              0.003 |            0.224 |           0.018 |                  0.004 |           0.004 |
| Santa Cruz                    |         614 |   1556 |          3 |               13.7 |              0.004 |              0.005 |            0.395 |           0.075 |                  0.021 |           0.011 |
| La Rioja                      |         409 |   4190 |         18 |               13.2 |              0.038 |              0.044 |            0.098 |           0.066 |                  0.015 |           0.005 |
| Salta                         |         369 |   2057 |          2 |                2.5 |              0.003 |              0.005 |            0.179 |           0.325 |                  0.019 |           0.008 |
| Tucumán                       |         318 |  12428 |          4 |               14.2 |              0.002 |              0.013 |            0.026 |           0.107 |                  0.028 |           0.006 |
| Chubut                        |         301 |   3050 |          3 |               20.7 |              0.005 |              0.010 |            0.099 |           0.050 |                  0.013 |           0.010 |
| Corrientes                    |         196 |   4519 |          2 |               12.0 |              0.005 |              0.010 |            0.043 |           0.026 |                  0.010 |           0.005 |
| La Pampa                      |         165 |   1257 |          0 |                NaN |              0.000 |              0.000 |            0.131 |           0.036 |                  0.006 |           0.000 |
| Formosa                       |          80 |    849 |          0 |                NaN |              0.000 |              0.000 |            0.094 |           0.013 |                  0.000 |           0.000 |
| Santiago del Estero           |          68 |   5475 |          0 |                NaN |              0.000 |              0.000 |            0.012 |           0.029 |                  0.015 |           0.000 |
| Catamarca                     |          60 |   2130 |          0 |                NaN |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          51 |   2198 |          2 |                6.5 |              0.011 |              0.039 |            0.023 |           0.588 |                  0.118 |           0.059 |
| San Luis                      |          33 |    860 |          0 |                NaN |              0.000 |              0.000 |            0.038 |           0.303 |                  0.030 |           0.000 |
| San Juan                      |          23 |   1039 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.217 |                  0.043 |           0.000 |

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
    #> INFO  [01:40:36.078] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 23
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-08-01              |                        38 |          97 |    666 |         66 |          9 |              0.065 |              0.093 |            0.146 |           0.680 |                  0.124 |           0.062 |
|             12 | 2020-08-01              |                        61 |         413 |   2049 |        255 |         17 |              0.033 |              0.041 |            0.202 |           0.617 |                  0.092 |           0.053 |
|             13 | 2020-08-01              |                        94 |        1085 |   5517 |        600 |         63 |              0.049 |              0.058 |            0.197 |           0.553 |                  0.094 |           0.056 |
|             14 | 2020-08-04              |                       125 |        1776 |  11537 |        974 |        114 |              0.053 |              0.064 |            0.154 |           0.548 |                  0.095 |           0.056 |
|             15 | 2020-08-05              |                       148 |        2440 |  20256 |       1322 |        179 |              0.059 |              0.073 |            0.120 |           0.542 |                  0.090 |           0.051 |
|             16 | 2020-08-05              |                       158 |        3238 |  31861 |       1671 |        236 |              0.057 |              0.073 |            0.102 |           0.516 |                  0.081 |           0.044 |
|             17 | 2020-08-05              |                       161 |        4351 |  45912 |       2190 |        341 |              0.062 |              0.078 |            0.095 |           0.503 |                  0.073 |           0.038 |
|             18 | 2020-08-05              |                       161 |        5352 |  59105 |       2588 |        413 |              0.061 |              0.077 |            0.091 |           0.484 |                  0.065 |           0.035 |
|             19 | 2020-08-05              |                       161 |        6795 |  73238 |       3175 |        493 |              0.058 |              0.073 |            0.093 |           0.467 |                  0.061 |           0.032 |
|             20 | 2020-08-05              |                       161 |        9194 |  90603 |       4017 |        588 |              0.052 |              0.064 |            0.101 |           0.437 |                  0.056 |           0.029 |
|             21 | 2020-08-05              |                       161 |       13556 | 114036 |       5333 |        739 |              0.045 |              0.055 |            0.119 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-08-05              |                       161 |       18787 | 139397 |       6773 |        923 |              0.041 |              0.049 |            0.135 |           0.361 |                  0.044 |           0.022 |
|             23 | 2020-08-05              |                       161 |       25214 | 167660 |       8304 |       1140 |              0.038 |              0.045 |            0.150 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-08-05              |                       161 |       34814 | 202749 |      10434 |       1386 |              0.034 |              0.040 |            0.172 |           0.300 |                  0.036 |           0.017 |
|             25 | 2020-08-05              |                       161 |       47620 | 244112 |      12764 |       1698 |              0.030 |              0.036 |            0.195 |           0.268 |                  0.031 |           0.014 |
|             26 | 2020-08-05              |                       161 |       65284 | 295993 |      15795 |       2085 |              0.027 |              0.032 |            0.221 |           0.242 |                  0.028 |           0.012 |
|             27 | 2020-08-05              |                       161 |       83866 | 346531 |      18518 |       2517 |              0.025 |              0.030 |            0.242 |           0.221 |                  0.025 |           0.011 |
|             28 | 2020-08-05              |                       162 |      107027 | 405041 |      21704 |       3018 |              0.024 |              0.028 |            0.264 |           0.203 |                  0.023 |           0.010 |
|             29 | 2020-08-05              |                       163 |      135387 | 475351 |      25017 |       3512 |              0.022 |              0.026 |            0.285 |           0.185 |                  0.021 |           0.009 |
|             30 | 2020-08-05              |                       163 |      171635 | 558185 |      28087 |       3898 |              0.019 |              0.023 |            0.307 |           0.164 |                  0.019 |           0.008 |
|             31 | 2020-08-29              |                       164 |      207290 | 639787 |      30182 |       4073 |              0.016 |              0.020 |            0.324 |           0.146 |                  0.017 |           0.007 |
|             32 | 2020-08-29              |                       164 |      220669 | 671066 |      30807 |       4106 |              0.014 |              0.019 |            0.329 |           0.140 |                  0.016 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [01:41:21.336] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [01:41:44.018] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [01:41:56.708] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [01:41:58.115] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [01:42:01.511] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [01:42:03.530] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [01:42:08.079] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [01:42:10.455] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [01:42:12.797] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [01:42:14.432] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [01:42:17.013] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [01:42:19.045] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [01:42:21.209] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [01:42:23.665] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [01:42:25.691] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [01:42:27.952] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [01:42:30.524] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [01:42:32.672] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [01:42:34.650] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [01:42:36.710] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [01:42:38.943] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [01:42:42.670] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [01:42:45.589] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [01:42:48.025] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [01:42:50.267] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       68336 |       7867 |       1278 |              0.013 |              0.019 |            0.404 |           0.115 |                  0.015 |           0.007 |
| Buenos Aires                  | F    |       64535 |       6565 |        983 |              0.011 |              0.015 |            0.368 |           0.102 |                  0.011 |           0.004 |
| CABA                          | F    |       32794 |       6234 |        609 |              0.015 |              0.019 |            0.386 |           0.190 |                  0.014 |           0.006 |
| CABA                          | M    |       31971 |       6407 |        753 |              0.020 |              0.024 |            0.425 |           0.200 |                  0.023 |           0.011 |
| Chaco                         | F    |        1913 |        223 |         58 |              0.023 |              0.030 |            0.162 |           0.117 |                  0.061 |           0.021 |
| Chaco                         | M    |        1910 |        220 |         96 |              0.038 |              0.050 |            0.162 |           0.115 |                  0.077 |           0.033 |
| Jujuy                         | M    |        1782 |         15 |         18 |              0.005 |              0.010 |            0.306 |           0.008 |                  0.002 |           0.002 |
| Córdoba                       | M    |        1429 |         74 |         26 |              0.012 |              0.018 |            0.087 |           0.052 |                  0.016 |           0.009 |
| Córdoba                       | F    |        1418 |         80 |         26 |              0.012 |              0.018 |            0.083 |           0.056 |                  0.014 |           0.006 |
| Río Negro                     | F    |        1275 |        364 |         28 |              0.019 |              0.022 |            0.289 |           0.285 |                  0.011 |           0.005 |
| Río Negro                     | M    |        1168 |        355 |         49 |              0.036 |              0.042 |            0.307 |           0.304 |                  0.027 |           0.021 |
| Jujuy                         | F    |        1099 |          4 |         13 |              0.004 |              0.012 |            0.232 |           0.004 |                  0.001 |           0.001 |
| Mendoza                       | F    |         853 |        315 |         14 |              0.013 |              0.016 |            0.207 |           0.369 |                  0.011 |           0.001 |
| Santa Fe                      | F    |         830 |         61 |          6 |              0.005 |              0.007 |            0.072 |           0.073 |                  0.016 |           0.004 |
| Mendoza                       | M    |         810 |        310 |         31 |              0.027 |              0.038 |            0.206 |           0.383 |                  0.036 |           0.010 |
| Santa Fe                      | M    |         807 |         97 |         12 |              0.010 |              0.015 |            0.076 |           0.120 |                  0.027 |           0.012 |
| SIN ESPECIFICAR               | F    |         778 |         46 |          1 |              0.001 |              0.001 |            0.448 |           0.059 |                  0.004 |           0.000 |
| Neuquén                       | M    |         668 |        428 |         12 |              0.015 |              0.018 |            0.274 |           0.641 |                  0.016 |           0.010 |
| Neuquén                       | F    |         655 |        460 |         14 |              0.018 |              0.021 |            0.270 |           0.702 |                  0.021 |           0.011 |
| SIN ESPECIFICAR               | M    |         512 |         44 |          2 |              0.003 |              0.004 |            0.459 |           0.086 |                  0.012 |           0.010 |
| Buenos Aires                  | NR   |         486 |         47 |         12 |              0.015 |              0.025 |            0.399 |           0.097 |                  0.027 |           0.014 |
| Entre Ríos                    | M    |         477 |        109 |          6 |              0.009 |              0.013 |            0.188 |           0.229 |                  0.010 |           0.002 |
| Entre Ríos                    | F    |         462 |         87 |          5 |              0.008 |              0.011 |            0.170 |           0.188 |                  0.013 |           0.002 |
| Tierra del Fuego              | M    |         439 |          8 |          2 |              0.003 |              0.005 |            0.251 |           0.018 |                  0.007 |           0.007 |
| Santa Cruz                    | M    |         313 |         23 |          2 |              0.006 |              0.006 |            0.378 |           0.073 |                  0.022 |           0.010 |
| Santa Cruz                    | F    |         300 |         23 |          1 |              0.003 |              0.003 |            0.413 |           0.077 |                  0.020 |           0.013 |
| Tierra del Fuego              | F    |         294 |          5 |          0 |              0.000 |              0.000 |            0.193 |           0.017 |                  0.000 |           0.000 |
| CABA                          | NR   |         253 |         75 |         15 |              0.035 |              0.059 |            0.378 |           0.296 |                  0.051 |           0.036 |
| Salta                         | M    |         222 |         71 |          2 |              0.005 |              0.009 |            0.168 |           0.320 |                  0.023 |           0.014 |
| La Rioja                      | F    |         217 |         15 |          7 |              0.028 |              0.032 |            0.107 |           0.069 |                  0.023 |           0.009 |
| La Rioja                      | M    |         190 |         12 |         11 |              0.049 |              0.058 |            0.089 |           0.063 |                  0.005 |           0.000 |
| Tucumán                       | M    |         181 |         19 |          2 |              0.002 |              0.011 |            0.023 |           0.105 |                  0.017 |           0.000 |
| Chubut                        | M    |         163 |         11 |          1 |              0.003 |              0.006 |            0.104 |           0.067 |                  0.012 |           0.012 |
| Salta                         | F    |         147 |         49 |          0 |              0.000 |              0.000 |            0.201 |           0.333 |                  0.014 |           0.000 |
| Tucumán                       | F    |         136 |         15 |          2 |              0.003 |              0.015 |            0.029 |           0.110 |                  0.044 |           0.015 |
| Chubut                        | F    |         134 |          4 |          2 |              0.008 |              0.015 |            0.093 |           0.030 |                  0.015 |           0.007 |
| Corrientes                    | M    |         108 |          5 |          2 |              0.008 |              0.019 |            0.043 |           0.046 |                  0.009 |           0.009 |
| La Pampa                      | F    |          96 |          4 |          0 |              0.000 |              0.000 |            0.141 |           0.042 |                  0.000 |           0.000 |
| Corrientes                    | F    |          88 |          0 |          0 |              0.000 |              0.000 |            0.044 |           0.000 |                  0.011 |           0.000 |
| La Pampa                      | M    |          69 |          2 |          0 |              0.000 |              0.000 |            0.120 |           0.029 |                  0.014 |           0.000 |
| Formosa                       | M    |          66 |          0 |          0 |              0.000 |              0.000 |            0.131 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          43 |          2 |          0 |              0.000 |              0.000 |            0.011 |           0.047 |                  0.023 |           0.000 |
| Catamarca                     | M    |          38 |          0 |          0 |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          29 |         16 |          1 |              0.009 |              0.034 |            0.025 |           0.552 |                  0.138 |           0.069 |
| San Luis                      | M    |          26 |          8 |          0 |              0.000 |              0.000 |            0.054 |           0.308 |                  0.038 |           0.000 |
| Santiago del Estero           | F    |          25 |          0 |          0 |              0.000 |              0.000 |            0.017 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          22 |         14 |          1 |              0.013 |              0.045 |            0.021 |           0.636 |                  0.091 |           0.045 |
| San Juan                      | M    |          16 |          2 |          0 |              0.000 |              0.000 |            0.027 |           0.125 |                  0.000 |           0.000 |
| Formosa                       | F    |          14 |          1 |          0 |              0.000 |              0.000 |            0.041 |           0.071 |                  0.000 |           0.000 |
| Mendoza                       | NR   |          11 |          4 |          2 |              0.087 |              0.182 |            0.220 |           0.364 |                  0.000 |           0.000 |


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
