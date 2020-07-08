
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
#> INFO  [08:58:54.428] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [08:58:57.589] Normalize 
#> INFO  [08:58:58.216] checkSoundness 
#> INFO  [08:58:58.525] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-07"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-07"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-07"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-07              |       83413 |       1644 |              0.014 |               0.02 |                       132 | 350185 |            0.238 |

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
| Buenos Aires                  |       43072 |        788 |              0.012 |              0.018 |                       131 | 163744 |            0.263 |
| CABA                          |       32902 |        608 |              0.015 |              0.018 |                       130 |  91069 |            0.361 |
| Chaco                         |        2357 |        109 |              0.032 |              0.046 |                       118 |  13656 |            0.173 |
| Río Negro                     |         997 |         46 |              0.041 |              0.046 |                       113 |   4764 |            0.209 |
| Córdoba                       |         778 |         37 |              0.020 |              0.048 |                       120 |  21898 |            0.036 |
| Neuquén                       |         616 |         18 |              0.022 |              0.029 |                       115 |   2797 |            0.220 |
| SIN ESPECIFICAR               |         528 |          2 |              0.003 |              0.004 |                       108 |   1474 |            0.358 |
| Santa Fe                      |         451 |          6 |              0.008 |              0.013 |                       116 |  14237 |            0.032 |
| Entre Ríos                    |         345 |          0 |              0.000 |              0.000 |                       113 |   2812 |            0.123 |
| Jujuy                         |         222 |          1 |              0.001 |              0.005 |                       109 |   2905 |            0.076 |
| Mendoza                       |         219 |         10 |              0.023 |              0.046 |                       119 |   3462 |            0.063 |
| Chubut                        |         159 |          1 |              0.003 |              0.006 |                        98 |   1555 |            0.102 |
| Tierra del Fuego              |         142 |          1 |              0.006 |              0.007 |                       112 |   1670 |            0.085 |
| Corrientes                    |         122 |          0 |              0.000 |              0.000 |                       110 |   3496 |            0.035 |
| La Rioja                      |         111 |          9 |              0.053 |              0.081 |                       104 |   2351 |            0.047 |

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
| Buenos Aires                  |       43072 | 163744 |        788 |               12.8 |              0.012 |              0.018 |            0.263 |           0.167 |                  0.019 |           0.007 |
| CABA                          |       32902 |  91069 |        608 |               13.9 |              0.015 |              0.018 |            0.361 |           0.243 |                  0.021 |           0.009 |
| Chaco                         |        2357 |  13656 |        109 |               14.3 |              0.032 |              0.046 |            0.173 |           0.113 |                  0.063 |           0.025 |
| Río Negro                     |         997 |   4764 |         46 |               13.5 |              0.041 |              0.046 |            0.209 |           0.403 |                  0.030 |           0.021 |
| Córdoba                       |         778 |  21898 |         37 |               24.3 |              0.020 |              0.048 |            0.036 |           0.166 |                  0.040 |           0.015 |
| Neuquén                       |         616 |   2797 |         18 |               18.1 |              0.022 |              0.029 |            0.220 |           0.516 |                  0.013 |           0.010 |
| SIN ESPECIFICAR               |         528 |   1474 |          2 |               34.5 |              0.003 |              0.004 |            0.358 |           0.180 |                  0.011 |           0.006 |
| Santa Fe                      |         451 |  14237 |          6 |               20.5 |              0.008 |              0.013 |            0.032 |           0.160 |                  0.042 |           0.018 |
| Entre Ríos                    |         345 |   2812 |          0 |                NaN |              0.000 |              0.000 |            0.123 |           0.243 |                  0.006 |           0.003 |
| Jujuy                         |         222 |   2905 |          1 |               22.0 |              0.001 |              0.005 |            0.076 |           0.014 |                  0.005 |           0.005 |
| Mendoza                       |         219 |   3462 |         10 |               13.1 |              0.023 |              0.046 |            0.063 |           0.909 |                  0.055 |           0.023 |
| Chubut                        |         159 |   1555 |          1 |               19.0 |              0.003 |              0.006 |            0.102 |           0.031 |                  0.006 |           0.006 |
| Tierra del Fuego              |         142 |   1670 |          1 |               24.0 |              0.006 |              0.007 |            0.085 |           0.049 |                  0.021 |           0.021 |
| Corrientes                    |         122 |   3496 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.008 |                  0.008 |           0.000 |
| La Rioja                      |         111 |   2351 |          9 |               11.7 |              0.053 |              0.081 |            0.047 |           0.144 |                  0.045 |           0.009 |
| Tucumán                       |          84 |   8288 |          4 |               14.2 |              0.009 |              0.048 |            0.010 |           0.214 |                  0.107 |           0.024 |
| Formosa                       |          76 |    773 |          0 |                NaN |              0.000 |              0.000 |            0.098 |           0.013 |                  0.000 |           0.000 |
| Salta                         |          65 |   1208 |          2 |                1.0 |              0.017 |              0.031 |            0.054 |           0.415 |                  0.015 |           0.000 |
| Santa Cruz                    |          57 |    673 |          0 |                NaN |              0.000 |              0.000 |            0.085 |           0.386 |                  0.088 |           0.053 |
| Misiones                      |          42 |   1604 |          2 |                6.5 |              0.030 |              0.048 |            0.026 |           0.690 |                  0.143 |           0.071 |
| Santiago del Estero           |          31 |   3016 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.032 |                  0.032 |           0.000 |
| San Luis                      |          12 |    594 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.667 |                  0.083 |           0.000 |
| San Juan                      |          10 |    854 |          0 |                NaN |              0.000 |              0.000 |            0.012 |           0.500 |                  0.100 |           0.000 |
| Catamarca                     |           8 |    822 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      |           7 |    463 |          0 |                NaN |              0.000 |              0.000 |            0.015 |           0.143 |                  0.000 |           0.000 |

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
#> INFO  [09:00:00.060] Processing {current.group: }
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
|             16 | 2020-07-06              |                       127 |        3140 |  31825 |       1625 |        225 |              0.056 |              0.072 |            0.099 |           0.518 |                  0.082 |           0.044 |
|             17 | 2020-07-07              |                       132 |        4184 |  45874 |       2117 |        326 |              0.061 |              0.078 |            0.091 |           0.506 |                  0.075 |           0.039 |
|             18 | 2020-07-07              |                       132 |        5117 |  59054 |       2497 |        389 |              0.060 |              0.076 |            0.087 |           0.488 |                  0.068 |           0.036 |
|             19 | 2020-07-07              |                       132 |        6488 |  73173 |       3049 |        459 |              0.056 |              0.071 |            0.089 |           0.470 |                  0.062 |           0.032 |
|             20 | 2020-07-07              |                       132 |        8774 |  90522 |       3863 |        537 |              0.049 |              0.061 |            0.097 |           0.440 |                  0.056 |           0.028 |
|             21 | 2020-07-07              |                       132 |       12986 | 113910 |       5129 |        667 |              0.042 |              0.051 |            0.114 |           0.395 |                  0.049 |           0.025 |
|             22 | 2020-07-07              |                       132 |       18053 | 139239 |       6504 |        815 |              0.037 |              0.045 |            0.130 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-07              |                       132 |       24257 | 167403 |       7965 |        984 |              0.033 |              0.041 |            0.145 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-07-07              |                       132 |       33575 | 202327 |       9971 |       1155 |              0.028 |              0.034 |            0.166 |           0.297 |                  0.035 |           0.016 |
|             25 | 2020-07-07              |                       132 |       46064 | 243306 |      12084 |       1339 |              0.024 |              0.029 |            0.189 |           0.262 |                  0.030 |           0.013 |
|             26 | 2020-07-07              |                       132 |       63113 | 294144 |      14627 |       1538 |              0.020 |              0.024 |            0.215 |           0.232 |                  0.026 |           0.011 |
|             27 | 2020-07-07              |                       132 |       79662 | 340259 |      16510 |       1638 |              0.016 |              0.021 |            0.234 |           0.207 |                  0.022 |           0.009 |
|             28 | 2020-07-07              |                       132 |       83413 | 350185 |      16881 |       1644 |              0.014 |              0.020 |            0.238 |           0.202 |                  0.022 |           0.009 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [09:00:29.693] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [09:00:41.731] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [09:00:49.709] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [09:00:50.910] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [09:00:54.038] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [09:00:55.995] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [09:01:00.097] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [09:01:02.473] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [09:01:04.780] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [09:01:06.366] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [09:01:08.809] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [09:01:11.035] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [09:01:13.357] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [09:01:15.684] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [09:01:17.762] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [09:01:20.275] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [09:01:22.779] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [09:01:24.873] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [09:01:27.008] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [09:01:29.082] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [09:01:30.921] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [09:01:33.888] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [09:01:35.865] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [09:01:37.634] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [09:01:39.570] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       21974 |       3875 |        451 |              0.014 |              0.021 |            0.279 |           0.176 |                  0.022 |           0.009 |
| Buenos Aires                  | F    |       20929 |       3291 |        334 |              0.011 |              0.016 |            0.248 |           0.157 |                  0.016 |           0.005 |
| CABA                          | F    |       16492 |       3951 |        266 |              0.013 |              0.016 |            0.345 |           0.240 |                  0.016 |           0.006 |
| CABA                          | M    |       16271 |       3988 |        334 |              0.017 |              0.021 |            0.380 |           0.245 |                  0.026 |           0.013 |
| Chaco                         | F    |        1182 |        131 |         42 |              0.025 |              0.036 |            0.172 |           0.111 |                  0.052 |           0.015 |
| Chaco                         | M    |        1173 |        135 |         67 |              0.040 |              0.057 |            0.173 |           0.115 |                  0.073 |           0.036 |
| Río Negro                     | F    |         510 |        203 |         17 |              0.030 |              0.033 |            0.198 |           0.398 |                  0.020 |           0.012 |
| Río Negro                     | M    |         487 |        199 |         29 |              0.052 |              0.060 |            0.223 |           0.409 |                  0.041 |           0.031 |
| Córdoba                       | M    |         401 |         55 |         18 |              0.020 |              0.045 |            0.037 |           0.137 |                  0.042 |           0.020 |
| Córdoba                       | F    |         375 |         73 |         19 |              0.021 |              0.051 |            0.034 |           0.195 |                  0.037 |           0.011 |
| Neuquén                       | F    |         321 |        165 |          8 |              0.020 |              0.025 |            0.236 |           0.514 |                  0.009 |           0.009 |
| Neuquén                       | M    |         295 |        153 |         10 |              0.025 |              0.034 |            0.206 |           0.519 |                  0.017 |           0.010 |
| SIN ESPECIFICAR               | F    |         291 |         48 |          0 |              0.000 |              0.000 |            0.335 |           0.165 |                  0.007 |           0.000 |
| SIN ESPECIFICAR               | M    |         235 |         46 |          1 |              0.003 |              0.004 |            0.396 |           0.196 |                  0.013 |           0.009 |
| Santa Fe                      | M    |         229 |         45 |          5 |              0.014 |              0.022 |            0.033 |           0.197 |                  0.057 |           0.031 |
| Santa Fe                      | F    |         222 |         27 |          1 |              0.003 |              0.005 |            0.030 |           0.122 |                  0.027 |           0.005 |
| Entre Ríos                    | M    |         182 |         48 |          0 |              0.000 |              0.000 |            0.128 |           0.264 |                  0.011 |           0.005 |
| Buenos Aires                  | NR   |         169 |         21 |          3 |              0.009 |              0.018 |            0.308 |           0.124 |                  0.030 |           0.006 |
| Entre Ríos                    | F    |         162 |         36 |          0 |              0.000 |              0.000 |            0.117 |           0.222 |                  0.000 |           0.000 |
| CABA                          | NR   |         139 |         46 |          8 |              0.033 |              0.058 |            0.329 |           0.331 |                  0.058 |           0.043 |
| Jujuy                         | M    |         123 |          3 |          1 |              0.002 |              0.008 |            0.065 |           0.024 |                  0.008 |           0.008 |
| Mendoza                       | M    |         113 |        107 |         10 |              0.050 |              0.088 |            0.063 |           0.947 |                  0.088 |           0.035 |
| Mendoza                       | F    |         104 |         92 |          0 |              0.000 |              0.000 |            0.063 |           0.885 |                  0.019 |           0.010 |
| Jujuy                         | F    |          98 |          0 |          0 |              0.000 |              0.000 |            0.100 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | M    |          87 |          4 |          1 |              0.006 |              0.011 |            0.110 |           0.046 |                  0.011 |           0.011 |
| Tierra del Fuego              | M    |          82 |          4 |          1 |              0.010 |              0.012 |            0.092 |           0.049 |                  0.037 |           0.037 |
| Corrientes                    | M    |          75 |          1 |          0 |              0.000 |              0.000 |            0.038 |           0.013 |                  0.000 |           0.000 |
| Chubut                        | F    |          71 |          1 |          0 |              0.000 |              0.000 |            0.095 |           0.014 |                  0.000 |           0.000 |
| Formosa                       | M    |          63 |          0 |          0 |              0.000 |              0.000 |            0.137 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.076 |           0.051 |                  0.000 |           0.000 |
| La Rioja                      | F    |          58 |         10 |          6 |              0.067 |              0.103 |            0.052 |           0.172 |                  0.052 |           0.017 |
| La Rioja                      | M    |          53 |          6 |          3 |              0.038 |              0.057 |            0.044 |           0.113 |                  0.038 |           0.000 |
| Tucumán                       | M    |          51 |         10 |          2 |              0.008 |              0.039 |            0.010 |           0.196 |                  0.059 |           0.000 |
| Corrientes                    | F    |          47 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.021 |           0.000 |
| Salta                         | M    |          38 |         19 |          2 |              0.028 |              0.053 |            0.046 |           0.500 |                  0.026 |           0.000 |
| Santa Cruz                    | M    |          37 |         13 |          0 |              0.000 |              0.000 |            0.096 |           0.351 |                  0.108 |           0.054 |
| Tucumán                       | F    |          33 |          8 |          2 |              0.011 |              0.061 |            0.011 |           0.242 |                  0.182 |           0.061 |
| Salta                         | F    |          27 |          8 |          0 |              0.000 |              0.000 |            0.073 |           0.296 |                  0.000 |           0.000 |
| Misiones                      | M    |          24 |         16 |          1 |              0.028 |              0.042 |            0.028 |           0.667 |                  0.167 |           0.083 |
| Santiago del Estero           | M    |          21 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.048 |                  0.048 |           0.000 |
| Santa Cruz                    | F    |          20 |          9 |          0 |              0.000 |              0.000 |            0.070 |           0.450 |                  0.050 |           0.050 |
| Misiones                      | F    |          18 |         13 |          1 |              0.033 |              0.056 |            0.024 |           0.722 |                  0.111 |           0.056 |
| Formosa                       | F    |          13 |          1 |          0 |              0.000 |              0.000 |            0.042 |           0.077 |                  0.000 |           0.000 |
| San Luis                      | M    |          10 |          6 |          0 |              0.000 |              0.000 |            0.029 |           0.600 |                  0.100 |           0.000 |
| Santiago del Estero           | F    |          10 |          0 |          0 |              0.000 |              0.000 |            0.012 |           0.000 |                  0.000 |           0.000 |

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
