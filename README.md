
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
#> INFO  [08:43:56.471] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [08:44:00.582] Normalize 
#> INFO  [08:44:01.307] checkSoundness 
#> INFO  [08:44:01.648] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-20"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-20"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-20"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-20              |      129812 |       2334 |              0.013 |              0.018 |                       146 | 465658 |            0.279 |

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
| Buenos Aires                  |       72376 |       1159 |              0.011 |              0.016 |                       145 | 227102 |            0.319 |
| CABA                          |       45684 |        870 |              0.016 |              0.019 |                       143 | 118296 |            0.386 |
| Chaco                         |        2990 |        123 |              0.031 |              0.041 |                       131 |  17725 |            0.169 |
| Río Negro                     |        1321 |         59 |              0.039 |              0.045 |                       125 |   5811 |            0.227 |
| Córdoba                       |        1312 |         39 |              0.014 |              0.030 |                       133 |  25824 |            0.051 |
| SIN ESPECIFICAR               |        1110 |          4 |              0.003 |              0.004 |                       121 |   2713 |            0.409 |
| Neuquén                       |         900 |         22 |              0.020 |              0.024 |                       128 |   3742 |            0.241 |
| Jujuy                         |         740 |          1 |              0.000 |              0.001 |                       121 |   5334 |            0.139 |
| Santa Fe                      |         706 |          9 |              0.008 |              0.013 |                       129 |  17049 |            0.041 |
| Entre Ríos                    |         649 |          5 |              0.005 |              0.008 |                       126 |   3806 |            0.171 |
| Mendoza                       |         507 |         15 |              0.019 |              0.030 |                       131 |   4765 |            0.106 |
| Chubut                        |         241 |          2 |              0.004 |              0.008 |                       112 |   2434 |            0.099 |
| Tierra del Fuego              |         228 |          2 |              0.006 |              0.009 |                       124 |   1882 |            0.121 |
| Santa Cruz                    |         207 |          0 |              0.000 |              0.000 |                       118 |    977 |            0.212 |
| La Rioja                      |         186 |         15 |              0.060 |              0.081 |                       117 |   3123 |            0.060 |
| Salta                         |         166 |          2 |              0.007 |              0.012 |                       121 |   1544 |            0.108 |
| Corrientes                    |         131 |          1 |              0.003 |              0.008 |                       122 |   3800 |            0.034 |

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
| Buenos Aires                  |       72376 | 227102 |       1159 |               13.2 |              0.011 |              0.016 |            0.319 |           0.138 |                  0.016 |           0.006 |
| CABA                          |       45684 | 118296 |        870 |               14.5 |              0.016 |              0.019 |            0.386 |           0.222 |                  0.019 |           0.009 |
| Chaco                         |        2990 |  17725 |        123 |               14.6 |              0.031 |              0.041 |            0.169 |           0.099 |                  0.053 |           0.021 |
| Río Negro                     |        1321 |   5811 |         59 |               14.2 |              0.039 |              0.045 |            0.227 |           0.397 |                  0.029 |           0.019 |
| Córdoba                       |        1312 |  25824 |         39 |               24.9 |              0.014 |              0.030 |            0.051 |           0.101 |                  0.025 |           0.010 |
| SIN ESPECIFICAR               |        1110 |   2713 |          4 |               29.2 |              0.003 |              0.004 |            0.409 |           0.116 |                  0.006 |           0.003 |
| Neuquén                       |         900 |   3742 |         22 |               18.6 |              0.020 |              0.024 |            0.241 |           0.701 |                  0.012 |           0.007 |
| Jujuy                         |         740 |   5334 |          1 |               22.0 |              0.000 |              0.001 |            0.139 |           0.012 |                  0.003 |           0.003 |
| Santa Fe                      |         706 |  17049 |          9 |               17.9 |              0.008 |              0.013 |            0.041 |           0.126 |                  0.028 |           0.013 |
| Entre Ríos                    |         649 |   3806 |          5 |                7.8 |              0.005 |              0.008 |            0.171 |           0.216 |                  0.008 |           0.002 |
| Mendoza                       |         507 |   4765 |         15 |               11.1 |              0.019 |              0.030 |            0.106 |           0.606 |                  0.036 |           0.012 |
| Chubut                        |         241 |   2434 |          2 |               10.5 |              0.004 |              0.008 |            0.099 |           0.058 |                  0.017 |           0.012 |
| Tierra del Fuego              |         228 |   1882 |          2 |               19.0 |              0.006 |              0.009 |            0.121 |           0.031 |                  0.013 |           0.013 |
| Santa Cruz                    |         207 |    977 |          0 |                NaN |              0.000 |              0.000 |            0.212 |           0.145 |                  0.024 |           0.014 |
| La Rioja                      |         186 |   3123 |         15 |               13.2 |              0.060 |              0.081 |            0.060 |           0.108 |                  0.027 |           0.005 |
| Salta                         |         166 |   1544 |          2 |                2.5 |              0.007 |              0.012 |            0.108 |           0.343 |                  0.018 |           0.006 |
| Corrientes                    |         131 |   3800 |          1 |               12.0 |              0.003 |              0.008 |            0.034 |           0.031 |                  0.015 |           0.008 |
| Tucumán                       |          98 |   9405 |          4 |               14.2 |              0.007 |              0.041 |            0.010 |           0.286 |                  0.092 |           0.020 |
| Formosa                       |          76 |    794 |          0 |                NaN |              0.000 |              0.000 |            0.096 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     |          57 |   1700 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          45 |   1782 |          2 |                6.5 |              0.016 |              0.044 |            0.025 |           0.644 |                  0.133 |           0.067 |
| Santiago del Estero           |          44 |   3868 |          0 |                NaN |              0.000 |              0.000 |            0.011 |           0.045 |                  0.045 |           0.000 |
| San Luis                      |          17 |    687 |          0 |                NaN |              0.000 |              0.000 |            0.025 |           0.529 |                  0.059 |           0.000 |
| San Juan                      |          13 |    929 |          0 |                NaN |              0.000 |              0.000 |            0.014 |           0.385 |                  0.077 |           0.000 |
| La Pampa                      |           8 |    566 |          0 |                NaN |              0.000 |              0.000 |            0.014 |           0.125 |                  0.000 |           0.000 |

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
rg$getDepartamentosCrossSectionConfirmedPostitivyPlot()
```

<img src="man/figures/README-exponential_growth-2.png" width="100%" />

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
#> INFO  [08:45:17.091] Processing {current.group: }
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
|             11 | 2020-07-15              |                        36 |          95 |    666 |         65 |          9 |              0.066 |              0.095 |            0.143 |           0.684 |                  0.126 |           0.063 |
|             12 | 2020-07-15              |                        56 |         409 |   2048 |        253 |         17 |              0.033 |              0.042 |            0.200 |           0.619 |                  0.093 |           0.054 |
|             13 | 2020-07-16              |                        85 |        1077 |   5514 |        597 |         62 |              0.048 |              0.058 |            0.195 |           0.554 |                  0.095 |           0.057 |
|             14 | 2020-07-17              |                       111 |        1754 |  11529 |        963 |        112 |              0.052 |              0.064 |            0.152 |           0.549 |                  0.095 |           0.056 |
|             15 | 2020-07-20              |                       134 |        2406 |  20242 |       1302 |        173 |              0.057 |              0.072 |            0.119 |           0.541 |                  0.090 |           0.051 |
|             16 | 2020-07-20              |                       142 |        3181 |  31842 |       1643 |        228 |              0.056 |              0.072 |            0.100 |           0.517 |                  0.081 |           0.044 |
|             17 | 2020-07-20              |                       145 |        4249 |  45891 |       2146 |        329 |              0.061 |              0.077 |            0.093 |           0.505 |                  0.073 |           0.039 |
|             18 | 2020-07-20              |                       145 |        5210 |  59077 |       2533 |        392 |              0.059 |              0.075 |            0.088 |           0.486 |                  0.066 |           0.035 |
|             19 | 2020-07-20              |                       145 |        6613 |  73201 |       3103 |        466 |              0.056 |              0.070 |            0.090 |           0.469 |                  0.062 |           0.032 |
|             20 | 2020-07-20              |                       145 |        8949 |  90561 |       3929 |        548 |              0.050 |              0.061 |            0.099 |           0.439 |                  0.056 |           0.029 |
|             21 | 2020-07-20              |                       145 |       13228 | 113969 |       5214 |        684 |              0.042 |              0.052 |            0.116 |           0.394 |                  0.049 |           0.025 |
|             22 | 2020-07-20              |                       145 |       18372 | 139310 |       6617 |        845 |              0.038 |              0.046 |            0.132 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-20              |                       145 |       24676 | 167524 |       8114 |       1037 |              0.035 |              0.042 |            0.147 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-07-20              |                       145 |       34103 | 202538 |      10180 |       1239 |              0.030 |              0.036 |            0.168 |           0.299 |                  0.036 |           0.017 |
|             25 | 2020-07-20              |                       145 |       46745 | 243768 |      12422 |       1479 |              0.027 |              0.032 |            0.192 |           0.266 |                  0.031 |           0.014 |
|             26 | 2020-07-20              |                       145 |       64174 | 295289 |      15308 |       1775 |              0.023 |              0.028 |            0.217 |           0.239 |                  0.027 |           0.012 |
|             27 | 2020-07-20              |                       145 |       82308 | 345011 |      17771 |       2021 |              0.020 |              0.025 |            0.239 |           0.216 |                  0.024 |           0.010 |
|             28 | 2020-07-20              |                       145 |      104484 | 401880 |      20381 |       2240 |              0.018 |              0.021 |            0.260 |           0.195 |                  0.021 |           0.009 |
|             29 | 2020-07-20              |                       146 |      127816 | 461277 |      22504 |       2334 |              0.014 |              0.018 |            0.277 |           0.176 |                  0.018 |           0.008 |
|             30 | 2020-07-20              |                       146 |      129812 | 465658 |      22600 |       2334 |              0.013 |              0.018 |            0.279 |           0.174 |                  0.018 |           0.008 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [08:45:58.021] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [08:46:20.425] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [08:46:31.774] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [08:46:33.349] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [08:46:38.515] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [08:46:41.488] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [08:46:47.543] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [08:46:50.573] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [08:46:53.447] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [08:46:55.555] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [08:47:01.327] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [08:47:05.629] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [08:47:10.056] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [08:47:14.790] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [08:47:18.744] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [08:47:22.800] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [08:47:25.785] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [08:47:27.924] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [08:47:29.947] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [08:47:31.996] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [08:47:34.156] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [08:47:37.658] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [08:47:39.969] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [08:47:42.442] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [08:47:44.903] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       36896 |       5418 |        677 |              0.013 |              0.018 |            0.336 |           0.147 |                  0.018 |           0.008 |
| Buenos Aires                  | F    |       35198 |       4557 |        478 |              0.009 |              0.014 |            0.302 |           0.129 |                  0.013 |           0.004 |
| CABA                          | F    |       22967 |       4979 |        369 |              0.013 |              0.016 |            0.369 |           0.217 |                  0.014 |           0.006 |
| CABA                          | M    |       22530 |       5088 |        489 |              0.018 |              0.022 |            0.406 |           0.226 |                  0.025 |           0.011 |
| Chaco                         | F    |        1507 |        144 |         46 |              0.023 |              0.031 |            0.169 |           0.096 |                  0.044 |           0.013 |
| Chaco                         | M    |        1481 |        153 |         77 |              0.039 |              0.052 |            0.169 |           0.103 |                  0.062 |           0.029 |
| Río Negro                     | F    |         669 |        264 |         20 |              0.026 |              0.030 |            0.216 |           0.395 |                  0.016 |           0.009 |
| Córdoba                       | M    |         656 |         57 |         20 |              0.015 |              0.030 |            0.052 |           0.087 |                  0.027 |           0.014 |
| Córdoba                       | F    |         654 |         74 |         19 |              0.014 |              0.029 |            0.050 |           0.113 |                  0.023 |           0.006 |
| Río Negro                     | M    |         652 |        261 |         39 |              0.053 |              0.060 |            0.241 |           0.400 |                  0.041 |           0.029 |
| SIN ESPECIFICAR               | F    |         626 |         64 |          0 |              0.000 |              0.000 |            0.388 |           0.102 |                  0.005 |           0.000 |
| SIN ESPECIFICAR               | M    |         480 |         64 |          3 |              0.005 |              0.006 |            0.441 |           0.133 |                  0.006 |           0.004 |
| Neuquén                       | F    |         461 |        336 |         12 |              0.022 |              0.026 |            0.248 |           0.729 |                  0.011 |           0.007 |
| Jujuy                         | M    |         448 |          9 |          1 |              0.001 |              0.002 |            0.148 |           0.020 |                  0.004 |           0.004 |
| Neuquén                       | M    |         439 |        295 |         10 |              0.019 |              0.023 |            0.233 |           0.672 |                  0.014 |           0.007 |
| Santa Fe                      | F    |         354 |         34 |          2 |              0.003 |              0.006 |            0.040 |           0.096 |                  0.020 |           0.006 |
| Santa Fe                      | M    |         352 |         55 |          7 |              0.013 |              0.020 |            0.043 |           0.156 |                  0.037 |           0.020 |
| Entre Ríos                    | F    |         324 |         63 |          2 |              0.004 |              0.006 |            0.168 |           0.194 |                  0.006 |           0.000 |
| Entre Ríos                    | M    |         324 |         77 |          3 |              0.006 |              0.009 |            0.174 |           0.238 |                  0.009 |           0.003 |
| Jujuy                         | F    |         290 |          0 |          0 |              0.000 |              0.000 |            0.127 |           0.000 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |         282 |         31 |          4 |              0.008 |              0.014 |            0.356 |           0.110 |                  0.028 |           0.011 |
| Mendoza                       | M    |         257 |        154 |         13 |              0.032 |              0.051 |            0.108 |           0.599 |                  0.051 |           0.019 |
| Mendoza                       | F    |         246 |        151 |          2 |              0.005 |              0.008 |            0.104 |           0.614 |                  0.020 |           0.004 |
| CABA                          | NR   |         187 |         62 |         12 |              0.036 |              0.064 |            0.353 |           0.332 |                  0.048 |           0.037 |
| Tierra del Fuego              | M    |         162 |          4 |          2 |              0.010 |              0.012 |            0.155 |           0.025 |                  0.019 |           0.019 |
| Chubut                        | M    |         130 |          9 |          1 |              0.004 |              0.008 |            0.104 |           0.069 |                  0.015 |           0.015 |
| Santa Cruz                    | M    |         117 |         16 |          0 |              0.000 |              0.000 |            0.215 |           0.137 |                  0.034 |           0.017 |
| Chubut                        | F    |         107 |          5 |          1 |              0.005 |              0.009 |            0.093 |           0.047 |                  0.019 |           0.009 |
| Salta                         | M    |         103 |         34 |          2 |              0.011 |              0.019 |            0.101 |           0.330 |                  0.019 |           0.010 |
| La Rioja                      | F    |          99 |         12 |          7 |              0.053 |              0.071 |            0.066 |           0.121 |                  0.040 |           0.010 |
| Santa Cruz                    | F    |          90 |         14 |          0 |              0.000 |              0.000 |            0.208 |           0.156 |                  0.011 |           0.011 |
| La Rioja                      | M    |          87 |          8 |          8 |              0.067 |              0.092 |            0.054 |           0.092 |                  0.011 |           0.000 |
| Corrientes                    | M    |          78 |          3 |          1 |              0.005 |              0.013 |            0.037 |           0.038 |                  0.013 |           0.013 |
| Formosa                       | M    |          65 |          0 |          0 |              0.000 |              0.000 |            0.137 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          65 |          3 |          0 |              0.000 |              0.000 |            0.078 |           0.046 |                  0.000 |           0.000 |
| Salta                         | F    |          63 |         23 |          0 |              0.000 |              0.000 |            0.123 |           0.365 |                  0.016 |           0.000 |
| Tucumán                       | M    |          59 |         14 |          2 |              0.006 |              0.034 |            0.010 |           0.237 |                  0.051 |           0.000 |
| Corrientes                    | F    |          53 |          1 |          0 |              0.000 |              0.000 |            0.032 |           0.019 |                  0.019 |           0.000 |
| Tucumán                       | F    |          39 |         14 |          2 |              0.009 |              0.051 |            0.011 |           0.359 |                  0.154 |           0.051 |
| Catamarca                     | M    |          36 |          0 |          0 |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          34 |          1 |          0 |              0.000 |              0.000 |            0.013 |           0.029 |                  0.029 |           0.000 |
| Misiones                      | M    |          25 |         16 |          1 |              0.015 |              0.040 |            0.026 |           0.640 |                  0.160 |           0.080 |
| Catamarca                     | F    |          21 |          0 |          0 |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.018 |              0.050 |            0.024 |           0.650 |                  0.100 |           0.050 |
| San Luis                      | M    |          15 |          7 |          0 |              0.000 |              0.000 |            0.038 |           0.467 |                  0.067 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          10 |          1 |          0 |              0.000 |              0.000 |            0.009 |           0.100 |                  0.100 |           0.000 |

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
