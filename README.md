
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
#> Warning: replacing previous import 'magrittr::not' by 'testthat::not' when
#> loading 'COVID19AR'
#> Warning: replacing previous import 'dplyr::matches' by 'testthat::matches' when
#> loading 'COVID19AR'
#> Warning: replacing previous import 'magrittr::equals' by 'testthat::equals' when
#> loading 'COVID19AR'
#> Warning: replacing previous import 'magrittr::is_less_than' by
#> 'testthat::is_less_than' when loading 'COVID19AR'
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
covid19.curator <- COVID19ARCurator$new(report.date = Sys.Date() -1 , 
                                        download.new.data = FALSE)

dummy <- covid19.curator$loadData()
#> INFO  [09:16:18.046] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [09:16:33.751] Normalize 
#> INFO  [09:16:39.024] checkSoundness 
#> INFO  [09:16:41.136] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-11-11"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-11-11"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-11-11"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| 2020-11-11              |     1273347 |      34531 |              0.023 |              0.027 |                       267 | 2599339 |             0.49 |

``` r
covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
  filter(confirmados >= 100) %>%
  arrange(desc(confirmados))
# Provinces with > 100 confirmed cases
kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |   tests | positividad.porc |
|:------------------------------|------------:|-----------:|-------------------:|-------------------:|--------------------------:|--------:|-----------------:|
| Buenos Aires                  |      577838 |      18862 |              0.028 |              0.033 |                       259 | 1222024 |            0.473 |
| CABA                          |      151000 |       5172 |              0.032 |              0.034 |                       257 |  423290 |            0.357 |
| Santa Fe                      |      122821 |       1835 |              0.013 |              0.015 |                       243 |  149744 |            0.820 |
| Córdoba                       |       97413 |       1580 |              0.012 |              0.016 |                       249 |  172476 |            0.565 |
| Tucumán                       |       57081 |        958 |              0.011 |              0.017 |                       238 |   66247 |            0.862 |
| Mendoza                       |       51879 |       1004 |              0.016 |              0.019 |                       248 |   93235 |            0.556 |
| Río Negro                     |       27329 |        692 |              0.022 |              0.025 |                       240 |   44119 |            0.619 |
| Neuquén                       |       25878 |        459 |              0.013 |              0.018 |                       242 |   32942 |            0.786 |
| Salta                         |       19786 |        915 |              0.037 |              0.046 |                       235 |   37208 |            0.532 |
| Entre Ríos                    |       18955 |        349 |              0.015 |              0.018 |                       241 |   33156 |            0.572 |
| Jujuy                         |       18070 |        837 |              0.038 |              0.046 |                       237 |   45000 |            0.402 |
| Chubut                        |       18047 |        236 |              0.010 |              0.013 |                       228 |   19408 |            0.930 |
| Chaco                         |       15511 |        472 |              0.022 |              0.030 |                       245 |   66230 |            0.234 |
| Tierra del Fuego              |       13662 |        171 |              0.012 |              0.013 |                       239 |   20325 |            0.672 |
| Santiago del Estero           |       11910 |        146 |              0.010 |              0.012 |                       229 |   39414 |            0.302 |
| Santa Cruz                    |       11777 |        183 |              0.012 |              0.016 |                       234 |   18448 |            0.638 |
| San Luis                      |       10180 |        123 |              0.008 |              0.012 |                       224 |   28773 |            0.354 |
| La Rioja                      |        7955 |        294 |              0.034 |              0.037 |                       232 |   21573 |            0.369 |
| La Pampa                      |        4380 |         46 |              0.009 |              0.011 |                       223 |   17569 |            0.249 |
| San Juan                      |        4114 |        102 |              0.016 |              0.025 |                       230 |    4712 |            0.873 |
| Corrientes                    |        3244 |         58 |              0.012 |              0.018 |                       238 |   15056 |            0.215 |
| SIN ESPECIFICAR               |        2697 |         26 |              0.008 |              0.010 |                       234 |    6444 |            0.419 |
| Catamarca                     |        1301 |          2 |              0.001 |              0.002 |                       218 |   12126 |            0.107 |
| Misiones                      |         359 |          7 |              0.012 |              0.019 |                       217 |    7915 |            0.045 |
| Formosa                       |         160 |          2 |              0.008 |              0.013 |                       213 |    1905 |            0.084 |

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
nrow(covid19.ar.summary)
#> [1] 25
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
        select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))
```

| residencia\_provincia\_nombre | confirmados |   tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|------------:|--------:|-----------:|-------------------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  |      577838 | 1222024 |      18862 |               16.9 |              0.028 |              0.033 |            0.473 |           0.064 |                  0.010 |           0.005 |
| CABA                          |      151000 |  423290 |       5172 |               17.2 |              0.032 |              0.034 |            0.357 |           0.143 |                  0.018 |           0.009 |
| Santa Fe                      |      122821 |  149744 |       1835 |               13.1 |              0.013 |              0.015 |            0.820 |           0.025 |                  0.007 |           0.004 |
| Córdoba                       |       97413 |  172476 |       1580 |               13.1 |              0.012 |              0.016 |            0.565 |           0.020 |                  0.009 |           0.003 |
| Tucumán                       |       57081 |   66247 |        958 |               11.6 |              0.011 |              0.017 |            0.862 |           0.007 |                  0.002 |           0.001 |
| Mendoza                       |       51879 |   93235 |       1004 |               12.4 |              0.016 |              0.019 |            0.556 |           0.061 |                  0.007 |           0.004 |
| Río Negro                     |       27329 |   44119 |        692 |               15.2 |              0.022 |              0.025 |            0.619 |           0.141 |                  0.006 |           0.004 |
| Neuquén                       |       25878 |   32942 |        459 |               18.0 |              0.013 |              0.018 |            0.786 |           0.346 |                  0.009 |           0.007 |
| Salta                         |       19786 |   37208 |        915 |               14.2 |              0.037 |              0.046 |            0.532 |           0.105 |                  0.020 |           0.011 |
| Entre Ríos                    |       18955 |   33156 |        349 |               15.4 |              0.015 |              0.018 |            0.572 |           0.067 |                  0.007 |           0.003 |
| Jujuy                         |       18070 |   45000 |        837 |               19.0 |              0.038 |              0.046 |            0.402 |           0.023 |                  0.010 |           0.006 |
| Chubut                        |       18047 |   19408 |        236 |               11.2 |              0.010 |              0.013 |            0.930 |           0.010 |                  0.003 |           0.002 |
| Chaco                         |       15511 |   66230 |        472 |               14.4 |              0.022 |              0.030 |            0.234 |           0.077 |                  0.040 |           0.019 |
| Tierra del Fuego              |       13662 |   20325 |        171 |               15.0 |              0.012 |              0.013 |            0.672 |           0.017 |                  0.006 |           0.005 |
| Santiago del Estero           |       11910 |   39414 |        146 |               11.1 |              0.010 |              0.012 |            0.302 |           0.013 |                  0.002 |           0.001 |
| Santa Cruz                    |       11777 |   18448 |        183 |               15.5 |              0.012 |              0.016 |            0.638 |           0.056 |                  0.012 |           0.009 |
| San Luis                      |       10180 |   28773 |        123 |               12.7 |              0.008 |              0.012 |            0.354 |           0.023 |                  0.006 |           0.005 |
| La Rioja                      |        7955 |   21573 |        294 |               16.9 |              0.034 |              0.037 |            0.369 |           0.007 |                  0.002 |           0.001 |
| La Pampa                      |        4380 |   17569 |         46 |               14.5 |              0.009 |              0.011 |            0.249 |           0.021 |                  0.005 |           0.002 |
| San Juan                      |        4114 |    4712 |        102 |               10.7 |              0.016 |              0.025 |            0.873 |           0.024 |                  0.010 |           0.003 |
| Corrientes                    |        3244 |   15056 |         58 |               10.2 |              0.012 |              0.018 |            0.215 |           0.024 |                  0.016 |           0.011 |
| SIN ESPECIFICAR               |        2697 |    6444 |         26 |               23.1 |              0.008 |              0.010 |            0.419 |           0.064 |                  0.008 |           0.004 |
| Catamarca                     |        1301 |   12126 |          2 |               16.0 |              0.001 |              0.002 |            0.107 |           0.013 |                  0.002 |           0.000 |
| Misiones                      |         359 |    7915 |          7 |                9.5 |              0.012 |              0.019 |            0.045 |           0.217 |                  0.028 |           0.014 |
| Formosa                       |         160 |    1905 |          2 |               12.0 |              0.008 |              0.013 |            0.084 |           0.419 |                  0.000 |           0.000 |

``` r
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
```

<img src="man/figures/README-exponential_growth-1.png" width="100%" />

``` r
rg$getDepartamentosCrossSectionConfirmedPostivityPlot()
```

<img src="man/figures/README-exponential_growth-2.png" width="100%" />

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
#> INFO  [09:25:18.568] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 37
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% 
        filter(confirmados > 0) %>% 
        arrange(sepi_apertura, desc(confirmados)) %>% 
        select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))
```

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |   tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|---------------:|:------------------------|--------------------------:|------------:|--------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
|             10 | 2020-11-03              |                        22 |          16 |      87 |          9 |          1 |              0.053 |              0.062 |            0.184 |           0.562 |                  0.125 |           0.125 |
|             11 | 2020-11-03              |                        48 |         103 |     671 |         69 |          9 |              0.069 |              0.087 |            0.154 |           0.670 |                  0.117 |           0.058 |
|             12 | 2020-11-03              |                        84 |         430 |    2059 |        265 |         17 |              0.034 |              0.040 |            0.209 |           0.616 |                  0.088 |           0.051 |
|             13 | 2020-11-07              |                       141 |        1140 |    5539 |        625 |         66 |              0.051 |              0.058 |            0.206 |           0.548 |                  0.090 |           0.054 |
|             14 | 2020-11-07              |                       195 |        1894 |   11580 |       1024 |        121 |              0.056 |              0.064 |            0.164 |           0.541 |                  0.090 |           0.053 |
|             15 | 2020-11-10              |                       232 |        2663 |   20319 |       1401 |        190 |              0.062 |              0.071 |            0.131 |           0.526 |                  0.084 |           0.047 |
|             16 | 2020-11-11              |                       251 |        3620 |   31956 |       1791 |        258 |              0.061 |              0.071 |            0.113 |           0.495 |                  0.074 |           0.040 |
|             17 | 2020-11-11              |                       256 |        4910 |   46042 |       2361 |        385 |              0.068 |              0.078 |            0.107 |           0.481 |                  0.067 |           0.035 |
|             18 | 2020-11-11              |                       256 |        6069 |   59270 |       2804 |        494 |              0.071 |              0.081 |            0.102 |           0.462 |                  0.060 |           0.031 |
|             19 | 2020-11-11              |                       257 |        7711 |   73440 |       3442 |        609 |              0.070 |              0.079 |            0.105 |           0.446 |                  0.056 |           0.029 |
|             20 | 2020-11-11              |                       258 |       10292 |   90917 |       4341 |        736 |              0.064 |              0.072 |            0.113 |           0.422 |                  0.052 |           0.027 |
|             21 | 2020-11-11              |                       258 |       14981 |  114448 |       5748 |        954 |              0.057 |              0.064 |            0.131 |           0.384 |                  0.047 |           0.023 |
|             22 | 2020-11-11              |                       258 |       20511 |  139964 |       7284 |       1227 |              0.054 |              0.060 |            0.147 |           0.355 |                  0.043 |           0.021 |
|             23 | 2020-11-11              |                       258 |       27338 |  168361 |       8903 |       1561 |              0.052 |              0.057 |            0.162 |           0.326 |                  0.040 |           0.019 |
|             24 | 2020-11-11              |                       259 |       37402 |  203669 |      11150 |       1992 |              0.048 |              0.053 |            0.184 |           0.298 |                  0.036 |           0.017 |
|             25 | 2020-11-11              |                       259 |       50658 |  245314 |      13637 |       2557 |              0.046 |              0.050 |            0.207 |           0.269 |                  0.031 |           0.014 |
|             26 | 2020-11-11              |                       259 |       69073 |  297885 |      16869 |       3328 |              0.044 |              0.048 |            0.232 |           0.244 |                  0.028 |           0.013 |
|             27 | 2020-11-11              |                       259 |       88435 |  349534 |      19806 |       4178 |              0.043 |              0.047 |            0.253 |           0.224 |                  0.026 |           0.011 |
|             28 | 2020-11-11              |                       260 |      112533 |  409145 |      23284 |       5290 |              0.042 |              0.047 |            0.275 |           0.207 |                  0.024 |           0.011 |
|             29 | 2020-11-11              |                       262 |      142354 |  481908 |      27103 |       6619 |              0.042 |              0.046 |            0.295 |           0.190 |                  0.023 |           0.010 |
|             30 | 2020-11-11              |                       262 |      181015 |  568816 |      30965 |       8115 |              0.040 |              0.045 |            0.318 |           0.171 |                  0.021 |           0.010 |
|             31 | 2020-11-11              |                       262 |      221415 |  660050 |      34409 |       9531 |              0.039 |              0.043 |            0.335 |           0.155 |                  0.019 |           0.009 |
|             32 | 2020-11-11              |                       262 |      271709 |  769564 |      38405 |      11257 |              0.037 |              0.041 |            0.353 |           0.141 |                  0.018 |           0.008 |
|             33 | 2020-11-11              |                       262 |      319515 |  884864 |      42279 |      12858 |              0.036 |              0.040 |            0.361 |           0.132 |                  0.017 |           0.008 |
|             34 | 2020-11-11              |                       262 |      369247 |  996669 |      46184 |      14660 |              0.035 |              0.040 |            0.370 |           0.125 |                  0.016 |           0.008 |
|             35 | 2020-11-11              |                       262 |      435262 | 1133509 |      50911 |      16775 |              0.034 |              0.039 |            0.384 |           0.117 |                  0.016 |           0.007 |
|             36 | 2020-11-11              |                       262 |      505848 | 1276668 |      55401 |      18984 |              0.033 |              0.038 |            0.396 |           0.110 |                  0.015 |           0.007 |
|             37 | 2020-11-11              |                       262 |      581896 | 1430449 |      60184 |      21259 |              0.033 |              0.037 |            0.407 |           0.103 |                  0.014 |           0.007 |
|             38 | 2020-11-11              |                       262 |      656077 | 1575809 |      64553 |      23394 |              0.032 |              0.036 |            0.416 |           0.098 |                  0.014 |           0.007 |
|             39 | 2020-11-11              |                       263 |      734813 | 1717120 |      69087 |      25572 |              0.031 |              0.035 |            0.428 |           0.094 |                  0.013 |           0.007 |
|             40 | 2020-11-11              |                       265 |      820362 | 1857306 |      73365 |      27706 |              0.030 |              0.034 |            0.442 |           0.089 |                  0.013 |           0.006 |
|             41 | 2020-11-11              |                       266 |      911659 | 1997663 |      77543 |      29819 |              0.029 |              0.033 |            0.456 |           0.085 |                  0.012 |           0.006 |
|             42 | 2020-11-11              |                       266 |     1006567 | 2131484 |      81102 |      31734 |              0.028 |              0.032 |            0.472 |           0.081 |                  0.012 |           0.006 |
|             43 | 2020-11-11              |                       266 |     1101223 | 2269990 |      83748 |      33166 |              0.026 |              0.030 |            0.485 |           0.076 |                  0.011 |           0.006 |
|             44 | 2020-11-11              |                       267 |     1179513 | 2394707 |      85679 |      34088 |              0.025 |              0.029 |            0.493 |           0.073 |                  0.011 |           0.005 |
|             45 | 2020-11-11              |                       267 |     1245616 | 2527240 |      86929 |      34476 |              0.024 |              0.028 |            0.493 |           0.070 |                  0.010 |           0.005 |
|             46 | 2020-11-11              |                       267 |     1273347 | 2599339 |      87260 |      34531 |              0.023 |              0.027 |            0.490 |           0.069 |                  0.010 |           0.005 |


    ```r
    covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
    #> INFO  [09:30:43.778] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
    #> INFO  [09:33:36.621] Processing {current.group: residencia_provincia_nombre = CABA}
    #> INFO  [09:35:04.643] Processing {current.group: residencia_provincia_nombre = Catamarca}
    #> INFO  [09:35:09.849] Processing {current.group: residencia_provincia_nombre = Chaco}
    #> INFO  [09:35:23.570] Processing {current.group: residencia_provincia_nombre = Chubut}
    #> INFO  [09:35:30.657] Processing {current.group: residencia_provincia_nombre = Córdoba}
    #> INFO  [09:35:58.139] Processing {current.group: residencia_provincia_nombre = Corrientes}
    #> INFO  [09:36:06.147] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
    #> INFO  [09:36:16.205] Processing {current.group: residencia_provincia_nombre = Formosa}
    #> INFO  [09:36:21.339] Processing {current.group: residencia_provincia_nombre = Jujuy}
    #> INFO  [09:36:31.495] Processing {current.group: residencia_provincia_nombre = La Pampa}
    #> INFO  [09:36:36.401] Processing {current.group: residencia_provincia_nombre = La Rioja}
    #> INFO  [09:36:43.305] Processing {current.group: residencia_provincia_nombre = Mendoza}
    #> INFO  [09:36:56.125] Processing {current.group: residencia_provincia_nombre = Misiones}
    #> INFO  [09:37:01.038] Processing {current.group: residencia_provincia_nombre = Neuquén}
    #> INFO  [09:37:09.288] Processing {current.group: residencia_provincia_nombre = Río Negro}
    #> INFO  [09:37:18.764] Processing {current.group: residencia_provincia_nombre = Salta}
    #> INFO  [09:37:26.661] Processing {current.group: residencia_provincia_nombre = San Juan}
    #> INFO  [09:37:30.934] Processing {current.group: residencia_provincia_nombre = San Luis}
    #> INFO  [09:37:36.372] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
    #> INFO  [09:37:41.907] Processing {current.group: residencia_provincia_nombre = Santa Fe}
    #> INFO  [09:38:03.763] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
    #> INFO  [09:38:11.776] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
    #> INFO  [09:38:17.153] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
    #> INFO  [09:38:23.531] Processing {current.group: residencia_provincia_nombre = Tucumán}
    nrow(covid19.ar.summary)
    #> [1] 868
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
#> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_, : no
#> non-missing arguments to max; returning -Inf
nrow(covid19.ar.summary)
#> [1] 71
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
|:------------------------------|:-----|------------:|-----------:|-----------:|-------------------:|-------------------:|-----------------:|----------------:|-----------------------:|----------------:|
| Buenos Aires                  | M    |      291985 |      20373 |      10453 |              0.031 |              0.036 |            0.486 |           0.070 |                  0.012 |           0.006 |
| Buenos Aires                  | F    |      283847 |      16692 |       8286 |              0.025 |              0.029 |            0.460 |           0.059 |                  0.008 |           0.003 |
| CABA                          | F    |       76190 |      10317 |       2414 |              0.029 |              0.032 |            0.336 |           0.135 |                  0.013 |           0.006 |
| CABA                          | M    |       74198 |      11112 |       2705 |              0.034 |              0.036 |            0.381 |           0.150 |                  0.022 |           0.012 |
| Santa Fe                      | F    |       62802 |       1344 |        810 |              0.012 |              0.013 |            0.811 |           0.021 |                  0.005 |           0.003 |
| Santa Fe                      | M    |       59961 |       1684 |       1022 |              0.015 |              0.017 |            0.831 |           0.028 |                  0.009 |           0.005 |
| Córdoba                       | F    |       49834 |        916 |        659 |              0.010 |              0.013 |            0.560 |           0.018 |                  0.007 |           0.002 |
| Córdoba                       | M    |       47532 |       1048 |        918 |              0.015 |              0.019 |            0.570 |           0.022 |                  0.010 |           0.003 |
| Tucumán                       | M    |       29087 |        245 |        599 |              0.013 |              0.021 |            0.815 |           0.008 |                  0.002 |           0.001 |
| Tucumán                       | F    |       27966 |        174 |        359 |              0.008 |              0.013 |            0.916 |           0.006 |                  0.001 |           0.001 |
| Mendoza                       | F    |       26064 |       1408 |        392 |              0.012 |              0.015 |            0.544 |           0.054 |                  0.004 |           0.002 |
| Mendoza                       | M    |       25610 |       1730 |        608 |              0.019 |              0.024 |            0.571 |           0.068 |                  0.010 |           0.006 |
| Río Negro                     | F    |       14126 |       1943 |        281 |              0.018 |              0.020 |            0.603 |           0.138 |                  0.005 |           0.003 |
| Río Negro                     | M    |       13184 |       1914 |        411 |              0.028 |              0.031 |            0.638 |           0.145 |                  0.008 |           0.006 |
| Neuquén                       | F    |       13016 |       4513 |        170 |              0.010 |              0.013 |            0.775 |           0.347 |                  0.006 |           0.004 |
| Neuquén                       | M    |       12852 |       4449 |        288 |              0.017 |              0.022 |            0.796 |           0.346 |                  0.012 |           0.010 |
| Salta                         | M    |       10934 |       1238 |        609 |              0.045 |              0.056 |            0.539 |           0.113 |                  0.024 |           0.014 |
| Jujuy                         | M    |       10057 |        276 |        545 |              0.044 |              0.054 |            0.407 |           0.027 |                  0.013 |           0.009 |
| Chubut                        | M    |        9653 |        104 |        131 |              0.011 |              0.014 |            0.922 |           0.011 |                  0.004 |           0.003 |
| Entre Ríos                    | F    |        9563 |        601 |        129 |              0.011 |              0.013 |            0.551 |           0.063 |                  0.005 |           0.002 |
| Entre Ríos                    | M    |        9383 |        661 |        217 |              0.019 |              0.023 |            0.595 |           0.070 |                  0.009 |           0.003 |
| Salta                         | F    |        8795 |        835 |        303 |              0.027 |              0.034 |            0.524 |           0.095 |                  0.015 |           0.007 |
| Chubut                        | F    |        8360 |         83 |        104 |              0.010 |              0.012 |            0.942 |           0.010 |                  0.003 |           0.002 |
| Jujuy                         | F    |        7990 |        138 |        290 |              0.030 |              0.036 |            0.395 |           0.017 |                  0.006 |           0.004 |
| Chaco                         | M    |        7752 |        634 |        300 |              0.028 |              0.039 |            0.240 |           0.082 |                  0.047 |           0.023 |
| Chaco                         | F    |        7751 |        557 |        172 |              0.016 |              0.022 |            0.229 |           0.072 |                  0.034 |           0.015 |
| Tierra del Fuego              | M    |        7003 |        161 |        122 |              0.016 |              0.017 |            0.686 |           0.023 |                  0.008 |           0.007 |
| Tierra del Fuego              | F    |        6642 |         76 |         49 |              0.007 |              0.007 |            0.657 |           0.011 |                  0.003 |           0.002 |
| Santiago del Estero           | M    |        6326 |        101 |         91 |              0.012 |              0.014 |            0.290 |           0.016 |                  0.002 |           0.001 |
| Santa Cruz                    | M    |        6143 |        375 |        120 |              0.015 |              0.020 |            0.675 |           0.061 |                  0.017 |           0.012 |
| Santa Cruz                    | F    |        5624 |        279 |         63 |              0.009 |              0.011 |            0.602 |           0.050 |                  0.008 |           0.006 |
| Santiago del Estero           | F    |        5577 |         59 |         55 |              0.008 |              0.010 |            0.329 |           0.011 |                  0.001 |           0.001 |
| San Luis                      | M    |        5214 |        141 |         79 |              0.010 |              0.015 |            0.364 |           0.027 |                  0.008 |           0.006 |
| San Luis                      | F    |        4956 |         97 |         44 |              0.006 |              0.009 |            0.344 |           0.020 |                  0.003 |           0.003 |
| La Rioja                      | M    |        4124 |         29 |        187 |              0.041 |              0.045 |            0.375 |           0.007 |                  0.002 |           0.000 |
| La Rioja                      | F    |        3797 |         24 |        103 |              0.025 |              0.027 |            0.362 |           0.006 |                  0.002 |           0.001 |
| La Pampa                      | F    |        2296 |         46 |         21 |              0.008 |              0.009 |            0.239 |           0.020 |                  0.004 |           0.001 |
| San Juan                      | M    |        2250 |         48 |         56 |              0.016 |              0.025 |            0.858 |           0.021 |                  0.010 |           0.004 |
| La Pampa                      | M    |        2054 |         43 |         25 |              0.011 |              0.012 |            0.261 |           0.021 |                  0.007 |           0.002 |
| Buenos Aires                  | NR   |        2006 |        159 |        123 |              0.045 |              0.061 |            0.480 |           0.079 |                  0.017 |           0.007 |
| San Juan                      | F    |        1859 |         49 |         46 |              0.015 |              0.025 |            0.892 |           0.026 |                  0.011 |           0.002 |
| Corrientes                    | M    |        1686 |         54 |         41 |              0.016 |              0.024 |            0.210 |           0.032 |                  0.023 |           0.015 |
| SIN ESPECIFICAR               | F    |        1601 |         91 |         11 |              0.006 |              0.007 |            0.412 |           0.057 |                  0.006 |           0.002 |
| Corrientes                    | F    |        1558 |         23 |         17 |              0.007 |              0.011 |            0.222 |           0.015 |                  0.010 |           0.006 |
| SIN ESPECIFICAR               | M    |        1089 |         79 |         14 |              0.011 |              0.013 |            0.430 |           0.073 |                  0.009 |           0.006 |
| Catamarca                     | M    |         759 |          9 |          2 |              0.002 |              0.003 |            0.107 |           0.012 |                  0.000 |           0.000 |
| CABA                          | NR   |         612 |        141 |         53 |              0.074 |              0.087 |            0.367 |           0.230 |                  0.039 |           0.023 |
| Catamarca                     | F    |         542 |          8 |          0 |              0.000 |              0.000 |            0.108 |           0.015 |                  0.004 |           0.000 |
| Mendoza                       | NR   |         205 |          8 |          4 |              0.014 |              0.020 |            0.415 |           0.039 |                  0.010 |           0.010 |
| Misiones                      | M    |         196 |         45 |          4 |              0.013 |              0.020 |            0.043 |           0.230 |                  0.031 |           0.020 |
| Misiones                      | F    |         163 |         33 |          3 |              0.011 |              0.018 |            0.048 |           0.202 |                  0.025 |           0.006 |
| Formosa                       | M    |         112 |         37 |          1 |              0.006 |              0.009 |            0.101 |           0.330 |                  0.000 |           0.000 |
| Santa Fe                      | NR   |          58 |          6 |          3 |              0.041 |              0.052 |            0.552 |           0.103 |                  0.000 |           0.000 |
| Salta                         | NR   |          57 |          5 |          3 |              0.042 |              0.053 |            0.475 |           0.088 |                  0.035 |           0.018 |
| Formosa                       | F    |          48 |         30 |          1 |              0.010 |              0.021 |            0.061 |           0.625 |                  0.000 |           0.000 |
| Córdoba                       | NR   |          47 |          1 |          3 |              0.036 |              0.064 |            0.653 |           0.021 |                  0.000 |           0.000 |
| Chubut                        | NR   |          34 |          1 |          1 |              0.021 |              0.029 |            0.479 |           0.029 |                  0.000 |           0.000 |
| La Rioja                      | NR   |          34 |          0 |          4 |              0.114 |              0.118 |            0.343 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      | NR   |          30 |          1 |          0 |              0.000 |              0.000 |            0.337 |           0.033 |                  0.000 |           0.000 |
| Tucumán                       | NR   |          28 |          0 |          0 |              0.000 |              0.000 |            0.700 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | NR   |          23 |          1 |          2 |              0.041 |              0.087 |            0.303 |           0.043 |                  0.000 |           0.000 |
| Río Negro                     | NR   |          19 |          4 |          0 |              0.000 |              0.000 |            0.594 |           0.211 |                  0.053 |           0.053 |
| Tierra del Fuego              | NR   |          17 |          0 |          0 |              0.000 |              0.000 |            1.545 |           0.000 |                  0.000 |           0.000 |
| Neuquén                       | NR   |          10 |          2 |          1 |              0.045 |              0.100 |            0.667 |           0.200 |                  0.100 |           0.100 |
| San Luis                      | NR   |          10 |          0 |          0 |              0.000 |              0.000 |            0.455 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    | NR   |          10 |          0 |          0 |              0.000 |              0.000 |            0.833 |           0.000 |                  0.000 |           0.000 |

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
