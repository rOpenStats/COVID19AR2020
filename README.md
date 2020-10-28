
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
    #> INFO  [11:42:28.801] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
    dummy <- covid19.curator$curateData()
    #> INFO  [11:42:42.993] Normalize 
    #> INFO  [11:42:46.937] checkSoundness 
    #> INFO  [11:42:48.630] Mutating data
    # Dates of current processed file
    max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
    #> [1] "2020-10-26"
    # Inicio de síntomas

    max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    #> [1] "2020-10-26"

    # Ultima muerte
    max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
    #> [1] "2020-10-26"

    report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

    kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-10-26              |     1102297 |      29301 |              0.023 |              0.027 |                       250 | 2260552 |            0.488 |


    covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
      filter(confirmados >= 100) %>%
      arrange(desc(confirmados))
    # Provinces with > 100 confirmed cases
    kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| Buenos Aires                  |      529569 |      16825 |              0.027 |              0.032 |                       243 | 1109943 |            0.477 |
| CABA                          |      143460 |       4741 |              0.030 |              0.033 |                       241 |  379630 |            0.378 |
| Santa Fe                      |       96239 |       1113 |              0.011 |              0.012 |                       227 |  126442 |            0.761 |
| Córdoba                       |       77253 |       1161 |              0.012 |              0.015 |                       233 |  115793 |            0.667 |
| Tucumán                       |       44116 |        685 |              0.010 |              0.016 |                       222 |   55689 |            0.792 |
| Mendoza                       |       43590 |        727 |              0.014 |              0.017 |                       232 |   79245 |            0.550 |
| Río Negro                     |       22085 |        576 |              0.023 |              0.026 |                       224 |   37849 |            0.584 |
| Neuquén                       |       19775 |        354 |              0.014 |              0.018 |                       226 |   27429 |            0.721 |
| Salta                         |       17870 |        726 |              0.033 |              0.041 |                       219 |   33022 |            0.541 |
| Jujuy                         |       17647 |        791 |              0.036 |              0.045 |                       221 |   42354 |            0.417 |
| Entre Ríos                    |       14292 |        250 |              0.015 |              0.017 |                       224 |   27515 |            0.519 |
| Chaco                         |       13226 |        401 |              0.022 |              0.030 |                       229 |   59642 |            0.222 |
| Chubut                        |       12980 |        157 |              0.010 |              0.012 |                       210 |   16230 |            0.800 |
| Tierra del Fuego              |       10352 |        131 |              0.011 |              0.013 |                       223 |   17156 |            0.603 |
| Santiago del Estero           |        8623 |        109 |              0.010 |              0.013 |                       210 |   30047 |            0.287 |
| Santa Cruz                    |        8548 |        117 |              0.011 |              0.014 |                       216 |   15204 |            0.562 |
| La Rioja                      |        7169 |        254 |              0.033 |              0.035 |                       216 |   19326 |            0.371 |
| San Luis                      |        5626 |         37 |              0.004 |              0.007 |                       200 |   17032 |            0.330 |
| SIN ESPECIFICAR               |        2567 |         21 |              0.007 |              0.008 |                       217 |    5868 |            0.437 |
| La Pampa                      |        2524 |         25 |              0.006 |              0.010 |                       204 |   12108 |            0.208 |
| Corrientes                    |        2383 |         38 |              0.010 |              0.016 |                       221 |   13835 |            0.172 |
| San Juan                      |        1395 |         56 |              0.019 |              0.040 |                       213 |    2707 |            0.515 |
| Catamarca                     |         637 |          0 |              0.000 |              0.000 |                       194 |    8463 |            0.075 |
| Misiones                      |         229 |          5 |              0.010 |              0.022 |                       201 |    6495 |            0.035 |
| Formosa                       |         142 |          1 |              0.005 |              0.007 |                       195 |    1528 |            0.093 |

    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
    nrow(covid19.ar.summary)
    #> [1] 25
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
            select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))

| residencia\_provincia\_nombre | confirmados |   tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|--------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      529569 | 1109943 |      16825 |               16.6 |              0.027 |              0.032 |            0.477 |           0.066 |                  0.010 |           0.005 |
| CABA                          |      143460 |  379630 |       4741 |               17.0 |              0.030 |              0.033 |            0.378 |           0.145 |                  0.017 |           0.009 |
| Santa Fe                      |       96239 |  126442 |       1113 |               13.1 |              0.011 |              0.012 |            0.761 |           0.024 |                  0.006 |           0.004 |
| Córdoba                       |       77253 |  115793 |       1161 |               12.8 |              0.012 |              0.015 |            0.667 |           0.017 |                  0.008 |           0.002 |
| Tucumán                       |       44116 |   55689 |        685 |               11.1 |              0.010 |              0.016 |            0.792 |           0.008 |                  0.002 |           0.001 |
| Mendoza                       |       43590 |   79245 |        727 |               12.3 |              0.014 |              0.017 |            0.550 |           0.060 |                  0.006 |           0.003 |
| Río Negro                     |       22085 |   37849 |        576 |               14.7 |              0.023 |              0.026 |            0.584 |           0.161 |                  0.007 |           0.005 |
| Neuquén                       |       19775 |   27429 |        354 |               17.7 |              0.014 |              0.018 |            0.721 |           0.414 |                  0.009 |           0.007 |
| Salta                         |       17870 |   33022 |        726 |               13.9 |              0.033 |              0.041 |            0.541 |           0.103 |                  0.019 |           0.010 |
| Jujuy                         |       17647 |   42354 |        791 |               18.5 |              0.036 |              0.045 |            0.417 |           0.020 |                  0.009 |           0.005 |
| Entre Ríos                    |       14292 |   27515 |        250 |               13.5 |              0.015 |              0.017 |            0.519 |           0.069 |                  0.007 |           0.003 |
| Chaco                         |       13226 |   59642 |        401 |               14.6 |              0.022 |              0.030 |            0.222 |           0.081 |                  0.042 |           0.020 |
| Chubut                        |       12980 |   16230 |        157 |               10.6 |              0.010 |              0.012 |            0.800 |           0.009 |                  0.003 |           0.002 |
| Tierra del Fuego              |       10352 |   17156 |        131 |               15.6 |              0.011 |              0.013 |            0.603 |           0.018 |                  0.006 |           0.005 |
| Santiago del Estero           |        8623 |   30047 |        109 |               11.6 |              0.010 |              0.013 |            0.287 |           0.016 |                  0.001 |           0.001 |
| Santa Cruz                    |        8548 |   15204 |        117 |               15.0 |              0.011 |              0.014 |            0.562 |           0.057 |                  0.013 |           0.009 |
| La Rioja                      |        7169 |   19326 |        254 |               16.4 |              0.033 |              0.035 |            0.371 |           0.007 |                  0.002 |           0.001 |
| San Luis                      |        5626 |   17032 |         37 |               13.9 |              0.004 |              0.007 |            0.330 |           0.021 |                  0.003 |           0.001 |
| SIN ESPECIFICAR               |        2567 |    5868 |         21 |               18.9 |              0.007 |              0.008 |            0.437 |           0.065 |                  0.008 |           0.004 |
| La Pampa                      |        2524 |   12108 |         25 |               16.2 |              0.006 |              0.010 |            0.208 |           0.023 |                  0.006 |           0.002 |
| Corrientes                    |        2383 |   13835 |         38 |                9.9 |              0.010 |              0.016 |            0.172 |           0.018 |                  0.014 |           0.008 |
| San Juan                      |        1395 |    2707 |         56 |               11.2 |              0.019 |              0.040 |            0.515 |           0.049 |                  0.022 |           0.007 |
| Catamarca                     |         637 |    8463 |          0 |                NaN |              0.000 |              0.000 |            0.075 |           0.014 |                  0.000 |           0.000 |
| Misiones                      |         229 |    6495 |          5 |                7.0 |              0.010 |              0.022 |            0.035 |           0.284 |                  0.035 |           0.013 |
| Formosa                       |         142 |    1528 |          1 |               12.0 |              0.005 |              0.007 |            0.093 |           0.373 |                  0.000 |           0.000 |

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
    #> INFO  [11:52:12.913] Processing {current.group: }
    nrow(covid19.ar.summary)
    #> [1] 35
    porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
    kable(covid19.ar.summary %>% 
            filter(confirmados > 0) %>% 
            arrange(sepi_apertura, desc(confirmados)) %>% 
            select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-10-17              |                        21 |          16 |      86 |          9 |          1 |              0.045 |              0.062 |            0.186 |           0.562 |                  0.125 |           0.125 |
|             11 | 2020-10-25              |                        47 |         103 |     670 |         69 |          9 |              0.065 |              0.087 |            0.154 |           0.670 |                  0.117 |           0.058 |
|             12 | 2020-10-26              |                        83 |         430 |    2058 |        265 |         17 |              0.033 |              0.040 |            0.209 |           0.616 |                  0.088 |           0.051 |
|             13 | 2020-10-26              |                       136 |        1135 |    5537 |        621 |         65 |              0.049 |              0.057 |            0.205 |           0.547 |                  0.090 |           0.054 |
|             14 | 2020-10-26              |                       188 |        1885 |   11575 |       1017 |        120 |              0.054 |              0.064 |            0.163 |           0.540 |                  0.090 |           0.053 |
|             15 | 2020-10-26              |                       222 |        2644 |   20313 |       1391 |        189 |              0.060 |              0.071 |            0.130 |           0.526 |                  0.084 |           0.048 |
|             16 | 2020-10-26              |                       238 |        3586 |   31947 |       1776 |        257 |              0.060 |              0.072 |            0.112 |           0.495 |                  0.074 |           0.041 |
|             17 | 2020-10-26              |                       243 |        4867 |   46031 |       2344 |        383 |              0.066 |              0.079 |            0.106 |           0.482 |                  0.067 |           0.035 |
|             18 | 2020-10-26              |                       243 |        6011 |   59256 |       2782 |        489 |              0.069 |              0.081 |            0.101 |           0.463 |                  0.060 |           0.032 |
|             19 | 2020-10-26              |                       243 |        7639 |   73421 |       3415 |        602 |              0.067 |              0.079 |            0.104 |           0.447 |                  0.056 |           0.029 |
|             20 | 2020-10-26              |                       243 |       10198 |   90890 |       4309 |        728 |              0.062 |              0.071 |            0.112 |           0.423 |                  0.052 |           0.027 |
|             21 | 2020-10-26              |                       243 |       14867 |  114399 |       5712 |        942 |              0.055 |              0.063 |            0.130 |           0.384 |                  0.047 |           0.023 |
|             22 | 2020-10-26              |                       243 |       20375 |  139897 |       7233 |       1214 |              0.053 |              0.060 |            0.146 |           0.355 |                  0.043 |           0.021 |
|             23 | 2020-10-26              |                       243 |       27177 |  168268 |       8848 |       1544 |              0.050 |              0.057 |            0.162 |           0.326 |                  0.040 |           0.019 |
|             24 | 2020-10-26              |                       243 |       37218 |  203534 |      11090 |       1968 |              0.047 |              0.053 |            0.183 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-10-26              |                       243 |       50441 |  245134 |      13564 |       2528 |              0.045 |              0.050 |            0.206 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-10-26              |                       243 |       68818 |  297643 |      16789 |       3291 |              0.043 |              0.048 |            0.231 |           0.244 |                  0.028 |           0.013 |
|             27 | 2020-10-26              |                       243 |       88121 |  349169 |      19716 |       4133 |              0.042 |              0.047 |            0.252 |           0.224 |                  0.026 |           0.011 |
|             28 | 2020-10-26              |                       244 |      112160 |  408657 |      23184 |       5238 |              0.042 |              0.047 |            0.274 |           0.207 |                  0.024 |           0.011 |
|             29 | 2020-10-26              |                       246 |      141912 |  481172 |      26990 |       6559 |              0.041 |              0.046 |            0.295 |           0.190 |                  0.023 |           0.010 |
|             30 | 2020-10-26              |                       246 |      180482 |  567784 |      30837 |       8047 |              0.040 |              0.045 |            0.318 |           0.171 |                  0.021 |           0.010 |
|             31 | 2020-10-26              |                       246 |      220723 |  658663 |      34264 |       9434 |              0.038 |              0.043 |            0.335 |           0.155 |                  0.019 |           0.009 |
|             32 | 2020-10-26              |                       246 |      270846 |  767870 |      38231 |      11129 |              0.036 |              0.041 |            0.353 |           0.141 |                  0.018 |           0.008 |
|             33 | 2020-10-26              |                       246 |      318499 |  882913 |      42072 |      12711 |              0.035 |              0.040 |            0.361 |           0.132 |                  0.017 |           0.008 |
|             34 | 2020-10-26              |                       246 |      368074 |  994348 |      45937 |      14480 |              0.035 |              0.039 |            0.370 |           0.125 |                  0.016 |           0.008 |
|             35 | 2020-10-26              |                       246 |      433897 | 1130852 |      50611 |      16557 |              0.034 |              0.038 |            0.384 |           0.117 |                  0.016 |           0.007 |
|             36 | 2020-10-26              |                       246 |      504209 | 1273331 |      55027 |      18667 |              0.033 |              0.037 |            0.396 |           0.109 |                  0.015 |           0.007 |
|             37 | 2020-10-26              |                       246 |      579918 | 1426520 |      59701 |      20815 |              0.032 |              0.036 |            0.407 |           0.103 |                  0.014 |           0.007 |
|             38 | 2020-10-26              |                       246 |      653739 | 1571244 |      63923 |      22793 |              0.031 |              0.035 |            0.416 |           0.098 |                  0.013 |           0.007 |
|             39 | 2020-10-26              |                       247 |      732026 | 1711556 |      68181 |      24728 |              0.030 |              0.034 |            0.428 |           0.093 |                  0.013 |           0.006 |
|             40 | 2020-10-26              |                       249 |      816936 | 1850723 |      72149 |      26492 |              0.029 |              0.032 |            0.441 |           0.088 |                  0.012 |           0.006 |
|             41 | 2020-10-26              |                       250 |      907463 | 1989389 |      75757 |      27993 |              0.027 |              0.031 |            0.456 |           0.083 |                  0.012 |           0.006 |
|             42 | 2020-10-26              |                       250 |     1000820 | 2119966 |      78408 |      28915 |              0.025 |              0.029 |            0.472 |           0.078 |                  0.011 |           0.005 |
|             43 | 2020-10-26              |                       250 |     1090964 | 2247454 |      79951 |      29279 |              0.023 |              0.027 |            0.485 |           0.073 |                  0.010 |           0.005 |
|             44 | 2020-10-26              |                       250 |     1102297 | 2260552 |      80049 |      29301 |              0.023 |              0.027 |            0.488 |           0.073 |                  0.010 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [11:57:02.582] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [11:59:29.451] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [12:01:56.558] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [12:02:14.224] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [12:02:51.109] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [12:02:58.694] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [12:03:37.239] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [12:03:43.907] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [12:03:50.689] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [12:03:53.869] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [12:04:01.635] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [12:04:06.557] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [12:04:11.380] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [12:04:21.144] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [12:04:25.097] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [12:04:31.489] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [12:04:38.914] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [12:04:45.225] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [12:04:49.011] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [12:04:53.326] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [12:04:57.610] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [12:05:12.236] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [12:05:17.868] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [12:05:22.123] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [12:05:27.028] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 818
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
| Buenos Aires                  | M    |      268264 |      19201 |       9300 |              0.030 |              0.035 |            0.491 |           0.072 |                  0.012 |           0.006 |
| Buenos Aires                  | F    |      259438 |      15722 |       7410 |              0.025 |              0.029 |            0.463 |           0.061 |                  0.008 |           0.003 |
| CABA                          | F    |       72449 |      10021 |       2217 |              0.028 |              0.031 |            0.356 |           0.138 |                  0.013 |           0.006 |
| CABA                          | M    |       70444 |      10699 |       2478 |              0.032 |              0.035 |            0.403 |           0.152 |                  0.022 |           0.012 |
| Santa Fe                      | F    |       48933 |        995 |        503 |              0.009 |              0.010 |            0.749 |           0.020 |                  0.005 |           0.003 |
| Santa Fe                      | M    |       47263 |       1268 |        608 |              0.012 |              0.013 |            0.774 |           0.027 |                  0.008 |           0.005 |
| Córdoba                       | F    |       39244 |        610 |        494 |              0.010 |              0.013 |            0.668 |           0.016 |                  0.007 |           0.002 |
| Córdoba                       | M    |       37967 |        701 |        664 |              0.014 |              0.017 |            0.666 |           0.018 |                  0.009 |           0.002 |
| Tucumán                       | M    |       22672 |        219 |        447 |              0.013 |              0.020 |            0.745 |           0.010 |                  0.002 |           0.001 |
| Mendoza                       | F    |       21734 |       1203 |        301 |              0.011 |              0.014 |            0.538 |           0.055 |                  0.004 |           0.002 |
| Mendoza                       | M    |       21671 |       1393 |        422 |              0.016 |              0.019 |            0.564 |           0.064 |                  0.009 |           0.005 |
| Tucumán                       | F    |       21425 |        154 |        238 |              0.007 |              0.011 |            0.849 |           0.007 |                  0.002 |           0.001 |
| Río Negro                     | F    |       11371 |       1802 |        237 |              0.018 |              0.021 |            0.568 |           0.158 |                  0.005 |           0.003 |
| Río Negro                     | M    |       10703 |       1758 |        339 |              0.028 |              0.032 |            0.602 |           0.164 |                  0.009 |           0.007 |
| Salta                         | M    |        9961 |       1100 |        483 |              0.040 |              0.048 |            0.546 |           0.110 |                  0.023 |           0.013 |
| Neuquén                       | F    |        9900 |       4146 |        131 |              0.010 |              0.013 |            0.708 |           0.419 |                  0.005 |           0.004 |
| Neuquén                       | M    |        9867 |       4039 |        222 |              0.018 |              0.022 |            0.735 |           0.409 |                  0.012 |           0.011 |
| Jujuy                         | M    |        9815 |        241 |        517 |              0.043 |              0.053 |            0.423 |           0.025 |                  0.012 |           0.008 |
| Salta                         | F    |        7856 |        740 |        240 |              0.024 |              0.031 |            0.535 |           0.094 |                  0.015 |           0.007 |
| Jujuy                         | F    |        7809 |        114 |        272 |              0.028 |              0.035 |            0.409 |           0.015 |                  0.005 |           0.003 |
| Entre Ríos                    | F    |        7176 |        473 |        101 |              0.012 |              0.014 |            0.498 |           0.066 |                  0.005 |           0.002 |
| Entre Ríos                    | M    |        7109 |        509 |        148 |              0.018 |              0.021 |            0.543 |           0.072 |                  0.009 |           0.003 |
| Chubut                        | M    |        7108 |         59 |         92 |              0.010 |              0.013 |            0.812 |           0.008 |                  0.003 |           0.003 |
| Chaco                         | M    |        6628 |        564 |        254 |              0.029 |              0.038 |            0.228 |           0.085 |                  0.049 |           0.025 |
| Chaco                         | F    |        6589 |        501 |        147 |              0.016 |              0.022 |            0.216 |           0.076 |                  0.036 |           0.016 |
| Chubut                        | F    |        5842 |         58 |         64 |              0.009 |              0.011 |            0.788 |           0.010 |                  0.003 |           0.002 |
| Tierra del Fuego              | M    |        5341 |        128 |         91 |              0.015 |              0.017 |            0.615 |           0.024 |                  0.009 |           0.008 |
| Tierra del Fuego              | F    |        4996 |         63 |         40 |              0.007 |              0.008 |            0.591 |           0.013 |                  0.003 |           0.002 |
| Santiago del Estero           | M    |        4631 |         88 |         66 |              0.011 |              0.014 |            0.272 |           0.019 |                  0.002 |           0.001 |
| Santa Cruz                    | M    |        4452 |        284 |         78 |              0.014 |              0.018 |            0.595 |           0.064 |                  0.016 |           0.011 |
| Santa Cruz                    | F    |        4089 |        204 |         39 |              0.008 |              0.010 |            0.530 |           0.050 |                  0.009 |           0.006 |
| Santiago del Estero           | F    |        3987 |         49 |         43 |              0.009 |              0.011 |            0.319 |           0.012 |                  0.001 |           0.001 |
| La Rioja                      | M    |        3747 |         28 |        163 |              0.041 |              0.044 |            0.379 |           0.007 |                  0.002 |           0.001 |
| La Rioja                      | F    |        3391 |         21 |         88 |              0.024 |              0.026 |            0.363 |           0.006 |                  0.002 |           0.001 |
| San Luis                      | M    |        2879 |         68 |         23 |              0.005 |              0.008 |            0.345 |           0.024 |                  0.003 |           0.000 |
| San Luis                      | F    |        2742 |         52 |         14 |              0.003 |              0.005 |            0.316 |           0.019 |                  0.003 |           0.002 |
| Buenos Aires                  | NR   |        1867 |        149 |        115 |              0.046 |              0.062 |            0.480 |           0.080 |                  0.016 |           0.006 |
| SIN ESPECIFICAR               | F    |        1519 |         89 |          9 |              0.005 |              0.006 |            0.430 |           0.059 |                  0.006 |           0.002 |
| La Pampa                      | F    |        1312 |         32 |          8 |              0.004 |              0.006 |            0.200 |           0.024 |                  0.006 |           0.001 |
| Corrientes                    | M    |        1222 |         32 |         27 |              0.014 |              0.022 |            0.167 |           0.026 |                  0.020 |           0.012 |
| La Pampa                      | M    |        1199 |         26 |         17 |              0.009 |              0.014 |            0.218 |           0.022 |                  0.006 |           0.003 |
| Corrientes                    | F    |        1161 |         12 |         11 |              0.006 |              0.009 |            0.178 |           0.010 |                  0.008 |           0.003 |
| SIN ESPECIFICAR               | M    |        1041 |         75 |         11 |              0.009 |              0.011 |            0.452 |           0.072 |                  0.010 |           0.006 |
| San Juan                      | M    |         827 |         33 |         29 |              0.019 |              0.035 |            0.527 |           0.040 |                  0.019 |           0.008 |
| San Juan                      | F    |         568 |         35 |         27 |              0.020 |              0.048 |            0.500 |           0.062 |                  0.025 |           0.005 |
| CABA                          | NR   |         567 |        135 |         46 |              0.064 |              0.081 |            0.385 |           0.238 |                  0.035 |           0.021 |
| Catamarca                     | M    |         393 |          5 |          0 |              0.000 |              0.000 |            0.075 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     | F    |         244 |          4 |          0 |              0.000 |              0.000 |            0.076 |           0.016 |                  0.000 |           0.000 |
| Mendoza                       | NR   |         185 |          7 |          4 |              0.016 |              0.022 |            0.448 |           0.038 |                  0.005 |           0.005 |
| Misiones                      | M    |         131 |         36 |          2 |              0.008 |              0.015 |            0.035 |           0.275 |                  0.031 |           0.015 |
| Formosa                       | M    |         102 |         29 |          0 |              0.000 |              0.000 |            0.113 |           0.284 |                  0.000 |           0.000 |
| Misiones                      | F    |          98 |         29 |          3 |              0.013 |              0.031 |            0.035 |           0.296 |                  0.041 |           0.010 |
| Salta                         | NR   |          53 |          5 |          3 |              0.045 |              0.057 |            0.482 |           0.094 |                  0.038 |           0.019 |
| Santa Fe                      | NR   |          43 |          5 |          2 |              0.036 |              0.047 |            0.478 |           0.116 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          42 |          1 |          3 |              0.045 |              0.071 |            0.627 |           0.024 |                  0.000 |           0.000 |
| Formosa                       | F    |          40 |         24 |          1 |              0.013 |              0.025 |            0.065 |           0.600 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          31 |          0 |          3 |              0.091 |              0.097 |            0.360 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | NR   |          30 |          1 |          1 |              0.022 |              0.033 |            0.484 |           0.033 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          23 |          1 |          2 |              0.045 |              0.087 |            0.319 |           0.043 |                  0.000 |           0.000 |
| Tucumán                       | NR   |          19 |          0 |          0 |              0.000 |              0.000 |            0.528 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | NR   |          15 |          0 |          0 |              0.000 |              0.000 |            2.143 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      | NR   |          13 |          1 |          0 |              0.000 |              0.000 |            0.260 |           0.077 |                  0.000 |           0.000 |
| Río Negro                     | NR   |          11 |          3 |          0 |              0.000 |              0.000 |            0.440 |           0.273 |                  0.000 |           0.000 |


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
