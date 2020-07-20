
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
#> INFO  [09:42:16.355] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [09:42:20.763] Normalize 
#> INFO  [09:42:21.493] checkSoundness 
#> INFO  [09:42:21.837] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-19"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-19"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-19"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-19              |      126742 |       2260 |              0.013 |              0.018 |                       145 | 458174 |            0.277 |

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
| Buenos Aires                  |       70525 |       1122 |              0.011 |              0.016 |                       144 | 223100 |            0.316 |
| CABA                          |       44766 |        838 |              0.016 |              0.019 |                       142 | 116524 |            0.384 |
| Chaco                         |        2966 |        122 |              0.031 |              0.041 |                       129 |  17476 |            0.170 |
| Río Negro                     |        1320 |         56 |              0.038 |              0.042 |                       125 |   5775 |            0.229 |
| Córdoba                       |        1198 |         39 |              0.016 |              0.033 |                       132 |  25575 |            0.047 |
| SIN ESPECIFICAR               |        1091 |          3 |              0.002 |              0.003 |                       120 |   2706 |            0.403 |
| Neuquén                       |         889 |         22 |              0.021 |              0.025 |                       127 |   3703 |            0.240 |
| Santa Fe                      |         691 |          9 |              0.008 |              0.013 |                       128 |  16867 |            0.041 |
| Jujuy                         |         688 |          1 |              0.000 |              0.001 |                       120 |   5046 |            0.136 |
| Entre Ríos                    |         631 |          5 |              0.005 |              0.008 |                       125 |   3663 |            0.172 |
| Mendoza                       |         487 |         15 |              0.020 |              0.031 |                       131 |   4715 |            0.103 |
| Chubut                        |         237 |          2 |              0.004 |              0.008 |                       110 |   2357 |            0.101 |
| Tierra del Fuego              |         228 |          2 |              0.007 |              0.009 |                       123 |   1875 |            0.122 |
| La Rioja                      |         186 |         15 |              0.060 |              0.081 |                       116 |   3113 |            0.060 |
| Santa Cruz                    |         185 |          0 |              0.000 |              0.000 |                       117 |    930 |            0.199 |
| Salta                         |         165 |          2 |              0.007 |              0.012 |                       120 |   1531 |            0.108 |
| Corrientes                    |         129 |          1 |              0.003 |              0.008 |                       122 |   3797 |            0.034 |

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
| Buenos Aires                  |       70525 | 223100 |       1122 |               13.1 |              0.011 |              0.016 |            0.316 |           0.139 |                  0.016 |           0.006 |
| CABA                          |       44766 | 116524 |        838 |               14.4 |              0.016 |              0.019 |            0.384 |           0.223 |                  0.020 |           0.009 |
| Chaco                         |        2966 |  17476 |        122 |               14.6 |              0.031 |              0.041 |            0.170 |           0.099 |                  0.053 |           0.021 |
| Río Negro                     |        1320 |   5775 |         56 |               14.2 |              0.038 |              0.042 |            0.229 |           0.392 |                  0.029 |           0.019 |
| Córdoba                       |        1198 |  25575 |         39 |               24.9 |              0.016 |              0.033 |            0.047 |           0.110 |                  0.028 |           0.011 |
| SIN ESPECIFICAR               |        1091 |   2706 |          3 |               23.0 |              0.002 |              0.003 |            0.403 |           0.115 |                  0.006 |           0.003 |
| Neuquén                       |         889 |   3703 |         22 |               18.6 |              0.021 |              0.025 |            0.240 |           0.666 |                  0.012 |           0.007 |
| Santa Fe                      |         691 |  16867 |          9 |               17.9 |              0.008 |              0.013 |            0.041 |           0.129 |                  0.029 |           0.013 |
| Jujuy                         |         688 |   5046 |          1 |               22.0 |              0.000 |              0.001 |            0.136 |           0.012 |                  0.003 |           0.003 |
| Entre Ríos                    |         631 |   3663 |          5 |                7.8 |              0.005 |              0.008 |            0.172 |           0.219 |                  0.008 |           0.002 |
| Mendoza                       |         487 |   4715 |         15 |               11.1 |              0.020 |              0.031 |            0.103 |           0.620 |                  0.037 |           0.012 |
| Chubut                        |         237 |   2357 |          2 |               10.5 |              0.004 |              0.008 |            0.101 |           0.063 |                  0.017 |           0.013 |
| Tierra del Fuego              |         228 |   1875 |          2 |               19.0 |              0.007 |              0.009 |            0.122 |           0.031 |                  0.013 |           0.013 |
| La Rioja                      |         186 |   3113 |         15 |               13.2 |              0.060 |              0.081 |            0.060 |           0.108 |                  0.027 |           0.005 |
| Santa Cruz                    |         185 |    930 |          0 |                NaN |              0.000 |              0.000 |            0.199 |           0.162 |                  0.027 |           0.016 |
| Salta                         |         165 |   1531 |          2 |                2.5 |              0.007 |              0.012 |            0.108 |           0.333 |                  0.018 |           0.006 |
| Corrientes                    |         129 |   3797 |          1 |               12.0 |              0.003 |              0.008 |            0.034 |           0.023 |                  0.016 |           0.008 |
| Tucumán                       |          99 |   9321 |          4 |               14.2 |              0.007 |              0.040 |            0.011 |           0.273 |                  0.091 |           0.020 |
| Formosa                       |          77 |    794 |          0 |                NaN |              0.000 |              0.000 |            0.097 |           0.000 |                  0.000 |           0.000 |
| Catamarca                     |          57 |   1687 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          46 |   1779 |          2 |                6.5 |              0.018 |              0.043 |            0.026 |           0.630 |                  0.130 |           0.065 |
| Santiago del Estero           |          43 |   3683 |          0 |                NaN |              0.000 |              0.000 |            0.012 |           0.047 |                  0.047 |           0.000 |
| San Luis                      |          16 |    671 |          0 |                NaN |              0.000 |              0.000 |            0.024 |           0.500 |                  0.062 |           0.000 |
| San Juan                      |          14 |    924 |          0 |                NaN |              0.000 |              0.000 |            0.015 |           0.357 |                  0.071 |           0.000 |
| La Pampa                      |           8 |    562 |          0 |                NaN |              0.000 |              0.000 |            0.014 |           0.125 |                  0.000 |           0.000 |

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
#> INFO  [09:43:38.349] Processing {current.group: }
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
|             15 | 2020-07-19              |                       133 |        2406 |  20241 |       1302 |        173 |              0.057 |              0.072 |            0.119 |           0.541 |                  0.090 |           0.051 |
|             16 | 2020-07-19              |                       141 |        3178 |  31841 |       1642 |        228 |              0.056 |              0.072 |            0.100 |           0.517 |                  0.081 |           0.044 |
|             17 | 2020-07-19              |                       144 |        4245 |  45890 |       2145 |        329 |              0.061 |              0.078 |            0.093 |           0.505 |                  0.073 |           0.039 |
|             18 | 2020-07-19              |                       144 |        5205 |  59076 |       2532 |        392 |              0.059 |              0.075 |            0.088 |           0.486 |                  0.066 |           0.035 |
|             19 | 2020-07-19              |                       144 |        6608 |  73200 |       3100 |        466 |              0.056 |              0.071 |            0.090 |           0.469 |                  0.062 |           0.032 |
|             20 | 2020-07-19              |                       144 |        8941 |  90559 |       3923 |        547 |              0.049 |              0.061 |            0.099 |           0.439 |                  0.056 |           0.029 |
|             21 | 2020-07-19              |                       144 |       13217 | 113967 |       5207 |        683 |              0.042 |              0.052 |            0.116 |           0.394 |                  0.049 |           0.025 |
|             22 | 2020-07-19              |                       144 |       18357 | 139307 |       6606 |        844 |              0.038 |              0.046 |            0.132 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-19              |                       144 |       24655 | 167519 |       8099 |       1035 |              0.035 |              0.042 |            0.147 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-07-19              |                       144 |       34077 | 202531 |      10162 |       1237 |              0.030 |              0.036 |            0.168 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-07-19              |                       144 |       46716 | 243757 |      12395 |       1472 |              0.027 |              0.032 |            0.192 |           0.265 |                  0.031 |           0.014 |
|             26 | 2020-07-19              |                       144 |       64137 | 295269 |      15261 |       1762 |              0.023 |              0.027 |            0.217 |           0.238 |                  0.027 |           0.012 |
|             27 | 2020-07-19              |                       144 |       82245 | 344896 |      17697 |       1991 |              0.020 |              0.024 |            0.238 |           0.215 |                  0.024 |           0.010 |
|             28 | 2020-07-19              |                       144 |      104362 | 401483 |      20238 |       2186 |              0.017 |              0.021 |            0.260 |           0.194 |                  0.021 |           0.009 |
|             29 | 2020-07-19              |                       145 |      126234 | 457119 |      22168 |       2260 |              0.013 |              0.018 |            0.276 |           0.176 |                  0.018 |           0.008 |
|             30 | 2020-07-19              |                       145 |      126742 | 458174 |      22177 |       2260 |              0.013 |              0.018 |            0.277 |           0.175 |                  0.018 |           0.008 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [09:44:09.139] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [09:44:23.855] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [09:44:32.677] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [09:44:33.950] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [09:44:36.829] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [09:44:38.515] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [09:44:42.285] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [09:44:44.333] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [09:44:46.371] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [09:44:47.754] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [09:44:49.865] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [09:44:51.604] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [09:44:53.456] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [09:44:55.519] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [09:44:57.268] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [09:44:59.172] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [09:45:01.336] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [09:45:03.157] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [09:45:04.980] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [09:45:06.716] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [09:45:08.462] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [09:45:11.402] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [09:45:13.298] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [09:45:15.116] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [09:45:17.062] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       35969 |       5308 |        654 |              0.013 |              0.018 |            0.333 |           0.148 |                  0.018 |           0.008 |
| Buenos Aires                  | F    |       34287 |       4473 |        464 |              0.009 |              0.014 |            0.300 |           0.130 |                  0.013 |           0.004 |
| CABA                          | F    |       22497 |       4901 |        356 |              0.013 |              0.016 |            0.367 |           0.218 |                  0.014 |           0.006 |
| CABA                          | M    |       22086 |       5001 |        470 |              0.018 |              0.021 |            0.404 |           0.226 |                  0.025 |           0.011 |
| Chaco                         | F    |        1492 |        144 |         46 |              0.024 |              0.031 |            0.170 |           0.097 |                  0.044 |           0.013 |
| Chaco                         | M    |        1472 |        151 |         76 |              0.038 |              0.052 |            0.170 |           0.103 |                  0.062 |           0.029 |
| Río Negro                     | F    |         669 |        263 |         20 |              0.027 |              0.030 |            0.217 |           0.393 |                  0.016 |           0.009 |
| Río Negro                     | M    |         651 |        255 |         36 |              0.050 |              0.055 |            0.243 |           0.392 |                  0.041 |           0.029 |
| SIN ESPECIFICAR               | F    |         608 |         64 |          0 |              0.000 |              0.000 |            0.380 |           0.105 |                  0.005 |           0.000 |
| Córdoba                       | M    |         602 |         57 |         20 |              0.017 |              0.033 |            0.048 |           0.095 |                  0.030 |           0.015 |
| Córdoba                       | F    |         594 |         74 |         19 |              0.015 |              0.032 |            0.046 |           0.125 |                  0.025 |           0.007 |
| SIN ESPECIFICAR               | M    |         479 |         61 |          2 |              0.003 |              0.004 |            0.439 |           0.127 |                  0.006 |           0.004 |
| Neuquén                       | F    |         456 |        315 |         12 |              0.023 |              0.026 |            0.249 |           0.691 |                  0.011 |           0.007 |
| Neuquén                       | M    |         433 |        277 |         10 |              0.020 |              0.023 |            0.232 |           0.640 |                  0.014 |           0.007 |
| Jujuy                         | M    |         425 |          8 |          1 |              0.001 |              0.002 |            0.147 |           0.019 |                  0.005 |           0.005 |
| Santa Fe                      | M    |         346 |         55 |          7 |              0.014 |              0.020 |            0.042 |           0.159 |                  0.038 |           0.020 |
| Santa Fe                      | F    |         345 |         34 |          2 |              0.004 |              0.006 |            0.040 |           0.099 |                  0.020 |           0.006 |
| Entre Ríos                    | F    |         316 |         63 |          2 |              0.004 |              0.006 |            0.170 |           0.199 |                  0.006 |           0.000 |
| Entre Ríos                    | M    |         314 |         75 |          3 |              0.006 |              0.010 |            0.175 |           0.239 |                  0.010 |           0.003 |
| Buenos Aires                  | NR   |         269 |         30 |          4 |              0.008 |              0.015 |            0.351 |           0.112 |                  0.026 |           0.007 |
| Jujuy                         | F    |         261 |          0 |          0 |              0.000 |              0.000 |            0.123 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | M    |         248 |        152 |         13 |              0.034 |              0.052 |            0.106 |           0.613 |                  0.052 |           0.020 |
| Mendoza                       | F    |         235 |        148 |          2 |              0.006 |              0.009 |            0.100 |           0.630 |                  0.021 |           0.004 |
| CABA                          | NR   |         183 |         62 |         12 |              0.037 |              0.066 |            0.351 |           0.339 |                  0.049 |           0.038 |
| Tierra del Fuego              | M    |         162 |          4 |          2 |              0.011 |              0.012 |            0.156 |           0.025 |                  0.019 |           0.019 |
| Chubut                        | M    |         129 |          9 |          1 |              0.004 |              0.008 |            0.105 |           0.070 |                  0.016 |           0.016 |
| Santa Cruz                    | M    |         110 |         16 |          0 |              0.000 |              0.000 |            0.209 |           0.145 |                  0.036 |           0.018 |
| Chubut                        | F    |         105 |          6 |          1 |              0.004 |              0.010 |            0.095 |           0.057 |                  0.019 |           0.010 |
| Salta                         | M    |         103 |         34 |          2 |              0.011 |              0.019 |            0.101 |           0.330 |                  0.019 |           0.010 |
| La Rioja                      | F    |          99 |         12 |          7 |              0.053 |              0.071 |            0.066 |           0.121 |                  0.040 |           0.010 |
| La Rioja                      | M    |          87 |          8 |          8 |              0.067 |              0.092 |            0.054 |           0.092 |                  0.011 |           0.000 |
| Corrientes                    | M    |          78 |          3 |          1 |              0.005 |              0.013 |            0.037 |           0.038 |                  0.013 |           0.013 |
| Santa Cruz                    | F    |          75 |         14 |          0 |              0.000 |              0.000 |            0.186 |           0.187 |                  0.013 |           0.013 |
| Formosa                       | M    |          66 |          0 |          0 |              0.000 |              0.000 |            0.139 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          65 |          3 |          0 |              0.000 |              0.000 |            0.078 |           0.046 |                  0.000 |           0.000 |
| Salta                         | F    |          62 |         21 |          0 |              0.000 |              0.000 |            0.122 |           0.339 |                  0.016 |           0.000 |
| Tucumán                       | M    |          59 |         14 |          2 |              0.006 |              0.034 |            0.010 |           0.237 |                  0.051 |           0.000 |
| Corrientes                    | F    |          51 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.020 |           0.000 |
| Tucumán                       | F    |          40 |         13 |          2 |              0.008 |              0.050 |            0.011 |           0.325 |                  0.150 |           0.050 |
| Catamarca                     | M    |          36 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          33 |          1 |          0 |              0.000 |              0.000 |            0.013 |           0.030 |                  0.030 |           0.000 |
| Misiones                      | M    |          25 |         16 |          1 |              0.016 |              0.040 |            0.026 |           0.640 |                  0.160 |           0.080 |
| Catamarca                     | F    |          21 |          0 |          0 |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          21 |         13 |          1 |              0.020 |              0.048 |            0.025 |           0.619 |                  0.095 |           0.048 |
| San Luis                      | M    |          14 |          6 |          0 |              0.000 |              0.000 |            0.036 |           0.429 |                  0.071 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| San Juan                      | M    |          10 |          2 |          0 |              0.000 |              0.000 |            0.019 |           0.200 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          10 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.100 |                  0.100 |           0.000 |

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
