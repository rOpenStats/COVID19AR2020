
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
#> INFO  [22:00:13.864] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [22:00:16.510] Normalize 
#> INFO  [22:00:16.927] checkSoundness 
#> INFO  [22:00:17.180] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-28"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-28"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-28"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-28              |       59920 |       1232 |              0.015 |              0.021 |                       123 | 286084 |            0.209 |

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
| Buenos Aires                  |       28905 |        550 |              0.013 |              0.019 |                       122 | 128339 |            0.225 |
| CABA                          |       25112 |        468 |              0.015 |              0.019 |                       121 |  73493 |            0.342 |
| Chaco                         |        1928 |         92 |              0.032 |              0.048 |                       109 |  11433 |            0.169 |
| Río Negro                     |         826 |         41 |              0.045 |              0.050 |                       104 |   4074 |            0.203 |
| Córdoba                       |         635 |         36 |              0.028 |              0.057 |                       111 |  19864 |            0.032 |
| Neuquén                       |         443 |         12 |              0.021 |              0.027 |                       106 |   2412 |            0.184 |
| Santa Fe                      |         417 |          4 |              0.006 |              0.010 |                       107 |  12918 |            0.032 |
| SIN ESPECIFICAR               |         380 |          2 |              0.004 |              0.005 |                        99 |   1117 |            0.340 |
| Entre Ríos                    |         274 |          0 |              0.000 |              0.000 |                       104 |   2452 |            0.112 |
| Mendoza                       |         164 |         10 |              0.034 |              0.061 |                       110 |   2988 |            0.055 |
| Tierra del Fuego              |         136 |          1 |              0.007 |              0.007 |                       103 |   1629 |            0.083 |
| Chubut                        |         119 |          1 |              0.004 |              0.008 |                        90 |   1301 |            0.091 |
| Corrientes                    |         117 |          0 |              0.000 |              0.000 |                       102 |   3404 |            0.034 |

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
| Buenos Aires                  |       28905 | 128339 |        550 |               12.3 |              0.013 |              0.019 |            0.225 |           0.192 |                  0.021 |           0.008 |
| CABA                          |       25112 |  73493 |        468 |               14.1 |              0.015 |              0.019 |            0.342 |           0.255 |                  0.022 |           0.010 |
| Chaco                         |        1928 |  11433 |         92 |               13.9 |              0.032 |              0.048 |            0.169 |           0.126 |                  0.068 |           0.030 |
| Río Negro                     |         826 |   4074 |         41 |               12.7 |              0.045 |              0.050 |            0.203 |           0.452 |                  0.033 |           0.021 |
| Córdoba                       |         635 |  19864 |         36 |               24.9 |              0.028 |              0.057 |            0.032 |           0.194 |                  0.047 |           0.019 |
| Neuquén                       |         443 |   2412 |         12 |               17.5 |              0.021 |              0.027 |            0.184 |           0.623 |                  0.014 |           0.011 |
| Santa Fe                      |         417 |  12918 |          4 |               25.5 |              0.006 |              0.010 |            0.032 |           0.158 |                  0.034 |           0.017 |
| SIN ESPECIFICAR               |         380 |   1117 |          2 |               14.5 |              0.004 |              0.005 |            0.340 |           0.192 |                  0.018 |           0.008 |
| Entre Ríos                    |         274 |   2452 |          0 |                NaN |              0.000 |              0.000 |            0.112 |           0.259 |                  0.000 |           0.000 |
| Mendoza                       |         164 |   2988 |         10 |               13.1 |              0.034 |              0.061 |            0.055 |           0.927 |                  0.073 |           0.030 |
| Tierra del Fuego              |         136 |   1629 |          1 |               24.0 |              0.007 |              0.007 |            0.083 |           0.051 |                  0.022 |           0.022 |
| Chubut                        |         119 |   1301 |          1 |               19.0 |              0.004 |              0.008 |            0.091 |           0.034 |                  0.008 |           0.008 |
| Corrientes                    |         117 |   3404 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.009 |                  0.009 |           0.000 |
| Jujuy                         |          78 |   2555 |          1 |               22.0 |              0.003 |              0.013 |            0.031 |           0.026 |                  0.013 |           0.013 |
| La Rioja                      |          76 |   1857 |          8 |               12.0 |              0.063 |              0.105 |            0.041 |           0.184 |                  0.053 |           0.013 |
| Tucumán                       |          74 |   7532 |          4 |               14.2 |              0.011 |              0.054 |            0.010 |           0.243 |                  0.135 |           0.041 |
| Formosa                       |          69 |    762 |          0 |                NaN |              0.000 |              0.000 |            0.091 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    |          50 |    611 |          0 |                NaN |              0.000 |              0.000 |            0.082 |           0.420 |                  0.080 |           0.040 |
| Misiones                      |          40 |   1446 |          2 |                6.5 |              0.033 |              0.050 |            0.028 |           0.725 |                  0.150 |           0.075 |
| Salta                         |          27 |    994 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.778 |                  0.000 |           0.000 |
| Santiago del Estero           |          24 |   2578 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.042 |                  0.042 |           0.000 |
| San Luis                      |          11 |    506 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.727 |                  0.091 |           0.000 |
| San Juan                      |           8 |    801 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.625 |                  0.125 |           0.000 |
| La Pampa                      |           7 |    399 |          0 |                NaN |              0.000 |              0.000 |            0.018 |           0.143 |                  0.000 |           0.000 |

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
#> INFO  [22:01:07.625] Processing {current.group: }
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
|             14 | 2020-06-27              |                        99 |        1736 |  11523 |        954 |        110 |              0.051 |              0.063 |            0.151 |           0.550 |                  0.096 |           0.056 |
|             15 | 2020-06-27              |                       116 |        2370 |  20228 |       1283 |        170 |              0.056 |              0.072 |            0.117 |           0.541 |                  0.092 |           0.051 |
|             16 | 2020-06-27              |                       120 |        3116 |  31801 |       1615 |        224 |              0.055 |              0.072 |            0.098 |           0.518 |                  0.082 |           0.044 |
|             17 | 2020-06-27              |                       122 |        4145 |  45835 |       2102 |        324 |              0.060 |              0.078 |            0.090 |           0.507 |                  0.075 |           0.039 |
|             18 | 2020-06-28              |                       123 |        5052 |  59011 |       2477 |        386 |              0.059 |              0.076 |            0.086 |           0.490 |                  0.068 |           0.036 |
|             19 | 2020-06-28              |                       123 |        6394 |  73129 |       3018 |        454 |              0.055 |              0.071 |            0.087 |           0.472 |                  0.063 |           0.032 |
|             20 | 2020-06-28              |                       123 |        8652 |  90471 |       3809 |        527 |              0.048 |              0.061 |            0.096 |           0.440 |                  0.057 |           0.028 |
|             21 | 2020-06-28              |                       123 |       12828 | 113840 |       5042 |        652 |              0.041 |              0.051 |            0.113 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-06-28              |                       123 |       17849 | 139144 |       6397 |        788 |              0.036 |              0.044 |            0.128 |           0.358 |                  0.044 |           0.021 |
|             23 | 2020-06-28              |                       123 |       23978 | 167283 |       7810 |        937 |              0.032 |              0.039 |            0.143 |           0.326 |                  0.040 |           0.018 |
|             24 | 2020-06-28              |                       123 |       33199 | 202070 |       9730 |       1074 |              0.027 |              0.032 |            0.164 |           0.293 |                  0.034 |           0.016 |
|             25 | 2020-06-28              |                       123 |       45449 | 242749 |      11650 |       1177 |              0.021 |              0.026 |            0.187 |           0.256 |                  0.028 |           0.012 |
|             26 | 2020-06-28              |                       123 |       59752 | 285571 |      13464 |       1232 |              0.015 |              0.021 |            0.209 |           0.225 |                  0.024 |           0.010 |
|             27 | 2020-06-28              |                       123 |       59920 | 286084 |      13469 |       1232 |              0.015 |              0.021 |            0.209 |           0.225 |                  0.024 |           0.010 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [22:01:27.089] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [22:01:38.075] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [22:01:44.943] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [22:01:46.171] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [22:01:49.675] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [22:01:51.763] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [22:01:55.962] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [22:01:58.439] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [22:02:00.967] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [22:02:02.855] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [22:02:05.401] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [22:02:07.505] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [22:02:09.649] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [22:02:12.470] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [22:02:14.304] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [22:02:16.432] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [22:02:18.793] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [22:02:20.894] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [22:02:22.952] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [22:02:24.992] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [22:02:27.108] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [22:02:30.259] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [22:02:32.528] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [22:02:34.679] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [22:02:37.021] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 382
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
| Buenos Aires                  | M    |       14737 |       2977 |        328 |              0.015 |              0.022 |            0.239 |           0.202 |                  0.024 |           0.010 |
| Buenos Aires                  | F    |       14057 |       2552 |        220 |              0.010 |              0.016 |            0.212 |           0.182 |                  0.017 |           0.006 |
| CABA                          | F    |       12605 |       3185 |        200 |              0.013 |              0.016 |            0.327 |           0.253 |                  0.016 |           0.006 |
| CABA                          | M    |       12394 |       3196 |        261 |              0.017 |              0.021 |            0.359 |           0.258 |                  0.029 |           0.014 |
| Chaco                         | M    |         973 |        125 |         60 |              0.041 |              0.062 |            0.172 |           0.128 |                  0.081 |           0.041 |
| Chaco                         | F    |         953 |        117 |         32 |              0.022 |              0.034 |            0.166 |           0.123 |                  0.056 |           0.018 |
| Río Negro                     | F    |         417 |        185 |         13 |              0.028 |              0.031 |            0.190 |           0.444 |                  0.019 |           0.010 |
| Río Negro                     | M    |         409 |        188 |         28 |              0.062 |              0.068 |            0.218 |           0.460 |                  0.046 |           0.032 |
| Córdoba                       | M    |         324 |         52 |         17 |              0.027 |              0.052 |            0.033 |           0.160 |                  0.049 |           0.025 |
| Córdoba                       | F    |         309 |         70 |         19 |              0.029 |              0.061 |            0.031 |           0.227 |                  0.045 |           0.013 |
| Neuquén                       | F    |         231 |        143 |          5 |              0.017 |              0.022 |            0.196 |           0.619 |                  0.013 |           0.013 |
| Neuquén                       | M    |         212 |        133 |          7 |              0.025 |              0.033 |            0.172 |           0.627 |                  0.014 |           0.009 |
| Santa Fe                      | M    |         212 |         40 |          3 |              0.009 |              0.014 |            0.033 |           0.189 |                  0.047 |           0.028 |
| SIN ESPECIFICAR               | F    |         209 |         34 |          1 |              0.004 |              0.005 |            0.321 |           0.163 |                  0.014 |           0.000 |
| Santa Fe                      | F    |         205 |         26 |          1 |              0.003 |              0.005 |            0.031 |           0.127 |                  0.020 |           0.005 |
| SIN ESPECIFICAR               | M    |         169 |         38 |          0 |              0.000 |              0.000 |            0.372 |           0.225 |                  0.018 |           0.012 |
| Entre Ríos                    | M    |         143 |         43 |          0 |              0.000 |              0.000 |            0.114 |           0.301 |                  0.000 |           0.000 |
| Entre Ríos                    | F    |         130 |         28 |          0 |              0.000 |              0.000 |            0.109 |           0.215 |                  0.000 |           0.000 |
| CABA                          | NR   |         113 |         33 |          7 |              0.034 |              0.062 |            0.332 |           0.292 |                  0.053 |           0.035 |
| Buenos Aires                  | NR   |         111 |         18 |          2 |              0.010 |              0.018 |            0.276 |           0.162 |                  0.018 |           0.000 |
| Mendoza                       | M    |          88 |         83 |         10 |              0.068 |              0.114 |            0.057 |           0.943 |                  0.114 |           0.045 |
| Tierra del Fuego              | M    |          77 |          4 |          1 |              0.012 |              0.013 |            0.089 |           0.052 |                  0.039 |           0.039 |
| Mendoza                       | F    |          76 |         69 |          0 |              0.000 |              0.000 |            0.053 |           0.908 |                  0.026 |           0.013 |
| Corrientes                    | M    |          72 |          1 |          0 |              0.000 |              0.000 |            0.037 |           0.014 |                  0.000 |           0.000 |
| Chubut                        | M    |          70 |          3 |          1 |              0.008 |              0.014 |            0.101 |           0.043 |                  0.014 |           0.014 |
| Formosa                       | M    |          62 |          0 |          0 |              0.000 |              0.000 |            0.135 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.077 |           0.052 |                  0.000 |           0.000 |
| Chubut                        | F    |          48 |          1 |          0 |              0.000 |              0.000 |            0.080 |           0.021 |                  0.000 |           0.000 |
| Tucumán                       | M    |          47 |          9 |          2 |              0.009 |              0.043 |            0.010 |           0.191 |                  0.064 |           0.000 |
| Corrientes                    | F    |          45 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.022 |           0.000 |
| La Rioja                      | F    |          40 |         10 |          6 |              0.091 |              0.150 |            0.045 |           0.250 |                  0.075 |           0.025 |
| Jujuy                         | F    |          39 |          0 |          0 |              0.000 |              0.000 |            0.046 |           0.000 |                  0.000 |           0.000 |
| Jujuy                         | M    |          38 |          2 |          1 |              0.006 |              0.026 |            0.022 |           0.053 |                  0.026 |           0.026 |
| La Rioja                      | M    |          36 |          4 |          2 |              0.033 |              0.056 |            0.038 |           0.111 |                  0.028 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.089 |           0.387 |                  0.097 |           0.032 |
| Tucumán                       | F    |          27 |          9 |          2 |              0.014 |              0.074 |            0.009 |           0.333 |                  0.259 |           0.111 |
| Misiones                      | M    |          22 |         16 |          1 |              0.030 |              0.045 |            0.028 |           0.727 |                  0.182 |           0.091 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.073 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.037 |              0.056 |            0.027 |           0.722 |                  0.111 |           0.056 |
| Salta                         | M    |          18 |         14 |          0 |              0.000 |              0.000 |            0.026 |           0.778 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          17 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.059 |                  0.059 |           0.000 |

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
