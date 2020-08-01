
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
    covid19.curator <- COVID19ARCurator$new(download.new.data = FALSE)

    dummy <- covid19.curator$loadData()
    #> INFO  [21:17:14.878] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [21:17:20.088] Normalize 
    #> INFO  [21:17:20.874] checkSoundness 
    #> INFO  [21:17:21.369] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-07-30"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-07-30"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-07-30"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| 2020-07-30              |      185360 |       3441 |              0.014 |              0.019 |                       157 | 593365 |            0.312 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|-------:|-----------------:|
| Buenos Aires                  |      110044 |       1845 |              0.012 |              0.017 |                       155 | 301461 |            0.365 |
| CABA                          |       58093 |       1203 |              0.017 |              0.021 |                       153 | 145493 |            0.399 |
| Chaco                         |        3521 |        140 |              0.030 |              0.040 |                       141 |  21639 |            0.163 |
| Córdoba                       |        2147 |         46 |              0.012 |              0.021 |                       143 |  30400 |            0.071 |
| Jujuy                         |        2021 |         31 |              0.005 |              0.015 |                       131 |   8868 |            0.228 |
| Río Negro                     |        1843 |         69 |              0.033 |              0.037 |                       136 |   7116 |            0.259 |
| Santa Fe                      |        1153 |         12 |              0.007 |              0.010 |                       139 |  20209 |            0.057 |
| Neuquén                       |        1152 |         23 |              0.017 |              0.020 |                       138 |   4446 |            0.259 |
| SIN ESPECIFICAR               |        1094 |          3 |              0.002 |              0.003 |                       129 |   2505 |            0.437 |
| Mendoza                       |        1088 |         31 |              0.020 |              0.028 |                       142 |   6705 |            0.162 |
| Entre Ríos                    |         804 |          7 |              0.006 |              0.009 |                       136 |   4716 |            0.170 |
| Tierra del Fuego              |         434 |          2 |              0.003 |              0.005 |                       135 |   2631 |            0.165 |
| Santa Cruz                    |         430 |          2 |              0.004 |              0.005 |                       128 |   1274 |            0.338 |
| La Rioja                      |         302 |         16 |              0.044 |              0.053 |                       127 |   3714 |            0.081 |
| Chubut                        |         273 |          2 |              0.004 |              0.007 |                       122 |   2847 |            0.096 |
| Salta                         |         246 |          2 |              0.004 |              0.008 |                       131 |   1812 |            0.136 |
| Tucumán                       |         196 |          4 |              0.004 |              0.020 |                       134 |  11061 |            0.018 |
| Corrientes                    |         165 |          1 |              0.003 |              0.006 |                       133 |   4075 |            0.040 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|-------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      110044 | 301461 |       1845 |               13.4 |              0.012 |              0.017 |            0.365 |           0.117 |                  0.014 |           0.006 |
| CABA                          |       58093 | 145493 |       1203 |               14.8 |              0.017 |              0.021 |            0.399 |           0.205 |                  0.019 |           0.009 |
| Chaco                         |        3521 |  21639 |        140 |               14.5 |              0.030 |              0.040 |            0.163 |           0.109 |                  0.067 |           0.027 |
| Córdoba                       |        2147 |  30400 |         46 |               22.8 |              0.012 |              0.021 |            0.071 |           0.069 |                  0.019 |           0.010 |
| Jujuy                         |        2021 |   8868 |         31 |               12.6 |              0.005 |              0.015 |            0.228 |           0.007 |                  0.002 |           0.002 |
| Río Negro                     |        1843 |   7116 |         69 |               13.2 |              0.033 |              0.037 |            0.259 |           0.362 |                  0.024 |           0.017 |
| Santa Fe                      |        1153 |  20209 |         12 |               15.4 |              0.007 |              0.010 |            0.057 |           0.120 |                  0.025 |           0.009 |
| Neuquén                       |        1152 |   4446 |         23 |               18.6 |              0.017 |              0.020 |            0.259 |           0.678 |                  0.012 |           0.005 |
| SIN ESPECIFICAR               |        1094 |   2505 |          3 |               26.7 |              0.002 |              0.003 |            0.437 |           0.080 |                  0.009 |           0.005 |
| Mendoza                       |        1088 |   6705 |         31 |               10.3 |              0.020 |              0.028 |            0.162 |           0.457 |                  0.030 |           0.007 |
| Entre Ríos                    |         804 |   4716 |          7 |                9.9 |              0.006 |              0.009 |            0.170 |           0.218 |                  0.007 |           0.002 |
| Tierra del Fuego              |         434 |   2631 |          2 |               19.0 |              0.003 |              0.005 |            0.165 |           0.025 |                  0.007 |           0.007 |
| Santa Cruz                    |         430 |   1274 |          2 |               10.5 |              0.004 |              0.005 |            0.338 |           0.074 |                  0.016 |           0.012 |
| La Rioja                      |         302 |   3714 |         16 |               13.2 |              0.044 |              0.053 |            0.081 |           0.083 |                  0.020 |           0.007 |
| Chubut                        |         273 |   2847 |          2 |               10.5 |              0.004 |              0.007 |            0.096 |           0.051 |                  0.015 |           0.011 |
| Salta                         |         246 |   1812 |          2 |                2.5 |              0.004 |              0.008 |            0.136 |           0.366 |                  0.020 |           0.008 |
| Tucumán                       |         196 |  11061 |          4 |               14.2 |              0.004 |              0.020 |            0.018 |           0.168 |                  0.046 |           0.010 |
| Corrientes                    |         165 |   4075 |          1 |               12.0 |              0.003 |              0.006 |            0.040 |           0.024 |                  0.012 |           0.006 |
| Formosa                       |          79 |    825 |          0 |                NaN |              0.000 |              0.000 |            0.096 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      |          75 |    767 |          0 |                NaN |              0.000 |              0.000 |            0.098 |           0.040 |                  0.013 |           0.000 |
| Catamarca                     |          60 |   1972 |          0 |                NaN |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           |          47 |   4942 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.043 |                  0.021 |           0.000 |
| Misiones                      |          45 |   2097 |          2 |                6.5 |              0.016 |              0.044 |            0.021 |           0.644 |                  0.133 |           0.067 |
| San Luis                      |          27 |    804 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.370 |                  0.037 |           0.000 |
| San Juan                      |          21 |    986 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.238 |                  0.048 |           0.000 |


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
    #> INFO  [21:18:57.098] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 22
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|-------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-07-29              |                        37 |          96 |    666 |         66 |          9 |              0.066 |              0.094 |            0.144 |           0.688 |                  0.125 |           0.062 |
|             12 | 2020-07-29              |                        60 |         412 |   2049 |        255 |         17 |              0.033 |              0.041 |            0.201 |           0.619 |                  0.092 |           0.053 |
|             13 | 2020-07-30              |                        92 |        1084 |   5516 |        600 |         63 |              0.049 |              0.058 |            0.197 |           0.554 |                  0.094 |           0.056 |
|             14 | 2020-07-30              |                       121 |        1768 |  11535 |        968 |        114 |              0.053 |              0.064 |            0.153 |           0.548 |                  0.094 |           0.057 |
|             15 | 2020-07-30              |                       143 |        2427 |  20250 |       1313 |        177 |              0.058 |              0.073 |            0.120 |           0.541 |                  0.090 |           0.051 |
|             16 | 2020-07-30              |                       152 |        3219 |  31851 |       1659 |        233 |              0.057 |              0.072 |            0.101 |           0.515 |                  0.080 |           0.044 |
|             17 | 2020-07-30              |                       155 |        4323 |  45901 |       2176 |        337 |              0.062 |              0.078 |            0.094 |           0.503 |                  0.072 |           0.038 |
|             18 | 2020-07-30              |                       155 |        5314 |  59092 |       2568 |        402 |              0.060 |              0.076 |            0.090 |           0.483 |                  0.065 |           0.035 |
|             19 | 2020-07-30              |                       155 |        6746 |  73222 |       3152 |        480 |              0.057 |              0.071 |            0.092 |           0.467 |                  0.061 |           0.032 |
|             20 | 2020-07-30              |                       155 |        9123 |  90587 |       3986 |        571 |              0.051 |              0.063 |            0.101 |           0.437 |                  0.056 |           0.029 |
|             21 | 2020-07-30              |                       155 |       13453 | 114013 |       5291 |        717 |              0.044 |              0.053 |            0.118 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-07-30              |                       155 |       18659 | 139367 |       6722 |        890 |              0.040 |              0.048 |            0.134 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-30              |                       155 |       25054 | 167626 |       8241 |       1098 |              0.037 |              0.044 |            0.149 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-07-30              |                       155 |       34594 | 202692 |      10355 |       1325 |              0.032 |              0.038 |            0.171 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-07-30              |                       155 |       47339 | 244035 |      12657 |       1610 |              0.029 |              0.034 |            0.194 |           0.267 |                  0.031 |           0.014 |
|             26 | 2020-07-30              |                       155 |       64939 | 295866 |      15655 |       1971 |              0.026 |              0.030 |            0.219 |           0.241 |                  0.028 |           0.012 |
|             27 | 2020-07-30              |                       155 |       83417 | 346226 |      18306 |       2347 |              0.024 |              0.028 |            0.241 |           0.219 |                  0.025 |           0.011 |
|             28 | 2020-07-30              |                       156 |      106412 | 404548 |      21370 |       2769 |              0.022 |              0.026 |            0.263 |           0.201 |                  0.023 |           0.010 |
|             29 | 2020-07-30              |                       157 |      134420 | 474233 |      24470 |       3153 |              0.019 |              0.023 |            0.283 |           0.182 |                  0.020 |           0.009 |
|             30 | 2020-07-30              |                       157 |      169211 | 554517 |      27118 |       3400 |              0.016 |              0.020 |            0.305 |           0.160 |                  0.018 |           0.008 |
|             31 | 2020-07-30              |                       157 |      185360 | 593365 |      27995 |       3441 |              0.014 |              0.019 |            0.312 |           0.151 |                  0.017 |           0.007 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [21:19:36.133] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [21:20:06.908] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [21:20:20.066] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [21:20:21.453] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [21:20:25.940] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [21:20:28.181] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [21:20:34.530] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [21:20:38.715] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [21:20:41.206] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [21:20:42.917] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [21:20:46.168] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [21:20:48.765] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [21:20:55.054] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [21:20:57.903] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [21:20:59.808] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [21:21:01.935] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [21:21:04.327] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [21:21:06.278] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [21:21:08.138] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [21:21:10.095] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [21:21:13.362] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [21:21:16.516] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [21:21:18.550] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [21:21:20.425] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [21:21:22.450] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 486
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
    #> [1] 62
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |       56331 |       7006 |       1039 |              0.013 |              0.018 |            0.384 |           0.124 |                  0.017 |           0.007 |
| Buenos Aires                  | F    |       53306 |       5861 |        799 |              0.011 |              0.015 |            0.347 |           0.110 |                  0.012 |           0.004 |
| CABA                          | F    |       29195 |       5849 |        530 |              0.015 |              0.018 |            0.381 |           0.200 |                  0.014 |           0.006 |
| CABA                          | M    |       28661 |       6015 |        658 |              0.019 |              0.023 |            0.420 |           0.210 |                  0.024 |           0.011 |
| Chaco                         | F    |        1771 |        187 |         51 |              0.022 |              0.029 |            0.163 |           0.106 |                  0.057 |           0.020 |
| Chaco                         | M    |        1748 |        198 |         89 |              0.038 |              0.051 |            0.162 |           0.113 |                  0.077 |           0.034 |
| Jujuy                         | M    |        1295 |         12 |         18 |              0.006 |              0.014 |            0.260 |           0.009 |                  0.002 |           0.002 |
| Córdoba                       | M    |        1074 |         68 |         23 |              0.013 |              0.021 |            0.072 |           0.063 |                  0.020 |           0.011 |
| Córdoba                       | F    |        1071 |         80 |         23 |              0.012 |              0.021 |            0.069 |           0.075 |                  0.019 |           0.008 |
| Río Negro                     | F    |         947 |        340 |         25 |              0.023 |              0.026 |            0.248 |           0.359 |                  0.015 |           0.007 |
| Río Negro                     | M    |         896 |        328 |         44 |              0.043 |              0.049 |            0.272 |           0.366 |                  0.035 |           0.027 |
| Jujuy                         | F    |         723 |          3 |         13 |              0.005 |              0.018 |            0.187 |           0.004 |                  0.001 |           0.001 |
| SIN ESPECIFICAR               | F    |         644 |         44 |          0 |              0.000 |              0.000 |            0.427 |           0.068 |                  0.005 |           0.000 |
| Neuquén                       | M    |         589 |        376 |         10 |              0.014 |              0.017 |            0.263 |           0.638 |                  0.012 |           0.005 |
| Santa Fe                      | F    |         585 |         52 |          4 |              0.005 |              0.007 |            0.056 |           0.089 |                  0.017 |           0.003 |
| Santa Fe                      | M    |         568 |         86 |          8 |              0.010 |              0.014 |            0.058 |           0.151 |                  0.033 |           0.014 |
| Neuquén                       | F    |         563 |        405 |         13 |              0.019 |              0.023 |            0.256 |           0.719 |                  0.012 |           0.005 |
| Mendoza                       | M    |         541 |        248 |         20 |              0.026 |              0.037 |            0.164 |           0.458 |                  0.046 |           0.013 |
| Mendoza                       | F    |         540 |        245 |          9 |              0.012 |              0.017 |            0.160 |           0.454 |                  0.015 |           0.002 |
| SIN ESPECIFICAR               | M    |         446 |         42 |          2 |              0.003 |              0.004 |            0.454 |           0.094 |                  0.013 |           0.011 |
| Entre Ríos                    | M    |         411 |         99 |          4 |              0.007 |              0.010 |            0.180 |           0.241 |                  0.007 |           0.002 |
| Buenos Aires                  | NR   |         407 |         38 |          7 |              0.010 |              0.017 |            0.383 |           0.093 |                  0.025 |           0.012 |
| Entre Ríos                    | F    |         392 |         76 |          3 |              0.006 |              0.008 |            0.162 |           0.194 |                  0.008 |           0.003 |
| Tierra del Fuego              | M    |         268 |          7 |          2 |              0.005 |              0.007 |            0.187 |           0.026 |                  0.011 |           0.011 |
| CABA                          | NR   |         237 |         73 |         15 |              0.036 |              0.063 |            0.377 |           0.308 |                  0.055 |           0.038 |
| Santa Cruz                    | M    |         219 |         18 |          2 |              0.009 |              0.009 |            0.317 |           0.082 |                  0.023 |           0.014 |
| Santa Cruz                    | F    |         210 |         14 |          0 |              0.000 |              0.000 |            0.361 |           0.067 |                  0.010 |           0.010 |
| Tierra del Fuego              | F    |         165 |          4 |          0 |              0.000 |              0.000 |            0.138 |           0.024 |                  0.000 |           0.000 |
| La Rioja                      | F    |         160 |         14 |          7 |              0.037 |              0.044 |            0.089 |           0.088 |                  0.031 |           0.013 |
| Salta                         | M    |         153 |         55 |          2 |              0.007 |              0.013 |            0.131 |           0.359 |                  0.026 |           0.013 |
| Chubut                        | M    |         149 |         10 |          1 |              0.003 |              0.007 |            0.102 |           0.067 |                  0.013 |           0.013 |
| La Rioja                      | M    |         140 |         11 |          9 |              0.053 |              0.064 |            0.074 |           0.079 |                  0.007 |           0.000 |
| Tucumán                       | M    |         125 |         18 |          2 |              0.003 |              0.016 |            0.018 |           0.144 |                  0.024 |           0.000 |
| Chubut                        | F    |         120 |          4 |          1 |              0.004 |              0.008 |            0.089 |           0.033 |                  0.017 |           0.008 |
| Corrientes                    | M    |          96 |          4 |          1 |              0.005 |              0.010 |            0.042 |           0.042 |                  0.010 |           0.010 |
| Salta                         | F    |          93 |         35 |          0 |              0.000 |              0.000 |            0.147 |           0.376 |                  0.011 |           0.000 |
| Tucumán                       | F    |          71 |         15 |          2 |              0.005 |              0.028 |            0.017 |           0.211 |                  0.085 |           0.028 |
| Corrientes                    | F    |          69 |          0 |          0 |              0.000 |              0.000 |            0.038 |           0.000 |                  0.014 |           0.000 |
| Formosa                       | M    |          66 |          0 |          0 |              0.000 |              0.000 |            0.134 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     | M    |          38 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      | M    |          38 |          2 |          0 |              0.000 |              0.000 |            0.099 |           0.053 |                  0.026 |           0.000 |
| La Pampa                      | F    |          37 |          1 |          0 |              0.000 |              0.000 |            0.097 |           0.027 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          34 |          2 |          0 |              0.000 |              0.000 |            0.010 |           0.059 |                  0.029 |           0.000 |
| Misiones                      | M    |          25 |         16 |          1 |              0.014 |              0.040 |            0.023 |           0.640 |                  0.160 |           0.080 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.018 |              0.050 |            0.020 |           0.650 |                  0.100 |           0.050 |
| San Luis                      | M    |          20 |          8 |          0 |              0.000 |              0.000 |            0.045 |           0.400 |                  0.050 |           0.000 |
| San Juan                      | M    |          15 |          2 |          0 |              0.000 |              0.000 |            0.027 |           0.133 |                  0.000 |           0.000 |
| Formosa                       | F    |          13 |          0 |          0 |              0.000 |              0.000 |            0.039 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          13 |          0 |          0 |              0.000 |              0.000 |            0.010 |           0.000 |                  0.000 |           0.000 |


    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))
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
