
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
#> INFO  [21:07:28.273] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [21:07:31.653] Normalize 
#> INFO  [21:07:32.319] checkSoundness 
#> INFO  [21:07:32.598] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-08"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-08"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-08"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-08              |       87017 |       1694 |              0.014 |              0.019 |                       133 | 359193 |            0.242 |

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
| Buenos Aires                  |       45288 |        823 |              0.012 |              0.018 |                       132 | 168696 |            0.268 |
| CABA                          |       33986 |        624 |              0.015 |              0.018 |                       131 |  93367 |            0.364 |
| Chaco                         |        2416 |        109 |              0.032 |              0.045 |                       119 |  13980 |            0.173 |
| Río Negro                     |        1008 |         46 |              0.041 |              0.046 |                       114 |   4839 |            0.208 |
| Córdoba                       |         799 |         37 |              0.020 |              0.046 |                       121 |  22210 |            0.036 |
| Neuquén                       |         639 |         18 |              0.022 |              0.028 |                       116 |   2891 |            0.221 |
| SIN ESPECIFICAR               |         565 |          2 |              0.003 |              0.004 |                       109 |   1547 |            0.365 |
| Santa Fe                      |         465 |          6 |              0.008 |              0.013 |                       117 |  14473 |            0.032 |
| Entre Ríos                    |         355 |          0 |              0.000 |              0.000 |                       114 |   2852 |            0.124 |
| Jujuy                         |         261 |          1 |              0.001 |              0.004 |                       109 |   2958 |            0.088 |
| Mendoza                       |         241 |         10 |              0.022 |              0.041 |                       120 |   3557 |            0.068 |
| Chubut                        |         175 |          1 |              0.003 |              0.006 |                        99 |   1629 |            0.107 |
| Tierra del Fuego              |         141 |          1 |              0.006 |              0.007 |                       112 |   1672 |            0.084 |
| Corrientes                    |         126 |          0 |              0.000 |              0.000 |                       111 |   3517 |            0.036 |
| La Rioja                      |         125 |          9 |              0.044 |              0.072 |                       105 |   2442 |            0.051 |

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
| Buenos Aires                  |       45288 | 168696 |        823 |               13.0 |              0.012 |              0.018 |            0.268 |           0.164 |                  0.018 |           0.007 |
| CABA                          |       33986 |  93367 |        624 |               14.0 |              0.015 |              0.018 |            0.364 |           0.241 |                  0.021 |           0.009 |
| Chaco                         |        2416 |  13980 |        109 |               14.3 |              0.032 |              0.045 |            0.173 |           0.111 |                  0.062 |           0.025 |
| Río Negro                     |        1008 |   4839 |         46 |               13.5 |              0.041 |              0.046 |            0.208 |           0.404 |                  0.030 |           0.021 |
| Córdoba                       |         799 |  22210 |         37 |               24.3 |              0.020 |              0.046 |            0.036 |           0.161 |                  0.039 |           0.015 |
| Neuquén                       |         639 |   2891 |         18 |               18.1 |              0.022 |              0.028 |            0.221 |           0.531 |                  0.013 |           0.009 |
| SIN ESPECIFICAR               |         565 |   1547 |          2 |               34.5 |              0.003 |              0.004 |            0.365 |           0.170 |                  0.011 |           0.005 |
| Santa Fe                      |         465 |  14473 |          6 |               20.5 |              0.008 |              0.013 |            0.032 |           0.157 |                  0.041 |           0.017 |
| Entre Ríos                    |         355 |   2852 |          0 |                NaN |              0.000 |              0.000 |            0.124 |           0.242 |                  0.006 |           0.003 |
| Jujuy                         |         261 |   2958 |          1 |               22.0 |              0.001 |              0.004 |            0.088 |           0.011 |                  0.004 |           0.004 |
| Mendoza                       |         241 |   3557 |         10 |               13.1 |              0.022 |              0.041 |            0.068 |           0.876 |                  0.050 |           0.021 |
| Chubut                        |         175 |   1629 |          1 |               19.0 |              0.003 |              0.006 |            0.107 |           0.029 |                  0.006 |           0.006 |
| Tierra del Fuego              |         141 |   1672 |          1 |               24.0 |              0.006 |              0.007 |            0.084 |           0.050 |                  0.021 |           0.021 |
| Corrientes                    |         126 |   3517 |          0 |                NaN |              0.000 |              0.000 |            0.036 |           0.008 |                  0.008 |           0.000 |
| La Rioja                      |         125 |   2442 |          9 |               11.7 |              0.044 |              0.072 |            0.051 |           0.128 |                  0.040 |           0.008 |
| Tucumán                       |          85 |   8348 |          4 |               14.2 |              0.009 |              0.047 |            0.010 |           0.235 |                  0.106 |           0.024 |
| Formosa                       |          76 |    775 |          0 |                NaN |              0.000 |              0.000 |            0.098 |           0.013 |                  0.000 |           0.000 |
| Salta                         |          72 |   1223 |          1 |                1.0 |              0.008 |              0.014 |            0.059 |           0.389 |                  0.014 |           0.000 |
| Santa Cruz                    |          58 |    682 |          0 |                NaN |              0.000 |              0.000 |            0.085 |           0.379 |                  0.086 |           0.052 |
| Misiones                      |          42 |   1622 |          2 |                6.5 |              0.030 |              0.048 |            0.026 |           0.690 |                  0.143 |           0.071 |
| Santiago del Estero           |          39 |   3133 |          0 |                NaN |              0.000 |              0.000 |            0.012 |           0.051 |                  0.051 |           0.000 |
| Catamarca                     |          27 |    854 |          0 |                NaN |              0.000 |              0.000 |            0.032 |           0.000 |                  0.000 |           0.000 |
| San Luis                      |          12 |    595 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.667 |                  0.083 |           0.000 |
| San Juan                      |           9 |    860 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.556 |                  0.111 |           0.000 |
| La Pampa                      |           7 |    471 |          0 |                NaN |              0.000 |              0.000 |            0.015 |           0.143 |                  0.000 |           0.000 |

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
#> INFO  [21:08:38.558] Processing {current.group: }
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
|             12 | 2020-06-18              |                        54 |         407 |   2048 |        252 |         16 |              0.032 |              0.039 |            0.199 |           0.619 |                  0.093 |           0.054 |
|             13 | 2020-07-01              |                        79 |        1072 |   5510 |        595 |         61 |              0.048 |              0.057 |            0.195 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-07-01              |                       102 |        1741 |  11523 |        956 |        110 |              0.051 |              0.063 |            0.151 |           0.549 |                  0.095 |           0.056 |
|             15 | 2020-07-03              |                       121 |        2384 |  20233 |       1289 |        170 |              0.057 |              0.071 |            0.118 |           0.541 |                  0.091 |           0.051 |
|             16 | 2020-07-08              |                       129 |        3143 |  31825 |       1625 |        225 |              0.056 |              0.072 |            0.099 |           0.517 |                  0.082 |           0.044 |
|             17 | 2020-07-08              |                       133 |        4187 |  45874 |       2117 |        326 |              0.061 |              0.078 |            0.091 |           0.506 |                  0.075 |           0.039 |
|             18 | 2020-07-08              |                       133 |        5120 |  59055 |       2497 |        389 |              0.060 |              0.076 |            0.087 |           0.488 |                  0.068 |           0.036 |
|             19 | 2020-07-08              |                       133 |        6491 |  73174 |       3049 |        459 |              0.056 |              0.071 |            0.089 |           0.470 |                  0.062 |           0.032 |
|             20 | 2020-07-08              |                       133 |        8783 |  90525 |       3864 |        539 |              0.049 |              0.061 |            0.097 |           0.440 |                  0.056 |           0.029 |
|             21 | 2020-07-08              |                       133 |       12997 | 113913 |       5131 |        671 |              0.042 |              0.052 |            0.114 |           0.395 |                  0.049 |           0.025 |
|             22 | 2020-07-08              |                       133 |       18071 | 139243 |       6509 |        822 |              0.037 |              0.045 |            0.130 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-08              |                       133 |       24283 | 167413 |       7973 |        992 |              0.034 |              0.041 |            0.145 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-07-08              |                       133 |       33611 | 202342 |       9986 |       1167 |              0.029 |              0.035 |            0.166 |           0.297 |                  0.035 |           0.016 |
|             25 | 2020-07-08              |                       133 |       46126 | 243353 |      12121 |       1358 |              0.025 |              0.029 |            0.190 |           0.263 |                  0.030 |           0.013 |
|             26 | 2020-07-08              |                       133 |       63219 | 294251 |      14711 |       1568 |              0.021 |              0.025 |            0.215 |           0.233 |                  0.026 |           0.011 |
|             27 | 2020-07-08              |                       133 |       80248 | 341574 |      16704 |       1679 |              0.017 |              0.021 |            0.235 |           0.208 |                  0.023 |           0.009 |
|             28 | 2020-07-08              |                       133 |       87017 | 359193 |      17351 |       1694 |              0.014 |              0.019 |            0.242 |           0.199 |                  0.021 |           0.009 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [21:09:06.301] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [21:09:18.153] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [21:09:25.311] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [21:09:26.511] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [21:09:29.250] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [21:09:31.008] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [21:09:34.789] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [21:09:37.075] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [21:09:39.744] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [21:09:41.695] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [21:09:44.610] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [21:09:47.122] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [21:09:49.306] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [21:09:51.585] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [21:09:53.889] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [21:09:56.121] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [21:09:58.417] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [21:10:00.449] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [21:10:02.335] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [21:10:04.100] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [21:10:06.892] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [21:10:10.633] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [21:10:12.658] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [21:10:14.642] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [21:10:16.634] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 411
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
| Buenos Aires                  | M    |       23104 |       4000 |        469 |              0.014 |              0.020 |            0.284 |           0.173 |                  0.022 |           0.009 |
| Buenos Aires                  | F    |       21999 |       3383 |        351 |              0.011 |              0.016 |            0.253 |           0.154 |                  0.015 |           0.005 |
| CABA                          | F    |       17034 |       4052 |        272 |              0.013 |              0.016 |            0.348 |           0.238 |                  0.015 |           0.006 |
| CABA                          | M    |       16811 |       4090 |        344 |              0.017 |              0.020 |            0.383 |           0.243 |                  0.026 |           0.012 |
| Chaco                         | F    |        1218 |        131 |         42 |              0.025 |              0.034 |            0.173 |           0.108 |                  0.051 |           0.015 |
| Chaco                         | M    |        1196 |        137 |         67 |              0.040 |              0.056 |            0.173 |           0.115 |                  0.074 |           0.035 |
| Río Negro                     | F    |         518 |        206 |         17 |              0.029 |              0.033 |            0.198 |           0.398 |                  0.019 |           0.012 |
| Río Negro                     | M    |         490 |        201 |         29 |              0.053 |              0.059 |            0.221 |           0.410 |                  0.041 |           0.031 |
| Córdoba                       | M    |         407 |         55 |         18 |              0.020 |              0.044 |            0.037 |           0.135 |                  0.042 |           0.020 |
| Córdoba                       | F    |         390 |         73 |         19 |              0.020 |              0.049 |            0.035 |           0.187 |                  0.036 |           0.010 |
| Neuquén                       | F    |         335 |        173 |          8 |              0.019 |              0.024 |            0.236 |           0.516 |                  0.009 |           0.009 |
| SIN ESPECIFICAR               | F    |         308 |         49 |          0 |              0.000 |              0.000 |            0.338 |           0.159 |                  0.006 |           0.000 |
| Neuquén                       | M    |         304 |        166 |         10 |              0.025 |              0.033 |            0.207 |           0.546 |                  0.016 |           0.010 |
| SIN ESPECIFICAR               | M    |         255 |         46 |          1 |              0.003 |              0.004 |            0.407 |           0.180 |                  0.012 |           0.008 |
| Santa Fe                      | M    |         237 |         45 |          5 |              0.014 |              0.021 |            0.034 |           0.190 |                  0.055 |           0.030 |
| Santa Fe                      | F    |         228 |         28 |          1 |              0.003 |              0.004 |            0.031 |           0.123 |                  0.026 |           0.004 |
| Entre Ríos                    | M    |         189 |         49 |          0 |              0.000 |              0.000 |            0.131 |           0.259 |                  0.011 |           0.005 |
| Buenos Aires                  | NR   |         185 |         22 |          3 |              0.009 |              0.016 |            0.318 |           0.119 |                  0.027 |           0.005 |
| Entre Ríos                    | F    |         165 |         37 |          0 |              0.000 |              0.000 |            0.117 |           0.224 |                  0.000 |           0.000 |
| Jujuy                         | M    |         151 |          3 |          1 |              0.001 |              0.007 |            0.078 |           0.020 |                  0.007 |           0.007 |
| CABA                          | NR   |         141 |         47 |          8 |              0.032 |              0.057 |            0.329 |           0.333 |                  0.057 |           0.043 |
| Mendoza                       | M    |         120 |        112 |         10 |              0.046 |              0.083 |            0.066 |           0.933 |                  0.083 |           0.033 |
| Mendoza                       | F    |         119 |         99 |          0 |              0.000 |              0.000 |            0.069 |           0.832 |                  0.017 |           0.008 |
| Jujuy                         | F    |         109 |          0 |          0 |              0.000 |              0.000 |            0.109 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | M    |          94 |          4 |          1 |              0.005 |              0.011 |            0.114 |           0.043 |                  0.011 |           0.011 |
| Tierra del Fuego              | M    |          81 |          4 |          1 |              0.010 |              0.012 |            0.091 |           0.049 |                  0.037 |           0.037 |
| Chubut                        | F    |          80 |          1 |          0 |              0.000 |              0.000 |            0.102 |           0.013 |                  0.000 |           0.000 |
| Corrientes                    | M    |          78 |          1 |          0 |              0.000 |              0.000 |            0.039 |           0.013 |                  0.000 |           0.000 |
| La Rioja                      | F    |          67 |         10 |          6 |              0.058 |              0.090 |            0.057 |           0.149 |                  0.045 |           0.015 |
| Formosa                       | M    |          63 |          0 |          0 |              0.000 |              0.000 |            0.136 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.076 |           0.051 |                  0.000 |           0.000 |
| La Rioja                      | M    |          58 |          6 |          3 |              0.029 |              0.052 |            0.046 |           0.103 |                  0.034 |           0.000 |
| Tucumán                       | M    |          52 |         11 |          2 |              0.007 |              0.038 |            0.010 |           0.212 |                  0.058 |           0.000 |
| Corrientes                    | F    |          48 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.021 |           0.000 |
| Salta                         | M    |          47 |         19 |          1 |              0.012 |              0.021 |            0.056 |           0.404 |                  0.021 |           0.000 |
| Santa Cruz                    | M    |          38 |         13 |          0 |              0.000 |              0.000 |            0.097 |           0.342 |                  0.105 |           0.053 |
| Tucumán                       | F    |          33 |          9 |          2 |              0.011 |              0.061 |            0.011 |           0.273 |                  0.182 |           0.061 |
| Santiago del Estero           | M    |          29 |          1 |          0 |              0.000 |              0.000 |            0.013 |           0.034 |                  0.034 |           0.000 |
| Salta                         | F    |          25 |          9 |          0 |              0.000 |              0.000 |            0.067 |           0.360 |                  0.000 |           0.000 |
| Misiones                      | M    |          24 |         16 |          1 |              0.028 |              0.042 |            0.028 |           0.667 |                  0.167 |           0.083 |
| Santa Cruz                    | F    |          20 |          9 |          0 |              0.000 |              0.000 |            0.069 |           0.450 |                  0.050 |           0.050 |
| Misiones                      | F    |          18 |         13 |          1 |              0.033 |              0.056 |            0.024 |           0.722 |                  0.111 |           0.056 |
| Catamarca                     | M    |          17 |          0 |          0 |              0.000 |              0.000 |            0.033 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | F    |          13 |          1 |          0 |              0.000 |              0.000 |            0.042 |           0.077 |                  0.000 |           0.000 |
| Catamarca                     | F    |          10 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | M    |          10 |          6 |          0 |              0.000 |              0.000 |            0.029 |           0.600 |                  0.100 |           0.000 |
| Santiago del Estero           | F    |          10 |          1 |          0 |              0.000 |              0.000 |            0.011 |           0.100 |                  0.100 |           0.000 |

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
#> Warning: Removed 33 rows containing missing values (position_stack).
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
