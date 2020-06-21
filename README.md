
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
#> INFO  [18:25:00.251] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [18:25:02.405] Normalize 
#> INFO  [18:25:02.805] checkSoundness 
#> INFO  [18:25:02.943] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-20"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-20"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-20"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-20              |       41191 |        992 |              0.016 |              0.024 |                       115 | 230132 |            0.179 |

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
| Buenos Aires                  |       18535 |        439 |              0.015 |              0.024 |                       114 | 99826 |            0.186 |
| CABA                          |       18079 |        364 |              0.015 |              0.020 |                       113 | 57116 |            0.317 |
| Chaco                         |        1530 |         84 |              0.032 |              0.055 |                       101 |  9423 |            0.162 |
| Río Negro                     |         675 |         32 |              0.042 |              0.047 |                        96 |  3357 |            0.201 |
| Córdoba                       |         552 |         35 |              0.027 |              0.063 |                       103 | 17634 |            0.031 |
| Santa Fe                      |         318 |          4 |              0.006 |              0.013 |                        99 | 11606 |            0.027 |
| Neuquén                       |         303 |          7 |              0.016 |              0.023 |                        98 |  1980 |            0.153 |
| SIN ESPECIFICAR               |         271 |          2 |              0.005 |              0.007 |                        91 |   875 |            0.310 |
| Tierra del Fuego              |         136 |          0 |              0.000 |              0.000 |                        94 |  1582 |            0.086 |
| Entre Ríos                    |         135 |          0 |              0.000 |              0.000 |                        96 |  1922 |            0.070 |
| Mendoza                       |         127 |          9 |              0.035 |              0.071 |                       102 |  2510 |            0.051 |
| Corrientes                    |         115 |          0 |              0.000 |              0.000 |                        94 |  3240 |            0.035 |

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
nrow(covid19.ar.summary)
#> [1] 24
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
        select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))
```

| residencia\_provincia\_nombre | confirmados | tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | ----------: | ----: | ---------: | -----------------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| Buenos Aires                  |       18535 | 99826 |        439 |               12.3 |              0.015 |              0.024 |            0.186 |           0.228 |                  0.025 |           0.010 |
| CABA                          |       18079 | 57116 |        364 |               14.1 |              0.015 |              0.020 |            0.317 |           0.279 |                  0.024 |           0.011 |
| Chaco                         |        1530 |  9423 |         84 |               14.3 |              0.032 |              0.055 |            0.162 |           0.143 |                  0.059 |           0.034 |
| Río Negro                     |         675 |  3357 |         32 |               13.7 |              0.042 |              0.047 |            0.201 |           0.514 |                  0.033 |           0.016 |
| Córdoba                       |         552 | 17634 |         35 |               23.1 |              0.027 |              0.063 |            0.031 |           0.221 |                  0.054 |           0.022 |
| Santa Fe                      |         318 | 11606 |          4 |               25.5 |              0.006 |              0.013 |            0.027 |           0.182 |                  0.041 |           0.019 |
| Neuquén                       |         303 |  1980 |          7 |                9.4 |              0.016 |              0.023 |            0.153 |           0.743 |                  0.020 |           0.017 |
| SIN ESPECIFICAR               |         271 |   875 |          2 |                9.5 |              0.005 |              0.007 |            0.310 |           0.221 |                  0.022 |           0.011 |
| Tierra del Fuego              |         136 |  1582 |          0 |                NaN |              0.000 |              0.000 |            0.086 |           0.051 |                  0.015 |           0.015 |
| Entre Ríos                    |         135 |  1922 |          0 |                NaN |              0.000 |              0.000 |            0.070 |           0.230 |                  0.000 |           0.000 |
| Mendoza                       |         127 |  2510 |          9 |               13.3 |              0.035 |              0.071 |            0.051 |           0.937 |                  0.087 |           0.039 |
| Corrientes                    |         115 |  3240 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.017 |                  0.009 |           0.000 |
| Chubut                        |          86 |   871 |          1 |               19.0 |              0.005 |              0.012 |            0.099 |           0.035 |                  0.012 |           0.012 |
| La Rioja                      |          64 |  1512 |          8 |               12.0 |              0.081 |              0.125 |            0.042 |           0.172 |                  0.062 |           0.016 |
| Tucumán                       |          57 |  6460 |          4 |               14.2 |              0.008 |              0.070 |            0.009 |           0.228 |                  0.140 |           0.035 |
| Santa Cruz                    |          50 |   572 |          0 |                NaN |              0.000 |              0.000 |            0.087 |           0.420 |                  0.080 |           0.040 |
| Formosa                       |          39 |   739 |          0 |                NaN |              0.000 |              0.000 |            0.053 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          39 |  1335 |          2 |                6.5 |              0.034 |              0.051 |            0.029 |           0.744 |                  0.128 |           0.077 |
| Santiago del Estero           |          22 |  2330 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.045 |                  0.045 |           0.000 |
| Salta                         |          21 |   820 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.762 |                  0.000 |           0.000 |
| Jujuy                         |          12 |  2371 |          1 |               22.0 |              0.008 |              0.083 |            0.005 |           0.167 |                  0.083 |           0.083 |
| San Luis                      |          12 |   454 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.667 |                  0.083 |           0.000 |
| San Juan                      |           7 |   730 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.714 |                  0.143 |           0.000 |
| La Pampa                      |           6 |   325 |          0 |                NaN |              0.000 |              0.000 |            0.018 |           0.167 |                  0.000 |           0.000 |

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
#> INFO  [18:25:54.587] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 16
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
|             14 | 2020-06-20              |                        94 |        1731 |  11520 |        952 |        109 |              0.051 |              0.063 |            0.150 |           0.550 |                  0.096 |           0.056 |
|             15 | 2020-06-20              |                       109 |        2361 |  20223 |       1279 |        168 |              0.056 |              0.071 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 | 2020-06-20              |                       113 |        3093 |  31786 |       1603 |        222 |              0.055 |              0.072 |            0.097 |           0.518 |                  0.083 |           0.044 |
|             17 | 2020-06-20              |                       115 |        4107 |  45815 |       2087 |        321 |              0.060 |              0.078 |            0.090 |           0.508 |                  0.076 |           0.039 |
|             18 | 2020-06-20              |                       115 |        5003 |  58989 |       2461 |        383 |              0.059 |              0.077 |            0.085 |           0.492 |                  0.069 |           0.036 |
|             19 | 2020-06-20              |                       115 |        6334 |  73106 |       2997 |        450 |              0.055 |              0.071 |            0.087 |           0.473 |                  0.063 |           0.032 |
|             20 | 2020-06-20              |                       115 |        8572 |  90418 |       3774 |        518 |              0.048 |              0.060 |            0.095 |           0.440 |                  0.056 |           0.028 |
|             21 | 2020-06-20              |                       115 |       12721 | 113772 |       4989 |        635 |              0.040 |              0.050 |            0.112 |           0.392 |                  0.049 |           0.024 |
|             22 | 2020-06-20              |                       115 |       17697 | 139055 |       6310 |        761 |              0.035 |              0.043 |            0.127 |           0.357 |                  0.043 |           0.021 |
|             23 | 2020-06-20              |                       115 |       23734 | 167112 |       7639 |        879 |              0.030 |              0.037 |            0.142 |           0.322 |                  0.038 |           0.018 |
|             24 | 2020-06-20              |                       115 |       32744 | 201382 |       9402 |        965 |              0.024 |              0.029 |            0.163 |           0.287 |                  0.031 |           0.014 |
|             25 | 2020-06-20              |                       115 |       41191 | 230132 |      10577 |        992 |              0.016 |              0.024 |            0.179 |           0.257 |                  0.027 |           0.012 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [18:26:13.115] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [18:26:23.272] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [18:26:30.834] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [18:26:31.865] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [18:26:35.083] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [18:26:37.480] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [18:26:41.614] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [18:26:43.895] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [18:26:46.026] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [18:26:47.335] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [18:26:49.319] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [18:26:51.193] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [18:26:53.110] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [18:26:55.254] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [18:26:56.974] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [18:26:58.834] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [18:27:01.062] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [18:27:03.194] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [18:27:05.557] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [18:27:08.131] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [18:27:10.473] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [18:27:13.920] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [18:27:16.124] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [18:27:18.116] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [18:27:20.421] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 336
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
| Buenos Aires                  | M    |        9506 |       2251 |        257 |              0.018 |              0.027 |            0.198 |           0.237 |                  0.029 |           0.012 |
| CABA                          | F    |        9110 |       2523 |        156 |              0.013 |              0.017 |            0.304 |           0.277 |                  0.017 |           0.006 |
| Buenos Aires                  | F    |        8952 |       1969 |        181 |              0.013 |              0.020 |            0.174 |           0.220 |                  0.020 |           0.007 |
| CABA                          | M    |        8885 |       2497 |        203 |              0.017 |              0.023 |            0.331 |           0.281 |                  0.031 |           0.016 |
| Chaco                         | M    |         773 |        111 |         54 |              0.042 |              0.070 |            0.165 |           0.144 |                  0.069 |           0.047 |
| Chaco                         | F    |         755 |        108 |         30 |              0.023 |              0.040 |            0.159 |           0.143 |                  0.049 |           0.021 |
| Río Negro                     | F    |         340 |        175 |         12 |              0.031 |              0.035 |            0.189 |           0.515 |                  0.024 |           0.012 |
| Río Negro                     | M    |         335 |        172 |         20 |              0.052 |              0.060 |            0.215 |           0.513 |                  0.042 |           0.021 |
| Córdoba                       | M    |         277 |         51 |         17 |              0.027 |              0.061 |            0.032 |           0.184 |                  0.058 |           0.029 |
| Córdoba                       | F    |         273 |         70 |         18 |              0.027 |              0.066 |            0.030 |           0.256 |                  0.051 |           0.015 |
| Santa Fe                      | M    |         164 |         36 |          3 |              0.010 |              0.018 |            0.029 |           0.220 |                  0.055 |           0.030 |
| Santa Fe                      | F    |         154 |         22 |          1 |              0.003 |              0.006 |            0.026 |           0.143 |                  0.026 |           0.006 |
| Neuquén                       | F    |         152 |        115 |          4 |              0.018 |              0.026 |            0.160 |           0.757 |                  0.020 |           0.020 |
| Neuquén                       | M    |         151 |        110 |          3 |              0.014 |              0.020 |            0.147 |           0.728 |                  0.020 |           0.013 |
| SIN ESPECIFICAR               | F    |         151 |         28 |          0 |              0.000 |              0.000 |            0.293 |           0.185 |                  0.020 |           0.000 |
| SIN ESPECIFICAR               | M    |         118 |         31 |          1 |              0.007 |              0.008 |            0.338 |           0.263 |                  0.017 |           0.017 |
| CABA                          | NR   |          84 |         22 |          5 |              0.030 |              0.060 |            0.307 |           0.262 |                  0.048 |           0.024 |
| Entre Ríos                    | M    |          80 |         23 |          0 |              0.000 |              0.000 |            0.081 |           0.288 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |          77 |         15 |          1 |              0.007 |              0.013 |            0.259 |           0.195 |                  0.026 |           0.000 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.091 |           0.052 |                  0.026 |           0.026 |
| Corrientes                    | M    |          71 |          1 |          0 |              0.000 |              0.000 |            0.039 |           0.014 |                  0.000 |           0.000 |
| Mendoza                       | M    |          70 |         66 |          9 |              0.065 |              0.129 |            0.053 |           0.943 |                  0.129 |           0.057 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.079 |           0.052 |                  0.000 |           0.000 |
| Mendoza                       | F    |          57 |         53 |          0 |              0.000 |              0.000 |            0.048 |           0.930 |                  0.035 |           0.018 |
| Entre Ríos                    | F    |          54 |          8 |          0 |              0.000 |              0.000 |            0.058 |           0.148 |                  0.000 |           0.000 |
| Chubut                        | M    |          51 |          2 |          1 |              0.009 |              0.020 |            0.105 |           0.039 |                  0.020 |           0.020 |
| Corrientes                    | F    |          44 |          1 |          0 |              0.000 |              0.000 |            0.031 |           0.023 |                  0.023 |           0.000 |
| Formosa                       | M    |          38 |          0 |          0 |              0.000 |              0.000 |            0.086 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | F    |          36 |          8 |          6 |              0.109 |              0.167 |            0.048 |           0.222 |                  0.083 |           0.028 |
| Chubut                        | F    |          34 |          1 |          0 |              0.000 |              0.000 |            0.089 |           0.029 |                  0.000 |           0.000 |
| Tucumán                       | M    |          34 |          7 |          2 |              0.007 |              0.059 |            0.009 |           0.206 |                  0.088 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.094 |           0.387 |                  0.097 |           0.032 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.045 |              0.071 |            0.037 |           0.107 |                  0.036 |           0.000 |
| Tucumán                       | F    |          23 |          6 |          2 |              0.010 |              0.087 |            0.009 |           0.261 |                  0.217 |           0.087 |
| Misiones                      | M    |          21 |         16 |          1 |              0.031 |              0.048 |            0.029 |           0.762 |                  0.143 |           0.095 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.078 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.038 |              0.056 |            0.030 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          15 |          1 |          0 |              0.000 |              0.000 |            0.009 |           0.067 |                  0.067 |           0.000 |
| Salta                         | M    |          11 |          9 |          0 |              0.000 |              0.000 |            0.020 |           0.818 |                  0.000 |           0.000 |
| Salta                         | F    |          10 |          7 |          0 |              0.000 |              0.000 |            0.039 |           0.700 |                  0.000 |           0.000 |
| San Luis                      | M    |          10 |          6 |          0 |              0.000 |              0.000 |            0.038 |           0.600 |                  0.100 |           0.000 |

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
