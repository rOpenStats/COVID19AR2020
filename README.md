
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
#> INFO  [00:27:01.413] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [00:27:07.040] Normalize 
#> INFO  [00:27:08.311] checkSoundness 
#> INFO  [00:27:08.800] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-23"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-23"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-23"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-23              |      148013 |       2702 |              0.013 |              0.018 |                       150 | 507831 |            0.291 |

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
| Buenos Aires                  |       84512 |       1348 |              0.011 |              0.016 |                       148 | 251149 |            0.337 |
| CABA                          |       50073 |       1001 |              0.017 |              0.020 |                       146 | 127671 |            0.392 |
| Chaco                         |        3154 |        129 |              0.031 |              0.041 |                       134 |  19123 |            0.165 |
| Córdoba                       |        1566 |         41 |              0.014 |              0.026 |                       136 |  27331 |            0.057 |
| Río Negro                     |        1486 |         62 |              0.037 |              0.042 |                       129 |   6269 |            0.237 |
| Jujuy                         |        1202 |         31 |              0.008 |              0.026 |                       125 |   6607 |            0.182 |
| SIN ESPECIFICAR               |        1149 |          4 |              0.003 |              0.003 |                       124 |   2766 |            0.415 |
| Neuquén                       |         983 |         22 |              0.019 |              0.022 |                       131 |   3982 |            0.247 |
| Santa Fe                      |         836 |          9 |              0.007 |              0.011 |                       132 |  18171 |            0.046 |
| Entre Ríos                    |         711 |          6 |              0.006 |              0.008 |                       129 |   4133 |            0.172 |
| Mendoza                       |         670 |         20 |              0.019 |              0.030 |                       135 |   5405 |            0.124 |
| Santa Cruz                    |         264 |          0 |              0.000 |              0.000 |                       121 |   1073 |            0.246 |
| Chubut                        |         253 |          2 |              0.004 |              0.008 |                       114 |   2569 |            0.098 |
| Tierra del Fuego              |         251 |          2 |              0.005 |              0.008 |                       128 |   2037 |            0.123 |
| La Rioja                      |         206 |         15 |              0.056 |              0.073 |                       120 |   3218 |            0.064 |
| Salta                         |         191 |          2 |              0.006 |              0.010 |                       124 |   1651 |            0.116 |
| Corrientes                    |         134 |          1 |              0.003 |              0.007 |                       126 |   3842 |            0.035 |

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
| Buenos Aires                  |       84512 | 251149 |       1348 |               13.1 |              0.011 |              0.016 |            0.337 |           0.131 |                  0.015 |           0.006 |
| CABA                          |       50073 | 127671 |       1001 |               14.5 |              0.017 |              0.020 |            0.392 |           0.216 |                  0.020 |           0.009 |
| Chaco                         |        3154 |  19123 |        129 |               14.5 |              0.031 |              0.041 |            0.165 |           0.100 |                  0.052 |           0.021 |
| Córdoba                       |        1566 |  27331 |         41 |               23.5 |              0.014 |              0.026 |            0.057 |           0.086 |                  0.022 |           0.010 |
| Río Negro                     |        1486 |   6269 |         62 |               14.2 |              0.037 |              0.042 |            0.237 |           0.380 |                  0.027 |           0.017 |
| Jujuy                         |        1202 |   6607 |         31 |               12.6 |              0.008 |              0.026 |            0.182 |           0.007 |                  0.002 |           0.002 |
| SIN ESPECIFICAR               |        1149 |   2766 |          4 |               20.0 |              0.003 |              0.003 |            0.415 |           0.112 |                  0.008 |           0.004 |
| Neuquén                       |         983 |   3982 |         22 |               18.6 |              0.019 |              0.022 |            0.247 |           0.666 |                  0.012 |           0.006 |
| Santa Fe                      |         836 |  18171 |          9 |               17.9 |              0.007 |              0.011 |            0.046 |           0.127 |                  0.030 |           0.011 |
| Entre Ríos                    |         711 |   4133 |          6 |                8.3 |              0.006 |              0.008 |            0.172 |           0.212 |                  0.008 |           0.003 |
| Mendoza                       |         670 |   5405 |         20 |               10.5 |              0.019 |              0.030 |            0.124 |           0.533 |                  0.031 |           0.010 |
| Santa Cruz                    |         264 |   1073 |          0 |                NaN |              0.000 |              0.000 |            0.246 |           0.114 |                  0.019 |           0.011 |
| Chubut                        |         253 |   2569 |          2 |               10.5 |              0.004 |              0.008 |            0.098 |           0.047 |                  0.016 |           0.012 |
| Tierra del Fuego              |         251 |   2037 |          2 |               19.0 |              0.005 |              0.008 |            0.123 |           0.040 |                  0.012 |           0.012 |
| La Rioja                      |         206 |   3218 |         15 |               13.2 |              0.056 |              0.073 |            0.064 |           0.112 |                  0.029 |           0.010 |
| Salta                         |         191 |   1651 |          2 |                2.5 |              0.006 |              0.010 |            0.116 |           0.340 |                  0.021 |           0.005 |
| Corrientes                    |         134 |   3842 |          1 |               12.0 |              0.003 |              0.007 |            0.035 |           0.022 |                  0.015 |           0.007 |
| Tucumán                       |          98 |   9740 |          4 |               14.2 |              0.007 |              0.041 |            0.010 |           0.306 |                  0.092 |           0.020 |
| Formosa                       |          77 |    804 |          0 |                NaN |              0.000 |              0.000 |            0.096 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          60 |   1785 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           |          47 |   4377 |          1 |               15.0 |              0.004 |              0.021 |            0.011 |           0.064 |                  0.043 |           0.021 |
| Misiones                      |          45 |   1875 |          2 |                6.5 |              0.012 |              0.044 |            0.024 |           0.644 |                  0.133 |           0.067 |
| San Luis                      |          19 |    717 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.474 |                  0.053 |           0.000 |
| San Juan                      |          18 |    949 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.278 |                  0.056 |           0.000 |
| La Pampa                      |           8 |    587 |          0 |                NaN |              0.000 |              0.000 |            0.014 |           0.125 |                  0.000 |           0.000 |

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
#> INFO  [00:28:41.409] Processing {current.group: }
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
|             13 | 2020-07-23              |                        87 |        1078 |   5515 |        598 |         62 |              0.048 |              0.058 |            0.195 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-07-23              |                       114 |        1757 |  11532 |        964 |        112 |              0.052 |              0.064 |            0.152 |           0.549 |                  0.094 |           0.056 |
|             15 | 2020-07-23              |                       136 |        2411 |  20247 |       1303 |        173 |              0.057 |              0.072 |            0.119 |           0.540 |                  0.090 |           0.051 |
|             16 | 2020-07-23              |                       145 |        3191 |  31847 |       1645 |        228 |              0.056 |              0.071 |            0.100 |           0.516 |                  0.081 |           0.044 |
|             17 | 2020-07-23              |                       148 |        4278 |  45897 |       2155 |        329 |              0.061 |              0.077 |            0.093 |           0.504 |                  0.073 |           0.038 |
|             18 | 2020-07-23              |                       148 |        5255 |  59083 |       2544 |        392 |              0.059 |              0.075 |            0.089 |           0.484 |                  0.066 |           0.035 |
|             19 | 2020-07-23              |                       148 |        6667 |  73208 |       3115 |        467 |              0.056 |              0.070 |            0.091 |           0.467 |                  0.061 |           0.031 |
|             20 | 2020-07-23              |                       148 |        9021 |  90569 |       3944 |        550 |              0.049 |              0.061 |            0.100 |           0.437 |                  0.055 |           0.028 |
|             21 | 2020-07-23              |                       148 |       13314 | 113984 |       5234 |        686 |              0.042 |              0.052 |            0.117 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-07-23              |                       148 |       18479 | 139329 |       6643 |        850 |              0.038 |              0.046 |            0.133 |           0.359 |                  0.044 |           0.022 |
|             23 | 2020-07-23              |                       148 |       24822 | 167554 |       8147 |       1048 |              0.035 |              0.042 |            0.148 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-07-23              |                       148 |       34289 | 202582 |      10226 |       1260 |              0.031 |              0.037 |            0.169 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-07-23              |                       148 |       46972 | 243858 |      12494 |       1518 |              0.027 |              0.032 |            0.193 |           0.266 |                  0.031 |           0.014 |
|             26 | 2020-07-23              |                       148 |       64465 | 295497 |      15415 |       1838 |              0.024 |              0.029 |            0.218 |           0.239 |                  0.027 |           0.012 |
|             27 | 2020-07-23              |                       148 |       82769 | 345571 |      17974 |       2144 |              0.022 |              0.026 |            0.240 |           0.217 |                  0.024 |           0.011 |
|             28 | 2020-07-23              |                       149 |      105370 | 403358 |      20807 |       2453 |              0.019 |              0.023 |            0.261 |           0.197 |                  0.022 |           0.009 |
|             29 | 2020-07-23              |                       150 |      132006 | 470816 |      23402 |       2650 |              0.016 |              0.020 |            0.280 |           0.177 |                  0.019 |           0.008 |
|             30 | 2020-07-23              |                       150 |      148013 | 507831 |      24493 |       2702 |              0.013 |              0.018 |            0.291 |           0.165 |                  0.018 |           0.007 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [00:29:18.019] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [00:29:36.686] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [00:29:47.854] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [00:29:49.280] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [00:29:52.837] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [00:29:54.816] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [00:29:59.437] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [00:30:01.868] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [00:30:04.237] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [00:30:05.905] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [00:30:08.465] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [00:30:10.543] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [00:30:12.846] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [00:30:15.387] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [00:30:17.528] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [00:30:19.824] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [00:30:22.430] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [00:30:24.594] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [00:30:26.717] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [00:30:28.731] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [00:30:30.711] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [00:30:34.178] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [00:30:36.454] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [00:30:38.529] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [00:30:40.805] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       43061 |       5991 |        780 |              0.013 |              0.018 |            0.354 |           0.139 |                  0.018 |           0.008 |
| Buenos Aires                  | F    |       41131 |       5027 |        562 |              0.009 |              0.014 |            0.320 |           0.122 |                  0.012 |           0.004 |
| CABA                          | F    |       25233 |       5315 |        439 |              0.014 |              0.017 |            0.375 |           0.211 |                  0.014 |           0.006 |
| CABA                          | M    |       24634 |       5416 |        549 |              0.019 |              0.022 |            0.411 |           0.220 |                  0.025 |           0.012 |
| Chaco                         | F    |        1593 |        151 |         48 |              0.023 |              0.030 |            0.166 |           0.095 |                  0.043 |           0.013 |
| Chaco                         | M    |        1559 |        163 |         81 |              0.038 |              0.052 |            0.164 |           0.105 |                  0.062 |           0.030 |
| Córdoba                       | M    |         790 |         59 |         21 |              0.015 |              0.027 |            0.059 |           0.075 |                  0.024 |           0.013 |
| Jujuy                         | M    |         790 |          8 |         18 |              0.008 |              0.023 |            0.211 |           0.010 |                  0.003 |           0.003 |
| Córdoba                       | F    |         774 |         75 |         20 |              0.014 |              0.026 |            0.056 |           0.097 |                  0.021 |           0.006 |
| Río Negro                     | F    |         744 |        281 |         21 |              0.025 |              0.028 |            0.223 |           0.378 |                  0.016 |           0.008 |
| Río Negro                     | M    |         742 |        283 |         41 |              0.050 |              0.055 |            0.254 |           0.381 |                  0.038 |           0.027 |
| SIN ESPECIFICAR               | F    |         668 |         63 |          0 |              0.000 |              0.000 |            0.397 |           0.094 |                  0.004 |           0.000 |
| Neuquén                       | F    |         497 |        349 |         12 |              0.020 |              0.024 |            0.252 |           0.702 |                  0.012 |           0.006 |
| Neuquén                       | M    |         486 |        306 |         10 |              0.018 |              0.021 |            0.242 |           0.630 |                  0.012 |           0.006 |
| SIN ESPECIFICAR               | M    |         477 |         65 |          3 |              0.005 |              0.006 |            0.445 |           0.136 |                  0.010 |           0.008 |
| Santa Fe                      | F    |         424 |         42 |          2 |              0.003 |              0.005 |            0.045 |           0.099 |                  0.021 |           0.005 |
| Santa Fe                      | M    |         412 |         64 |          7 |              0.011 |              0.017 |            0.047 |           0.155 |                  0.039 |           0.017 |
| Jujuy                         | F    |         410 |          1 |         13 |              0.007 |              0.032 |            0.145 |           0.002 |                  0.000 |           0.000 |
| Entre Ríos                    | M    |         364 |         85 |          3 |              0.006 |              0.008 |            0.182 |           0.234 |                  0.008 |           0.003 |
| Entre Ríos                    | F    |         346 |         66 |          3 |              0.006 |              0.009 |            0.163 |           0.191 |                  0.009 |           0.003 |
| Mendoza                       | M    |         336 |        182 |         15 |              0.028 |              0.045 |            0.126 |           0.542 |                  0.048 |           0.018 |
| Mendoza                       | F    |         329 |        172 |          4 |              0.008 |              0.012 |            0.122 |           0.523 |                  0.015 |           0.003 |
| Buenos Aires                  | NR   |         320 |         36 |          6 |              0.011 |              0.019 |            0.361 |           0.112 |                  0.031 |           0.016 |
| CABA                          | NR   |         206 |         67 |         13 |              0.036 |              0.063 |            0.360 |           0.325 |                  0.053 |           0.039 |
| Tierra del Fuego              | M    |         173 |          7 |          2 |              0.008 |              0.012 |            0.154 |           0.040 |                  0.017 |           0.017 |
| Santa Cruz                    | M    |         148 |         16 |          0 |              0.000 |              0.000 |            0.246 |           0.108 |                  0.027 |           0.014 |
| Chubut                        | M    |         135 |          8 |          1 |              0.004 |              0.007 |            0.102 |           0.059 |                  0.015 |           0.015 |
| Santa Cruz                    | F    |         116 |         14 |          0 |              0.000 |              0.000 |            0.246 |           0.121 |                  0.009 |           0.009 |
| Chubut                        | F    |         113 |          4 |          1 |              0.005 |              0.009 |            0.093 |           0.035 |                  0.018 |           0.009 |
| Salta                         | M    |         112 |         37 |          2 |              0.010 |              0.018 |            0.105 |           0.330 |                  0.027 |           0.009 |
| La Rioja                      | F    |         110 |         14 |          7 |              0.051 |              0.064 |            0.071 |           0.127 |                  0.045 |           0.018 |
| La Rioja                      | M    |          96 |          9 |          8 |              0.062 |              0.083 |            0.058 |           0.094 |                  0.010 |           0.000 |
| Corrientes                    | M    |          81 |          3 |          1 |              0.005 |              0.012 |            0.038 |           0.037 |                  0.012 |           0.012 |
| Salta                         | F    |          79 |         28 |          0 |              0.000 |              0.000 |            0.138 |           0.354 |                  0.013 |           0.000 |
| Tierra del Fuego              | F    |          77 |          3 |          0 |              0.000 |              0.000 |            0.085 |           0.039 |                  0.000 |           0.000 |
| Formosa                       | M    |          66 |          1 |          0 |              0.000 |              0.000 |            0.138 |           0.015 |                  0.000 |           0.000 |
| Tucumán                       | M    |          60 |         16 |          2 |              0.006 |              0.033 |            0.010 |           0.267 |                  0.050 |           0.000 |
| Corrientes                    | F    |          53 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.019 |           0.000 |
| Catamarca                     | M    |          38 |          0 |          0 |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | F    |          38 |         14 |          2 |              0.010 |              0.053 |            0.010 |           0.368 |                  0.158 |           0.053 |
| Santiago del Estero           | M    |          36 |          2 |          0 |              0.000 |              0.000 |            0.012 |           0.056 |                  0.028 |           0.000 |
| Misiones                      | M    |          25 |         16 |          1 |              0.013 |              0.040 |            0.025 |           0.640 |                  0.160 |           0.080 |
| Catamarca                     | F    |          22 |          0 |          0 |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.012 |              0.050 |            0.023 |           0.650 |                  0.100 |           0.050 |
| San Luis                      | M    |          15 |          7 |          0 |              0.000 |              0.000 |            0.037 |           0.467 |                  0.067 |           0.000 |
| San Juan                      | M    |          13 |          2 |          0 |              0.000 |              0.000 |            0.024 |           0.154 |                  0.000 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          11 |          1 |          1 |              0.012 |              0.091 |            0.009 |           0.091 |                  0.091 |           0.091 |

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
