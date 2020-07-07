
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
#> INFO  [15:56:28.469] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [15:56:31.962] Normalize 
#> INFO  [15:56:32.511] checkSoundness 
#> INFO  [15:56:32.785] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-06"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-06"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-06"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-06              |       80434 |       1582 |              0.014 |               0.02 |                       131 | 342655 |            0.235 |

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
| Buenos Aires                  |       41323 |        749 |              0.012 |              0.018 |                       130 | 159783 |            0.259 |
| CABA                          |       31889 |        587 |              0.015 |              0.018 |                       129 |  88868 |            0.359 |
| Chaco                         |        2335 |        109 |              0.033 |              0.047 |                       117 |  13381 |            0.175 |
| Río Negro                     |         972 |         45 |              0.040 |              0.046 |                       112 |   4638 |            0.210 |
| Córdoba                       |         730 |         37 |              0.023 |              0.051 |                       119 |  21675 |            0.034 |
| Neuquén                       |         594 |         18 |              0.022 |              0.030 |                       114 |   2714 |            0.219 |
| SIN ESPECIFICAR               |         516 |          2 |              0.003 |              0.004 |                       107 |   1430 |            0.361 |
| Santa Fe                      |         442 |          6 |              0.008 |              0.014 |                       115 |  14104 |            0.031 |
| Entre Ríos                    |         335 |          0 |              0.000 |              0.000 |                       112 |   2781 |            0.120 |
| Mendoza                       |         196 |         10 |              0.025 |              0.051 |                       118 |   3371 |            0.058 |
| Jujuy                         |         192 |          1 |              0.001 |              0.005 |                       108 |   2856 |            0.067 |
| Chubut                        |         159 |          1 |              0.003 |              0.006 |                        98 |   1525 |            0.104 |
| Tierra del Fuego              |         141 |          1 |              0.006 |              0.007 |                       110 |   1668 |            0.085 |
| Corrientes                    |         121 |          0 |              0.000 |              0.000 |                       109 |   3481 |            0.035 |
| La Rioja                      |         108 |          9 |              0.054 |              0.083 |                       103 |   2319 |            0.047 |

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
| Buenos Aires                  |       41323 | 159783 |        749 |               12.5 |              0.012 |              0.018 |            0.259 |           0.169 |                  0.019 |           0.007 |
| CABA                          |       31889 |  88868 |        587 |               13.9 |              0.015 |              0.018 |            0.359 |           0.244 |                  0.021 |           0.009 |
| Chaco                         |        2335 |  13381 |        109 |               14.3 |              0.033 |              0.047 |            0.175 |           0.114 |                  0.063 |           0.026 |
| Río Negro                     |         972 |   4638 |         45 |               13.3 |              0.040 |              0.046 |            0.210 |           0.412 |                  0.031 |           0.022 |
| Córdoba                       |         730 |  21675 |         37 |               24.3 |              0.023 |              0.051 |            0.034 |           0.177 |                  0.042 |           0.016 |
| Neuquén                       |         594 |   2714 |         18 |               18.1 |              0.022 |              0.030 |            0.219 |           0.527 |                  0.013 |           0.010 |
| SIN ESPECIFICAR               |         516 |   1430 |          2 |               34.5 |              0.003 |              0.004 |            0.361 |           0.180 |                  0.012 |           0.006 |
| Santa Fe                      |         442 |  14104 |          6 |               20.5 |              0.008 |              0.014 |            0.031 |           0.163 |                  0.043 |           0.018 |
| Entre Ríos                    |         335 |   2781 |          0 |                NaN |              0.000 |              0.000 |            0.120 |           0.242 |                  0.003 |           0.000 |
| Mendoza                       |         196 |   3371 |         10 |               13.1 |              0.025 |              0.051 |            0.058 |           0.939 |                  0.061 |           0.026 |
| Jujuy                         |         192 |   2856 |          1 |               22.0 |              0.001 |              0.005 |            0.067 |           0.016 |                  0.005 |           0.005 |
| Chubut                        |         159 |   1525 |          1 |               19.0 |              0.003 |              0.006 |            0.104 |           0.031 |                  0.006 |           0.006 |
| Tierra del Fuego              |         141 |   1668 |          1 |               24.0 |              0.006 |              0.007 |            0.085 |           0.050 |                  0.021 |           0.021 |
| Corrientes                    |         121 |   3481 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.008 |                  0.008 |           0.000 |
| La Rioja                      |         108 |   2319 |          9 |               11.7 |              0.054 |              0.083 |            0.047 |           0.148 |                  0.046 |           0.009 |
| Tucumán                       |          84 |   8216 |          4 |               14.2 |              0.010 |              0.048 |            0.010 |           0.214 |                  0.107 |           0.024 |
| Formosa                       |          76 |    773 |          0 |                NaN |              0.000 |              0.000 |            0.098 |           0.013 |                  0.000 |           0.000 |
| Salta                         |          59 |   1190 |          1 |                1.0 |              0.009 |              0.017 |            0.050 |           0.441 |                  0.017 |           0.000 |
| Santa Cruz                    |          56 |    663 |          0 |                NaN |              0.000 |              0.000 |            0.084 |           0.393 |                  0.089 |           0.054 |
| Misiones                      |          43 |   1563 |          2 |                6.5 |              0.030 |              0.047 |            0.028 |           0.674 |                  0.140 |           0.070 |
| Santiago del Estero           |          27 |   2950 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.037 |                  0.037 |           0.000 |
| San Luis                      |          12 |    587 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.667 |                  0.083 |           0.000 |
| San Juan                      |           9 |    842 |          0 |                NaN |              0.000 |              0.000 |            0.011 |           0.556 |                  0.111 |           0.000 |
| Catamarca                     |           8 |    821 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      |           7 |    456 |          0 |                NaN |              0.000 |              0.000 |            0.015 |           0.143 |                  0.000 |           0.000 |

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
#> INFO  [15:57:29.914] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 19
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% 
        filter(confirmados > 0) %>% 
        arrange(sepi_apertura, desc(confirmados)) %>% 
        select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))
```

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| -------------: | :---------------------- | ------------------------: | ----------: | -----: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-06-18              |                        35 |          93 |    666 |         64 |          8 |              0.060 |              0.086 |            0.140 |           0.688 |                  0.129 |           0.065 |
|             12 | 2020-06-18              |                        54 |         407 |   2048 |        252 |         16 |              0.031 |              0.039 |            0.199 |           0.619 |                  0.093 |           0.054 |
|             13 | 2020-07-01              |                        79 |        1072 |   5510 |        595 |         61 |              0.047 |              0.057 |            0.195 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-07-01              |                       102 |        1741 |  11523 |        956 |        110 |              0.051 |              0.063 |            0.151 |           0.549 |                  0.095 |           0.056 |
|             15 | 2020-07-03              |                       121 |        2384 |  20233 |       1289 |        170 |              0.056 |              0.071 |            0.118 |           0.541 |                  0.091 |           0.051 |
|             16 | 2020-07-03              |                       126 |        3138 |  31825 |       1625 |        225 |              0.055 |              0.072 |            0.099 |           0.518 |                  0.082 |           0.044 |
|             17 | 2020-07-06              |                       131 |        4179 |  45873 |       2115 |        325 |              0.061 |              0.078 |            0.091 |           0.506 |                  0.075 |           0.039 |
|             18 | 2020-07-06              |                       131 |        5112 |  59053 |       2495 |        388 |              0.059 |              0.076 |            0.087 |           0.488 |                  0.068 |           0.036 |
|             19 | 2020-07-06              |                       131 |        6475 |  73172 |       3045 |        458 |              0.056 |              0.071 |            0.088 |           0.470 |                  0.062 |           0.032 |
|             20 | 2020-07-06              |                       131 |        8757 |  90521 |       3853 |        534 |              0.049 |              0.061 |            0.097 |           0.440 |                  0.056 |           0.029 |
|             21 | 2020-07-06              |                       131 |       12963 | 113908 |       5116 |        664 |              0.041 |              0.051 |            0.114 |           0.395 |                  0.049 |           0.025 |
|             22 | 2020-07-06              |                       131 |       18025 | 139235 |       6490 |        811 |              0.037 |              0.045 |            0.129 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-06              |                       131 |       24217 | 167398 |       7946 |        978 |              0.033 |              0.040 |            0.145 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-07-06              |                       131 |       33529 | 202320 |       9944 |       1143 |              0.028 |              0.034 |            0.166 |           0.297 |                  0.035 |           0.016 |
|             25 | 2020-07-06              |                       131 |       46001 | 243287 |      12039 |       1317 |              0.024 |              0.029 |            0.189 |           0.262 |                  0.030 |           0.013 |
|             26 | 2020-07-06              |                       131 |       62963 | 294016 |      14534 |       1493 |              0.020 |              0.024 |            0.214 |           0.231 |                  0.025 |           0.011 |
|             27 | 2020-07-06              |                       131 |       78828 | 338279 |      16296 |       1580 |              0.015 |              0.020 |            0.233 |           0.207 |                  0.022 |           0.009 |
|             28 | 2020-07-06              |                       131 |       80434 | 342655 |      16435 |       1582 |              0.014 |              0.020 |            0.235 |           0.204 |                  0.022 |           0.009 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [15:57:52.057] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [15:58:02.900] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [15:58:10.087] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [15:58:11.418] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [15:58:14.580] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [15:58:16.532] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [15:58:22.359] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [15:58:25.717] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [15:58:27.883] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [15:58:29.353] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [15:58:31.512] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [15:58:33.440] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [15:58:35.456] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [15:58:37.967] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [15:58:41.303] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [15:58:43.720] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [15:58:46.134] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [15:58:48.540] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [15:58:50.614] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [15:58:52.726] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [15:58:55.266] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [15:58:59.021] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [15:59:01.122] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [15:59:03.178] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [15:59:05.416] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 410
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
| Buenos Aires                  | M    |       21057 |       3766 |        430 |              0.014 |              0.020 |            0.274 |           0.179 |                  0.022 |           0.009 |
| Buenos Aires                  | F    |       20104 |       3199 |        317 |              0.011 |              0.016 |            0.244 |           0.159 |                  0.016 |           0.005 |
| CABA                          | F    |       16013 |       3852 |        260 |              0.013 |              0.016 |            0.343 |           0.241 |                  0.016 |           0.006 |
| CABA                          | M    |       15738 |       3871 |        319 |              0.017 |              0.020 |            0.377 |           0.246 |                  0.027 |           0.013 |
| Chaco                         | F    |        1169 |        131 |         42 |              0.025 |              0.036 |            0.173 |           0.112 |                  0.053 |           0.015 |
| Chaco                         | M    |        1164 |        135 |         67 |              0.040 |              0.058 |            0.176 |           0.116 |                  0.074 |           0.036 |
| Río Negro                     | F    |         496 |        202 |         16 |              0.028 |              0.032 |            0.198 |           0.407 |                  0.020 |           0.012 |
| Río Negro                     | M    |         476 |        198 |         29 |              0.053 |              0.061 |            0.224 |           0.416 |                  0.042 |           0.032 |
| Córdoba                       | M    |         376 |         55 |         18 |              0.023 |              0.048 |            0.035 |           0.146 |                  0.045 |           0.021 |
| Córdoba                       | F    |         352 |         73 |         19 |              0.023 |              0.054 |            0.032 |           0.207 |                  0.040 |           0.011 |
| Neuquén                       | F    |         305 |        163 |          8 |              0.020 |              0.026 |            0.230 |           0.534 |                  0.010 |           0.010 |
| Neuquén                       | M    |         289 |        150 |         10 |              0.024 |              0.035 |            0.208 |           0.519 |                  0.017 |           0.010 |
| SIN ESPECIFICAR               | F    |         282 |         47 |          0 |              0.000 |              0.000 |            0.335 |           0.167 |                  0.007 |           0.000 |
| SIN ESPECIFICAR               | M    |         232 |         45 |          1 |              0.004 |              0.004 |            0.401 |           0.194 |                  0.013 |           0.009 |
| Santa Fe                      | M    |         225 |         45 |          5 |              0.014 |              0.022 |            0.033 |           0.200 |                  0.058 |           0.031 |
| Santa Fe                      | F    |         217 |         27 |          1 |              0.003 |              0.005 |            0.030 |           0.124 |                  0.028 |           0.005 |
| Entre Ríos                    | M    |         176 |         47 |          0 |              0.000 |              0.000 |            0.126 |           0.267 |                  0.006 |           0.000 |
| Buenos Aires                  | NR   |         162 |         20 |          2 |              0.006 |              0.012 |            0.307 |           0.123 |                  0.025 |           0.000 |
| Entre Ríos                    | F    |         158 |         34 |          0 |              0.000 |              0.000 |            0.115 |           0.215 |                  0.000 |           0.000 |
| CABA                          | NR   |         138 |         46 |          8 |              0.033 |              0.058 |            0.334 |           0.333 |                  0.058 |           0.043 |
| Jujuy                         | M    |         103 |          3 |          1 |              0.002 |              0.010 |            0.055 |           0.029 |                  0.010 |           0.010 |
| Mendoza                       | M    |         100 |         96 |         10 |              0.051 |              0.100 |            0.058 |           0.960 |                  0.100 |           0.040 |
| Mendoza                       | F    |          94 |         88 |          0 |              0.000 |              0.000 |            0.058 |           0.936 |                  0.021 |           0.011 |
| Jujuy                         | F    |          88 |          0 |          0 |              0.000 |              0.000 |            0.091 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | M    |          87 |          4 |          1 |              0.007 |              0.011 |            0.111 |           0.046 |                  0.011 |           0.011 |
| Tierra del Fuego              | M    |          81 |          4 |          1 |              0.011 |              0.012 |            0.091 |           0.049 |                  0.037 |           0.037 |
| Corrientes                    | M    |          74 |          1 |          0 |              0.000 |              0.000 |            0.038 |           0.014 |                  0.000 |           0.000 |
| Chubut                        | F    |          71 |          1 |          0 |              0.000 |              0.000 |            0.098 |           0.014 |                  0.000 |           0.000 |
| Formosa                       | M    |          63 |          0 |          0 |              0.000 |              0.000 |            0.137 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.076 |           0.051 |                  0.000 |           0.000 |
| La Rioja                      | F    |          57 |         10 |          6 |              0.068 |              0.105 |            0.051 |           0.175 |                  0.053 |           0.018 |
| La Rioja                      | M    |          51 |          6 |          3 |              0.038 |              0.059 |            0.043 |           0.118 |                  0.039 |           0.000 |
| Tucumán                       | M    |          51 |         10 |          2 |              0.008 |              0.039 |            0.010 |           0.196 |                  0.059 |           0.000 |
| Corrientes                    | F    |          47 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.021 |           0.000 |
| Salta                         | M    |          36 |         18 |          1 |              0.014 |              0.028 |            0.044 |           0.500 |                  0.028 |           0.000 |
| Santa Cruz                    | M    |          36 |         13 |          0 |              0.000 |              0.000 |            0.094 |           0.361 |                  0.111 |           0.056 |
| Tucumán                       | F    |          33 |          8 |          2 |              0.011 |              0.061 |            0.011 |           0.242 |                  0.182 |           0.061 |
| Misiones                      | M    |          24 |         16 |          1 |              0.029 |              0.042 |            0.029 |           0.667 |                  0.167 |           0.083 |
| Salta                         | F    |          23 |          8 |          0 |              0.000 |              0.000 |            0.064 |           0.348 |                  0.000 |           0.000 |
| Santa Cruz                    | F    |          20 |          9 |          0 |              0.000 |              0.000 |            0.071 |           0.450 |                  0.050 |           0.050 |
| Misiones                      | F    |          19 |         13 |          1 |              0.032 |              0.053 |            0.026 |           0.684 |                  0.105 |           0.053 |
| Santiago del Estero           | M    |          19 |          1 |          0 |              0.000 |              0.000 |            0.009 |           0.053 |                  0.053 |           0.000 |
| Formosa                       | F    |          13 |          1 |          0 |              0.000 |              0.000 |            0.042 |           0.077 |                  0.000 |           0.000 |
| San Luis                      | M    |          10 |          6 |          0 |              0.000 |              0.000 |            0.030 |           0.600 |                  0.100 |           0.000 |

``` r

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))
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
#> Warning: Removed 32 rows containing missing values (position_stack).
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
