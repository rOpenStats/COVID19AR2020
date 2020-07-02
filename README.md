
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
#> INFO  [09:30:10.011] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [09:30:15.585] Normalize 
#> INFO  [09:30:16.274] checkSoundness 
#> INFO  [09:30:16.628] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-01"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-01"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-01"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-01              |       67184 |       1351 |              0.014 |               0.02 |                       126 | 307843 |            0.218 |

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
| Buenos Aires                  |       33216 |        612 |              0.012 |              0.018 |                       125 | 140220 |            0.237 |
| CABA                          |       27614 |        516 |              0.015 |              0.019 |                       124 |  79838 |            0.346 |
| Chaco                         |        2091 |         99 |              0.032 |              0.047 |                       112 |  12108 |            0.173 |
| Río Negro                     |         877 |         41 |              0.042 |              0.047 |                       107 |   4326 |            0.203 |
| Córdoba                       |         659 |         37 |              0.025 |              0.056 |                       114 |  20475 |            0.032 |
| Neuquén                       |         491 |         13 |              0.020 |              0.026 |                       109 |   2521 |            0.195 |
| Santa Fe                      |         422 |          4 |              0.005 |              0.009 |                       110 |  13394 |            0.032 |
| SIN ESPECIFICAR               |         421 |          1 |              0.002 |              0.002 |                       102 |   1224 |            0.344 |
| Entre Ríos                    |         294 |          0 |              0.000 |              0.000 |                       107 |   2570 |            0.114 |
| Mendoza                       |         176 |         10 |              0.031 |              0.057 |                       113 |   3137 |            0.056 |
| Tierra del Fuego              |         137 |          1 |              0.006 |              0.007 |                       106 |   1643 |            0.083 |
| Chubut                        |         136 |          1 |              0.004 |              0.007 |                        93 |   1418 |            0.096 |
| Corrientes                    |         118 |          0 |              0.000 |              0.000 |                       105 |   3438 |            0.034 |
| Jujuy                         |         114 |          1 |              0.002 |              0.009 |                       102 |   2694 |            0.042 |

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
| Buenos Aires                  |       33216 | 140220 |        612 |               12.3 |              0.012 |              0.018 |            0.237 |           0.184 |                  0.021 |           0.008 |
| CABA                          |       27614 |  79838 |        516 |               14.0 |              0.015 |              0.019 |            0.346 |           0.252 |                  0.022 |           0.010 |
| Chaco                         |        2091 |  12108 |         99 |               13.9 |              0.032 |              0.047 |            0.173 |           0.123 |                  0.068 |           0.028 |
| Río Negro                     |         877 |   4326 |         41 |               12.7 |              0.042 |              0.047 |            0.203 |           0.433 |                  0.031 |           0.019 |
| Córdoba                       |         659 |  20475 |         37 |               24.3 |              0.025 |              0.056 |            0.032 |           0.194 |                  0.047 |           0.018 |
| Neuquén                       |         491 |   2521 |         13 |               18.1 |              0.020 |              0.026 |            0.195 |           0.601 |                  0.012 |           0.010 |
| Santa Fe                      |         422 |  13394 |          4 |               25.5 |              0.005 |              0.009 |            0.032 |           0.156 |                  0.033 |           0.017 |
| SIN ESPECIFICAR               |         421 |   1224 |          1 |               12.0 |              0.002 |              0.002 |            0.344 |           0.188 |                  0.014 |           0.007 |
| Entre Ríos                    |         294 |   2570 |          0 |                NaN |              0.000 |              0.000 |            0.114 |           0.265 |                  0.003 |           0.000 |
| Mendoza                       |         176 |   3137 |         10 |               13.1 |              0.031 |              0.057 |            0.056 |           0.943 |                  0.068 |           0.028 |
| Tierra del Fuego              |         137 |   1643 |          1 |               24.0 |              0.006 |              0.007 |            0.083 |           0.051 |                  0.022 |           0.022 |
| Chubut                        |         136 |   1418 |          1 |               19.0 |              0.004 |              0.007 |            0.096 |           0.037 |                  0.007 |           0.007 |
| Corrientes                    |         118 |   3438 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.008 |                  0.008 |           0.000 |
| Jujuy                         |         114 |   2694 |          1 |               22.0 |              0.002 |              0.009 |            0.042 |           0.018 |                  0.009 |           0.009 |
| La Rioja                      |          86 |   1989 |          9 |               11.7 |              0.062 |              0.105 |            0.043 |           0.174 |                  0.058 |           0.012 |
| Tucumán                       |          79 |   7719 |          4 |               14.2 |              0.009 |              0.051 |            0.010 |           0.228 |                  0.114 |           0.025 |
| Formosa                       |          74 |    770 |          0 |                NaN |              0.000 |              0.000 |            0.096 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    |          51 |    631 |          0 |                NaN |              0.000 |              0.000 |            0.081 |           0.412 |                  0.078 |           0.039 |
| Misiones                      |          42 |   1483 |          2 |                6.5 |              0.031 |              0.048 |            0.028 |           0.690 |                  0.143 |           0.071 |
| Salta                         |          33 |   1074 |          0 |                NaN |              0.000 |              0.000 |            0.031 |           0.727 |                  0.000 |           0.000 |
| Santiago del Estero           |          26 |   2727 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.038 |                  0.038 |           0.000 |
| San Luis                      |          11 |    550 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.727 |                  0.091 |           0.000 |
| San Juan                      |           8 |    816 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.625 |                  0.125 |           0.000 |
| La Pampa                      |           7 |    425 |          0 |                NaN |              0.000 |              0.000 |            0.016 |           0.143 |                  0.000 |           0.000 |
| Catamarca                     |           1 |    653 |          0 |                NaN |              0.000 |              0.000 |            0.002 |           0.000 |                  0.000 |           0.000 |

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
#> INFO  [09:31:53.484] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 18
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
|             13 | 2020-06-28              |                        77 |        1070 |   5510 |        594 |         61 |              0.047 |              0.057 |            0.194 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-06-30              |                       101 |        1738 |  11523 |        955 |        110 |              0.051 |              0.063 |            0.151 |           0.549 |                  0.096 |           0.056 |
|             15 | 2020-06-30              |                       118 |        2374 |  20229 |       1285 |        170 |              0.057 |              0.072 |            0.117 |           0.541 |                  0.091 |           0.051 |
|             16 | 2020-07-01              |                       124 |        3121 |  31808 |       1619 |        225 |              0.055 |              0.072 |            0.098 |           0.519 |                  0.082 |           0.044 |
|             17 | 2020-07-01              |                       126 |        4152 |  45853 |       2106 |        325 |              0.061 |              0.078 |            0.091 |           0.507 |                  0.075 |           0.039 |
|             18 | 2020-07-01              |                       126 |        5070 |  59031 |       2483 |        388 |              0.059 |              0.077 |            0.086 |           0.490 |                  0.068 |           0.036 |
|             19 | 2020-07-01              |                       126 |        6425 |  73149 |       3031 |        456 |              0.056 |              0.071 |            0.088 |           0.472 |                  0.063 |           0.032 |
|             20 | 2020-07-01              |                       126 |        8687 |  90495 |       3828 |        529 |              0.048 |              0.061 |            0.096 |           0.441 |                  0.056 |           0.028 |
|             21 | 2020-07-01              |                       126 |       12871 | 113869 |       5066 |        658 |              0.041 |              0.051 |            0.113 |           0.394 |                  0.049 |           0.025 |
|             22 | 2020-07-01              |                       126 |       17908 | 139182 |       6432 |        801 |              0.037 |              0.045 |            0.129 |           0.359 |                  0.044 |           0.022 |
|             23 | 2020-07-01              |                       126 |       24064 | 167335 |       7870 |        958 |              0.033 |              0.040 |            0.144 |           0.327 |                  0.040 |           0.019 |
|             24 | 2020-07-01              |                       126 |       33327 | 202171 |       9830 |       1107 |              0.027 |              0.033 |            0.165 |           0.295 |                  0.035 |           0.016 |
|             25 | 2020-07-01              |                       126 |       45690 | 243030 |      11850 |       1246 |              0.023 |              0.027 |            0.188 |           0.259 |                  0.029 |           0.013 |
|             26 | 2020-07-01              |                       126 |       61951 | 292194 |      14098 |       1338 |              0.017 |              0.022 |            0.212 |           0.228 |                  0.025 |           0.010 |
|             27 | 2020-07-01              |                       126 |       67184 | 307843 |      14645 |       1351 |              0.014 |              0.020 |            0.218 |           0.218 |                  0.024 |           0.010 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [09:32:56.186] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [09:33:58.304] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [09:34:08.970] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [09:34:10.560] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [09:34:15.188] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [09:34:18.830] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [09:34:24.575] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [09:34:27.219] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [09:34:29.643] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [09:34:31.405] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [09:34:33.695] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [09:34:35.808] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [09:34:38.047] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [09:34:40.699] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [09:34:42.702] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [09:34:44.844] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [09:34:47.141] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [09:34:49.289] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [09:34:51.304] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [09:34:53.285] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [09:34:55.396] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [09:34:58.435] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [09:35:00.603] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [09:35:02.694] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [09:35:04.967] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 385
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
#> [1] 58
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| Buenos Aires                  | M    |       16950 |       3266 |        365 |              0.014 |              0.022 |            0.252 |           0.193 |                  0.024 |           0.010 |
| Buenos Aires                  | F    |       16140 |       2812 |        245 |              0.010 |              0.015 |            0.223 |           0.174 |                  0.017 |           0.006 |
| CABA                          | F    |       13815 |       3451 |        226 |              0.013 |              0.016 |            0.330 |           0.250 |                  0.016 |           0.006 |
| CABA                          | M    |       13676 |       3477 |        282 |              0.017 |              0.021 |            0.364 |           0.254 |                  0.029 |           0.014 |
| Chaco                         | M    |        1053 |        131 |         62 |              0.040 |              0.059 |            0.175 |           0.124 |                  0.078 |           0.038 |
| Chaco                         | F    |        1036 |        127 |         37 |              0.024 |              0.036 |            0.170 |           0.123 |                  0.058 |           0.017 |
| Río Negro                     | M    |         440 |        191 |         28 |              0.057 |              0.064 |            0.220 |           0.434 |                  0.043 |           0.030 |
| Río Negro                     | F    |         437 |        189 |         13 |              0.027 |              0.030 |            0.188 |           0.432 |                  0.018 |           0.009 |
| Córdoba                       | M    |         336 |         54 |         18 |              0.025 |              0.054 |            0.033 |           0.161 |                  0.051 |           0.024 |
| Córdoba                       | F    |         321 |         73 |         19 |              0.025 |              0.059 |            0.031 |           0.227 |                  0.044 |           0.012 |
| Neuquén                       | F    |         251 |        153 |          6 |              0.019 |              0.024 |            0.205 |           0.610 |                  0.012 |           0.012 |
| Neuquén                       | M    |         240 |        142 |          7 |              0.022 |              0.029 |            0.185 |           0.592 |                  0.013 |           0.008 |
| SIN ESPECIFICAR               | F    |         231 |         38 |          0 |              0.000 |              0.000 |            0.319 |           0.165 |                  0.009 |           0.000 |
| Santa Fe                      | M    |         214 |         40 |          3 |              0.008 |              0.014 |            0.033 |           0.187 |                  0.047 |           0.028 |
| Santa Fe                      | F    |         208 |         26 |          1 |              0.003 |              0.005 |            0.030 |           0.125 |                  0.019 |           0.005 |
| SIN ESPECIFICAR               | M    |         188 |         40 |          0 |              0.000 |              0.000 |            0.384 |           0.213 |                  0.016 |           0.011 |
| Entre Ríos                    | M    |         154 |         46 |          0 |              0.000 |              0.000 |            0.119 |           0.299 |                  0.006 |           0.000 |
| Entre Ríos                    | F    |         139 |         32 |          0 |              0.000 |              0.000 |            0.110 |           0.230 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |         126 |         18 |          2 |              0.008 |              0.016 |            0.281 |           0.143 |                  0.016 |           0.000 |
| CABA                          | NR   |         123 |         34 |          8 |              0.036 |              0.065 |            0.333 |           0.276 |                  0.049 |           0.033 |
| Mendoza                       | M    |          92 |         88 |         10 |              0.062 |              0.109 |            0.057 |           0.957 |                  0.109 |           0.043 |
| Mendoza                       | F    |          84 |         78 |          0 |              0.000 |              0.000 |            0.056 |           0.929 |                  0.024 |           0.012 |
| Tierra del Fuego              | M    |          78 |          4 |          1 |              0.012 |              0.013 |            0.089 |           0.051 |                  0.038 |           0.038 |
| Chubut                        | M    |          74 |          4 |          1 |              0.009 |              0.014 |            0.101 |           0.054 |                  0.014 |           0.014 |
| Corrientes                    | M    |          73 |          1 |          0 |              0.000 |              0.000 |            0.037 |           0.014 |                  0.000 |           0.000 |
| Formosa                       | M    |          63 |          0 |          0 |              0.000 |              0.000 |            0.137 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | M    |          63 |          2 |          1 |              0.004 |              0.016 |            0.035 |           0.032 |                  0.016 |           0.016 |
| Chubut                        | F    |          61 |          1 |          0 |              0.000 |              0.000 |            0.091 |           0.016 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.076 |           0.052 |                  0.000 |           0.000 |
| Jujuy                         | F    |          50 |          0 |          0 |              0.000 |              0.000 |            0.056 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | M    |          49 |         10 |          2 |              0.008 |              0.041 |            0.010 |           0.204 |                  0.061 |           0.000 |
| Corrientes                    | F    |          45 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.022 |           0.000 |
| La Rioja                      | F    |          44 |         10 |          6 |              0.083 |              0.136 |            0.046 |           0.227 |                  0.068 |           0.023 |
| La Rioja                      | M    |          42 |          5 |          3 |              0.042 |              0.071 |            0.041 |           0.119 |                  0.048 |           0.000 |
| Santa Cruz                    | M    |          32 |         12 |          0 |              0.000 |              0.000 |            0.089 |           0.375 |                  0.094 |           0.031 |
| Tucumán                       | F    |          30 |          8 |          2 |              0.012 |              0.067 |            0.010 |           0.267 |                  0.200 |           0.067 |
| Misiones                      | M    |          24 |         16 |          1 |              0.026 |              0.042 |            0.030 |           0.667 |                  0.167 |           0.083 |
| Salta                         | M    |          21 |         16 |          0 |              0.000 |              0.000 |            0.028 |           0.762 |                  0.000 |           0.000 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.070 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.040 |              0.056 |            0.027 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          18 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.056 |                  0.056 |           0.000 |
| Salta                         | F    |          12 |          8 |          0 |              0.000 |              0.000 |            0.037 |           0.667 |                  0.000 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.036 |           0.000 |                  0.000 |           0.000 |

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
