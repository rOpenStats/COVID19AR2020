
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
#> INFO  [21:14:56.783] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [21:14:59.548] Normalize 
#> INFO  [21:14:59.935] checkSoundness 
#> INFO  [21:15:00.201] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-26"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-26"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-26"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-26              |       55218 |       1184 |              0.015 |              0.021 |                       121 | 272981 |            0.202 |

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
| Buenos Aires                  |       26168 |        526 |              0.013 |              0.020 |                       120 | 121356 |            0.216 |
| CABA                          |       23412 |        446 |              0.015 |              0.019 |                       119 |  69743 |            0.336 |
| Chaco                         |        1829 |         92 |              0.032 |              0.050 |                       107 |  10906 |            0.168 |
| Río Negro                     |         805 |         41 |              0.045 |              0.051 |                       102 |   3938 |            0.204 |
| Córdoba                       |         613 |         36 |              0.025 |              0.059 |                       109 |  19408 |            0.032 |
| Neuquén                       |         415 |         11 |              0.020 |              0.027 |                       104 |   2299 |            0.181 |
| Santa Fe                      |         406 |          4 |              0.006 |              0.010 |                       105 |  12680 |            0.032 |
| SIN ESPECIFICAR               |         361 |          2 |              0.004 |              0.006 |                        97 |   1066 |            0.339 |
| Entre Ríos                    |         238 |          0 |              0.000 |              0.000 |                       102 |   2318 |            0.103 |
| Mendoza                       |         153 |          9 |              0.028 |              0.059 |                       108 |   2868 |            0.053 |
| Tierra del Fuego              |         136 |          1 |              0.007 |              0.007 |                       101 |   1618 |            0.084 |
| Chubut                        |         115 |          1 |              0.004 |              0.009 |                        88 |   1211 |            0.095 |
| Corrientes                    |         114 |          0 |              0.000 |              0.000 |                        99 |   3382 |            0.034 |

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
| Buenos Aires                  |       26168 | 121356 |        526 |               12.3 |              0.013 |              0.020 |            0.216 |           0.201 |                  0.022 |           0.008 |
| CABA                          |       23412 |  69743 |        446 |               14.3 |              0.015 |              0.019 |            0.336 |           0.262 |                  0.023 |           0.011 |
| Chaco                         |        1829 |  10906 |         92 |               13.9 |              0.032 |              0.050 |            0.168 |           0.132 |                  0.072 |           0.031 |
| Río Negro                     |         805 |   3938 |         41 |               12.7 |              0.045 |              0.051 |            0.204 |           0.456 |                  0.034 |           0.021 |
| Córdoba                       |         613 |  19408 |         36 |               24.9 |              0.025 |              0.059 |            0.032 |           0.201 |                  0.049 |           0.020 |
| Neuquén                       |         415 |   2299 |         11 |               18.3 |              0.020 |              0.027 |            0.181 |           0.665 |                  0.014 |           0.012 |
| Santa Fe                      |         406 |  12680 |          4 |               25.5 |              0.006 |              0.010 |            0.032 |           0.163 |                  0.034 |           0.017 |
| SIN ESPECIFICAR               |         361 |   1066 |          2 |               14.5 |              0.004 |              0.006 |            0.339 |           0.186 |                  0.014 |           0.006 |
| Entre Ríos                    |         238 |   2318 |          0 |                NaN |              0.000 |              0.000 |            0.103 |           0.282 |                  0.000 |           0.000 |
| Mendoza                       |         153 |   2868 |          9 |               13.3 |              0.028 |              0.059 |            0.053 |           0.928 |                  0.072 |           0.033 |
| Tierra del Fuego              |         136 |   1618 |          1 |               24.0 |              0.007 |              0.007 |            0.084 |           0.051 |                  0.022 |           0.022 |
| Chubut                        |         115 |   1211 |          1 |               19.0 |              0.004 |              0.009 |            0.095 |           0.035 |                  0.009 |           0.009 |
| Corrientes                    |         114 |   3382 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.009 |                  0.009 |           0.000 |
| Jujuy                         |          75 |   2522 |          1 |               22.0 |              0.005 |              0.013 |            0.030 |           0.027 |                  0.013 |           0.013 |
| La Rioja                      |          75 |   1728 |          8 |               12.0 |              0.056 |              0.107 |            0.043 |           0.187 |                  0.053 |           0.013 |
| Tucumán                       |          70 |   7362 |          4 |               14.2 |              0.010 |              0.057 |            0.010 |           0.229 |                  0.129 |           0.029 |
| Formosa                       |          69 |    761 |          0 |                NaN |              0.000 |              0.000 |            0.091 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    |          50 |    602 |          0 |                NaN |              0.000 |              0.000 |            0.083 |           0.420 |                  0.080 |           0.040 |
| Misiones                      |          41 |   1432 |          2 |                6.5 |              0.031 |              0.049 |            0.029 |           0.707 |                  0.146 |           0.073 |
| Salta                         |          24 |    952 |          0 |                NaN |              0.000 |              0.000 |            0.025 |           0.833 |                  0.000 |           0.000 |
| Santiago del Estero           |          23 |   2567 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.043 |                  0.043 |           0.000 |
| San Luis                      |          11 |    504 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.727 |                  0.091 |           0.000 |
| San Juan                      |           8 |    773 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.625 |                  0.125 |           0.000 |
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
#> INFO  [21:15:56.721] Processing {current.group: }
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
|             14 | 2020-06-26              |                        98 |        1736 |  11521 |        954 |        110 |              0.051 |              0.063 |            0.151 |           0.550 |                  0.096 |           0.056 |
|             15 | 2020-06-26              |                       115 |        2369 |  20225 |       1283 |        170 |              0.056 |              0.072 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 | 2020-06-26              |                       119 |        3114 |  31798 |       1615 |        224 |              0.055 |              0.072 |            0.098 |           0.519 |                  0.083 |           0.044 |
|             17 | 2020-06-26              |                       121 |        4141 |  45831 |       2102 |        324 |              0.060 |              0.078 |            0.090 |           0.508 |                  0.075 |           0.039 |
|             18 | 2020-06-26              |                       121 |        5045 |  59007 |       2477 |        386 |              0.059 |              0.077 |            0.085 |           0.491 |                  0.069 |           0.036 |
|             19 | 2020-06-26              |                       121 |        6384 |  73124 |       3017 |        454 |              0.055 |              0.071 |            0.087 |           0.473 |                  0.063 |           0.032 |
|             20 | 2020-06-26              |                       121 |        8640 |  90464 |       3807 |        527 |              0.048 |              0.061 |            0.096 |           0.441 |                  0.057 |           0.028 |
|             21 | 2020-06-26              |                       121 |       12809 | 113830 |       5035 |        651 |              0.041 |              0.051 |            0.113 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-06-26              |                       121 |       17818 | 139130 |       6385 |        786 |              0.036 |              0.044 |            0.128 |           0.358 |                  0.044 |           0.021 |
|             23 | 2020-06-26              |                       121 |       23924 | 167266 |       7793 |        934 |              0.032 |              0.039 |            0.143 |           0.326 |                  0.040 |           0.018 |
|             24 | 2020-06-26              |                       121 |       33115 | 202028 |       9686 |       1061 |              0.026 |              0.032 |            0.164 |           0.292 |                  0.034 |           0.015 |
|             25 | 2020-06-26              |                       121 |       45286 | 242456 |      11574 |       1147 |              0.021 |              0.025 |            0.187 |           0.256 |                  0.028 |           0.012 |
|             26 | 2020-06-26              |                       121 |       55218 | 272981 |      12874 |       1184 |              0.015 |              0.021 |            0.202 |           0.233 |                  0.025 |           0.011 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [21:16:14.933] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [21:16:23.501] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [21:16:29.648] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [21:16:30.974] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [21:16:34.525] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [21:16:36.646] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [21:16:40.422] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [21:16:42.692] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [21:16:45.088] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [21:16:46.571] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [21:16:48.727] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [21:16:50.723] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [21:16:52.786] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [21:16:54.959] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [21:16:56.832] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [21:16:58.870] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [21:17:01.174] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [21:17:03.224] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [21:17:05.261] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [21:17:07.295] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [21:17:09.279] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [21:17:12.157] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [21:17:14.371] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [21:17:16.416] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [21:17:18.586] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       13410 |       2822 |        312 |              0.015 |              0.023 |            0.230 |           0.210 |                  0.026 |           0.011 |
| Buenos Aires                  | F    |       12658 |       2412 |        212 |              0.011 |              0.017 |            0.202 |           0.191 |                  0.018 |           0.006 |
| CABA                          | F    |       11764 |       3054 |        189 |              0.013 |              0.016 |            0.321 |           0.260 |                  0.016 |           0.006 |
| CABA                          | M    |       11541 |       3057 |        250 |              0.017 |              0.022 |            0.352 |           0.265 |                  0.030 |           0.015 |
| Chaco                         | M    |         927 |        125 |         60 |              0.041 |              0.065 |            0.171 |           0.135 |                  0.084 |           0.042 |
| Chaco                         | F    |         900 |        117 |         32 |              0.022 |              0.036 |            0.164 |           0.130 |                  0.059 |           0.019 |
| Río Negro                     | F    |         405 |        179 |         13 |              0.028 |              0.032 |            0.192 |           0.442 |                  0.020 |           0.010 |
| Río Negro                     | M    |         400 |        188 |         28 |              0.062 |              0.070 |            0.219 |           0.470 |                  0.048 |           0.032 |
| Córdoba                       | M    |         316 |         52 |         17 |              0.024 |              0.054 |            0.033 |           0.165 |                  0.051 |           0.025 |
| Córdoba                       | F    |         295 |         70 |         19 |              0.026 |              0.064 |            0.030 |           0.237 |                  0.047 |           0.014 |
| Neuquén                       | F    |         215 |        143 |          5 |              0.018 |              0.023 |            0.193 |           0.665 |                  0.014 |           0.014 |
| Santa Fe                      | M    |         206 |         40 |          3 |              0.008 |              0.015 |            0.033 |           0.194 |                  0.049 |           0.029 |
| Neuquén                       | M    |         200 |        133 |          6 |              0.021 |              0.030 |            0.169 |           0.665 |                  0.015 |           0.010 |
| Santa Fe                      | F    |         200 |         26 |          1 |              0.003 |              0.005 |            0.031 |           0.130 |                  0.020 |           0.005 |
| SIN ESPECIFICAR               | F    |         200 |         32 |          1 |              0.004 |              0.005 |            0.322 |           0.160 |                  0.015 |           0.000 |
| SIN ESPECIFICAR               | M    |         159 |         34 |          0 |              0.000 |              0.000 |            0.367 |           0.214 |                  0.006 |           0.006 |
| Entre Ríos                    | M    |         128 |         40 |          0 |              0.000 |              0.000 |            0.108 |           0.312 |                  0.000 |           0.000 |
| Entre Ríos                    | F    |         109 |         27 |          0 |              0.000 |              0.000 |            0.096 |           0.248 |                  0.000 |           0.000 |
| CABA                          | NR   |         107 |         33 |          7 |              0.034 |              0.065 |            0.330 |           0.308 |                  0.056 |           0.037 |
| Buenos Aires                  | NR   |         100 |         17 |          2 |              0.011 |              0.020 |            0.262 |           0.170 |                  0.020 |           0.000 |
| Mendoza                       | M    |          84 |         79 |          9 |              0.057 |              0.107 |            0.056 |           0.940 |                  0.107 |           0.048 |
| Tierra del Fuego              | M    |          77 |          4 |          1 |              0.012 |              0.013 |            0.089 |           0.052 |                  0.039 |           0.039 |
| Corrientes                    | M    |          71 |          1 |          0 |              0.000 |              0.000 |            0.037 |           0.014 |                  0.000 |           0.000 |
| Mendoza                       | F    |          69 |         63 |          0 |              0.000 |              0.000 |            0.051 |           0.913 |                  0.029 |           0.014 |
| Chubut                        | M    |          67 |          3 |          1 |              0.007 |              0.015 |            0.105 |           0.045 |                  0.015 |           0.015 |
| Formosa                       | M    |          62 |          0 |          0 |              0.000 |              0.000 |            0.135 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.077 |           0.052 |                  0.000 |           0.000 |
| Chubut                        | F    |          47 |          1 |          0 |              0.000 |              0.000 |            0.083 |           0.021 |                  0.000 |           0.000 |
| Tucumán                       | M    |          44 |          8 |          2 |              0.009 |              0.045 |            0.010 |           0.182 |                  0.068 |           0.000 |
| Corrientes                    | F    |          43 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.023 |           0.000 |
| La Rioja                      | F    |          40 |         10 |          6 |              0.083 |              0.150 |            0.048 |           0.250 |                  0.075 |           0.025 |
| Jujuy                         | F    |          38 |          0 |          0 |              0.000 |              0.000 |            0.046 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | M    |          36 |          2 |          1 |              0.009 |              0.028 |            0.022 |           0.056 |                  0.028 |           0.028 |
| La Rioja                      | M    |          35 |          4 |          2 |              0.028 |              0.057 |            0.039 |           0.114 |                  0.029 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.090 |           0.387 |                  0.097 |           0.032 |
| Tucumán                       | F    |          26 |          8 |          2 |              0.012 |              0.077 |            0.009 |           0.308 |                  0.231 |           0.077 |
| Misiones                      | M    |          22 |         16 |          1 |              0.029 |              0.045 |            0.028 |           0.727 |                  0.182 |           0.091 |
| Misiones                      | F    |          19 |         13 |          1 |              0.033 |              0.053 |            0.029 |           0.684 |                  0.105 |           0.053 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.074 |           0.474 |                  0.053 |           0.053 |
| Santiago del Estero           | M    |          16 |          1 |          0 |              0.000 |              0.000 |            0.009 |           0.062 |                  0.062 |           0.000 |
| Salta                         | M    |          15 |         13 |          0 |              0.000 |              0.000 |            0.023 |           0.867 |                  0.000 |           0.000 |

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
