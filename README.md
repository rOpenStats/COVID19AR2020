
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
#> INFO  [21:24:42.878] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [21:24:50.456] Normalize 
#> INFO  [21:24:51.046] checkSoundness 
#> INFO  [21:24:51.639] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-10"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-10"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-10"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-10              |       94047 |       1774 |              0.014 |              0.019 |                       135 | 376946 |            0.249 |

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
| Buenos Aires                  |       49769 |        864 |              0.012 |              0.017 |                       134 | 178730 |            0.278 |
| CABA                          |       35966 |        654 |              0.015 |              0.018 |                       133 |  97473 |            0.369 |
| Chaco                         |        2497 |        114 |              0.033 |              0.046 |                       121 |  14576 |            0.171 |
| Río Negro                     |        1057 |         46 |              0.040 |              0.044 |                       116 |   4992 |            0.212 |
| Córdoba                       |         852 |         37 |              0.019 |              0.043 |                       123 |  22765 |            0.037 |
| SIN ESPECIFICAR               |         699 |          2 |              0.002 |              0.003 |                       111 |   1871 |            0.374 |
| Neuquén                       |         663 |         19 |              0.023 |              0.029 |                       117 |   3051 |            0.217 |
| Santa Fe                      |         486 |          6 |              0.007 |              0.012 |                       119 |  14760 |            0.033 |
| Entre Ríos                    |         401 |          0 |              0.000 |              0.000 |                       116 |   2974 |            0.135 |
| Jujuy                         |         334 |          1 |              0.001 |              0.003 |                       112 |   3218 |            0.104 |
| Mendoza                       |         264 |         10 |              0.021 |              0.038 |                       122 |   3728 |            0.071 |
| Chubut                        |         198 |          1 |              0.003 |              0.005 |                       101 |   1745 |            0.113 |
| Tierra del Fuego              |         142 |          1 |              0.006 |              0.007 |                       113 |   1695 |            0.084 |
| La Rioja                      |         132 |         11 |              0.056 |              0.083 |                       107 |   2610 |            0.051 |
| Corrientes                    |         124 |          0 |              0.000 |              0.000 |                       113 |   3592 |            0.035 |

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
| Buenos Aires                  |       49769 | 178730 |        864 |               12.9 |              0.012 |              0.017 |            0.278 |           0.158 |                  0.018 |           0.007 |
| CABA                          |       35966 |  97473 |        654 |               13.9 |              0.015 |              0.018 |            0.369 |           0.236 |                  0.021 |           0.009 |
| Chaco                         |        2497 |  14576 |        114 |               14.4 |              0.033 |              0.046 |            0.171 |           0.110 |                  0.061 |           0.024 |
| Río Negro                     |        1057 |   4992 |         46 |               13.5 |              0.040 |              0.044 |            0.212 |           0.395 |                  0.028 |           0.020 |
| Córdoba                       |         852 |  22765 |         37 |               24.3 |              0.019 |              0.043 |            0.037 |           0.151 |                  0.036 |           0.014 |
| SIN ESPECIFICAR               |         699 |   1871 |          2 |               34.5 |              0.002 |              0.003 |            0.374 |           0.144 |                  0.009 |           0.004 |
| Neuquén                       |         663 |   3051 |         19 |               17.5 |              0.023 |              0.029 |            0.217 |           0.564 |                  0.012 |           0.009 |
| Santa Fe                      |         486 |  14760 |          6 |               20.5 |              0.007 |              0.012 |            0.033 |           0.156 |                  0.039 |           0.016 |
| Entre Ríos                    |         401 |   2974 |          0 |                NaN |              0.000 |              0.000 |            0.135 |           0.242 |                  0.005 |           0.002 |
| Jujuy                         |         334 |   3218 |          1 |               22.0 |              0.001 |              0.003 |            0.104 |           0.009 |                  0.003 |           0.003 |
| Mendoza                       |         264 |   3728 |         10 |               13.1 |              0.021 |              0.038 |            0.071 |           0.860 |                  0.045 |           0.019 |
| Chubut                        |         198 |   1745 |          1 |               19.0 |              0.003 |              0.005 |            0.113 |           0.030 |                  0.005 |           0.005 |
| Tierra del Fuego              |         142 |   1695 |          1 |               24.0 |              0.006 |              0.007 |            0.084 |           0.049 |                  0.021 |           0.021 |
| La Rioja                      |         132 |   2610 |         11 |               11.8 |              0.056 |              0.083 |            0.051 |           0.121 |                  0.038 |           0.008 |
| Corrientes                    |         124 |   3592 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.008 |                  0.008 |           0.000 |
| Tucumán                       |          89 |   8581 |          4 |               14.2 |              0.008 |              0.045 |            0.010 |           0.225 |                  0.101 |           0.022 |
| Salta                         |          88 |   1266 |          2 |                2.5 |              0.013 |              0.023 |            0.070 |           0.330 |                  0.023 |           0.011 |
| Formosa                       |          75 |    776 |          0 |                NaN |              0.000 |              0.000 |            0.097 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    |          64 |    702 |          0 |                NaN |              0.000 |              0.000 |            0.091 |           0.438 |                  0.078 |           0.047 |
| Misiones                      |          43 |   1657 |          2 |                6.5 |              0.031 |              0.047 |            0.026 |           0.674 |                  0.140 |           0.070 |
| Santiago del Estero           |          39 |   3164 |          0 |                NaN |              0.000 |              0.000 |            0.012 |           0.051 |                  0.051 |           0.000 |
| Catamarca                     |          37 |   1046 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| San Luis                      |          12 |    621 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.667 |                  0.083 |           0.000 |
| La Pampa                      |           8 |    488 |          0 |                NaN |              0.000 |              0.000 |            0.016 |           0.125 |                  0.000 |           0.000 |
| San Juan                      |           8 |    865 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.625 |                  0.125 |           0.000 |

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
#> INFO  [21:26:11.095] Processing {current.group: }
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
|             13 | 2020-07-09              |                        81 |        1074 |   5511 |        596 |         61 |              0.047 |              0.057 |            0.195 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-07-09              |                       104 |        1743 |  11524 |        957 |        110 |              0.051 |              0.063 |            0.151 |           0.549 |                  0.095 |           0.056 |
|             15 | 2020-07-09              |                       123 |        2386 |  20234 |       1290 |        170 |              0.057 |              0.071 |            0.118 |           0.541 |                  0.091 |           0.051 |
|             16 | 2020-07-09              |                       130 |        3147 |  31827 |       1627 |        225 |              0.056 |              0.071 |            0.099 |           0.517 |                  0.082 |           0.044 |
|             17 | 2020-07-09              |                       134 |        4197 |  45876 |       2123 |        326 |              0.061 |              0.078 |            0.091 |           0.506 |                  0.074 |           0.039 |
|             18 | 2020-07-10              |                       135 |        5133 |  59059 |       2506 |        389 |              0.059 |              0.076 |            0.087 |           0.488 |                  0.067 |           0.035 |
|             19 | 2020-07-10              |                       135 |        6511 |  73178 |       3062 |        460 |              0.056 |              0.071 |            0.089 |           0.470 |                  0.062 |           0.032 |
|             20 | 2020-07-10              |                       135 |        8815 |  90530 |       3880 |        540 |              0.049 |              0.061 |            0.097 |           0.440 |                  0.056 |           0.028 |
|             21 | 2020-07-10              |                       135 |       13040 | 113923 |       5149 |        673 |              0.042 |              0.052 |            0.114 |           0.395 |                  0.049 |           0.025 |
|             22 | 2020-07-10              |                       135 |       18128 | 139255 |       6529 |        824 |              0.037 |              0.045 |            0.130 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-10              |                       135 |       24356 | 167430 |       7998 |        996 |              0.034 |              0.041 |            0.145 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-07-10              |                       135 |       33699 | 202371 |      10018 |       1175 |              0.029 |              0.035 |            0.167 |           0.297 |                  0.035 |           0.016 |
|             25 | 2020-07-10              |                       135 |       46238 | 243414 |      12178 |       1372 |              0.025 |              0.030 |            0.190 |           0.263 |                  0.030 |           0.013 |
|             26 | 2020-07-10              |                       135 |       63424 | 294444 |      14854 |       1599 |              0.021 |              0.025 |            0.215 |           0.234 |                  0.026 |           0.011 |
|             27 | 2020-07-10              |                       135 |       80951 | 342942 |      16938 |       1729 |              0.017 |              0.021 |            0.236 |           0.209 |                  0.023 |           0.010 |
|             28 | 2020-07-10              |                       135 |       94047 | 376946 |      18173 |       1774 |              0.014 |              0.019 |            0.249 |           0.193 |                  0.020 |           0.008 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [21:26:38.088] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [21:26:55.429] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [21:27:05.818] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [21:27:07.430] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [21:27:10.348] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [21:27:13.432] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [21:27:18.348] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [21:27:21.201] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [21:27:23.776] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [21:27:25.115] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [21:27:27.271] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [21:27:29.184] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [21:27:30.956] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [21:27:33.036] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [21:27:35.297] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [21:27:37.891] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [21:27:40.611] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [21:27:43.711] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [21:27:45.824] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [21:27:47.996] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [21:27:49.850] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [21:27:52.721] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [21:27:55.160] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [21:27:57.313] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [21:27:59.529] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 411
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
| Buenos Aires                  | M    |       25415 |       4261 |        497 |              0.014 |              0.020 |            0.295 |           0.168 |                  0.021 |           0.009 |
| Buenos Aires                  | F    |       24157 |       3562 |        364 |              0.010 |              0.015 |            0.263 |           0.147 |                  0.014 |           0.005 |
| CABA                          | F    |       18057 |       4202 |        285 |              0.013 |              0.016 |            0.353 |           0.233 |                  0.015 |           0.006 |
| CABA                          | M    |       17761 |       4227 |        359 |              0.017 |              0.020 |            0.387 |           0.238 |                  0.026 |           0.012 |
| Chaco                         | F    |        1256 |        134 |         44 |              0.025 |              0.035 |            0.171 |           0.107 |                  0.049 |           0.014 |
| Chaco                         | M    |        1239 |        140 |         70 |              0.040 |              0.056 |            0.171 |           0.113 |                  0.073 |           0.034 |
| Río Negro                     | F    |         544 |        210 |         17 |              0.029 |              0.031 |            0.201 |           0.386 |                  0.018 |           0.011 |
| Río Negro                     | M    |         513 |        207 |         29 |              0.051 |              0.057 |            0.225 |           0.404 |                  0.039 |           0.029 |
| Córdoba                       | M    |         437 |         55 |         18 |              0.019 |              0.041 |            0.039 |           0.126 |                  0.039 |           0.018 |
| Córdoba                       | F    |         413 |         73 |         19 |              0.019 |              0.046 |            0.036 |           0.177 |                  0.034 |           0.010 |
| SIN ESPECIFICAR               | F    |         382 |         51 |          0 |              0.000 |              0.000 |            0.347 |           0.134 |                  0.005 |           0.000 |
| Neuquén                       | F    |         348 |        196 |          9 |              0.021 |              0.026 |            0.232 |           0.563 |                  0.009 |           0.009 |
| Neuquén                       | M    |         315 |        178 |         10 |              0.025 |              0.032 |            0.203 |           0.565 |                  0.016 |           0.010 |
| SIN ESPECIFICAR               | M    |         315 |         49 |          1 |              0.003 |              0.003 |            0.415 |           0.156 |                  0.010 |           0.006 |
| Santa Fe                      | M    |         245 |         47 |          5 |              0.013 |              0.020 |            0.034 |           0.192 |                  0.053 |           0.029 |
| Santa Fe                      | F    |         241 |         29 |          1 |              0.002 |              0.004 |            0.032 |           0.120 |                  0.025 |           0.004 |
| Entre Ríos                    | M    |         214 |         54 |          0 |              0.000 |              0.000 |            0.143 |           0.252 |                  0.009 |           0.005 |
| Jujuy                         | M    |         198 |          3 |          1 |              0.001 |              0.005 |            0.096 |           0.015 |                  0.005 |           0.005 |
| Buenos Aires                  | NR   |         197 |         22 |          3 |              0.008 |              0.015 |            0.320 |           0.112 |                  0.025 |           0.005 |
| Entre Ríos                    | F    |         186 |         43 |          0 |              0.000 |              0.000 |            0.126 |           0.231 |                  0.000 |           0.000 |
| CABA                          | NR   |         148 |         49 |         10 |              0.037 |              0.068 |            0.332 |           0.331 |                  0.054 |           0.041 |
| Jujuy                         | F    |         135 |          0 |          0 |              0.000 |              0.000 |            0.120 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | M    |         132 |        117 |         10 |              0.045 |              0.076 |            0.070 |           0.886 |                  0.076 |           0.030 |
| Mendoza                       | F    |         130 |        108 |          0 |              0.000 |              0.000 |            0.071 |           0.831 |                  0.015 |           0.008 |
| Chubut                        | M    |         108 |          5 |          1 |              0.005 |              0.009 |            0.121 |           0.046 |                  0.009 |           0.009 |
| Chubut                        | F    |          89 |          1 |          0 |              0.000 |              0.000 |            0.106 |           0.011 |                  0.000 |           0.000 |
| Tierra del Fuego              | M    |          82 |          4 |          1 |              0.010 |              0.012 |            0.091 |           0.049 |                  0.037 |           0.037 |
| Corrientes                    | M    |          76 |          1 |          0 |              0.000 |              0.000 |            0.038 |           0.013 |                  0.000 |           0.000 |
| La Rioja                      | F    |          73 |         10 |          6 |              0.059 |              0.082 |            0.059 |           0.137 |                  0.041 |           0.014 |
| Formosa                       | M    |          64 |          0 |          0 |              0.000 |              0.000 |            0.138 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | M    |          59 |          6 |          5 |              0.054 |              0.085 |            0.044 |           0.102 |                  0.034 |           0.000 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.075 |           0.051 |                  0.000 |           0.000 |
| Salta                         | M    |          58 |         20 |          2 |              0.020 |              0.034 |            0.067 |           0.345 |                  0.034 |           0.017 |
| Tucumán                       | M    |          54 |         11 |          2 |              0.007 |              0.037 |            0.010 |           0.204 |                  0.056 |           0.000 |
| Corrientes                    | F    |          48 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.021 |           0.000 |
| Santa Cruz                    | M    |          41 |         15 |          0 |              0.000 |              0.000 |            0.102 |           0.366 |                  0.098 |           0.049 |
| Tucumán                       | F    |          35 |          9 |          2 |              0.010 |              0.057 |            0.011 |           0.257 |                  0.171 |           0.057 |
| Salta                         | F    |          30 |          9 |          0 |              0.000 |              0.000 |            0.077 |           0.300 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          30 |          1 |          0 |              0.000 |              0.000 |            0.014 |           0.033 |                  0.033 |           0.000 |
| Misiones                      | M    |          23 |         16 |          1 |              0.030 |              0.043 |            0.026 |           0.696 |                  0.174 |           0.087 |
| Santa Cruz                    | F    |          23 |         13 |          0 |              0.000 |              0.000 |            0.076 |           0.565 |                  0.043 |           0.043 |
| Catamarca                     | M    |          22 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.031 |              0.050 |            0.026 |           0.650 |                  0.100 |           0.050 |
| Catamarca                     | F    |          15 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | M    |          10 |          6 |          0 |              0.000 |              0.000 |            0.028 |           0.600 |                  0.100 |           0.000 |

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
#> Warning: Removed 32 rows containing missing values (position_stack).
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
