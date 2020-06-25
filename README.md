
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
#> INFO  [21:28:38.588] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [21:28:40.856] Normalize 
#> INFO  [21:28:41.199] checkSoundness 
#> INFO  [21:28:41.436] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-24"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-24"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-24"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-24              |       49832 |       1116 |              0.015 |              0.022 |                       119 | 257146 |            0.194 |

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
| Buenos Aires                  |       23093 |        491 |              0.013 |              0.021 |                       118 | 113133 |            0.204 |
| CABA                          |       21549 |        419 |              0.015 |              0.019 |                       117 |  65509 |            0.329 |
| Chaco                         |        1693 |         88 |              0.031 |              0.052 |                       105 |  10328 |            0.164 |
| Río Negro                     |         742 |         41 |              0.048 |              0.055 |                       100 |   3705 |            0.200 |
| Córdoba                       |         601 |         36 |              0.027 |              0.060 |                       107 |  18845 |            0.032 |
| Santa Fe                      |         373 |          4 |              0.006 |              0.011 |                       103 |  12230 |            0.030 |
| Neuquén                       |         364 |          9 |              0.020 |              0.025 |                       102 |   2216 |            0.164 |
| SIN ESPECIFICAR               |         325 |          2 |              0.005 |              0.006 |                        95 |    989 |            0.329 |
| Entre Ríos                    |         202 |          0 |              0.000 |              0.000 |                       100 |   2133 |            0.095 |
| Mendoza                       |         149 |          9 |              0.030 |              0.060 |                       106 |   2738 |            0.054 |
| Tierra del Fuego              |         136 |          1 |              0.006 |              0.007 |                        98 |   1606 |            0.085 |
| Corrientes                    |         114 |          0 |              0.000 |              0.000 |                        98 |   3344 |            0.034 |
| Chubut                        |         101 |          1 |              0.004 |              0.010 |                        86 |   1067 |            0.095 |

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
| Buenos Aires                  |       23093 | 113133 |        491 |               12.4 |              0.013 |              0.021 |            0.204 |           0.210 |                  0.023 |           0.009 |
| CABA                          |       21549 |  65509 |        419 |               14.4 |              0.015 |              0.019 |            0.329 |           0.268 |                  0.023 |           0.011 |
| Chaco                         |        1693 |  10328 |         88 |               14.1 |              0.031 |              0.052 |            0.164 |           0.137 |                  0.054 |           0.031 |
| Río Negro                     |         742 |   3705 |         41 |               12.7 |              0.048 |              0.055 |            0.200 |           0.492 |                  0.036 |           0.023 |
| Córdoba                       |         601 |  18845 |         36 |               24.9 |              0.027 |              0.060 |            0.032 |           0.205 |                  0.050 |           0.020 |
| Santa Fe                      |         373 |  12230 |          4 |               25.5 |              0.006 |              0.011 |            0.030 |           0.174 |                  0.038 |           0.019 |
| Neuquén                       |         364 |   2216 |          9 |               20.9 |              0.020 |              0.025 |            0.164 |           0.750 |                  0.016 |           0.014 |
| SIN ESPECIFICAR               |         325 |    989 |          2 |                9.5 |              0.005 |              0.006 |            0.329 |           0.200 |                  0.018 |           0.009 |
| Entre Ríos                    |         202 |   2133 |          0 |                NaN |              0.000 |              0.000 |            0.095 |           0.302 |                  0.000 |           0.000 |
| Mendoza                       |         149 |   2738 |          9 |               13.3 |              0.030 |              0.060 |            0.054 |           0.919 |                  0.074 |           0.034 |
| Tierra del Fuego              |         136 |   1606 |          1 |               24.0 |              0.006 |              0.007 |            0.085 |           0.051 |                  0.022 |           0.022 |
| Corrientes                    |         114 |   3344 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.009 |                  0.009 |           0.000 |
| Chubut                        |         101 |   1067 |          1 |               19.0 |              0.004 |              0.010 |            0.095 |           0.040 |                  0.010 |           0.010 |
| La Rioja                      |          72 |   1564 |          8 |               12.0 |              0.052 |              0.111 |            0.046 |           0.194 |                  0.056 |           0.014 |
| Tucumán                       |          68 |   7049 |          4 |               14.2 |              0.009 |              0.059 |            0.010 |           0.191 |                  0.118 |           0.029 |
| Santa Cruz                    |          50 |    586 |          0 |                NaN |              0.000 |              0.000 |            0.085 |           0.420 |                  0.080 |           0.040 |
| Formosa                       |          45 |    743 |          0 |                NaN |              0.000 |              0.000 |            0.061 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         |          44 |   2452 |          1 |               22.0 |              0.006 |              0.023 |            0.018 |           0.045 |                  0.023 |           0.023 |
| Misiones                      |          38 |   1336 |          2 |                6.5 |              0.033 |              0.053 |            0.028 |           0.737 |                  0.132 |           0.079 |
| Salta                         |          24 |    901 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.792 |                  0.000 |           0.000 |
| Santiago del Estero           |          23 |   2475 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.043 |                  0.043 |           0.000 |
| San Luis                      |          11 |    491 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.727 |                  0.091 |           0.000 |
| San Juan                      |           8 |    764 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.625 |                  0.125 |           0.000 |
| La Pampa                      |           7 |    362 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.143 |                  0.000 |           0.000 |

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
#> INFO  [21:29:28.088] Processing {current.group: }
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
|             14 | 2020-06-22              |                        96 |        1733 |  11521 |        953 |        110 |              0.051 |              0.063 |            0.150 |           0.550 |                  0.096 |           0.056 |
|             15 | 2020-06-23              |                       112 |        2365 |  20224 |       1281 |        170 |              0.056 |              0.072 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 | 2020-06-24              |                       117 |        3104 |  31792 |       1609 |        224 |              0.055 |              0.072 |            0.098 |           0.518 |                  0.082 |           0.044 |
|             17 | 2020-06-24              |                       119 |        4124 |  45823 |       2094 |        324 |              0.060 |              0.079 |            0.090 |           0.508 |                  0.075 |           0.039 |
|             18 | 2020-06-24              |                       119 |        5025 |  58998 |       2468 |        386 |              0.059 |              0.077 |            0.085 |           0.491 |                  0.069 |           0.036 |
|             19 | 2020-06-24              |                       119 |        6361 |  73115 |       3007 |        454 |              0.056 |              0.071 |            0.087 |           0.473 |                  0.063 |           0.032 |
|             20 | 2020-06-24              |                       119 |        8608 |  90453 |       3793 |        527 |              0.048 |              0.061 |            0.095 |           0.441 |                  0.056 |           0.028 |
|             21 | 2020-06-24              |                       119 |       12766 | 113818 |       5016 |        648 |              0.041 |              0.051 |            0.112 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-06-24              |                       119 |       17763 | 139112 |       6353 |        782 |              0.036 |              0.044 |            0.128 |           0.358 |                  0.043 |           0.021 |
|             23 | 2020-06-24              |                       119 |       23842 | 167222 |       7729 |        925 |              0.032 |              0.039 |            0.143 |           0.324 |                  0.039 |           0.018 |
|             24 | 2020-06-24              |                       119 |       32984 | 201908 |       9567 |       1039 |              0.026 |              0.032 |            0.163 |           0.290 |                  0.032 |           0.015 |
|             25 | 2020-06-24              |                       119 |       44888 | 241630 |      11387 |       1103 |              0.020 |              0.025 |            0.186 |           0.254 |                  0.027 |           0.012 |
|             26 | 2020-06-24              |                       119 |       49832 | 257146 |      12055 |       1116 |              0.015 |              0.022 |            0.194 |           0.242 |                  0.025 |           0.011 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [21:29:44.919] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [21:29:53.020] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [21:29:58.505] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [21:29:59.524] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [21:30:02.182] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [21:30:04.134] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [21:30:07.572] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [21:30:09.939] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [21:30:12.238] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [21:30:13.726] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [21:30:16.696] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [21:30:19.007] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [21:30:21.223] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [21:30:23.820] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [21:30:26.029] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [21:30:28.286] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [21:30:30.484] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [21:30:32.526] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [21:30:34.416] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [21:30:36.336] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [21:30:38.752] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [21:30:41.912] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [21:30:44.042] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [21:30:46.214] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [21:30:48.517] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
#> [1] 56
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| Buenos Aires                  | M    |       11833 |       2593 |        291 |              0.016 |              0.025 |            0.218 |           0.219 |                  0.027 |           0.011 |
| Buenos Aires                  | F    |       11171 |       2229 |        199 |              0.011 |              0.018 |            0.191 |           0.200 |                  0.019 |           0.007 |
| CABA                          | F    |       10841 |       2868 |        179 |              0.013 |              0.017 |            0.315 |           0.265 |                  0.016 |           0.006 |
| CABA                          | M    |       10607 |       2873 |        233 |              0.017 |              0.022 |            0.344 |           0.271 |                  0.030 |           0.015 |
| Chaco                         | M    |         859 |        117 |         57 |              0.040 |              0.066 |            0.168 |           0.136 |                  0.063 |           0.042 |
| Chaco                         | F    |         832 |        115 |         31 |              0.022 |              0.037 |            0.160 |           0.138 |                  0.044 |           0.019 |
| Río Negro                     | F    |         373 |        179 |         13 |              0.030 |              0.035 |            0.188 |           0.480 |                  0.021 |           0.011 |
| Río Negro                     | M    |         369 |        186 |         28 |              0.065 |              0.076 |            0.215 |           0.504 |                  0.051 |           0.035 |
| Córdoba                       | M    |         309 |         52 |         17 |              0.025 |              0.055 |            0.033 |           0.168 |                  0.052 |           0.026 |
| Córdoba                       | F    |         290 |         70 |         19 |              0.029 |              0.066 |            0.030 |           0.241 |                  0.048 |           0.014 |
| Santa Fe                      | M    |         192 |         39 |          3 |              0.009 |              0.016 |            0.032 |           0.203 |                  0.052 |           0.031 |
| Neuquén                       | F    |         184 |        142 |          5 |              0.022 |              0.027 |            0.172 |           0.772 |                  0.016 |           0.016 |
| Santa Fe                      | F    |         181 |         26 |          1 |              0.003 |              0.006 |            0.029 |           0.144 |                  0.022 |           0.006 |
| Neuquén                       | M    |         180 |        131 |          4 |              0.017 |              0.022 |            0.157 |           0.728 |                  0.017 |           0.011 |
| SIN ESPECIFICAR               | F    |         178 |         29 |          0 |              0.000 |              0.000 |            0.307 |           0.163 |                  0.017 |           0.000 |
| SIN ESPECIFICAR               | M    |         145 |         35 |          1 |              0.005 |              0.007 |            0.363 |           0.241 |                  0.014 |           0.014 |
| Entre Ríos                    | M    |         112 |         36 |          0 |              0.000 |              0.000 |            0.103 |           0.321 |                  0.000 |           0.000 |
| CABA                          | NR   |         101 |         31 |          7 |              0.037 |              0.069 |            0.328 |           0.307 |                  0.059 |           0.040 |
| Buenos Aires                  | NR   |          89 |         16 |          1 |              0.006 |              0.011 |            0.263 |           0.180 |                  0.022 |           0.000 |
| Entre Ríos                    | F    |          89 |         25 |          0 |              0.000 |              0.000 |            0.086 |           0.281 |                  0.000 |           0.000 |
| Mendoza                       | M    |          82 |         76 |          9 |              0.060 |              0.110 |            0.057 |           0.927 |                  0.110 |           0.049 |
| Tierra del Fuego              | M    |          77 |          4 |          1 |              0.011 |              0.013 |            0.090 |           0.052 |                  0.039 |           0.039 |
| Corrientes                    | M    |          71 |          1 |          0 |              0.000 |              0.000 |            0.038 |           0.014 |                  0.000 |           0.000 |
| Mendoza                       | F    |          67 |         61 |          0 |              0.000 |              0.000 |            0.052 |           0.910 |                  0.030 |           0.015 |
| Chubut                        | M    |          60 |          3 |          1 |              0.008 |              0.017 |            0.103 |           0.050 |                  0.017 |           0.017 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.078 |           0.052 |                  0.000 |           0.000 |
| Corrientes                    | F    |          43 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.023 |           0.000 |
| Formosa                       | M    |          43 |          0 |          0 |              0.000 |              0.000 |            0.097 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | M    |          43 |          7 |          2 |              0.008 |              0.047 |            0.010 |           0.163 |                  0.070 |           0.000 |
| Chubut                        | F    |          40 |          1 |          0 |              0.000 |              0.000 |            0.084 |           0.025 |                  0.000 |           0.000 |
| La Rioja                      | F    |          39 |         10 |          6 |              0.073 |              0.154 |            0.051 |           0.256 |                  0.077 |           0.026 |
| La Rioja                      | M    |          33 |          4 |          2 |              0.029 |              0.061 |            0.042 |           0.121 |                  0.030 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.092 |           0.387 |                  0.097 |           0.032 |
| Tucumán                       | F    |          25 |          6 |          2 |              0.012 |              0.080 |            0.009 |           0.240 |                  0.200 |           0.080 |
| Jujuy                         | F    |          23 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | M    |          21 |          2 |          1 |              0.013 |              0.048 |            0.013 |           0.095 |                  0.048 |           0.048 |
| Misiones                      | M    |          20 |         15 |          1 |              0.032 |              0.050 |            0.027 |           0.750 |                  0.150 |           0.100 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.076 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.033 |              0.056 |            0.030 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          16 |          1 |          0 |              0.000 |              0.000 |            0.009 |           0.062 |                  0.062 |           0.000 |
| Salta                         | M    |          15 |         12 |          0 |              0.000 |              0.000 |            0.024 |           0.800 |                  0.000 |           0.000 |

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
