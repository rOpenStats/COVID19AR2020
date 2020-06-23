
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
#> INFO  [23:38:51.502] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [23:38:53.628] Normalize 
#> INFO  [23:38:53.939] checkSoundness 
#> INFO  [23:38:54.106] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-22"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-22"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-22"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-22              |       44918 |       1043 |              0.016 |              0.023 |                       117 | 241666 |            0.186 |

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
| Buenos Aires                  |       20312 |        455 |              0.014 |              0.022 |                       116 | 105228 |            0.193 |
| CABA                          |       19795 |        391 |              0.015 |              0.020 |                       115 |  61116 |            0.324 |
| Chaco                         |        1602 |         85 |              0.031 |              0.053 |                       103 |   9823 |            0.163 |
| Río Negro                     |         699 |         38 |              0.046 |              0.054 |                        98 |   3468 |            0.202 |
| Córdoba                       |         576 |         35 |              0.025 |              0.061 |                       105 |  18117 |            0.032 |
| Santa Fe                      |         340 |          4 |              0.007 |              0.012 |                       101 |  11873 |            0.029 |
| Neuquén                       |         323 |          8 |              0.019 |              0.025 |                       100 |   2111 |            0.153 |
| SIN ESPECIFICAR               |         291 |          2 |              0.005 |              0.007 |                        93 |    918 |            0.317 |
| Entre Ríos                    |         161 |          0 |              0.000 |              0.000 |                        98 |   2000 |            0.080 |
| Tierra del Fuego              |         136 |          0 |              0.000 |              0.000 |                        96 |   1592 |            0.085 |
| Mendoza                       |         135 |          9 |              0.033 |              0.067 |                       104 |   2600 |            0.052 |
| Corrientes                    |         116 |          0 |              0.000 |              0.000 |                        96 |   3258 |            0.036 |

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
| Buenos Aires                  |       20312 | 105228 |        455 |               12.2 |              0.014 |              0.022 |            0.193 |           0.221 |                  0.024 |           0.010 |
| CABA                          |       19795 |  61116 |        391 |               14.4 |              0.015 |              0.020 |            0.324 |           0.270 |                  0.023 |           0.011 |
| Chaco                         |        1602 |   9823 |         85 |               14.3 |              0.031 |              0.053 |            0.163 |           0.136 |                  0.056 |           0.032 |
| Río Negro                     |         699 |   3468 |         38 |               12.9 |              0.046 |              0.054 |            0.202 |           0.506 |                  0.036 |           0.021 |
| Córdoba                       |         576 |  18117 |         35 |               23.1 |              0.025 |              0.061 |            0.032 |           0.214 |                  0.052 |           0.021 |
| Santa Fe                      |         340 |  11873 |          4 |               25.5 |              0.007 |              0.012 |            0.029 |           0.176 |                  0.041 |           0.021 |
| Neuquén                       |         323 |   2111 |          8 |               22.7 |              0.019 |              0.025 |            0.153 |           0.842 |                  0.019 |           0.015 |
| SIN ESPECIFICAR               |         291 |    918 |          2 |                9.5 |              0.005 |              0.007 |            0.317 |           0.210 |                  0.021 |           0.010 |
| Entre Ríos                    |         161 |   2000 |          0 |                NaN |              0.000 |              0.000 |            0.080 |           0.267 |                  0.000 |           0.000 |
| Tierra del Fuego              |         136 |   1592 |          0 |                NaN |              0.000 |              0.000 |            0.085 |           0.051 |                  0.015 |           0.015 |
| Mendoza                       |         135 |   2600 |          9 |               13.3 |              0.033 |              0.067 |            0.052 |           0.933 |                  0.081 |           0.037 |
| Corrientes                    |         116 |   3258 |          0 |                NaN |              0.000 |              0.000 |            0.036 |           0.017 |                  0.009 |           0.000 |
| Chubut                        |          97 |    965 |          1 |               19.0 |              0.004 |              0.010 |            0.101 |           0.041 |                  0.010 |           0.010 |
| La Rioja                      |          64 |   1524 |          8 |               12.0 |              0.074 |              0.125 |            0.042 |           0.172 |                  0.062 |           0.016 |
| Tucumán                       |          58 |   6746 |          4 |               14.2 |              0.011 |              0.069 |            0.009 |           0.224 |                  0.138 |           0.034 |
| Santa Cruz                    |          50 |    574 |          0 |                NaN |              0.000 |              0.000 |            0.087 |           0.420 |                  0.080 |           0.040 |
| Formosa                       |          39 |    739 |          0 |                NaN |              0.000 |              0.000 |            0.053 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          38 |   1335 |          2 |                6.5 |              0.034 |              0.053 |            0.028 |           0.737 |                  0.132 |           0.079 |
| Santiago del Estero           |          23 |   2357 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.043 |                  0.043 |           0.000 |
| Salta                         |          22 |    835 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.773 |                  0.000 |           0.000 |
| Jujuy                         |          14 |   2390 |          1 |               22.0 |              0.008 |              0.071 |            0.006 |           0.214 |                  0.071 |           0.071 |
| San Luis                      |          13 |    470 |          0 |                NaN |              0.000 |              0.000 |            0.028 |           0.615 |                  0.077 |           0.000 |
| San Juan                      |           8 |    741 |          0 |                NaN |              0.000 |              0.000 |            0.011 |           0.625 |                  0.125 |           0.000 |
| La Pampa                      |           6 |    334 |          0 |                NaN |              0.000 |              0.000 |            0.018 |           0.167 |                  0.000 |           0.000 |

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
#> INFO  [23:39:31.037] Processing {current.group: }
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
|             13 | 2020-06-18              |                        75 |        1069 |   5509 |        593 |         61 |              0.047 |              0.057 |            0.194 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-06-21              |                        95 |        1732 |  11521 |        953 |        110 |              0.051 |              0.064 |            0.150 |           0.550 |                  0.096 |           0.056 |
|             15 | 2020-06-22              |                       111 |        2363 |  20224 |       1281 |        169 |              0.056 |              0.072 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 | 2020-06-22              |                       115 |        3097 |  31787 |       1607 |        223 |              0.055 |              0.072 |            0.097 |           0.519 |                  0.083 |           0.044 |
|             17 | 2020-06-22              |                       117 |        4113 |  45817 |       2091 |        322 |              0.060 |              0.078 |            0.090 |           0.508 |                  0.076 |           0.039 |
|             18 | 2020-06-22              |                       117 |        5013 |  58991 |       2465 |        384 |              0.059 |              0.077 |            0.085 |           0.492 |                  0.069 |           0.036 |
|             19 | 2020-06-22              |                       117 |        6347 |  73108 |       3003 |        452 |              0.055 |              0.071 |            0.087 |           0.473 |                  0.063 |           0.032 |
|             20 | 2020-06-22              |                       117 |        8592 |  90438 |       3786 |        523 |              0.048 |              0.061 |            0.095 |           0.441 |                  0.057 |           0.028 |
|             21 | 2020-06-22              |                       117 |       12743 | 113795 |       5004 |        641 |              0.040 |              0.050 |            0.112 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-06-22              |                       117 |       17730 | 139084 |       6333 |        772 |              0.035 |              0.044 |            0.127 |           0.357 |                  0.043 |           0.021 |
|             23 | 2020-06-22              |                       117 |       23785 | 167160 |       7677 |        901 |              0.031 |              0.038 |            0.142 |           0.323 |                  0.038 |           0.018 |
|             24 | 2020-06-22              |                       117 |       32847 | 201642 |       9476 |        998 |              0.025 |              0.030 |            0.163 |           0.288 |                  0.032 |           0.015 |
|             25 | 2020-06-22              |                       117 |       43801 | 238301 |      11058 |       1041 |              0.018 |              0.024 |            0.184 |           0.252 |                  0.027 |           0.012 |
|             26 | 2020-06-22              |                       117 |       44918 | 241666 |      11212 |       1043 |              0.016 |              0.023 |            0.186 |           0.250 |                  0.026 |           0.012 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [23:39:46.647] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [23:39:54.206] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [23:39:59.244] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [23:40:00.174] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [23:40:02.656] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [23:40:04.519] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [23:40:07.696] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [23:40:09.715] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [23:40:11.793] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [23:40:13.037] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [23:40:14.876] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [23:40:16.555] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [23:40:18.284] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [23:40:20.239] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [23:40:21.890] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [23:40:23.700] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [23:40:25.715] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [23:40:27.510] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [23:40:29.197] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [23:40:30.998] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [23:40:32.785] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [23:40:35.413] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [23:40:37.190] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [23:40:38.969] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [23:40:40.947] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       10382 |       2393 |        269 |              0.017 |              0.026 |            0.206 |           0.230 |                  0.029 |           0.012 |
| CABA                          | F    |        9954 |       2658 |        166 |              0.013 |              0.017 |            0.310 |           0.267 |                  0.016 |           0.006 |
| Buenos Aires                  | F    |        9851 |       2083 |        185 |              0.012 |              0.019 |            0.181 |           0.211 |                  0.019 |           0.007 |
| CABA                          | M    |        9746 |       2658 |        219 |              0.017 |              0.022 |            0.339 |           0.273 |                  0.030 |           0.016 |
| Chaco                         | M    |         808 |        110 |         54 |              0.039 |              0.067 |            0.166 |           0.136 |                  0.066 |           0.045 |
| Chaco                         | F    |         792 |        108 |         31 |              0.023 |              0.039 |            0.160 |           0.136 |                  0.047 |           0.020 |
| Río Negro                     | F    |         353 |        176 |         13 |              0.032 |              0.037 |            0.190 |           0.499 |                  0.023 |           0.011 |
| Río Negro                     | M    |         346 |        178 |         25 |              0.060 |              0.072 |            0.216 |           0.514 |                  0.049 |           0.032 |
| Córdoba                       | M    |         293 |         52 |         17 |              0.024 |              0.058 |            0.033 |           0.177 |                  0.055 |           0.027 |
| Córdoba                       | F    |         281 |         70 |         18 |              0.025 |              0.064 |            0.031 |           0.249 |                  0.050 |           0.014 |
| Santa Fe                      | M    |         175 |         37 |          3 |              0.010 |              0.017 |            0.030 |           0.211 |                  0.057 |           0.034 |
| Neuquén                       | F    |         165 |        141 |          4 |              0.019 |              0.024 |            0.162 |           0.855 |                  0.018 |           0.018 |
| Santa Fe                      | F    |         165 |         23 |          1 |              0.003 |              0.006 |            0.027 |           0.139 |                  0.024 |           0.006 |
| SIN ESPECIFICAR               | F    |         163 |         28 |          0 |              0.000 |              0.000 |            0.301 |           0.172 |                  0.018 |           0.000 |
| Neuquén                       | M    |         158 |        131 |          4 |              0.019 |              0.025 |            0.145 |           0.829 |                  0.019 |           0.013 |
| SIN ESPECIFICAR               | M    |         126 |         32 |          1 |              0.006 |              0.008 |            0.345 |           0.254 |                  0.016 |           0.016 |
| CABA                          | NR   |          95 |         27 |          6 |              0.034 |              0.063 |            0.324 |           0.284 |                  0.053 |           0.032 |
| Entre Ríos                    | M    |          91 |         28 |          0 |              0.000 |              0.000 |            0.089 |           0.308 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |          79 |         15 |          1 |              0.007 |              0.013 |            0.256 |           0.190 |                  0.025 |           0.000 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.091 |           0.052 |                  0.026 |           0.026 |
| Mendoza                       | M    |          74 |         70 |          9 |              0.063 |              0.122 |            0.054 |           0.946 |                  0.122 |           0.054 |
| Corrientes                    | M    |          71 |          1 |          0 |              0.000 |              0.000 |            0.039 |           0.014 |                  0.000 |           0.000 |
| Entre Ríos                    | F    |          69 |         15 |          0 |              0.000 |              0.000 |            0.071 |           0.217 |                  0.000 |           0.000 |
| Mendoza                       | F    |          61 |         56 |          0 |              0.000 |              0.000 |            0.050 |           0.918 |                  0.033 |           0.016 |
| Chubut                        | M    |          58 |          3 |          1 |              0.008 |              0.017 |            0.109 |           0.052 |                  0.017 |           0.017 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.078 |           0.052 |                  0.000 |           0.000 |
| Corrientes                    | F    |          45 |          1 |          0 |              0.000 |              0.000 |            0.032 |           0.022 |                  0.022 |           0.000 |
| Formosa                       | M    |          38 |          0 |          0 |              0.000 |              0.000 |            0.086 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | F    |          37 |          1 |          0 |              0.000 |              0.000 |            0.087 |           0.027 |                  0.000 |           0.000 |
| La Rioja                      | F    |          36 |          8 |          6 |              0.100 |              0.167 |            0.048 |           0.222 |                  0.083 |           0.028 |
| Tucumán                       | M    |          34 |          7 |          2 |              0.009 |              0.059 |            0.008 |           0.206 |                  0.088 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.094 |           0.387 |                  0.097 |           0.032 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.042 |              0.071 |            0.036 |           0.107 |                  0.036 |           0.000 |
| Tucumán                       | F    |          24 |          6 |          2 |              0.014 |              0.083 |            0.009 |           0.250 |                  0.208 |           0.083 |
| Misiones                      | M    |          20 |         15 |          1 |              0.032 |              0.050 |            0.027 |           0.750 |                  0.150 |           0.100 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.078 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.037 |              0.056 |            0.030 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          16 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.062 |                  0.062 |           0.000 |
| Salta                         | M    |          12 |         10 |          0 |              0.000 |              0.000 |            0.021 |           0.833 |                  0.000 |           0.000 |
| Salta                         | F    |          10 |          7 |          0 |              0.000 |              0.000 |            0.038 |           0.700 |                  0.000 |           0.000 |
| San Luis                      | M    |          10 |          6 |          0 |              0.000 |              0.000 |            0.037 |           0.600 |                  0.100 |           0.000 |

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
