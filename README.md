
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

# How to get started (Development version)

Install the R package using the following commands on the R console:

``` r
# install.packages("devtools")
devtools::install_github("rOpenStats/COVID19AR")
```

# How to use it

First add variable with your preferred data dir configuration in
`~/.Renviron`. You will receive a message if you didn’t.

``` .renviron
COVID19AR_data_dir = "~/.R/COVID19AR"
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
#> INFO  [08:55:25.762] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [08:55:27.678] Normalize 
#> INFO  [08:55:28.085] checkSoundness 
#> INFO  [08:55:28.221] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-17"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-17"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-17"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)

covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% filter(confirmados >= 100)
# Provinces with > 100 confirmed cases
covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre
#>  [1] "Buenos Aires"     "CABA"             "Chaco"            "Córdoba"         
#>  [5] "Corrientes"       "Entre Ríos"       "Mendoza"          "Neuquén"         
#>  [9] "Río Negro"        "Santa Fe"         "SIN ESPECIFICAR"  "Tierra del Fuego"
```

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
nrow(covid19.ar.summary)
#> [1] 25
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
        select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))
```

| residencia\_provincia\_nombre | confirmados | tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | ----------: | ----: | ---------: | -----------------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                          |       16103 | 52269 |        332 |               13.5 |              0.016 |              0.021 |            0.308 |           0.288 |                  0.025 |           0.012 |
| Buenos Aires                  |       15304 | 89647 |        403 |               12.2 |              0.016 |              0.026 |            0.171 |           0.248 |                  0.028 |           0.011 |
| Chaco                         |        1407 |  8782 |         77 |               14.1 |              0.033 |              0.055 |            0.160 |           0.147 |                  0.060 |           0.034 |
| Río Negro                     |         595 |  3075 |         29 |               14.5 |              0.042 |              0.049 |            0.193 |           0.553 |                  0.035 |           0.018 |
| Córdoba                       |         504 | 16604 |         35 |               23.1 |              0.027 |              0.069 |            0.030 |           0.234 |                  0.060 |           0.024 |
| Santa Fe                      |         289 | 11162 |          4 |               25.5 |              0.007 |              0.014 |            0.026 |           0.190 |                  0.045 |           0.021 |
| Neuquén                       |         251 |  1875 |          6 |                9.4 |              0.018 |              0.024 |            0.134 |           0.594 |                  0.016 |           0.016 |
| SIN ESPECIFICAR               |         233 |   784 |          2 |                9.5 |              0.006 |              0.009 |            0.297 |           0.236 |                  0.021 |           0.013 |
| Tierra del Fuego              |         136 |  1563 |          0 |                NaN |              0.000 |              0.000 |            0.087 |           0.051 |                  0.015 |           0.015 |
| Mendoza                       |         116 |  2338 |          9 |               13.3 |              0.040 |              0.078 |            0.050 |           0.948 |                  0.095 |           0.043 |
| Corrientes                    |         107 |  3065 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.019 |                  0.009 |           0.000 |
| Entre Ríos                    |         105 |  1747 |          0 |                NaN |              0.000 |              0.000 |            0.060 |           0.267 |                  0.000 |           0.000 |
| Chubut                        |          70 |   726 |          1 |               19.0 |              0.009 |              0.014 |            0.096 |           0.043 |                  0.014 |           0.014 |
| La Rioja                      |          64 |  1470 |          8 |               12.0 |              0.079 |              0.125 |            0.044 |           0.172 |                  0.062 |           0.016 |
| Tucumán                       |          56 |  6126 |          4 |               14.2 |              0.011 |              0.071 |            0.009 |           0.214 |                  0.125 |           0.036 |
| Santa Cruz                    |          50 |   554 |          0 |                NaN |              0.000 |              0.000 |            0.090 |           0.420 |                  0.080 |           0.040 |
| Misiones                      |          38 |  1251 |          2 |                6.5 |              0.033 |              0.053 |            0.030 |           0.737 |                  0.132 |           0.079 |
| Formosa                       |          34 |   733 |          0 |                NaN |              0.000 |              0.000 |            0.046 |           0.000 |                  0.000 |           0.000 |
| Salta                         |          22 |   793 |          0 |                NaN |              0.000 |              0.000 |            0.028 |           0.682 |                  0.000 |           0.000 |
| Santiago del Estero           |          22 |  2251 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.045 |                  0.045 |           0.000 |
| San Luis                      |          11 |   437 |          0 |                NaN |              0.000 |              0.000 |            0.025 |           0.727 |                  0.091 |           0.000 |
| Jujuy                         |           8 |  2345 |          1 |               22.0 |              0.009 |              0.125 |            0.003 |           0.250 |                  0.125 |           0.125 |
| San Juan                      |           7 |   714 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.714 |                  0.143 |           0.000 |
| La Pampa                      |           6 |   301 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.167 |                  0.000 |           0.000 |

``` r
max.date.complete <- as.Date(covid19.curator$max.date)

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "residencia_departamento_nombre", "fecha_apertura"),
                                                   cache.filename = "covid19ar_residencia_provincia_nombre-residencia_departamento_nombre-fecha_apertura.csv")
#> Parsed with column specification:
#> cols(
#>   .default = col_double(),
#>   residencia_provincia_nombre = col_character(),
#>   residencia_departamento_nombre = col_character(),
#>   fecha_apertura = col_date(format = "")
#> )
#> See spec(...) for full column specifications.

max(covid19.ar.summary$fecha_apertura)
#> [1] "2020-06-17"
 # CABA reports data twice
nrow(covid19.ar.summary)
#> [1] 19566
covid19.ar.summary %<>% filter(!(residencia_provincia_nombre == "CABA" & residencia_departamento_nombre == "SIN ESPECIFICAR"))
nrow(covid19.ar.summary)
#> [1] 19456

covid19.ar.summary.last <- covid19.ar.summary %>% filter(fecha_apertura == max.date.complete)
covid19.ar.summary.last %<>% mutate(rank = rank(desc(confirmados)))
kable(covid19.ar.summary.last %>% filter(rank <= 10) %>% arrange(rank))
```

| residencia\_provincia\_nombre | residencia\_departamento\_nombre | fecha\_apertura |    n | confirmados | descartados | sospechosos | fallecidos | tests | sin.clasificar | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados | internados.porc | cuidado.intensivo | cuidado.intensivo.porc | respirador | respirador.porc | dias.diagnostico | dias.apertura | dias.cuidado.intensivo | dias.fallecimiento | dias.inicio | confirmados.inc | confirmados.rate | fallecidos.inc | tests.inc | tests.rate | sospechosos.inc | rank |
| :---------------------------- | :------------------------------- | :-------------- | ---: | ----------: | ----------: | ----------: | ---------: | ----: | -------------: | -----------------: | -----------------: | ---------------: | ---------: | --------------: | ----------------: | ---------------------: | ---------: | --------------: | ---------------: | ------------: | ---------------------: | -----------------: | ----------: | --------------: | ---------------: | -------------: | --------: | ---------: | --------------: | ---: |
| CABA                          | COMUNA 1                         | 2020-06-17      | 3737 |        2098 |        1472 |         167 |         27 |  3566 |              0 |              0.012 |              0.013 |            0.588 |        528 |           0.252 |                46 |                  0.022 |         30 |           0.014 |              4.7 |          33.7 |                    5.3 |               17.6 |          95 |               0 |        0.0000000 |              0 |         2 |  0.0005612 |              31 |    1 |
| Buenos Aires                  | La Matanza                       | 2020-06-17      | 9985 |        2088 |        6932 |         965 |         40 |  9012 |              0 |              0.013 |              0.019 |            0.232 |        479 |           0.229 |                44 |                  0.021 |         20 |           0.010 |              5.3 |          22.3 |                    6.0 |               11.9 |         100 |              13 |        0.0062651 |              0 |        36 |  0.0040107 |             203 |    2 |
| CABA                          | COMUNA 7                         | 2020-06-17      | 3704 |        1950 |        1445 |         309 |         28 |  3394 |              0 |              0.012 |              0.014 |            0.575 |        453 |           0.232 |                43 |                  0.022 |         22 |           0.011 |              4.7 |          24.9 |                    6.9 |               12.4 |          94 |               3 |        0.0015408 |              0 |         4 |  0.0011799 |              58 |    3 |
| Buenos Aires                  | Quilmes                          | 2020-06-17      | 6021 |        1360 |        4100 |         561 |         15 |  5439 |              0 |              0.008 |              0.011 |            0.250 |        257 |           0.189 |                24 |                  0.018 |          5 |           0.004 |              6.1 |          25.4 |                    6.2 |               14.1 |         101 |               2 |        0.0014728 |              0 |         9 |  0.0016575 |              97 |    4 |
| Chaco                         | San Fernando                     | 2020-06-17      | 8323 |        1337 |        6252 |         734 |         73 |  7583 |              0 |              0.035 |              0.055 |            0.176 |        189 |           0.141 |                82 |                  0.061 |         48 |           0.036 |              6.8 |          40.2 |                    5.7 |               13.6 |          99 |               4 |        0.0030008 |              0 |        12 |  0.0015850 |              86 |    5 |
| CABA                          | COMUNA 4                         | 2020-06-17      | 3373 |        1129 |        1891 |         353 |          8 |  3016 |              0 |              0.005 |              0.007 |            0.374 |        150 |           0.133 |                15 |                  0.013 |          8 |           0.007 |              4.2 |          18.6 |                    5.5 |               12.7 |          89 |               2 |        0.0017746 |              0 |         2 |  0.0006636 |              85 |    6 |
| Buenos Aires                  | Avellaneda                       | 2020-06-17      | 3788 |        1022 |        2274 |         492 |         19 |  3286 |              0 |              0.013 |              0.019 |            0.311 |        225 |           0.220 |                24 |                  0.023 |         10 |           0.010 |              5.2 |          22.1 |                    4.2 |                9.2 |          96 |               8 |        0.0078895 |              0 |        24 |  0.0073574 |              77 |    7 |
| CABA                          | COMUNA 8                         | 2020-06-17      | 2175 |         862 |        1047 |         266 |          3 |  1908 |              0 |              0.003 |              0.003 |            0.452 |        103 |           0.119 |                 5 |                  0.006 |          3 |           0.003 |              4.2 |          16.0 |                    4.0 |               15.0 |          86 |               3 |        0.0034924 |              0 |         5 |  0.0026274 |              57 |    8 |
| Buenos Aires                  | Lanús                            | 2020-06-17      | 4354 |         832 |        3097 |         425 |          9 |  3920 |              0 |              0.007 |              0.011 |            0.212 |        190 |           0.228 |                17 |                  0.020 |          5 |           0.006 |              6.1 |          21.5 |                    4.4 |                9.2 |          96 |               1 |        0.0012034 |              0 |        12 |  0.0030706 |             101 |    9 |
| Buenos Aires                  | Lomas de Zamora                  | 2020-06-17      | 5310 |         814 |        3706 |         790 |         18 |  4508 |              0 |              0.011 |              0.022 |            0.181 |        201 |           0.247 |                20 |                  0.025 |          9 |           0.011 |              5.5 |          20.7 |                    3.8 |                9.4 |         103 |               1 |        0.0012300 |              0 |         7 |  0.0015552 |             146 |   10 |

``` r

rg <- ReportGeneratorCOVID19AR$new(covid19ar.curator = covid19.curator)
rg$preprocess()
#> Parsed with column specification:
#> cols(
#>   .default = col_double(),
#>   residencia_provincia_nombre = col_character(),
#>   residencia_departamento_nombre = col_character(),
#>   fecha_apertura = col_date(format = "")
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
#> INFO  [08:56:01.817] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 21
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(sepi_apertura, desc(confirmados)) %>% select_at(c("sepi_apertura", "sepi_apertura", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))
```

| sepi\_apertura | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| -------------: | ----------: | -----: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
|             10 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 |          92 |    666 |         63 |          8 |              0.060 |              0.087 |            0.138 |           0.685 |                  0.130 |           0.065 |
|             12 |         406 |   2048 |        251 |         16 |              0.031 |              0.039 |            0.198 |           0.618 |                  0.094 |           0.054 |
|             13 |        1068 |   5509 |        592 |         60 |              0.047 |              0.056 |            0.194 |           0.554 |                  0.096 |           0.057 |
|             14 |        1729 |  11519 |        951 |        109 |              0.051 |              0.063 |            0.150 |           0.550 |                  0.096 |           0.056 |
|             15 |        2358 |  20221 |       1277 |        168 |              0.056 |              0.071 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 |        3087 |  31783 |       1601 |        221 |              0.054 |              0.072 |            0.097 |           0.519 |                  0.083 |           0.044 |
|             17 |        4096 |  45808 |       2084 |        318 |              0.059 |              0.078 |            0.089 |           0.509 |                  0.076 |           0.039 |
|             18 |        4988 |  58981 |       2457 |        377 |              0.058 |              0.076 |            0.085 |           0.493 |                  0.069 |           0.036 |
|             19 |        6317 |  73097 |       2992 |        441 |              0.054 |              0.070 |            0.086 |           0.474 |                  0.063 |           0.032 |
|             20 |        8545 |  90405 |       3765 |        509 |              0.047 |              0.060 |            0.095 |           0.441 |                  0.056 |           0.028 |
|             21 |       12680 | 113751 |       4975 |        625 |              0.039 |              0.049 |            0.111 |           0.392 |                  0.048 |           0.024 |
|             22 |       17641 | 139009 |       6279 |        741 |              0.034 |              0.042 |            0.127 |           0.356 |                  0.042 |           0.021 |
|             23 |       23621 | 167009 |       7563 |        839 |              0.029 |              0.036 |            0.141 |           0.320 |                  0.037 |           0.018 |
|             24 |       32446 | 200703 |       9208 |        905 |              0.022 |              0.028 |            0.162 |           0.284 |                  0.031 |           0.014 |
|             25 |       35538 | 211122 |       9606 |        913 |              0.017 |              0.026 |            0.168 |           0.270 |                  0.029 |           0.013 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [08:56:06.944] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [08:56:10.466] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [08:56:13.088] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [08:56:14.470] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [08:56:16.071] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [08:56:17.432] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [08:56:20.663] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [08:56:22.153] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [08:56:23.687] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [08:56:25.158] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [08:56:26.760] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [08:56:28.120] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [08:56:29.542] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [08:56:31.039] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [08:56:32.263] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [08:56:33.684] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [08:56:35.195] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [08:56:36.604] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [08:56:37.951] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [08:56:39.300] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [08:56:40.661] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [08:56:42.357] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [08:56:43.720] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [08:56:45.224] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [08:56:46.780] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 401
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
````

``` r
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
```

<img src="man/figures/README-residencia_provincia_nombre-sepi_apertura-plot-tests-1.png" width="100%" />

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
#> [1] 70
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                          | F    |        8138 |       2330 |        143 |              0.013 |              0.018 |            0.297 |           0.286 |                  0.017 |           0.007 |
| Buenos Aires                  | M    |        7891 |       2017 |        236 |              0.019 |              0.030 |            0.183 |           0.256 |                  0.032 |           0.014 |
| CABA                          | M    |        7890 |       2295 |        185 |              0.018 |              0.023 |            0.321 |           0.291 |                  0.032 |           0.017 |
| Buenos Aires                  | F    |        7346 |       1765 |        166 |              0.014 |              0.023 |            0.159 |           0.240 |                  0.023 |           0.009 |
| Chaco                         | M    |         712 |        105 |         49 |              0.042 |              0.069 |            0.164 |           0.147 |                  0.070 |           0.048 |
| Chaco                         | F    |         693 |        102 |         28 |              0.024 |              0.040 |            0.157 |           0.147 |                  0.051 |           0.020 |
| Río Negro                     | M    |         301 |        167 |         17 |              0.049 |              0.056 |            0.208 |           0.555 |                  0.043 |           0.023 |
| Río Negro                     | F    |         294 |        162 |         12 |              0.035 |              0.041 |            0.181 |           0.551 |                  0.027 |           0.014 |
| Córdoba                       | F    |         252 |         69 |         18 |              0.029 |              0.071 |            0.030 |           0.274 |                  0.056 |           0.016 |
| Córdoba                       | M    |         250 |         48 |         17 |              0.027 |              0.068 |            0.031 |           0.192 |                  0.064 |           0.032 |
| Santa Fe                      | M    |         150 |         34 |          3 |              0.010 |              0.020 |            0.027 |           0.227 |                  0.060 |           0.033 |
| Santa Fe                      | F    |         139 |         21 |          1 |              0.004 |              0.007 |            0.024 |           0.151 |                  0.029 |           0.007 |
| SIN ESPECIFICAR               | F    |         129 |         25 |          0 |              0.000 |              0.000 |            0.281 |           0.194 |                  0.016 |           0.000 |
| Neuquén                       | F    |         127 |         73 |          3 |              0.019 |              0.024 |            0.141 |           0.575 |                  0.024 |           0.024 |
| Neuquén                       | M    |         124 |         76 |          3 |              0.018 |              0.024 |            0.128 |           0.613 |                  0.008 |           0.008 |
| SIN ESPECIFICAR               | M    |         102 |         29 |          1 |              0.007 |              0.010 |            0.325 |           0.284 |                  0.020 |           0.020 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.093 |           0.052 |                  0.026 |           0.026 |
| CABA                          | NR   |          75 |         18 |          4 |              0.028 |              0.053 |            0.304 |           0.240 |                  0.040 |           0.027 |
| Corrientes                    | M    |          69 |          1 |          0 |              0.000 |              0.000 |            0.040 |           0.014 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |          67 |         14 |          1 |              0.008 |              0.015 |            0.263 |           0.209 |                  0.030 |           0.000 |
| Mendoza                       | M    |          64 |         60 |          9 |              0.075 |              0.141 |            0.052 |           0.938 |                  0.141 |           0.062 |
| Entre Ríos                    | M    |          63 |         22 |          0 |              0.000 |              0.000 |            0.070 |           0.349 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.080 |           0.052 |                  0.000 |           0.000 |
| Mendoza                       | F    |          52 |         50 |          0 |              0.000 |              0.000 |            0.048 |           0.962 |                  0.038 |           0.019 |
| Chubut                        | M    |          44 |          2 |          1 |              0.016 |              0.023 |            0.109 |           0.045 |                  0.023 |           0.023 |
| Entre Ríos                    | F    |          41 |          6 |          0 |              0.000 |              0.000 |            0.048 |           0.146 |                  0.000 |           0.000 |
| Corrientes                    | F    |          38 |          1 |          0 |              0.000 |              0.000 |            0.029 |           0.026 |                  0.026 |           0.000 |
| La Rioja                      | F    |          36 |          8 |          6 |              0.111 |              0.167 |            0.050 |           0.222 |                  0.083 |           0.028 |
| Formosa                       | M    |          34 |          0 |          0 |              0.000 |              0.000 |            0.077 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | M    |          34 |          7 |          2 |              0.009 |              0.059 |            0.009 |           0.206 |                  0.088 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.097 |           0.387 |                  0.097 |           0.032 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.043 |              0.071 |            0.038 |           0.107 |                  0.036 |           0.000 |
| Chubut                        | F    |          25 |          1 |          0 |              0.000 |              0.000 |            0.078 |           0.040 |                  0.000 |           0.000 |
| Tucumán                       | F    |          22 |          5 |          2 |              0.015 |              0.091 |            0.009 |           0.227 |                  0.182 |           0.091 |
| Misiones                      | M    |          20 |         15 |          1 |              0.029 |              0.050 |            0.029 |           0.750 |                  0.150 |           0.100 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.081 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.038 |              0.056 |            0.032 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          15 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.067 |                  0.067 |           0.000 |
| Salta                         | M    |          13 |         10 |          0 |              0.000 |              0.000 |            0.024 |           0.769 |                  0.000 |           0.000 |

``` r

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))

 # Share per province
 provinces.deaths <-covid19.ar.summary %>%
    group_by(residencia_provincia_nombre) %>%
    summarise(fallecidos.total.provincia = sum(fallecidos), .groups = "keep")
 covid19.ar.summary %<>% inner_join(provinces.deaths, by = "residencia_provincia_nombre")
 covid19.ar.summary %<>% mutate(fallecidos.prop = fallecidos/fallecidos.total.provincia)

 # Data 2 plot
 data2plot <- covid19.ar.summary %>% filter(residencia_provincia_nombre %in% covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre)

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
#> Warning: Removed 53 rows containing missing values (position_stack).
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-1.png" width="100%" />

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
#> Warning: Removed 14 rows containing missing values (position_stack).
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-2.png" width="100%" />

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
#> Warning: Removed 14 rows containing missing values (position_stack).
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-3.png" width="100%" />

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
#> Warning: Removed 5 rows containing missing values (position_stack).
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-4.png" width="100%" />

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
