
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
#> INFO  [20:50:03.909] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [20:50:06.581] Normalize 
#> INFO  [20:50:06.975] checkSoundness 
#> INFO  [20:50:07.231] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-25"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-25"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-25"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-25              |       52409 |       1150 |              0.015 |              0.022 |                       120 | 264729 |            0.198 |

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
| Buenos Aires                  |       24545 |        506 |              0.013 |              0.021 |                       119 | 116981 |            0.210 |
| CABA                          |       22475 |        434 |              0.015 |              0.019 |                       118 |  67607 |            0.332 |
| Chaco                         |        1754 |         90 |              0.031 |              0.051 |                       106 |  10596 |            0.166 |
| Río Negro                     |         792 |         41 |              0.046 |              0.052 |                       101 |   3826 |            0.207 |
| Córdoba                       |         607 |         36 |              0.025 |              0.059 |                       108 |  19082 |            0.032 |
| Santa Fe                      |         394 |          4 |              0.006 |              0.010 |                       104 |  12460 |            0.032 |
| Neuquén                       |         384 |         11 |              0.022 |              0.029 |                       103 |   2252 |            0.171 |
| SIN ESPECIFICAR               |         339 |          2 |              0.005 |              0.006 |                        96 |   1024 |            0.331 |
| Entre Ríos                    |         219 |          0 |              0.000 |              0.000 |                       101 |   2233 |            0.098 |
| Mendoza                       |         150 |          9 |              0.029 |              0.060 |                       107 |   2792 |            0.054 |
| Tierra del Fuego              |         136 |          1 |              0.006 |              0.007 |                        99 |   1610 |            0.084 |
| Corrientes                    |         114 |          0 |              0.000 |              0.000 |                        99 |   3373 |            0.034 |
| Chubut                        |         102 |          1 |              0.004 |              0.010 |                        87 |   1147 |            0.089 |

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
| Buenos Aires                  |       24545 | 116981 |        506 |               12.2 |              0.013 |              0.021 |            0.210 |           0.205 |                  0.022 |           0.009 |
| CABA                          |       22475 |  67607 |        434 |               14.4 |              0.015 |              0.019 |            0.332 |           0.265 |                  0.023 |           0.011 |
| Chaco                         |        1754 |  10596 |         90 |               14.0 |              0.031 |              0.051 |            0.166 |           0.134 |                  0.052 |           0.030 |
| Río Negro                     |         792 |   3826 |         41 |               12.7 |              0.046 |              0.052 |            0.207 |           0.461 |                  0.034 |           0.021 |
| Córdoba                       |         607 |  19082 |         36 |               24.9 |              0.025 |              0.059 |            0.032 |           0.203 |                  0.049 |           0.020 |
| Santa Fe                      |         394 |  12460 |          4 |               25.5 |              0.006 |              0.010 |            0.032 |           0.168 |                  0.036 |           0.018 |
| Neuquén                       |         384 |   2252 |         11 |               18.3 |              0.022 |              0.029 |            0.171 |           0.716 |                  0.016 |           0.013 |
| SIN ESPECIFICAR               |         339 |   1024 |          2 |                9.5 |              0.005 |              0.006 |            0.331 |           0.195 |                  0.018 |           0.009 |
| Entre Ríos                    |         219 |   2233 |          0 |                NaN |              0.000 |              0.000 |            0.098 |           0.292 |                  0.000 |           0.000 |
| Mendoza                       |         150 |   2792 |          9 |               13.3 |              0.029 |              0.060 |            0.054 |           0.927 |                  0.073 |           0.033 |
| Tierra del Fuego              |         136 |   1610 |          1 |               24.0 |              0.006 |              0.007 |            0.084 |           0.051 |                  0.022 |           0.022 |
| Corrientes                    |         114 |   3373 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.009 |                  0.009 |           0.000 |
| Chubut                        |         102 |   1147 |          1 |               19.0 |              0.004 |              0.010 |            0.089 |           0.039 |                  0.010 |           0.010 |
| La Rioja                      |          74 |   1613 |          8 |               12.0 |              0.048 |              0.108 |            0.046 |           0.189 |                  0.054 |           0.014 |
| Tucumán                       |          69 |   7209 |          4 |               14.2 |              0.010 |              0.058 |            0.010 |           0.203 |                  0.130 |           0.029 |
| Santa Cruz                    |          52 |    602 |          0 |                NaN |              0.000 |              0.000 |            0.086 |           0.423 |                  0.077 |           0.038 |
| Jujuy                         |          46 |   2484 |          1 |               22.0 |              0.006 |              0.022 |            0.019 |           0.043 |                  0.022 |           0.022 |
| Formosa                       |          45 |    744 |          0 |                NaN |              0.000 |              0.000 |            0.060 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          39 |   1430 |          2 |                6.5 |              0.034 |              0.051 |            0.027 |           0.744 |                  0.154 |           0.077 |
| Salta                         |          24 |    915 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.792 |                  0.000 |           0.000 |
| Santiago del Estero           |          23 |   2515 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.043 |                  0.043 |           0.000 |
| San Luis                      |          11 |    496 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.727 |                  0.091 |           0.000 |
| San Juan                      |           8 |    770 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.625 |                  0.125 |           0.000 |
| La Pampa                      |           7 |    377 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.143 |                  0.000 |           0.000 |

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
#> INFO  [20:50:54.651] Processing {current.group: }
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
|             14 | 2020-06-24              |                        97 |        1734 |  11521 |        953 |        110 |              0.051 |              0.063 |            0.151 |           0.550 |                  0.096 |           0.056 |
|             15 | 2020-06-25              |                       114 |        2367 |  20225 |       1282 |        170 |              0.056 |              0.072 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 | 2020-06-25              |                       118 |        3109 |  31797 |       1612 |        224 |              0.055 |              0.072 |            0.098 |           0.518 |                  0.082 |           0.044 |
|             17 | 2020-06-25              |                       120 |        4131 |  45830 |       2098 |        324 |              0.060 |              0.078 |            0.090 |           0.508 |                  0.075 |           0.039 |
|             18 | 2020-06-25              |                       120 |        5035 |  59006 |       2473 |        386 |              0.059 |              0.077 |            0.085 |           0.491 |                  0.069 |           0.036 |
|             19 | 2020-06-25              |                       120 |        6372 |  73123 |       3012 |        454 |              0.056 |              0.071 |            0.087 |           0.473 |                  0.063 |           0.032 |
|             20 | 2020-06-25              |                       120 |        8623 |  90462 |       3800 |        527 |              0.048 |              0.061 |            0.095 |           0.441 |                  0.056 |           0.028 |
|             21 | 2020-06-25              |                       120 |       12782 | 113827 |       5024 |        649 |              0.041 |              0.051 |            0.112 |           0.393 |                  0.049 |           0.024 |
|             22 | 2020-06-25              |                       120 |       17784 | 139122 |       6369 |        783 |              0.036 |              0.044 |            0.128 |           0.358 |                  0.043 |           0.021 |
|             23 | 2020-06-25              |                       120 |       23871 | 167246 |       7754 |        928 |              0.032 |              0.039 |            0.143 |           0.325 |                  0.039 |           0.018 |
|             24 | 2020-06-25              |                       120 |       33040 | 201974 |       9617 |       1051 |              0.026 |              0.032 |            0.164 |           0.291 |                  0.033 |           0.015 |
|             25 | 2020-06-25              |                       120 |       45150 | 242235 |      11469 |       1122 |              0.020 |              0.025 |            0.186 |           0.254 |                  0.027 |           0.012 |
|             26 | 2020-06-25              |                       120 |       52409 | 264729 |      12454 |       1150 |              0.015 |              0.022 |            0.198 |           0.238 |                  0.024 |           0.011 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [20:51:14.456] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [20:51:23.372] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [20:51:28.946] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [20:51:30.000] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [20:51:33.181] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [20:51:35.008] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [20:51:39.892] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [20:51:42.218] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [20:51:44.423] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [20:51:45.825] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [20:51:48.022] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [20:51:50.007] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [20:51:52.038] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [20:51:54.224] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [20:51:56.112] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [20:51:58.141] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [20:52:00.462] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [20:52:02.364] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [20:52:04.160] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [20:52:06.059] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [20:52:08.285] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [20:52:11.016] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [20:52:12.946] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [20:52:14.872] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [20:52:17.044] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       12571 |       2697 |        298 |              0.015 |              0.024 |            0.224 |           0.215 |                  0.026 |           0.011 |
| Buenos Aires                  | F    |       11880 |       2321 |        206 |              0.011 |              0.017 |            0.196 |           0.195 |                  0.018 |           0.006 |
| CABA                          | F    |       11311 |       2964 |        185 |              0.013 |              0.016 |            0.318 |           0.262 |                  0.016 |           0.006 |
| CABA                          | M    |       11059 |       2963 |        242 |              0.017 |              0.022 |            0.348 |           0.268 |                  0.030 |           0.015 |
| Chaco                         | M    |         888 |        120 |         59 |              0.040 |              0.066 |            0.169 |           0.135 |                  0.062 |           0.042 |
| Chaco                         | F    |         864 |        115 |         31 |              0.022 |              0.036 |            0.162 |           0.133 |                  0.043 |           0.019 |
| Río Negro                     | F    |         399 |        179 |         13 |              0.029 |              0.033 |            0.195 |           0.449 |                  0.020 |           0.010 |
| Río Negro                     | M    |         393 |        186 |         28 |              0.062 |              0.071 |            0.222 |           0.473 |                  0.048 |           0.033 |
| Córdoba                       | M    |         312 |         52 |         17 |              0.024 |              0.054 |            0.033 |           0.167 |                  0.051 |           0.026 |
| Córdoba                       | F    |         293 |         70 |         19 |              0.026 |              0.065 |            0.030 |           0.239 |                  0.048 |           0.014 |
| Santa Fe                      | M    |         203 |         40 |          3 |              0.009 |              0.015 |            0.033 |           0.197 |                  0.049 |           0.030 |
| Neuquén                       | F    |         197 |        143 |          5 |              0.020 |              0.025 |            0.181 |           0.726 |                  0.015 |           0.015 |
| Santa Fe                      | F    |         191 |         26 |          1 |              0.003 |              0.005 |            0.030 |           0.136 |                  0.021 |           0.005 |
| Neuquén                       | M    |         187 |        132 |          6 |              0.024 |              0.032 |            0.161 |           0.706 |                  0.016 |           0.011 |
| SIN ESPECIFICAR               | F    |         186 |         30 |          0 |              0.000 |              0.000 |            0.313 |           0.161 |                  0.016 |           0.000 |
| SIN ESPECIFICAR               | M    |         151 |         35 |          1 |              0.005 |              0.007 |            0.361 |           0.232 |                  0.013 |           0.013 |
| Entre Ríos                    | M    |         118 |         38 |          0 |              0.000 |              0.000 |            0.104 |           0.322 |                  0.000 |           0.000 |
| CABA                          | NR   |         105 |         33 |          7 |              0.036 |              0.067 |            0.333 |           0.314 |                  0.057 |           0.038 |
| Entre Ríos                    | F    |         100 |         26 |          0 |              0.000 |              0.000 |            0.091 |           0.260 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |          94 |         16 |          2 |              0.011 |              0.021 |            0.263 |           0.170 |                  0.021 |           0.000 |
| Mendoza                       | M    |          82 |         77 |          9 |              0.059 |              0.110 |            0.056 |           0.939 |                  0.110 |           0.049 |
| Tierra del Fuego              | M    |          77 |          4 |          1 |              0.012 |              0.013 |            0.090 |           0.052 |                  0.039 |           0.039 |
| Corrientes                    | M    |          71 |          1 |          0 |              0.000 |              0.000 |            0.037 |           0.014 |                  0.000 |           0.000 |
| Mendoza                       | F    |          68 |         62 |          0 |              0.000 |              0.000 |            0.052 |           0.912 |                  0.029 |           0.015 |
| Chubut                        | M    |          60 |          3 |          1 |              0.008 |              0.017 |            0.099 |           0.050 |                  0.017 |           0.017 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.078 |           0.052 |                  0.000 |           0.000 |
| Corrientes                    | F    |          43 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.023 |           0.000 |
| Formosa                       | M    |          43 |          0 |          0 |              0.000 |              0.000 |            0.096 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | M    |          43 |          7 |          2 |              0.008 |              0.047 |            0.010 |           0.163 |                  0.070 |           0.000 |
| Chubut                        | F    |          41 |          1 |          0 |              0.000 |              0.000 |            0.077 |           0.024 |                  0.000 |           0.000 |
| La Rioja                      | F    |          39 |         10 |          6 |              0.069 |              0.154 |            0.049 |           0.256 |                  0.077 |           0.026 |
| La Rioja                      | M    |          35 |          4 |          2 |              0.026 |              0.057 |            0.043 |           0.114 |                  0.029 |           0.000 |
| Santa Cruz                    | M    |          33 |         13 |          0 |              0.000 |              0.000 |            0.095 |           0.394 |                  0.091 |           0.030 |
| Tucumán                       | F    |          26 |          7 |          2 |              0.014 |              0.077 |            0.010 |           0.269 |                  0.231 |           0.077 |
| Jujuy                         | F    |          25 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | M    |          21 |          2 |          1 |              0.011 |              0.048 |            0.013 |           0.095 |                  0.048 |           0.048 |
| Misiones                      | M    |          21 |         16 |          1 |              0.031 |              0.048 |            0.027 |           0.762 |                  0.190 |           0.095 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.074 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.037 |              0.056 |            0.027 |           0.722 |                  0.111 |           0.056 |
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
