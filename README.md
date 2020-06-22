
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
#> INFO  [22:20:51.678] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [22:20:53.770] Normalize 
#> INFO  [22:20:54.087] checkSoundness 
#> INFO  [22:20:54.229] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-21"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-21"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-21"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-21              |       42772 |       1011 |              0.016 |              0.024 |                       116 | 235226 |            0.182 |

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
| Buenos Aires                  |       19276 |        448 |              0.015 |              0.023 |                       115 | 102193 |            0.189 |
| CABA                          |       18780 |        372 |              0.015 |              0.020 |                       114 |  58873 |            0.319 |
| Chaco                         |        1582 |         84 |              0.031 |              0.053 |                       102 |   9615 |            0.165 |
| Río Negro                     |         691 |         34 |              0.044 |              0.049 |                        97 |   3386 |            0.204 |
| Córdoba                       |         565 |         35 |              0.026 |              0.062 |                       104 |  17844 |            0.032 |
| Santa Fe                      |         335 |          4 |              0.007 |              0.012 |                       100 |  11731 |            0.029 |
| Neuquén                       |         312 |          7 |              0.016 |              0.022 |                        99 |   2019 |            0.155 |
| SIN ESPECIFICAR               |         282 |          2 |              0.005 |              0.007 |                        92 |    896 |            0.315 |
| Entre Ríos                    |         145 |          0 |              0.000 |              0.000 |                        97 |   1958 |            0.074 |
| Tierra del Fuego              |         136 |          0 |              0.000 |              0.000 |                        96 |   1592 |            0.085 |
| Mendoza                       |         132 |          9 |              0.035 |              0.068 |                       103 |   2556 |            0.052 |
| Corrientes                    |         115 |          0 |              0.000 |              0.000 |                        94 |   3249 |            0.035 |

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
| Buenos Aires                  |       19276 | 102193 |        448 |               12.3 |              0.015 |              0.023 |            0.189 |           0.225 |                  0.024 |           0.010 |
| CABA                          |       18780 |  58873 |        372 |               14.1 |              0.015 |              0.020 |            0.319 |           0.274 |                  0.024 |           0.011 |
| Chaco                         |        1582 |   9615 |         84 |               14.3 |              0.031 |              0.053 |            0.165 |           0.138 |                  0.057 |           0.033 |
| Río Negro                     |         691 |   3386 |         34 |               13.4 |              0.044 |              0.049 |            0.204 |           0.508 |                  0.033 |           0.017 |
| Córdoba                       |         565 |  17844 |         35 |               23.1 |              0.026 |              0.062 |            0.032 |           0.216 |                  0.053 |           0.021 |
| Santa Fe                      |         335 |  11731 |          4 |               25.5 |              0.007 |              0.012 |            0.029 |           0.176 |                  0.042 |           0.021 |
| Neuquén                       |         312 |   2019 |          7 |                9.4 |              0.016 |              0.022 |            0.155 |           0.744 |                  0.019 |           0.016 |
| SIN ESPECIFICAR               |         282 |    896 |          2 |                9.5 |              0.005 |              0.007 |            0.315 |           0.213 |                  0.021 |           0.011 |
| Entre Ríos                    |         145 |   1958 |          0 |                NaN |              0.000 |              0.000 |            0.074 |           0.228 |                  0.000 |           0.000 |
| Tierra del Fuego              |         136 |   1592 |          0 |                NaN |              0.000 |              0.000 |            0.085 |           0.051 |                  0.015 |           0.015 |
| Mendoza                       |         132 |   2556 |          9 |               13.3 |              0.035 |              0.068 |            0.052 |           0.932 |                  0.083 |           0.038 |
| Corrientes                    |         115 |   3249 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.026 |                  0.009 |           0.000 |
| Chubut                        |          92 |    921 |          1 |               19.0 |              0.005 |              0.011 |            0.100 |           0.033 |                  0.011 |           0.011 |
| La Rioja                      |          64 |   1523 |          8 |               12.0 |              0.084 |              0.125 |            0.042 |           0.172 |                  0.062 |           0.016 |
| Tucumán                       |          57 |   6617 |          4 |               14.2 |              0.010 |              0.070 |            0.009 |           0.228 |                  0.140 |           0.035 |
| Santa Cruz                    |          50 |    574 |          0 |                NaN |              0.000 |              0.000 |            0.087 |           0.420 |                  0.080 |           0.040 |
| Formosa                       |          39 |    739 |          0 |                NaN |              0.000 |              0.000 |            0.053 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          39 |   1336 |          2 |                6.5 |              0.034 |              0.051 |            0.029 |           0.744 |                  0.128 |           0.077 |
| Santiago del Estero           |          23 |   2333 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.043 |                  0.043 |           0.000 |
| Salta                         |          20 |    820 |          0 |                NaN |              0.000 |              0.000 |            0.024 |           0.800 |                  0.000 |           0.000 |
| Jujuy                         |          12 |   2380 |          1 |               22.0 |              0.009 |              0.083 |            0.005 |           0.167 |                  0.083 |           0.083 |
| San Luis                      |          12 |    467 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.667 |                  0.083 |           0.000 |
| San Juan                      |           7 |    737 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.714 |                  0.143 |           0.000 |
| La Pampa                      |           6 |    325 |          0 |                NaN |              0.000 |              0.000 |            0.018 |           0.167 |                  0.000 |           0.000 |

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
#> INFO  [22:21:32.999] Processing {current.group: }
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
|             11 | 2020-06-18              |                        35 |          93 |    666 |         64 |          8 |              0.059 |              0.086 |            0.140 |           0.688 |                  0.129 |           0.065 |
|             12 | 2020-06-18              |                        54 |         407 |   2048 |        252 |         16 |              0.031 |              0.039 |            0.199 |           0.619 |                  0.093 |           0.054 |
|             13 | 2020-06-18              |                        75 |        1069 |   5509 |        593 |         60 |              0.046 |              0.056 |            0.194 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-06-21              |                        95 |        1732 |  11521 |        953 |        109 |              0.051 |              0.063 |            0.150 |           0.550 |                  0.096 |           0.056 |
|             15 | 2020-06-21              |                       110 |        2363 |  20224 |       1281 |        168 |              0.056 |              0.071 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 | 2020-06-21              |                       114 |        3097 |  31787 |       1607 |        222 |              0.055 |              0.072 |            0.097 |           0.519 |                  0.083 |           0.044 |
|             17 | 2020-06-21              |                       116 |        4112 |  45816 |       2091 |        321 |              0.060 |              0.078 |            0.090 |           0.509 |                  0.076 |           0.039 |
|             18 | 2020-06-21              |                       116 |        5010 |  58990 |       2465 |        383 |              0.059 |              0.076 |            0.085 |           0.492 |                  0.069 |           0.036 |
|             19 | 2020-06-21              |                       116 |        6343 |  73107 |       3002 |        450 |              0.055 |              0.071 |            0.087 |           0.473 |                  0.063 |           0.032 |
|             20 | 2020-06-21              |                       116 |        8585 |  90435 |       3782 |        519 |              0.048 |              0.060 |            0.095 |           0.441 |                  0.056 |           0.028 |
|             21 | 2020-06-21              |                       116 |       12735 | 113790 |       4998 |        636 |              0.040 |              0.050 |            0.112 |           0.392 |                  0.049 |           0.024 |
|             22 | 2020-06-21              |                       116 |       17716 | 139076 |       6321 |        764 |              0.035 |              0.043 |            0.127 |           0.357 |                  0.043 |           0.021 |
|             23 | 2020-06-21              |                       116 |       23758 | 167138 |       7654 |        885 |              0.030 |              0.037 |            0.142 |           0.322 |                  0.038 |           0.018 |
|             24 | 2020-06-21              |                       116 |       32789 | 201497 |       9432 |        978 |              0.024 |              0.030 |            0.163 |           0.288 |                  0.032 |           0.015 |
|             25 | 2020-06-21              |                       116 |       42609 | 234814 |      10797 |       1011 |              0.017 |              0.024 |            0.181 |           0.253 |                  0.026 |           0.012 |
|             26 | 2020-06-21              |                       116 |       42772 | 235226 |      10801 |       1011 |              0.016 |              0.024 |            0.182 |           0.253 |                  0.026 |           0.012 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [22:21:48.234] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [22:21:56.018] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [22:22:01.863] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [22:22:02.904] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [22:22:05.857] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [22:22:07.743] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [22:22:11.278] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [22:22:13.565] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [22:22:15.946] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [22:22:17.332] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [22:22:19.432] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [22:22:21.302] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [22:22:23.301] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [22:22:25.494] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [22:22:27.214] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [22:22:29.275] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [22:22:31.573] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [22:22:33.667] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [22:22:35.562] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [22:22:37.558] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [22:22:39.546] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [22:22:42.492] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [22:22:44.796] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [22:22:46.809] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [22:22:49.005] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 357
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
| Buenos Aires                  | M    |        9868 |       2307 |        264 |              0.018 |              0.027 |            0.201 |           0.234 |                  0.028 |           0.012 |
| CABA                          | F    |        9454 |       2575 |        158 |              0.013 |              0.017 |            0.306 |           0.272 |                  0.017 |           0.007 |
| Buenos Aires                  | F    |        9331 |       2009 |        183 |              0.012 |              0.020 |            0.177 |           0.215 |                  0.020 |           0.008 |
| CABA                          | M    |        9239 |       2552 |        208 |              0.017 |              0.023 |            0.333 |           0.276 |                  0.031 |           0.016 |
| Chaco                         | M    |         798 |        111 |         54 |              0.040 |              0.068 |            0.168 |           0.139 |                  0.066 |           0.045 |
| Chaco                         | F    |         782 |        108 |         30 |              0.022 |              0.038 |            0.162 |           0.138 |                  0.047 |           0.020 |
| Río Negro                     | F    |         349 |        176 |         12 |              0.031 |              0.034 |            0.192 |           0.504 |                  0.023 |           0.011 |
| Río Negro                     | M    |         342 |        175 |         22 |              0.056 |              0.064 |            0.218 |           0.512 |                  0.044 |           0.023 |
| Córdoba                       | M    |         284 |         51 |         17 |              0.026 |              0.060 |            0.032 |           0.180 |                  0.056 |           0.028 |
| Córdoba                       | F    |         279 |         70 |         18 |              0.026 |              0.065 |            0.031 |           0.251 |                  0.050 |           0.014 |
| Santa Fe                      | M    |         172 |         37 |          3 |              0.010 |              0.017 |            0.030 |           0.215 |                  0.058 |           0.035 |
| Santa Fe                      | F    |         163 |         22 |          1 |              0.003 |              0.006 |            0.027 |           0.135 |                  0.025 |           0.006 |
| Neuquén                       | F    |         157 |        120 |          4 |              0.018 |              0.025 |            0.162 |           0.764 |                  0.019 |           0.019 |
| SIN ESPECIFICAR               | F    |         157 |         27 |          0 |              0.000 |              0.000 |            0.296 |           0.172 |                  0.019 |           0.000 |
| Neuquén                       | M    |         155 |        112 |          3 |              0.013 |              0.019 |            0.148 |           0.723 |                  0.019 |           0.013 |
| SIN ESPECIFICAR               | M    |         123 |         32 |          1 |              0.006 |              0.008 |            0.346 |           0.260 |                  0.016 |           0.016 |
| CABA                          | NR   |          87 |         24 |          6 |              0.036 |              0.069 |            0.309 |           0.276 |                  0.046 |           0.023 |
| Entre Ríos                    | M    |          85 |         24 |          0 |              0.000 |              0.000 |            0.085 |           0.282 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |          77 |         15 |          1 |              0.007 |              0.013 |            0.256 |           0.195 |                  0.026 |           0.000 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.091 |           0.052 |                  0.026 |           0.026 |
| Mendoza                       | M    |          73 |         68 |          9 |              0.066 |              0.123 |            0.054 |           0.932 |                  0.123 |           0.055 |
| Corrientes                    | M    |          71 |          2 |          0 |              0.000 |              0.000 |            0.039 |           0.028 |                  0.000 |           0.000 |
| Entre Ríos                    | F    |          59 |          9 |          0 |              0.000 |              0.000 |            0.062 |           0.153 |                  0.000 |           0.000 |
| Mendoza                       | F    |          59 |         55 |          0 |              0.000 |              0.000 |            0.049 |           0.932 |                  0.034 |           0.017 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.078 |           0.052 |                  0.000 |           0.000 |
| Chubut                        | M    |          54 |          2 |          1 |              0.009 |              0.019 |            0.105 |           0.037 |                  0.019 |           0.019 |
| Corrientes                    | F    |          44 |          1 |          0 |              0.000 |              0.000 |            0.031 |           0.023 |                  0.023 |           0.000 |
| Formosa                       | M    |          38 |          0 |          0 |              0.000 |              0.000 |            0.086 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | F    |          36 |          1 |          0 |              0.000 |              0.000 |            0.090 |           0.028 |                  0.000 |           0.000 |
| La Rioja                      | F    |          36 |          8 |          6 |              0.118 |              0.167 |            0.048 |           0.222 |                  0.083 |           0.028 |
| Tucumán                       | M    |          34 |          7 |          2 |              0.008 |              0.059 |            0.008 |           0.206 |                  0.088 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.094 |           0.387 |                  0.097 |           0.032 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.045 |              0.071 |            0.036 |           0.107 |                  0.036 |           0.000 |
| Tucumán                       | F    |          23 |          6 |          2 |              0.012 |              0.087 |            0.009 |           0.261 |                  0.217 |           0.087 |
| Misiones                      | M    |          21 |         16 |          1 |              0.031 |              0.048 |            0.029 |           0.762 |                  0.143 |           0.095 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.078 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.038 |              0.056 |            0.030 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          16 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.062 |                  0.062 |           0.000 |
| Salta                         | M    |          11 |          9 |          0 |              0.000 |              0.000 |            0.020 |           0.818 |                  0.000 |           0.000 |

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
#> Warning: Removed 47 rows containing missing values (position_stack).
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
