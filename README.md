
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
#> INFO  [08:28:37.101] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [08:28:45.255] Normalize 
#> INFO  [08:28:46.231] checkSoundness 
#> INFO  [08:28:46.723] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-15"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-15"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-15"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-15              |      111146 |       2050 |              0.013 |              0.018 |                       140 | 420848 |            0.264 |

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
| Buenos Aires                  |       60475 |       1010 |              0.012 |              0.017 |                       139 | 202153 |            0.299 |
| CABA                          |       40564 |        766 |              0.016 |              0.019 |                       138 | 107278 |            0.378 |
| Chaco                         |        2751 |        116 |              0.030 |              0.042 |                       126 |  16170 |            0.170 |
| Río Negro                     |        1194 |         53 |              0.040 |              0.044 |                       121 |   5412 |            0.221 |
| SIN ESPECIFICAR               |        1065 |          2 |              0.001 |              0.002 |                       116 |   2762 |            0.386 |
| Córdoba                       |        1020 |         37 |              0.017 |              0.036 |                       128 |  24420 |            0.042 |
| Neuquén                       |         796 |         20 |              0.021 |              0.025 |                       123 |   3423 |            0.233 |
| Santa Fe                      |         591 |          8 |              0.008 |              0.014 |                       124 |  15990 |            0.037 |
| Entre Ríos                    |         566 |          4 |              0.005 |              0.007 |                       121 |   3353 |            0.169 |
| Jujuy                         |         534 |          1 |              0.000 |              0.002 |                       117 |   4487 |            0.119 |
| Mendoza                       |         361 |         10 |              0.017 |              0.028 |                       127 |   4181 |            0.086 |
| Chubut                        |         217 |          2 |              0.004 |              0.009 |                       107 |   2099 |            0.103 |
| Tierra del Fuego              |         196 |          2 |              0.009 |              0.010 |                       118 |   1789 |            0.110 |
| La Rioja                      |         158 |         11 |              0.048 |              0.070 |                       112 |   2891 |            0.055 |
| Corrientes                    |         130 |          0 |              0.000 |              0.000 |                       118 |   3763 |            0.035 |
| Salta                         |         122 |          2 |              0.009 |              0.016 |                       116 |   1392 |            0.088 |

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
| Buenos Aires                  |       60475 | 202153 |       1010 |               13.0 |              0.012 |              0.017 |            0.299 |           0.148 |                  0.017 |           0.006 |
| CABA                          |       40564 | 107278 |        766 |               14.6 |              0.016 |              0.019 |            0.378 |           0.230 |                  0.020 |           0.009 |
| Chaco                         |        2751 |  16170 |        116 |               14.4 |              0.030 |              0.042 |            0.170 |           0.104 |                  0.057 |           0.022 |
| Río Negro                     |        1194 |   5412 |         53 |               14.3 |              0.040 |              0.044 |            0.221 |           0.387 |                  0.029 |           0.019 |
| SIN ESPECIFICAR               |        1065 |   2762 |          2 |               34.5 |              0.001 |              0.002 |            0.386 |           0.106 |                  0.007 |           0.003 |
| Córdoba                       |        1020 |  24420 |         37 |               24.3 |              0.017 |              0.036 |            0.042 |           0.128 |                  0.031 |           0.012 |
| Neuquén                       |         796 |   3423 |         20 |               18.6 |              0.021 |              0.025 |            0.233 |           0.627 |                  0.013 |           0.008 |
| Santa Fe                      |         591 |  15990 |          8 |               19.4 |              0.008 |              0.014 |            0.037 |           0.137 |                  0.032 |           0.014 |
| Entre Ríos                    |         566 |   3353 |          4 |                8.0 |              0.005 |              0.007 |            0.169 |           0.239 |                  0.009 |           0.002 |
| Jujuy                         |         534 |   4487 |          1 |               22.0 |              0.000 |              0.002 |            0.119 |           0.009 |                  0.004 |           0.004 |
| Mendoza                       |         361 |   4181 |         10 |               13.1 |              0.017 |              0.028 |            0.086 |           0.767 |                  0.042 |           0.017 |
| Chubut                        |         217 |   2099 |          2 |               10.5 |              0.004 |              0.009 |            0.103 |           0.065 |                  0.018 |           0.014 |
| Tierra del Fuego              |         196 |   1789 |          2 |               19.0 |              0.009 |              0.010 |            0.110 |           0.036 |                  0.015 |           0.015 |
| La Rioja                      |         158 |   2891 |         11 |               11.8 |              0.048 |              0.070 |            0.055 |           0.108 |                  0.025 |           0.006 |
| Corrientes                    |         130 |   3763 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.031 |                  0.008 |           0.000 |
| Salta                         |         122 |   1392 |          2 |                2.5 |              0.009 |              0.016 |            0.088 |           0.352 |                  0.016 |           0.008 |
| Tucumán                       |          92 |   8998 |          4 |               14.2 |              0.008 |              0.043 |            0.010 |           0.283 |                  0.098 |           0.022 |
| Formosa                       |          78 |    786 |          0 |                NaN |              0.000 |              0.000 |            0.099 |           0.013 |                  0.000 |           0.000 |
| Santa Cruz                    |          74 |    747 |          0 |                NaN |              0.000 |              0.000 |            0.099 |           0.405 |                  0.068 |           0.041 |
| Santiago del Estero           |          45 |   3461 |          0 |                NaN |              0.000 |              0.000 |            0.013 |           0.067 |                  0.044 |           0.000 |
| Misiones                      |          41 |   1704 |          2 |                6.5 |              0.019 |              0.049 |            0.024 |           0.707 |                  0.146 |           0.073 |
| Catamarca                     |          40 |   1514 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| San Luis                      |          14 |    657 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.571 |                  0.071 |           0.000 |
| San Juan                      |          13 |    900 |          0 |                NaN |              0.000 |              0.000 |            0.014 |           0.385 |                  0.077 |           0.000 |
| La Pampa                      |           9 |    518 |          0 |                NaN |              0.000 |              0.000 |            0.017 |           0.111 |                  0.000 |           0.000 |

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
#> INFO  [08:30:52.297] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 20
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% 
        filter(confirmados > 0) %>% 
        arrange(sepi_apertura, desc(confirmados)) %>% 
        select_at(c("sepi_apertura", "max_fecha_diagnostico", "count_fecha_diagnostico", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))
```

| sepi\_apertura | max\_fecha\_diagnostico | count\_fecha\_diagnostico | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| -------------: | :---------------------- | ------------------------: | ----------: | -----: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
|             10 | 2020-05-29              |                        19 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 | 2020-07-14              |                        36 |          94 |    666 |         64 |          9 |              0.067 |              0.096 |            0.141 |           0.681 |                  0.128 |           0.064 |
|             12 | 2020-07-14              |                        55 |         408 |   2048 |        252 |         17 |              0.034 |              0.042 |            0.199 |           0.618 |                  0.093 |           0.054 |
|             13 | 2020-07-14              |                        83 |        1075 |   5514 |        596 |         62 |              0.048 |              0.058 |            0.195 |           0.554 |                  0.095 |           0.057 |
|             14 | 2020-07-15              |                       109 |        1747 |  11529 |        960 |        111 |              0.052 |              0.064 |            0.152 |           0.550 |                  0.095 |           0.057 |
|             15 | 2020-07-15              |                       130 |        2396 |  20241 |       1297 |        172 |              0.057 |              0.072 |            0.118 |           0.541 |                  0.091 |           0.051 |
|             16 | 2020-07-15              |                       137 |        3162 |  31841 |       1635 |        227 |              0.056 |              0.072 |            0.099 |           0.517 |                  0.081 |           0.044 |
|             17 | 2020-07-15              |                       140 |        4223 |  45890 |       2134 |        328 |              0.061 |              0.078 |            0.092 |           0.505 |                  0.074 |           0.039 |
|             18 | 2020-07-15              |                       140 |        5169 |  59076 |       2518 |        391 |              0.060 |              0.076 |            0.087 |           0.487 |                  0.067 |           0.035 |
|             19 | 2020-07-15              |                       140 |        6560 |  73200 |       3079 |        465 |              0.056 |              0.071 |            0.090 |           0.469 |                  0.062 |           0.032 |
|             20 | 2020-07-15              |                       140 |        8876 |  90554 |       3900 |        545 |              0.050 |              0.061 |            0.098 |           0.439 |                  0.056 |           0.029 |
|             21 | 2020-07-15              |                       140 |       13128 | 113955 |       5178 |        680 |              0.042 |              0.052 |            0.115 |           0.394 |                  0.049 |           0.025 |
|             22 | 2020-07-15              |                       140 |       18244 | 139290 |       6572 |        836 |              0.038 |              0.046 |            0.131 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-15              |                       140 |       24520 | 167500 |       8058 |       1022 |              0.035 |              0.042 |            0.146 |           0.329 |                  0.041 |           0.019 |
|             24 | 2020-07-15              |                       140 |       33903 | 202493 |      10101 |       1216 |              0.030 |              0.036 |            0.167 |           0.298 |                  0.035 |           0.017 |
|             25 | 2020-07-15              |                       140 |       46497 | 243653 |      12309 |       1437 |              0.026 |              0.031 |            0.191 |           0.265 |                  0.030 |           0.014 |
|             26 | 2020-07-15              |                       140 |       63829 | 295041 |      15109 |       1706 |              0.022 |              0.027 |            0.216 |           0.237 |                  0.026 |           0.012 |
|             27 | 2020-07-15              |                       140 |       81759 | 344424 |      17440 |       1898 |              0.019 |              0.023 |            0.237 |           0.213 |                  0.024 |           0.010 |
|             28 | 2020-07-15              |                       140 |      103247 | 399614 |      19752 |       2025 |              0.016 |              0.020 |            0.258 |           0.191 |                  0.020 |           0.008 |
|             29 | 2020-07-15              |                       140 |      111146 | 420848 |      20487 |       2050 |              0.013 |              0.018 |            0.264 |           0.184 |                  0.019 |           0.008 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [08:31:31.221] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [08:31:46.741] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [08:31:56.704] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [08:31:58.171] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [08:32:01.975] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [08:32:04.135] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [08:32:08.860] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [08:32:11.415] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [08:32:13.969] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [08:32:15.731] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [08:32:18.638] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [08:32:20.888] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [08:32:23.010] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [08:32:25.489] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [08:32:27.564] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [08:32:29.833] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [08:32:32.341] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [08:32:34.460] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [08:32:36.560] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [08:32:38.658] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [08:32:40.902] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [08:32:44.520] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [08:32:46.891] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [08:32:49.220] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [08:32:51.597] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 436
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
| Buenos Aires                  | M    |       30881 |       4878 |        587 |              0.013 |              0.019 |            0.316 |           0.158 |                  0.020 |           0.008 |
| Buenos Aires                  | F    |       29364 |       4075 |        419 |              0.010 |              0.014 |            0.283 |           0.139 |                  0.013 |           0.004 |
| CABA                          | F    |       20333 |       4601 |        324 |              0.013 |              0.016 |            0.361 |           0.226 |                  0.015 |           0.006 |
| CABA                          | M    |       20066 |       4674 |        430 |              0.018 |              0.021 |            0.397 |           0.233 |                  0.026 |           0.012 |
| Chaco                         | F    |        1383 |        139 |         44 |              0.023 |              0.032 |            0.170 |           0.101 |                  0.047 |           0.013 |
| Chaco                         | M    |        1366 |        147 |         72 |              0.038 |              0.053 |            0.170 |           0.108 |                  0.067 |           0.031 |
| Río Negro                     | F    |         612 |        234 |         19 |              0.028 |              0.031 |            0.210 |           0.382 |                  0.018 |           0.010 |
| SIN ESPECIFICAR               | F    |         594 |         58 |          0 |              0.000 |              0.000 |            0.365 |           0.098 |                  0.005 |           0.000 |
| Río Negro                     | M    |         582 |        228 |         34 |              0.052 |              0.058 |            0.233 |           0.392 |                  0.041 |           0.029 |
| Córdoba                       | M    |         518 |         56 |         18 |              0.017 |              0.035 |            0.043 |           0.108 |                  0.033 |           0.015 |
| Córdoba                       | F    |         500 |         74 |         19 |              0.016 |              0.038 |            0.041 |           0.148 |                  0.030 |           0.008 |
| SIN ESPECIFICAR               | M    |         467 |         54 |          1 |              0.002 |              0.002 |            0.416 |           0.116 |                  0.006 |           0.004 |
| Neuquén                       | F    |         413 |        264 |         10 |              0.020 |              0.024 |            0.244 |           0.639 |                  0.010 |           0.007 |
| Neuquén                       | M    |         383 |        235 |         10 |              0.021 |              0.026 |            0.221 |           0.614 |                  0.016 |           0.008 |
| Jujuy                         | M    |         310 |          5 |          1 |              0.001 |              0.003 |            0.118 |           0.016 |                  0.006 |           0.006 |
| Santa Fe                      | M    |         296 |         50 |          6 |              0.013 |              0.020 |            0.038 |           0.169 |                  0.044 |           0.024 |
| Santa Fe                      | F    |         295 |         31 |          2 |              0.004 |              0.007 |            0.036 |           0.105 |                  0.020 |           0.003 |
| Entre Ríos                    | M    |         285 |         75 |          3 |              0.007 |              0.011 |            0.171 |           0.263 |                  0.011 |           0.004 |
| Entre Ríos                    | F    |         280 |         60 |          1 |              0.002 |              0.004 |            0.167 |           0.214 |                  0.007 |           0.000 |
| Buenos Aires                  | NR   |         230 |         27 |          4 |              0.010 |              0.017 |            0.336 |           0.117 |                  0.026 |           0.004 |
| Jujuy                         | F    |         223 |          0 |          0 |              0.000 |              0.000 |            0.121 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | M    |         181 |        142 |         10 |              0.034 |              0.055 |            0.087 |           0.785 |                  0.072 |           0.028 |
| Mendoza                       | F    |         178 |        133 |          0 |              0.000 |              0.000 |            0.086 |           0.747 |                  0.011 |           0.006 |
| CABA                          | NR   |         165 |         55 |         12 |              0.040 |              0.073 |            0.336 |           0.333 |                  0.055 |           0.042 |
| Tierra del Fuego              | M    |         136 |          4 |          2 |              0.013 |              0.015 |            0.139 |           0.029 |                  0.022 |           0.022 |
| Chubut                        | M    |         117 |          9 |          1 |              0.003 |              0.009 |            0.108 |           0.077 |                  0.017 |           0.017 |
| Chubut                        | F    |          97 |          5 |          1 |              0.004 |              0.010 |            0.098 |           0.052 |                  0.021 |           0.010 |
| La Rioja                      | F    |          83 |         10 |          6 |              0.050 |              0.072 |            0.060 |           0.120 |                  0.036 |           0.012 |
| Corrientes                    | M    |          79 |          3 |          0 |              0.000 |              0.000 |            0.037 |           0.038 |                  0.000 |           0.000 |
| Salta                         | M    |          78 |         28 |          2 |              0.014 |              0.026 |            0.083 |           0.359 |                  0.026 |           0.013 |
| La Rioja                      | M    |          75 |          7 |          5 |              0.045 |              0.067 |            0.050 |           0.093 |                  0.013 |           0.000 |
| Formosa                       | M    |          67 |          1 |          0 |              0.000 |              0.000 |            0.142 |           0.015 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.073 |           0.051 |                  0.000 |           0.000 |
| Tucumán                       | M    |          56 |         13 |          2 |              0.007 |              0.036 |            0.010 |           0.232 |                  0.054 |           0.000 |
| Corrientes                    | F    |          51 |          1 |          0 |              0.000 |              0.000 |            0.031 |           0.020 |                  0.020 |           0.000 |
| Salta                         | F    |          44 |         15 |          0 |              0.000 |              0.000 |            0.099 |           0.341 |                  0.000 |           0.000 |
| Santa Cruz                    | M    |          43 |         16 |          0 |              0.000 |              0.000 |            0.102 |           0.372 |                  0.093 |           0.047 |
| Tucumán                       | F    |          36 |         13 |          2 |              0.009 |              0.056 |            0.010 |           0.361 |                  0.167 |           0.056 |
| Santiago del Estero           | M    |          35 |          2 |          0 |              0.000 |              0.000 |            0.015 |           0.057 |                  0.029 |           0.000 |
| Santa Cruz                    | F    |          31 |         14 |          0 |              0.000 |              0.000 |            0.095 |           0.452 |                  0.032 |           0.032 |
| Catamarca                     | M    |          25 |          0 |          0 |              0.000 |              0.000 |            0.027 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          22 |         16 |          1 |              0.020 |              0.045 |            0.024 |           0.727 |                  0.182 |           0.091 |
| Misiones                      | F    |          19 |         13 |          1 |              0.019 |              0.053 |            0.024 |           0.684 |                  0.105 |           0.053 |
| Catamarca                     | F    |          15 |          0 |          0 |              0.000 |              0.000 |            0.026 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | M    |          12 |          6 |          0 |              0.000 |              0.000 |            0.032 |           0.500 |                  0.083 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          10 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.100 |                  0.100 |           0.000 |

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
#> Warning: Removed 15 rows containing missing values (position_stack).
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
