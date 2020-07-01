
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
#> INFO  [11:56:44.652] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [11:56:47.561] Normalize 
#> INFO  [11:56:47.968] checkSoundness 
#> INFO  [11:56:48.207] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-30"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-30"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-30"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-30              |       64517 |       1307 |              0.014 |               0.02 |                       125 | 300191 |            0.215 |

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
| Buenos Aires                  |       31553 |        585 |              0.012 |              0.019 |                       124 | 135890 |            0.232 |
| CABA                          |       26782 |        503 |              0.015 |              0.019 |                       123 |  77801 |            0.344 |
| Chaco                         |        2031 |         96 |              0.032 |              0.047 |                       111 |  11876 |            0.171 |
| Río Negro                     |         864 |         41 |              0.042 |              0.047 |                       106 |   4236 |            0.204 |
| Córdoba                       |         648 |         37 |              0.025 |              0.057 |                       113 |  20189 |            0.032 |
| Neuquén                       |         479 |         13 |              0.021 |              0.027 |                       108 |   2495 |            0.192 |
| Santa Fe                      |         421 |          4 |              0.006 |              0.010 |                       109 |  13243 |            0.032 |
| SIN ESPECIFICAR               |         404 |          1 |              0.002 |              0.002 |                       101 |   1187 |            0.340 |
| Entre Ríos                    |         285 |          0 |              0.000 |              0.000 |                       106 |   2520 |            0.113 |
| Mendoza                       |         169 |         10 |              0.031 |              0.059 |                       112 |   3080 |            0.055 |
| Tierra del Fuego              |         136 |          1 |              0.006 |              0.007 |                       105 |   1640 |            0.083 |
| Chubut                        |         128 |          1 |              0.004 |              0.008 |                        92 |   1383 |            0.093 |
| Corrientes                    |         117 |          0 |              0.000 |              0.000 |                       104 |   3429 |            0.034 |

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
| Buenos Aires                  |       31553 | 135890 |        585 |               12.3 |              0.012 |              0.019 |            0.232 |           0.186 |                  0.021 |           0.008 |
| CABA                          |       26782 |  77801 |        503 |               14.1 |              0.015 |              0.019 |            0.344 |           0.251 |                  0.022 |           0.010 |
| Chaco                         |        2031 |  11876 |         96 |               14.1 |              0.032 |              0.047 |            0.171 |           0.122 |                  0.068 |           0.029 |
| Río Negro                     |         864 |   4236 |         41 |               12.7 |              0.042 |              0.047 |            0.204 |           0.435 |                  0.031 |           0.020 |
| Córdoba                       |         648 |  20189 |         37 |               24.3 |              0.025 |              0.057 |            0.032 |           0.198 |                  0.048 |           0.019 |
| Neuquén                       |         479 |   2495 |         13 |               18.1 |              0.021 |              0.027 |            0.192 |           0.601 |                  0.013 |           0.010 |
| Santa Fe                      |         421 |  13243 |          4 |               25.5 |              0.006 |              0.010 |            0.032 |           0.157 |                  0.033 |           0.017 |
| SIN ESPECIFICAR               |         404 |   1187 |          1 |               12.0 |              0.002 |              0.002 |            0.340 |           0.188 |                  0.015 |           0.007 |
| Entre Ríos                    |         285 |   2520 |          0 |                NaN |              0.000 |              0.000 |            0.113 |           0.263 |                  0.000 |           0.000 |
| Mendoza                       |         169 |   3080 |         10 |               13.1 |              0.031 |              0.059 |            0.055 |           0.929 |                  0.071 |           0.030 |
| Tierra del Fuego              |         136 |   1640 |          1 |               24.0 |              0.006 |              0.007 |            0.083 |           0.051 |                  0.022 |           0.022 |
| Chubut                        |         128 |   1383 |          1 |               19.0 |              0.004 |              0.008 |            0.093 |           0.031 |                  0.008 |           0.008 |
| Corrientes                    |         117 |   3429 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.009 |                  0.009 |           0.000 |
| Jujuy                         |          97 |   2661 |          1 |               22.0 |              0.002 |              0.010 |            0.036 |           0.021 |                  0.010 |           0.010 |
| La Rioja                      |          85 |   1919 |          8 |               12.0 |              0.048 |              0.094 |            0.044 |           0.176 |                  0.059 |           0.012 |
| Tucumán                       |          71 |   7666 |          4 |               14.2 |              0.010 |              0.056 |            0.009 |           0.254 |                  0.127 |           0.028 |
| Formosa                       |          70 |    764 |          0 |                NaN |              0.000 |              0.000 |            0.092 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    |          50 |    625 |          0 |                NaN |              0.000 |              0.000 |            0.080 |           0.420 |                  0.080 |           0.040 |
| Misiones                      |          42 |   1480 |          2 |                6.5 |              0.032 |              0.048 |            0.028 |           0.690 |                  0.143 |           0.071 |
| Salta                         |          33 |   1037 |          0 |                NaN |              0.000 |              0.000 |            0.032 |           0.727 |                  0.000 |           0.000 |
| Santiago del Estero           |          25 |   2678 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.040 |                  0.040 |           0.000 |
| San Luis                      |          11 |    530 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.727 |                  0.091 |           0.000 |
| La Pampa                      |           8 |    411 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.125 |                  0.000 |           0.000 |
| San Juan                      |           8 |    807 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.625 |                  0.125 |           0.000 |

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
#> INFO  [11:57:49.803] Processing {current.group: }
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
|             13 | 2020-06-24              |                        76 |        1069 |   5510 |        593 |         61 |              0.047 |              0.057 |            0.194 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-06-30              |                       100 |        1737 |  11523 |        954 |        110 |              0.051 |              0.063 |            0.151 |           0.549 |                  0.096 |           0.056 |
|             15 | 2020-06-30              |                       118 |        2372 |  20229 |       1284 |        170 |              0.057 |              0.072 |            0.117 |           0.541 |                  0.091 |           0.051 |
|             16 | 2020-06-30              |                       123 |        3118 |  31805 |       1617 |        225 |              0.055 |              0.072 |            0.098 |           0.519 |                  0.082 |           0.044 |
|             17 | 2020-06-30              |                       125 |        4148 |  45848 |       2104 |        325 |              0.061 |              0.078 |            0.090 |           0.507 |                  0.075 |           0.039 |
|             18 | 2020-06-30              |                       125 |        5061 |  59025 |       2480 |        388 |              0.059 |              0.077 |            0.086 |           0.490 |                  0.068 |           0.036 |
|             19 | 2020-06-30              |                       125 |        6410 |  73143 |       3025 |        456 |              0.056 |              0.071 |            0.088 |           0.472 |                  0.063 |           0.032 |
|             20 | 2020-06-30              |                       125 |        8670 |  90489 |       3821 |        529 |              0.048 |              0.061 |            0.096 |           0.441 |                  0.056 |           0.028 |
|             21 | 2020-06-30              |                       125 |       12850 | 113860 |       5059 |        657 |              0.041 |              0.051 |            0.113 |           0.394 |                  0.049 |           0.025 |
|             22 | 2020-06-30              |                       125 |       17881 | 139171 |       6422 |        798 |              0.036 |              0.045 |            0.128 |           0.359 |                  0.044 |           0.021 |
|             23 | 2020-06-30              |                       125 |       24026 | 167320 |       7847 |        953 |              0.033 |              0.040 |            0.144 |           0.327 |                  0.040 |           0.019 |
|             24 | 2020-06-30              |                       125 |       33278 | 202137 |       9792 |       1098 |              0.027 |              0.033 |            0.165 |           0.294 |                  0.034 |           0.016 |
|             25 | 2020-06-30              |                       125 |       45607 | 242934 |      11764 |       1224 |              0.022 |              0.027 |            0.188 |           0.258 |                  0.029 |           0.013 |
|             26 | 2020-06-30              |                       125 |       61523 | 291036 |      13893 |       1302 |              0.017 |              0.021 |            0.211 |           0.226 |                  0.024 |           0.010 |
|             27 | 2020-06-30              |                       125 |       64517 | 300191 |      14141 |       1307 |              0.014 |              0.020 |            0.215 |           0.219 |                  0.023 |           0.010 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [11:58:13.093] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [11:58:30.457] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [11:58:38.166] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [11:58:39.342] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [11:58:42.920] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [11:58:45.220] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [11:58:49.523] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [11:58:51.993] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [11:58:54.409] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [11:58:56.092] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [11:58:58.475] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [11:59:01.011] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [11:59:03.364] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [11:59:06.550] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [11:59:08.784] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [11:59:11.577] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [11:59:14.098] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [11:59:16.393] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [11:59:18.526] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [11:59:20.763] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [11:59:22.851] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [11:59:26.394] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [11:59:28.470] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [11:59:30.644] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [11:59:33.108] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 384
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
| Buenos Aires                  | M    |       16078 |       3139 |        347 |              0.014 |              0.022 |            0.247 |           0.195 |                  0.024 |           0.010 |
| Buenos Aires                  | F    |       15354 |       2702 |        236 |              0.010 |              0.015 |            0.219 |           0.176 |                  0.017 |           0.006 |
| CABA                          | F    |       13412 |       3330 |        220 |              0.013 |              0.016 |            0.329 |           0.248 |                  0.015 |           0.006 |
| CABA                          | M    |       13250 |       3369 |        275 |              0.017 |              0.021 |            0.362 |           0.254 |                  0.028 |           0.014 |
| Chaco                         | M    |        1019 |        128 |         61 |              0.040 |              0.060 |            0.173 |           0.126 |                  0.080 |           0.039 |
| Chaco                         | F    |        1010 |        120 |         35 |              0.024 |              0.035 |            0.169 |           0.119 |                  0.055 |           0.018 |
| Río Negro                     | F    |         433 |        187 |         13 |              0.027 |              0.030 |            0.190 |           0.432 |                  0.018 |           0.009 |
| Río Negro                     | M    |         431 |        189 |         28 |              0.058 |              0.065 |            0.220 |           0.439 |                  0.044 |           0.030 |
| Córdoba                       | M    |         331 |         54 |         18 |              0.025 |              0.054 |            0.033 |           0.163 |                  0.051 |           0.024 |
| Córdoba                       | F    |         315 |         73 |         19 |              0.025 |              0.060 |            0.031 |           0.232 |                  0.044 |           0.013 |
| Neuquén                       | F    |         244 |        148 |          6 |              0.019 |              0.025 |            0.202 |           0.607 |                  0.012 |           0.012 |
| Neuquén                       | M    |         235 |        140 |          7 |              0.022 |              0.030 |            0.183 |           0.596 |                  0.013 |           0.009 |
| SIN ESPECIFICAR               | F    |         221 |         36 |          0 |              0.000 |              0.000 |            0.315 |           0.163 |                  0.009 |           0.000 |
| Santa Fe                      | M    |         213 |         40 |          3 |              0.009 |              0.014 |            0.033 |           0.188 |                  0.047 |           0.028 |
| Santa Fe                      | F    |         208 |         26 |          1 |              0.003 |              0.005 |            0.031 |           0.125 |                  0.019 |           0.005 |
| SIN ESPECIFICAR               | M    |         181 |         39 |          0 |              0.000 |              0.000 |            0.381 |           0.215 |                  0.017 |           0.011 |
| Entre Ríos                    | M    |         148 |         44 |          0 |              0.000 |              0.000 |            0.116 |           0.297 |                  0.000 |           0.000 |
| Entre Ríos                    | F    |         136 |         31 |          0 |              0.000 |              0.000 |            0.110 |           0.228 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |         121 |         18 |          2 |              0.008 |              0.017 |            0.281 |           0.149 |                  0.017 |           0.000 |
| CABA                          | NR   |         120 |         33 |          8 |              0.037 |              0.067 |            0.331 |           0.275 |                  0.050 |           0.033 |
| Mendoza                       | M    |          90 |         85 |         10 |              0.060 |              0.111 |            0.057 |           0.944 |                  0.111 |           0.044 |
| Mendoza                       | F    |          79 |         72 |          0 |              0.000 |              0.000 |            0.053 |           0.911 |                  0.025 |           0.013 |
| Tierra del Fuego              | M    |          77 |          4 |          1 |              0.012 |              0.013 |            0.088 |           0.052 |                  0.039 |           0.039 |
| Corrientes                    | M    |          72 |          1 |          0 |              0.000 |              0.000 |            0.037 |           0.014 |                  0.000 |           0.000 |
| Chubut                        | M    |          71 |          3 |          1 |              0.009 |              0.014 |            0.098 |           0.042 |                  0.014 |           0.014 |
| Formosa                       | M    |          63 |          0 |          0 |              0.000 |              0.000 |            0.137 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.076 |           0.052 |                  0.000 |           0.000 |
| Chubut                        | F    |          52 |          1 |          0 |              0.000 |              0.000 |            0.081 |           0.019 |                  0.000 |           0.000 |
| Jujuy                         | M    |          52 |          2 |          1 |              0.004 |              0.019 |            0.030 |           0.038 |                  0.019 |           0.019 |
| Corrientes                    | F    |          45 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.022 |           0.000 |
| Tucumán                       | M    |          45 |         10 |          2 |              0.009 |              0.044 |            0.009 |           0.222 |                  0.067 |           0.000 |
| Jujuy                         | F    |          44 |          0 |          0 |              0.000 |              0.000 |            0.050 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | F    |          43 |         10 |          6 |              0.075 |              0.140 |            0.047 |           0.233 |                  0.070 |           0.023 |
| La Rioja                      | M    |          42 |          5 |          2 |              0.024 |              0.048 |            0.042 |           0.119 |                  0.048 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.087 |           0.387 |                  0.097 |           0.032 |
| Tucumán                       | F    |          26 |          8 |          2 |              0.013 |              0.077 |            0.009 |           0.308 |                  0.231 |           0.077 |
| Misiones                      | M    |          24 |         16 |          1 |              0.028 |              0.042 |            0.030 |           0.667 |                  0.167 |           0.083 |
| Salta                         | M    |          22 |         16 |          0 |              0.000 |              0.000 |            0.031 |           0.727 |                  0.000 |           0.000 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.071 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.038 |              0.056 |            0.027 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          17 |          1 |          0 |              0.000 |              0.000 |            0.009 |           0.059 |                  0.059 |           0.000 |
| Salta                         | F    |          11 |          8 |          0 |              0.000 |              0.000 |            0.035 |           0.727 |                  0.000 |           0.000 |

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
