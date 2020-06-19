
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
#> INFO  [22:25:28.101] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [22:25:30.112] Normalize 
#> INFO  [22:25:30.512] checkSoundness 
#> INFO  [22:25:30.644] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-18"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-18"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-18"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-18              |       37506 |        948 |              0.017 |              0.025 |                       113 | 217978 |            0.172 |

``` r

covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% 
  filter(confirmados >= 100) %>%
  arrange(desc(confirmados))
# Provinces with > 100 confirmed cases
kable(covid19.ar.provincia.summary.100.confirmed %>% select(residencia_provincia_nombre, confirmados, fallecidos, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| residencia\_provincia\_nombre | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico | tests | positividad.porc |
| :---------------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | ----: | ---------------: |
| CABA                          |       16783 |        347 |              0.016 |              0.021 |                       111 | 54085 |            0.310 |
| Buenos Aires                  |       16409 |        417 |              0.016 |              0.025 |                       112 | 93351 |            0.176 |
| Chaco                         |        1475 |         79 |              0.033 |              0.054 |                        99 |  8998 |            0.164 |
| Río Negro                     |         622 |         32 |              0.044 |              0.051 |                        94 |  3179 |            0.196 |
| Córdoba                       |         513 |         35 |              0.026 |              0.068 |                       101 | 16921 |            0.030 |
| Santa Fe                      |         301 |          4 |              0.007 |              0.013 |                        97 | 11278 |            0.027 |
| Neuquén                       |         267 |          7 |              0.020 |              0.026 |                        96 |  1930 |            0.138 |
| SIN ESPECIFICAR               |         246 |          2 |              0.006 |              0.008 |                        89 |   819 |            0.300 |
| Tierra del Fuego              |         136 |          0 |              0.000 |              0.000 |                        93 |  1575 |            0.086 |
| Mendoza                       |         119 |          9 |              0.037 |              0.076 |                       100 |  2402 |            0.050 |
| Entre Ríos                    |         111 |          0 |              0.000 |              0.000 |                        94 |  1807 |            0.061 |
| Corrientes                    |         108 |          0 |              0.000 |              0.000 |                        91 |  3106 |            0.035 |

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
| CABA                          |       16783 | 54085 |        347 |               13.5 |              0.016 |              0.021 |            0.310 |           0.286 |                  0.025 |           0.012 |
| Buenos Aires                  |       16409 | 93351 |        417 |               12.3 |              0.016 |              0.025 |            0.176 |           0.242 |                  0.027 |           0.011 |
| Chaco                         |        1475 |  8998 |         79 |               14.3 |              0.033 |              0.054 |            0.164 |           0.147 |                  0.059 |           0.034 |
| Río Negro                     |         622 |  3179 |         32 |               13.7 |              0.044 |              0.051 |            0.196 |           0.539 |                  0.035 |           0.018 |
| Córdoba                       |         513 | 16921 |         35 |               23.1 |              0.026 |              0.068 |            0.030 |           0.238 |                  0.058 |           0.023 |
| Santa Fe                      |         301 | 11278 |          4 |               25.5 |              0.007 |              0.013 |            0.027 |           0.186 |                  0.043 |           0.020 |
| Neuquén                       |         267 |  1930 |          7 |                9.4 |              0.020 |              0.026 |            0.138 |           0.824 |                  0.022 |           0.019 |
| SIN ESPECIFICAR               |         246 |   819 |          2 |                9.5 |              0.006 |              0.008 |            0.300 |           0.232 |                  0.020 |           0.012 |
| Tierra del Fuego              |         136 |  1575 |          0 |                NaN |              0.000 |              0.000 |            0.086 |           0.051 |                  0.015 |           0.015 |
| Mendoza                       |         119 |  2402 |          9 |               13.3 |              0.037 |              0.076 |            0.050 |           0.941 |                  0.092 |           0.042 |
| Entre Ríos                    |         111 |  1807 |          0 |                NaN |              0.000 |              0.000 |            0.061 |           0.252 |                  0.000 |           0.000 |
| Corrientes                    |         108 |  3106 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.019 |                  0.009 |           0.000 |
| Chubut                        |          80 |   784 |          1 |               19.0 |              0.007 |              0.013 |            0.102 |           0.038 |                  0.013 |           0.013 |
| La Rioja                      |          64 |  1481 |          8 |               12.0 |              0.075 |              0.125 |            0.043 |           0.172 |                  0.062 |           0.016 |
| Tucumán                       |          57 |  6262 |          4 |               14.2 |              0.009 |              0.070 |            0.009 |           0.228 |                  0.140 |           0.035 |
| Santa Cruz                    |          52 |   559 |          0 |                NaN |              0.000 |              0.000 |            0.093 |           0.423 |                  0.077 |           0.038 |
| Formosa                       |          46 |   745 |          0 |                NaN |              0.000 |              0.000 |            0.062 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          39 |  1260 |          2 |                6.5 |              0.033 |              0.051 |            0.031 |           0.718 |                  0.128 |           0.077 |
| Santiago del Estero           |          23 |  2283 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.043 |                  0.043 |           0.000 |
| Salta                         |          20 |   800 |          0 |                NaN |              0.000 |              0.000 |            0.025 |           0.750 |                  0.000 |           0.000 |
| Jujuy                         |          11 |  2357 |          1 |               22.0 |              0.008 |              0.091 |            0.005 |           0.182 |                  0.091 |           0.091 |
| San Luis                      |          11 |   441 |          0 |                NaN |              0.000 |              0.000 |            0.025 |           0.727 |                  0.091 |           0.000 |
| San Juan                      |           7 |   720 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.714 |                  0.143 |           0.000 |
| La Pampa                      |           6 |   311 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.167 |                  0.000 |           0.000 |

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
#>   max_fecha_inicio_sintomas = col_date(format = "")
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
#> INFO  [22:26:01.619] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 21
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% 
        filter(confirmados > 0) %>% 
        arrange(sepi_apertura, desc(confirmados)) %>% 
        select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))
```

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| -------------: | :---------------------- | ------------------------: | ----------: | -----: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-06-18              |                        35 |          93 |    666 |         64 |          8 |              0.059 |              0.086 |            0.140 |           0.688 |                  0.129 |           0.065 |
|             12 | 2020-06-18              |                        54 |         407 |   2048 |        252 |         16 |              0.031 |              0.039 |            0.199 |           0.619 |                  0.093 |           0.054 |
|             13 | 2020-06-18              |                        75 |        1069 |   5509 |        593 |         60 |              0.046 |              0.056 |            0.194 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-06-18              |                        93 |        1730 |  11519 |        952 |        109 |              0.051 |              0.063 |            0.150 |           0.550 |                  0.096 |           0.056 |
|             15 | 2020-06-18              |                       107 |        2359 |  20221 |       1278 |        168 |              0.056 |              0.071 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 | 2020-06-18              |                       111 |        3090 |  31784 |       1602 |        221 |              0.054 |              0.072 |            0.097 |           0.518 |                  0.083 |           0.044 |
|             17 | 2020-06-18              |                       113 |        4101 |  45810 |       2086 |        318 |              0.059 |              0.078 |            0.090 |           0.509 |                  0.076 |           0.039 |
|             18 | 2020-06-18              |                       113 |        4995 |  58983 |       2460 |        378 |              0.058 |              0.076 |            0.085 |           0.492 |                  0.069 |           0.036 |
|             19 | 2020-06-18              |                       113 |        6324 |  73100 |       2996 |        443 |              0.054 |              0.070 |            0.087 |           0.474 |                  0.063 |           0.032 |
|             20 | 2020-06-18              |                       113 |        8556 |  90408 |       3771 |        511 |              0.047 |              0.060 |            0.095 |           0.441 |                  0.056 |           0.028 |
|             21 | 2020-06-18              |                       113 |       12693 | 113756 |       4985 |        628 |              0.039 |              0.049 |            0.112 |           0.393 |                  0.048 |           0.024 |
|             22 | 2020-06-18              |                       113 |       17661 | 139029 |       6297 |        749 |              0.034 |              0.042 |            0.127 |           0.357 |                  0.042 |           0.021 |
|             23 | 2020-06-18              |                       113 |       23668 | 167046 |       7604 |        859 |              0.029 |              0.036 |            0.142 |           0.321 |                  0.038 |           0.018 |
|             24 | 2020-06-18              |                       113 |       32584 | 201052 |       9328 |        932 |              0.023 |              0.029 |            0.162 |           0.286 |                  0.031 |           0.014 |
|             25 | 2020-06-18              |                       113 |       37506 | 217978 |      10034 |        948 |              0.017 |              0.025 |            0.172 |           0.268 |                  0.028 |           0.013 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [22:26:05.797] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> Warning in max.default(structure(c(NA_real_, NA_real_), class = "Date"), : no
#> non-missing arguments to max; returning -Inf
#> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_), class =
#> "Date"), : no non-missing arguments to max; returning -Inf
#> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_: no
#> non-missing arguments to max; returning -Inf
#> INFO  [22:26:08.441] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [22:26:10.609] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [22:26:11.889] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [22:26:13.328] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [22:26:14.629] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> Warning in max.default(structure(NA_real_, class = "Date"), na.rm = TRUE): no
#> non-missing arguments to max; returning -Inf
#> INFO  [22:26:16.349] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [22:26:17.780] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [22:26:19.154] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [22:26:20.609] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [22:26:21.914] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [22:26:23.225] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [22:26:24.623] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [22:26:26.120] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [22:26:27.366] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [22:26:28.687] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [22:26:30.110] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [22:26:31.402] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [22:26:32.723] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [22:26:34.042] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [22:26:35.357] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> Warning in max.default(structure(NA_real_, class = "Date"), na.rm = TRUE): no
#> non-missing arguments to max; returning -Inf
#> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_, : no
#> non-missing arguments to max; returning -Inf
#> INFO  [22:26:36.924] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [22:26:38.231] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> Warning in max.default(structure(c(NA_real_, NA_real_), class = "Date"), : no
#> non-missing arguments to max; returning -Inf
#> INFO  [22:26:39.690] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [22:26:41.166] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 401
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
#> Warning in max.default(structure(NA_real_, class = "Date"), na.rm = TRUE): no
#> non-missing arguments to max; returning -Inf
nrow(covid19.ar.summary)
#> [1] 70
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                          | F    |        8469 |       2411 |        151 |              0.013 |              0.018 |            0.299 |           0.285 |                  0.017 |           0.007 |
| Buenos Aires                  | M    |        8433 |       2108 |        246 |              0.019 |              0.029 |            0.188 |           0.250 |                  0.032 |           0.014 |
| CABA                          | M    |        8234 |       2365 |        191 |              0.018 |              0.023 |            0.323 |           0.287 |                  0.032 |           0.017 |
| Buenos Aires                  | F    |        7905 |       1851 |        170 |              0.013 |              0.022 |            0.164 |           0.234 |                  0.022 |           0.008 |
| Chaco                         | M    |         747 |        110 |         49 |              0.041 |              0.066 |            0.168 |           0.147 |                  0.067 |           0.046 |
| Chaco                         | F    |         726 |        107 |         30 |              0.025 |              0.041 |            0.160 |           0.147 |                  0.051 |           0.022 |
| Río Negro                     | M    |         314 |        169 |         20 |              0.056 |              0.064 |            0.210 |           0.538 |                  0.045 |           0.022 |
| Río Negro                     | F    |         308 |        166 |         12 |              0.033 |              0.039 |            0.183 |           0.539 |                  0.026 |           0.013 |
| Córdoba                       | F    |         256 |         70 |         18 |              0.027 |              0.070 |            0.030 |           0.273 |                  0.055 |           0.016 |
| Córdoba                       | M    |         255 |         51 |         17 |              0.025 |              0.067 |            0.031 |           0.200 |                  0.063 |           0.031 |
| Santa Fe                      | M    |         156 |         35 |          3 |              0.010 |              0.019 |            0.028 |           0.224 |                  0.058 |           0.032 |
| Santa Fe                      | F    |         145 |         21 |          1 |              0.003 |              0.007 |            0.025 |           0.145 |                  0.028 |           0.007 |
| Neuquén                       | F    |         135 |        113 |          4 |              0.022 |              0.030 |            0.146 |           0.837 |                  0.022 |           0.022 |
| SIN ESPECIFICAR               | F    |         134 |         25 |          0 |              0.000 |              0.000 |            0.282 |           0.187 |                  0.015 |           0.000 |
| Neuquén                       | M    |         132 |        107 |          3 |              0.018 |              0.023 |            0.132 |           0.811 |                  0.023 |           0.015 |
| SIN ESPECIFICAR               | M    |         110 |         31 |          1 |              0.007 |              0.009 |            0.330 |           0.282 |                  0.018 |           0.018 |
| CABA                          | NR   |          80 |         20 |          5 |              0.032 |              0.062 |            0.308 |           0.250 |                  0.050 |           0.025 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.092 |           0.052 |                  0.026 |           0.026 |
| Buenos Aires                  | NR   |          71 |         14 |          1 |              0.007 |              0.014 |            0.264 |           0.197 |                  0.028 |           0.000 |
| Corrientes                    | M    |          69 |          1 |          0 |              0.000 |              0.000 |            0.039 |           0.014 |                  0.000 |           0.000 |
| Mendoza                       | M    |          66 |         62 |          9 |              0.071 |              0.136 |            0.052 |           0.939 |                  0.136 |           0.061 |
| Entre Ríos                    | M    |          65 |         22 |          0 |              0.000 |              0.000 |            0.071 |           0.338 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.079 |           0.052 |                  0.000 |           0.000 |
| Mendoza                       | F    |          53 |         50 |          0 |              0.000 |              0.000 |            0.047 |           0.943 |                  0.038 |           0.019 |
| Chubut                        | M    |          48 |          2 |          1 |              0.013 |              0.021 |            0.110 |           0.042 |                  0.021 |           0.021 |
| Entre Ríos                    | F    |          45 |          6 |          0 |              0.000 |              0.000 |            0.051 |           0.133 |                  0.000 |           0.000 |
| Formosa                       | M    |          45 |          0 |          0 |              0.000 |              0.000 |            0.100 |           0.000 |                  0.000 |           0.000 |
| Corrientes                    | F    |          39 |          1 |          0 |              0.000 |              0.000 |            0.029 |           0.026 |                  0.026 |           0.000 |
| La Rioja                      | F    |          36 |          8 |          6 |              0.107 |              0.167 |            0.049 |           0.222 |                  0.083 |           0.028 |
| Tucumán                       | M    |          34 |          7 |          2 |              0.007 |              0.059 |            0.009 |           0.206 |                  0.088 |           0.000 |
| Santa Cruz                    | M    |          32 |         12 |          0 |              0.000 |              0.000 |            0.099 |           0.375 |                  0.094 |           0.031 |
| Chubut                        | F    |          31 |          1 |          0 |              0.000 |              0.000 |            0.089 |           0.032 |                  0.000 |           0.000 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.039 |              0.071 |            0.038 |           0.107 |                  0.036 |           0.000 |
| Tucumán                       | F    |          23 |          6 |          2 |              0.011 |              0.087 |            0.010 |           0.261 |                  0.217 |           0.087 |
| Misiones                      | M    |          20 |         15 |          1 |              0.030 |              0.050 |            0.029 |           0.750 |                  0.150 |           0.100 |
| Santa Cruz                    | F    |          20 |         10 |          0 |              0.000 |              0.000 |            0.084 |           0.500 |                  0.050 |           0.050 |
| Misiones                      | F    |          19 |         13 |          1 |              0.036 |              0.053 |            0.034 |           0.684 |                  0.105 |           0.053 |
| Santiago del Estero           | M    |          16 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.062 |                  0.062 |           0.000 |
| Salta                         | M    |          11 |          9 |          0 |              0.000 |              0.000 |            0.020 |           0.818 |                  0.000 |           0.000 |

``` r

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))
#> Warning in max.default(structure(NA_real_, class = "Date"), na.rm = TRUE): no
#> non-missing arguments to max; returning -Inf
#> Warning in max.default(structure(c(NA_real_, NA_real_, NA_real_, NA_real_, : no
#> non-missing arguments to max; returning -Inf
#> Warning in max.default(structure(NA_real_, class = "Date"), na.rm = TRUE): no
#> non-missing arguments to max; returning -Inf

#> Warning in max.default(structure(NA_real_, class = "Date"), na.rm = TRUE): no
#> non-missing arguments to max; returning -Inf

#> Warning in max.default(structure(NA_real_, class = "Date"), na.rm = TRUE): no
#> non-missing arguments to max; returning -Inf
#> Warning in max.default(structure(c(NA_real_, NA_real_), class = "Date"), : no
#> non-missing arguments to max; returning -Inf
#> Warning in max.default(structure(NA_real_, class = "Date"), na.rm = TRUE): no
#> non-missing arguments to max; returning -Inf

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
#> Warning: Removed 4 rows containing missing values (position_stack).
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
