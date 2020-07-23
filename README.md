
<!-- README.md is generated from README.Rmd. Please edit that file -->

<img src="man/figures/COVID19AR.png" height="139" align="right" />

# COVID19AR

A package for analysing COVID-19 Argentina’s outbreak

<!-- . -->

# Package

| Release                                                                                                | Usage                                                                                                    | Development                                                                                                                                                                                            |
| :----------------------------------------------------------------------------------------------------- | :------------------------------------------------------------------------------------------------------- | :----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
|                                                                                                        | [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)](https://cran.r-project.org/) | [![Travis](https://travis-ci.org/rOpenStats/COVID19AR.svg?branch=master)](https://travis-ci.org/rOpenStats/COVID19AR)                                                                                  |
| [![CRAN](http://www.r-pkg.org/badges/version/COVID19AR)](https://cran.r-project.org/package=COVID19AR) |                                                                                                          | [![codecov](https://codecov.io/gh/rOpenStats/COVID19AR/branch/master/graph/badge.svg)](https://codecov.io/gh/rOpenStats/COVID19AR)                                                                     |
|                                                                                                        |                                                                                                          | [![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active) |

# Argentina COVID19 open data

  - [Casos daily
    file](https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Casos.csv)
  - [Determinaciones daily
    file](https://sisa.msal.gov.ar/datos/descargas/covid-19/files/Covid19Determinaciones.csv)

# How to get started (Development version)

Install the R package using the following commands on the R console:

``` r
# install.packages("devtools")
devtools::install_github("rOpenStats/COVID19AR")
```

# How to use it

First add variable with your preferred configurations in `~/.Renviron`.
COVID19AR\_data\_dir is mandatory while COVID19AR\_credits can be
configured if you want to publish your own research.

``` .renviron
COVID19AR_data_dir = "~/.R/COVID19AR"
COVID19AR_credits = "@youralias"
```

``` r
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
```

# COVID19AR datos abiertos del Ministerio de Salud de la Nación

opendata From Ministerio de Salud de la Nación Argentina

``` r
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
#> INFO  [09:04:38.236] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [09:05:01.310] Normalize 
#> INFO  [09:05:19.714] checkSoundness 
#> INFO  [09:05:25.838] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-22"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-22"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-22"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-22              |      141887 |       2588 |              0.013 |              0.018 |                       149 | 493798 |            0.287 |

``` r

covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
  filter(confirmados >= 100) %>%
  arrange(desc(confirmados))
# Provinces with > 100 confirmed cases
kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| Buenos Aires                  |       80255 |       1279 |              0.011 |              0.016 |                       147 | 242755 |            0.331 |
| CABA                          |       48693 |        961 |              0.016 |              0.020 |                       145 | 124676 |            0.391 |
| Chaco                         |        3103 |        126 |              0.030 |              0.041 |                       133 |  18625 |            0.167 |
| Córdoba                       |        1464 |         41 |              0.014 |              0.028 |                       135 |  26788 |            0.055 |
| Río Negro                     |        1432 |         62 |              0.038 |              0.043 |                       128 |   6097 |            0.235 |
| SIN ESPECIFICAR               |        1212 |          5 |              0.003 |              0.004 |                       123 |   2918 |            0.415 |
| Jujuy                         |        1044 |         31 |              0.008 |              0.030 |                       124 |   6366 |            0.164 |
| Neuquén                       |         958 |         22 |              0.019 |              0.023 |                       130 |   3902 |            0.246 |
| Santa Fe                      |         802 |          9 |              0.007 |              0.011 |                       131 |  17745 |            0.045 |
| Entre Ríos                    |         680 |          6 |              0.006 |              0.009 |                       128 |   4002 |            0.170 |
| Mendoza                       |         618 |         17 |              0.017 |              0.028 |                       134 |   5176 |            0.119 |
| Chubut                        |         252 |          2 |              0.004 |              0.008 |                       113 |   2532 |            0.100 |
| Tierra del Fuego              |         247 |          2 |              0.006 |              0.008 |                       126 |   1993 |            0.124 |
| Santa Cruz                    |         241 |          0 |              0.000 |              0.000 |                       120 |   1030 |            0.234 |
| La Rioja                      |         197 |         15 |              0.058 |              0.076 |                       119 |   3180 |            0.062 |
| Salta                         |         190 |          2 |              0.006 |              0.011 |                       123 |   1628 |            0.117 |
| Corrientes                    |         130 |          1 |              0.003 |              0.008 |                       125 |   3829 |            0.034 |
| Tucumán                       |         100 |          4 |              0.007 |              0.040 |                       126 |   9652 |            0.010 |

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
nrow(covid19.ar.summary)
#> [1] 25
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
        select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))
```

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | ----------: | -----: | ---------: | -----------------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| Buenos Aires                  |       80255 | 242755 |       1279 |               13.2 |              0.011 |              0.016 |            0.331 |           0.133 |                  0.015 |           0.006 |
| CABA                          |       48693 | 124676 |        961 |               14.6 |              0.016 |              0.020 |            0.391 |           0.217 |                  0.019 |           0.009 |
| Chaco                         |        3103 |  18625 |        126 |               14.5 |              0.030 |              0.041 |            0.167 |           0.098 |                  0.052 |           0.021 |
| Córdoba                       |        1464 |  26788 |         41 |               23.5 |              0.014 |              0.028 |            0.055 |           0.092 |                  0.024 |           0.010 |
| Río Negro                     |        1432 |   6097 |         62 |               14.2 |              0.038 |              0.043 |            0.235 |           0.378 |                  0.027 |           0.017 |
| SIN ESPECIFICAR               |        1212 |   2918 |          5 |               25.6 |              0.003 |              0.004 |            0.415 |           0.111 |                  0.007 |           0.003 |
| Jujuy                         |        1044 |   6366 |         31 |               12.6 |              0.008 |              0.030 |            0.164 |           0.009 |                  0.002 |           0.002 |
| Neuquén                       |         958 |   3902 |         22 |               18.6 |              0.019 |              0.023 |            0.246 |           0.683 |                  0.013 |           0.006 |
| Santa Fe                      |         802 |  17745 |          9 |               17.9 |              0.007 |              0.011 |            0.045 |           0.131 |                  0.031 |           0.011 |
| Entre Ríos                    |         680 |   4002 |          6 |                8.3 |              0.006 |              0.009 |            0.170 |           0.216 |                  0.009 |           0.003 |
| Mendoza                       |         618 |   5176 |         17 |               10.9 |              0.017 |              0.028 |            0.119 |           0.557 |                  0.031 |           0.010 |
| Chubut                        |         252 |   2532 |          2 |               10.5 |              0.004 |              0.008 |            0.100 |           0.048 |                  0.016 |           0.012 |
| Tierra del Fuego              |         247 |   1993 |          2 |               19.0 |              0.006 |              0.008 |            0.124 |           0.040 |                  0.012 |           0.012 |
| Santa Cruz                    |         241 |   1030 |          0 |                NaN |              0.000 |              0.000 |            0.234 |           0.124 |                  0.021 |           0.012 |
| La Rioja                      |         197 |   3180 |         15 |               13.2 |              0.058 |              0.076 |            0.062 |           0.107 |                  0.025 |           0.005 |
| Salta                         |         190 |   1628 |          2 |                2.5 |              0.006 |              0.011 |            0.117 |           0.321 |                  0.016 |           0.005 |
| Corrientes                    |         130 |   3829 |          1 |               12.0 |              0.003 |              0.008 |            0.034 |           0.023 |                  0.015 |           0.008 |
| Tucumán                       |         100 |   9652 |          4 |               14.2 |              0.007 |              0.040 |            0.010 |           0.300 |                  0.090 |           0.020 |
| Formosa                       |          76 |    800 |          0 |                NaN |              0.000 |              0.000 |            0.095 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          60 |   1752 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           |          46 |   4292 |          1 |               15.0 |              0.004 |              0.022 |            0.011 |           0.065 |                  0.043 |           0.022 |
| Misiones                      |          44 |   1830 |          2 |                6.5 |              0.012 |              0.045 |            0.024 |           0.659 |                  0.136 |           0.068 |
| San Luis                      |          19 |    709 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.474 |                  0.053 |           0.000 |
| San Juan                      |          16 |    937 |          0 |                NaN |              0.000 |              0.000 |            0.017 |           0.312 |                  0.062 |           0.000 |
| La Pampa                      |           8 |    584 |          0 |                NaN |              0.000 |              0.000 |            0.014 |           0.125 |                  0.000 |           0.000 |

``` r

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
```

<img src="man/figures/README-exponential_growth-1.png" width="100%" />

``` r
rg$getDepartamentosCrossSectionConfirmedPostivityPlot()
```

<img src="man/figures/README-exponential_growth-2.png" width="100%" />

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
#> INFO  [09:07:22.427] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 21
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% 
        filter(confirmados > 0) %>% 
        arrange(sepi_apertura, desc(confirmados)) %>% 
        select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))
```

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| -------------: | :---------------------- | ------------------------: | ----------: | -----: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-07-15              |                        36 |          95 |    666 |         66 |          9 |              0.066 |              0.095 |            0.143 |           0.695 |                  0.126 |           0.063 |
|             12 | 2020-07-15              |                        56 |         409 |   2048 |        254 |         17 |              0.033 |              0.042 |            0.200 |           0.621 |                  0.093 |           0.054 |
|             13 | 2020-07-21              |                        86 |        1077 |   5515 |        598 |         62 |              0.048 |              0.058 |            0.195 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-07-21              |                       113 |        1756 |  11532 |        964 |        112 |              0.052 |              0.064 |            0.152 |           0.549 |                  0.095 |           0.056 |
|             15 | 2020-07-21              |                       135 |        2410 |  20246 |       1303 |        173 |              0.057 |              0.072 |            0.119 |           0.541 |                  0.090 |           0.051 |
|             16 | 2020-07-21              |                       143 |        3188 |  31846 |       1645 |        228 |              0.056 |              0.072 |            0.100 |           0.516 |                  0.081 |           0.044 |
|             17 | 2020-07-22              |                       147 |        4269 |  45895 |       2153 |        329 |              0.061 |              0.077 |            0.093 |           0.504 |                  0.073 |           0.038 |
|             18 | 2020-07-22              |                       147 |        5241 |  59081 |       2541 |        392 |              0.059 |              0.075 |            0.089 |           0.485 |                  0.066 |           0.035 |
|             19 | 2020-07-22              |                       147 |        6649 |  73206 |       3111 |        467 |              0.056 |              0.070 |            0.091 |           0.468 |                  0.061 |           0.032 |
|             20 | 2020-07-22              |                       147 |        8999 |  90567 |       3939 |        550 |              0.049 |              0.061 |            0.099 |           0.438 |                  0.055 |           0.029 |
|             21 | 2020-07-22              |                       147 |       13288 | 113978 |       5227 |        686 |              0.042 |              0.052 |            0.117 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-07-22              |                       147 |       18450 | 139322 |       6635 |        849 |              0.038 |              0.046 |            0.132 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-22              |                       147 |       24778 | 167540 |       8134 |       1044 |              0.035 |              0.042 |            0.148 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-07-22              |                       147 |       34229 | 202564 |      10212 |       1255 |              0.031 |              0.037 |            0.169 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-07-22              |                       147 |       46898 | 243828 |      12473 |       1508 |              0.027 |              0.032 |            0.192 |           0.266 |                  0.031 |           0.014 |
|             26 | 2020-07-22              |                       147 |       64365 | 295449 |      15384 |       1824 |              0.024 |              0.028 |            0.218 |           0.239 |                  0.027 |           0.012 |
|             27 | 2020-07-22              |                       147 |       82611 | 345456 |      17918 |       2113 |              0.021 |              0.026 |            0.239 |           0.217 |                  0.024 |           0.010 |
|             28 | 2020-07-22              |                       148 |      105105 | 403104 |      20692 |       2404 |              0.019 |              0.023 |            0.261 |           0.197 |                  0.021 |           0.009 |
|             29 | 2020-07-22              |                       149 |      131190 | 469304 |      23176 |       2566 |              0.016 |              0.020 |            0.280 |           0.177 |                  0.019 |           0.008 |
|             30 | 2020-07-22              |                       149 |      141887 | 493798 |      23867 |       2588 |              0.013 |              0.018 |            0.287 |           0.168 |                  0.018 |           0.007 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [09:07:57.016] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [09:08:15.072] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [09:08:26.109] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [09:08:27.503] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [09:08:30.972] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [09:08:33.008] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [09:08:37.455] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [09:08:39.857] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [09:08:42.263] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [09:08:43.905] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [09:08:46.707] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [09:08:48.844] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [09:08:51.141] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [09:08:53.761] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [09:08:56.021] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [09:08:58.350] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [09:09:01.148] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [09:09:03.220] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [09:09:05.239] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [09:09:07.758] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [09:09:10.336] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [09:09:13.918] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [09:09:16.254] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [09:09:18.404] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [09:09:20.834] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 461
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
````

<img src="man/figures/README-residencia_provincia_nombre-sepi_apertura-1.png" width="100%" />

``` r

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
```

<img src="man/figures/README-residencia_provincia_nombre-sepi_apertura-plot-positividad-1.png" width="100%" />

``` r

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sexo"))
nrow(covid19.ar.summary)
#> [1] 60
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| Buenos Aires                  | M    |       40904 |       5810 |        746 |              0.013 |              0.018 |            0.348 |           0.142 |                  0.018 |           0.008 |
| Buenos Aires                  | F    |       39040 |       4863 |        527 |              0.009 |              0.013 |            0.314 |           0.125 |                  0.012 |           0.004 |
| CABA                          | F    |       24519 |       5196 |        418 |              0.014 |              0.017 |            0.374 |           0.212 |                  0.014 |           0.006 |
| CABA                          | M    |       23972 |       5308 |        530 |              0.019 |              0.022 |            0.410 |           0.221 |                  0.024 |           0.011 |
| Chaco                         | F    |        1563 |        149 |         48 |              0.023 |              0.031 |            0.167 |           0.095 |                  0.044 |           0.013 |
| Chaco                         | M    |        1538 |        156 |         78 |              0.036 |              0.051 |            0.166 |           0.101 |                  0.061 |           0.029 |
| Córdoba                       | M    |         745 |         59 |         21 |              0.015 |              0.028 |            0.057 |           0.079 |                  0.026 |           0.013 |
| Río Negro                     | F    |         721 |        272 |         21 |              0.025 |              0.029 |            0.222 |           0.377 |                  0.017 |           0.008 |
| Córdoba                       | F    |         717 |         75 |         20 |              0.013 |              0.028 |            0.053 |           0.105 |                  0.022 |           0.007 |
| Río Negro                     | M    |         711 |        270 |         41 |              0.050 |              0.058 |            0.251 |           0.380 |                  0.038 |           0.027 |
| SIN ESPECIFICAR               | F    |         698 |         66 |          0 |              0.000 |              0.000 |            0.398 |           0.095 |                  0.004 |           0.000 |
| Jujuy                         | M    |         674 |          8 |         18 |              0.009 |              0.027 |            0.188 |           0.012 |                  0.003 |           0.003 |
| SIN ESPECIFICAR               | M    |         510 |         67 |          4 |              0.006 |              0.008 |            0.442 |           0.131 |                  0.008 |           0.006 |
| Neuquén                       | F    |         487 |        349 |         12 |              0.020 |              0.025 |            0.252 |           0.717 |                  0.012 |           0.006 |
| Neuquén                       | M    |         471 |        305 |         10 |              0.018 |              0.021 |            0.240 |           0.648 |                  0.013 |           0.006 |
| Santa Fe                      | F    |         406 |         42 |          2 |              0.003 |              0.005 |            0.044 |           0.103 |                  0.022 |           0.005 |
| Santa Fe                      | M    |         396 |         63 |          7 |              0.011 |              0.018 |            0.046 |           0.159 |                  0.040 |           0.018 |
| Jujuy                         | F    |         368 |          1 |         13 |              0.008 |              0.035 |            0.133 |           0.003 |                  0.000 |           0.000 |
| Entre Ríos                    | M    |         347 |         81 |          3 |              0.006 |              0.009 |            0.178 |           0.233 |                  0.009 |           0.003 |
| Entre Ríos                    | F    |         332 |         66 |          3 |              0.006 |              0.009 |            0.162 |           0.199 |                  0.009 |           0.003 |
| Buenos Aires                  | NR   |         311 |         34 |          6 |              0.011 |              0.019 |            0.363 |           0.109 |                  0.032 |           0.016 |
| Mendoza                       | M    |         310 |        176 |         13 |              0.027 |              0.042 |            0.120 |           0.568 |                  0.045 |           0.016 |
| Mendoza                       | F    |         304 |        166 |          4 |              0.008 |              0.013 |            0.118 |           0.546 |                  0.016 |           0.003 |
| CABA                          | NR   |         202 |         66 |         13 |              0.037 |              0.064 |            0.360 |           0.327 |                  0.054 |           0.040 |
| Tierra del Fuego              | M    |         172 |          7 |          2 |              0.009 |              0.012 |            0.156 |           0.041 |                  0.017 |           0.017 |
| Santa Cruz                    | M    |         136 |         16 |          0 |              0.000 |              0.000 |            0.237 |           0.118 |                  0.029 |           0.015 |
| Chubut                        | M    |         134 |          8 |          1 |              0.004 |              0.007 |            0.103 |           0.060 |                  0.015 |           0.015 |
| Salta                         | M    |         114 |         36 |          2 |              0.010 |              0.018 |            0.107 |           0.316 |                  0.018 |           0.009 |
| Chubut                        | F    |         113 |          4 |          1 |              0.005 |              0.009 |            0.094 |           0.035 |                  0.018 |           0.009 |
| La Rioja                      | F    |         105 |         13 |          7 |              0.052 |              0.067 |            0.069 |           0.124 |                  0.038 |           0.010 |
| Santa Cruz                    | F    |         105 |         14 |          0 |              0.000 |              0.000 |            0.231 |           0.133 |                  0.010 |           0.010 |
| La Rioja                      | M    |          92 |          8 |          8 |              0.065 |              0.087 |            0.056 |           0.087 |                  0.011 |           0.000 |
| Corrientes                    | M    |          80 |          3 |          1 |              0.005 |              0.013 |            0.037 |           0.038 |                  0.013 |           0.013 |
| Salta                         | F    |          76 |         25 |          0 |              0.000 |              0.000 |            0.137 |           0.329 |                  0.013 |           0.000 |
| Tierra del Fuego              | F    |          74 |          3 |          0 |              0.000 |              0.000 |            0.084 |           0.041 |                  0.000 |           0.000 |
| Formosa                       | M    |          65 |          1 |          0 |              0.000 |              0.000 |            0.137 |           0.015 |                  0.000 |           0.000 |
| Tucumán                       | M    |          62 |         16 |          2 |              0.006 |              0.032 |            0.010 |           0.258 |                  0.048 |           0.000 |
| Corrientes                    | F    |          50 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.020 |           0.000 |
| Catamarca                     | M    |          38 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | F    |          38 |         14 |          2 |              0.010 |              0.053 |            0.010 |           0.368 |                  0.158 |           0.053 |
| Santiago del Estero           | M    |          35 |          2 |          0 |              0.000 |              0.000 |            0.012 |           0.057 |                  0.029 |           0.000 |
| Misiones                      | M    |          24 |         16 |          1 |              0.012 |              0.042 |            0.025 |           0.667 |                  0.167 |           0.083 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.033 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.013 |              0.050 |            0.023 |           0.650 |                  0.100 |           0.050 |
| San Luis                      | M    |          16 |          7 |          0 |              0.000 |              0.000 |            0.039 |           0.438 |                  0.062 |           0.000 |
| San Juan                      | M    |          12 |          2 |          0 |              0.000 |              0.000 |            0.022 |           0.167 |                  0.000 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          11 |          1 |          1 |              0.011 |              0.091 |            0.009 |           0.091 |                  0.091 |           0.091 |

``` r

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
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-1.png" width="100%" />

``` r


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
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-2.png" width="100%" />

``` r


 # UCI rate
 covidplot <- data2plot %>%
   ggplot(aes(x = edad.rango, y = cuidado.intensivo.porc, fill = edad.rango)) +
   geom_bar(stat = "identity") + facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
    labs(title = "Porcentaje de pacientes en Unidades de Cuidados Intensivos por rango etario\n en provincias > 100 confirmados")
 covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                      total.colors = length(unique(data2plot$edad.rango)),
                      data.provider.abv = "@msalnacion", base.size = 6)
 covidplot
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-3.png" width="100%" />

``` r

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
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-4.png" width="100%" />

``` r

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
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-5.png" width="100%" />

# Generar diferentes agregaciones y guardar csv / Generate different aggregations

``` r
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
                                                   
                                                  
```

All this tables are accesible at
[COVID19ARdata](https://github.com/rOpenStats/COVID19ARdata/tree/master/curated)

# How to Cite This Work

Citation

    Alejandro Baranek, COVID19AR, 2020. URL: https://github.com/rOpenStats/COVID19AR

``` bibtex
BibTex
@techreport{baranek2020Covid19AR,
Author = {Alejandro Baranek},
Institution = {rOpenStats},
Title = {COVID19AR: a package for analysing Argentina COVID-19 outbreak},
Url = {https://github.com/rOpenStats/COVID19AR},
Year = {2020}}
```
