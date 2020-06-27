
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
#> INFO  [20:21:02.003] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [20:21:05.458] Normalize 
#> INFO  [20:21:05.895] checkSoundness 
#> INFO  [20:21:06.207] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-27"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-27"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-27"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-27              |       57622 |       1207 |              0.015 |              0.021 |                       122 | 279964 |            0.206 |

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
| Buenos Aires                  |       27589 |        539 |              0.013 |              0.020 |                       121 | 125070 |            0.221 |
| CABA                          |       24254 |        456 |              0.015 |              0.019 |                       120 |  71579 |            0.339 |
| Chaco                         |        1881 |         92 |              0.032 |              0.049 |                       108 |  11199 |            0.168 |
| Río Negro                     |         820 |         41 |              0.045 |              0.050 |                       103 |   4026 |            0.204 |
| Córdoba                       |         630 |         36 |              0.027 |              0.057 |                       110 |  19709 |            0.032 |
| Neuquén                       |         431 |         11 |              0.020 |              0.026 |                       105 |   2395 |            0.180 |
| Santa Fe                      |         411 |          4 |              0.005 |              0.010 |                       106 |  12792 |            0.032 |
| SIN ESPECIFICAR               |         371 |          2 |              0.004 |              0.005 |                        98 |   1096 |            0.339 |
| Entre Ríos                    |         250 |          0 |              0.000 |              0.000 |                       103 |   2383 |            0.105 |
| Mendoza                       |         159 |          9 |              0.029 |              0.057 |                       109 |   2946 |            0.054 |
| Tierra del Fuego              |         136 |          1 |              0.007 |              0.007 |                       102 |   1623 |            0.084 |
| Corrientes                    |         115 |          0 |              0.000 |              0.000 |                       101 |   3393 |            0.034 |
| Chubut                        |         114 |          1 |              0.004 |              0.009 |                        89 |   1276 |            0.089 |

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
nrow(covid19.ar.summary)
#> [1] 24
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
        select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))
```

| residencia\_provincia\_nombre | confirmados |  tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | ----------: | -----: | ---------: | -----------------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| Buenos Aires                  |       27589 | 125070 |        539 |               12.3 |              0.013 |              0.020 |            0.221 |           0.196 |                  0.021 |           0.008 |
| CABA                          |       24254 |  71579 |        456 |               14.2 |              0.015 |              0.019 |            0.339 |           0.259 |                  0.022 |           0.010 |
| Chaco                         |        1881 |  11199 |         92 |               13.9 |              0.032 |              0.049 |            0.168 |           0.129 |                  0.070 |           0.030 |
| Río Negro                     |         820 |   4026 |         41 |               12.7 |              0.045 |              0.050 |            0.204 |           0.451 |                  0.033 |           0.021 |
| Córdoba                       |         630 |  19709 |         36 |               24.9 |              0.027 |              0.057 |            0.032 |           0.195 |                  0.048 |           0.019 |
| Neuquén                       |         431 |   2395 |         11 |               18.3 |              0.020 |              0.026 |            0.180 |           0.640 |                  0.014 |           0.012 |
| Santa Fe                      |         411 |  12792 |          4 |               25.5 |              0.005 |              0.010 |            0.032 |           0.161 |                  0.034 |           0.017 |
| SIN ESPECIFICAR               |         371 |   1096 |          2 |               14.5 |              0.004 |              0.005 |            0.339 |           0.189 |                  0.019 |           0.008 |
| Entre Ríos                    |         250 |   2383 |          0 |                NaN |              0.000 |              0.000 |            0.105 |           0.272 |                  0.000 |           0.000 |
| Mendoza                       |         159 |   2946 |          9 |               13.3 |              0.029 |              0.057 |            0.054 |           0.931 |                  0.069 |           0.031 |
| Tierra del Fuego              |         136 |   1623 |          1 |               24.0 |              0.007 |              0.007 |            0.084 |           0.051 |                  0.022 |           0.022 |
| Corrientes                    |         115 |   3393 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.009 |                  0.009 |           0.000 |
| Chubut                        |         114 |   1276 |          1 |               19.0 |              0.004 |              0.009 |            0.089 |           0.035 |                  0.009 |           0.009 |
| Jujuy                         |          78 |   2531 |          1 |               22.0 |              0.004 |              0.013 |            0.031 |           0.026 |                  0.013 |           0.013 |
| La Rioja                      |          76 |   1815 |          8 |               12.0 |              0.056 |              0.105 |            0.042 |           0.184 |                  0.053 |           0.013 |
| Tucumán                       |          71 |   7476 |          4 |               14.2 |              0.011 |              0.056 |            0.009 |           0.239 |                  0.127 |           0.028 |
| Formosa                       |          70 |    763 |          0 |                NaN |              0.000 |              0.000 |            0.092 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    |          50 |    608 |          0 |                NaN |              0.000 |              0.000 |            0.082 |           0.420 |                  0.080 |           0.040 |
| Misiones                      |          40 |   1444 |          2 |                6.5 |              0.031 |              0.050 |            0.028 |           0.725 |                  0.150 |           0.075 |
| Salta                         |          26 |    978 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.769 |                  0.000 |           0.000 |
| Santiago del Estero           |          23 |   2568 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.043 |                  0.043 |           0.000 |
| San Luis                      |          11 |    505 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.727 |                  0.091 |           0.000 |
| San Juan                      |           9 |    795 |          0 |                NaN |              0.000 |              0.000 |            0.011 |           0.556 |                  0.111 |           0.000 |
| La Pampa                      |           7 |    386 |          0 |                NaN |              0.000 |              0.000 |            0.018 |           0.143 |                  0.000 |           0.000 |

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
#> INFO  [20:22:02.173] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 17
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
|             13 | 2020-06-18              |                        75 |        1069 |   5509 |        593 |         61 |              0.047 |              0.057 |            0.194 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-06-27              |                        99 |        1736 |  11522 |        954 |        110 |              0.051 |              0.063 |            0.151 |           0.550 |                  0.096 |           0.056 |
|             15 | 2020-06-27              |                       116 |        2370 |  20227 |       1283 |        170 |              0.056 |              0.072 |            0.117 |           0.541 |                  0.092 |           0.051 |
|             16 | 2020-06-27              |                       120 |        3116 |  31800 |       1615 |        224 |              0.055 |              0.072 |            0.098 |           0.518 |                  0.082 |           0.044 |
|             17 | 2020-06-27              |                       122 |        4144 |  45833 |       2102 |        324 |              0.060 |              0.078 |            0.090 |           0.507 |                  0.075 |           0.039 |
|             18 | 2020-06-27              |                       122 |        5049 |  59009 |       2477 |        386 |              0.059 |              0.076 |            0.086 |           0.491 |                  0.069 |           0.036 |
|             19 | 2020-06-27              |                       122 |        6390 |  73127 |       3018 |        454 |              0.055 |              0.071 |            0.087 |           0.472 |                  0.063 |           0.032 |
|             20 | 2020-06-27              |                       122 |        8647 |  90469 |       3808 |        527 |              0.048 |              0.061 |            0.096 |           0.440 |                  0.057 |           0.028 |
|             21 | 2020-06-27              |                       122 |       12818 | 113836 |       5039 |        652 |              0.041 |              0.051 |            0.113 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-06-27              |                       122 |       17832 | 139136 |       6390 |        787 |              0.036 |              0.044 |            0.128 |           0.358 |                  0.044 |           0.021 |
|             23 | 2020-06-27              |                       122 |       23948 | 167273 |       7799 |        935 |              0.032 |              0.039 |            0.143 |           0.326 |                  0.040 |           0.018 |
|             24 | 2020-06-27              |                       122 |       33159 | 202050 |       9703 |       1067 |              0.026 |              0.032 |            0.164 |           0.293 |                  0.034 |           0.015 |
|             25 | 2020-06-27              |                       122 |       45386 | 242681 |      11612 |       1161 |              0.021 |              0.026 |            0.187 |           0.256 |                  0.028 |           0.012 |
|             26 | 2020-06-27              |                       122 |       57622 | 279964 |      13190 |       1207 |              0.015 |              0.021 |            0.206 |           0.229 |                  0.024 |           0.010 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [20:22:22.304] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [20:22:31.594] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [20:22:38.708] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [20:22:39.786] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [20:22:43.139] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [20:22:45.107] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [20:22:48.818] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [20:22:51.277] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [20:22:53.522] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [20:22:55.178] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [20:22:58.060] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [20:23:01.085] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [20:23:04.259] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [20:23:07.429] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [20:23:09.824] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [20:23:13.733] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [20:23:18.630] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [20:23:21.548] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [20:23:25.001] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [20:23:28.057] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [20:23:30.754] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [20:23:36.433] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [20:23:40.761] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [20:23:45.571] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [20:23:48.384] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 360
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
#> [1] 57
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| Buenos Aires                  | M    |       14126 |       2909 |        321 |              0.015 |              0.023 |            0.235 |           0.206 |                  0.025 |           0.010 |
| Buenos Aires                  | F    |       13355 |       2487 |        216 |              0.010 |              0.016 |            0.207 |           0.186 |                  0.018 |           0.006 |
| CABA                          | F    |       12156 |       3121 |        192 |              0.012 |              0.016 |            0.323 |           0.257 |                  0.016 |           0.006 |
| CABA                          | M    |       11986 |       3129 |        257 |              0.017 |              0.021 |            0.356 |           0.261 |                  0.029 |           0.014 |
| Chaco                         | M    |         951 |        125 |         60 |              0.042 |              0.063 |            0.171 |           0.131 |                  0.083 |           0.042 |
| Chaco                         | F    |         928 |        117 |         32 |              0.023 |              0.034 |            0.165 |           0.126 |                  0.057 |           0.018 |
| Río Negro                     | F    |         412 |        182 |         13 |              0.028 |              0.032 |            0.191 |           0.442 |                  0.019 |           0.010 |
| Río Negro                     | M    |         408 |        188 |         28 |              0.063 |              0.069 |            0.219 |           0.461 |                  0.047 |           0.032 |
| Córdoba                       | M    |         323 |         52 |         17 |              0.026 |              0.053 |            0.033 |           0.161 |                  0.050 |           0.025 |
| Córdoba                       | F    |         305 |         70 |         19 |              0.028 |              0.062 |            0.031 |           0.230 |                  0.046 |           0.013 |
| Neuquén                       | F    |         223 |        143 |          5 |              0.018 |              0.022 |            0.191 |           0.641 |                  0.013 |           0.013 |
| Neuquén                       | M    |         208 |        133 |          6 |              0.023 |              0.029 |            0.170 |           0.639 |                  0.014 |           0.010 |
| Santa Fe                      | M    |         208 |         40 |          3 |              0.008 |              0.014 |            0.033 |           0.192 |                  0.048 |           0.029 |
| SIN ESPECIFICAR               | F    |         204 |         33 |          1 |              0.004 |              0.005 |            0.320 |           0.162 |                  0.015 |           0.000 |
| Santa Fe                      | F    |         203 |         26 |          1 |              0.003 |              0.005 |            0.031 |           0.128 |                  0.020 |           0.005 |
| SIN ESPECIFICAR               | M    |         165 |         36 |          0 |              0.000 |              0.000 |            0.368 |           0.218 |                  0.018 |           0.012 |
| Entre Ríos                    | M    |         132 |         41 |          0 |              0.000 |              0.000 |            0.108 |           0.311 |                  0.000 |           0.000 |
| Entre Ríos                    | F    |         117 |         27 |          0 |              0.000 |              0.000 |            0.101 |           0.231 |                  0.000 |           0.000 |
| CABA                          | NR   |         112 |         33 |          7 |              0.035 |              0.062 |            0.334 |           0.295 |                  0.054 |           0.036 |
| Buenos Aires                  | NR   |         108 |         18 |          2 |              0.010 |              0.019 |            0.275 |           0.167 |                  0.019 |           0.000 |
| Mendoza                       | M    |          85 |         80 |          9 |              0.056 |              0.106 |            0.056 |           0.941 |                  0.106 |           0.047 |
| Tierra del Fuego              | M    |          77 |          4 |          1 |              0.012 |              0.013 |            0.089 |           0.052 |                  0.039 |           0.039 |
| Mendoza                       | F    |          74 |         68 |          0 |              0.000 |              0.000 |            0.052 |           0.919 |                  0.027 |           0.014 |
| Corrientes                    | M    |          72 |          1 |          0 |              0.000 |              0.000 |            0.037 |           0.014 |                  0.000 |           0.000 |
| Chubut                        | M    |          66 |          3 |          1 |              0.008 |              0.015 |            0.098 |           0.045 |                  0.015 |           0.015 |
| Formosa                       | M    |          63 |          0 |          0 |              0.000 |              0.000 |            0.137 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.077 |           0.052 |                  0.000 |           0.000 |
| Chubut                        | F    |          47 |          1 |          0 |              0.000 |              0.000 |            0.079 |           0.021 |                  0.000 |           0.000 |
| Tucumán                       | M    |          45 |          9 |          2 |              0.009 |              0.044 |            0.010 |           0.200 |                  0.067 |           0.000 |
| Corrientes                    | F    |          43 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.023 |           0.000 |
| La Rioja                      | F    |          40 |         10 |          6 |              0.088 |              0.150 |            0.046 |           0.250 |                  0.075 |           0.025 |
| Jujuy                         | F    |          39 |          0 |          0 |              0.000 |              0.000 |            0.047 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | M    |          38 |          2 |          1 |              0.007 |              0.026 |            0.023 |           0.053 |                  0.026 |           0.026 |
| La Rioja                      | M    |          36 |          4 |          2 |              0.027 |              0.056 |            0.039 |           0.111 |                  0.028 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.089 |           0.387 |                  0.097 |           0.032 |
| Tucumán                       | F    |          26 |          8 |          2 |              0.013 |              0.077 |            0.009 |           0.308 |                  0.231 |           0.077 |
| Misiones                      | M    |          21 |         16 |          1 |              0.029 |              0.048 |            0.027 |           0.762 |                  0.190 |           0.095 |
| Misiones                      | F    |          19 |         13 |          1 |              0.033 |              0.053 |            0.029 |           0.684 |                  0.105 |           0.053 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.073 |           0.474 |                  0.053 |           0.053 |
| Salta                         | M    |          17 |         13 |          0 |              0.000 |              0.000 |            0.025 |           0.765 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          16 |          1 |          0 |              0.000 |              0.000 |            0.009 |           0.062 |                  0.062 |           0.000 |

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
#> Warning: Removed 31 rows containing missing values (position_stack).
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
