
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
#> INFO  [23:01:51.310] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [23:01:53.997] Normalize 
#> INFO  [23:01:54.387] checkSoundness 
#> INFO  [23:01:54.625] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-29"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-29"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-29"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-29              |       62255 |       1280 |              0.015 |              0.021 |                       124 | 293367 |            0.212 |

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
| Buenos Aires                  |       30181 |        572 |              0.013 |              0.019 |                       123 | 132110 |            0.228 |
| CABA                          |       26050 |        491 |              0.015 |              0.019 |                       122 |  75916 |            0.343 |
| Chaco                         |        1961 |         94 |              0.032 |              0.048 |                       110 |  11638 |            0.168 |
| Río Negro                     |         849 |         41 |              0.044 |              0.048 |                       105 |   4150 |            0.205 |
| Córdoba                       |         637 |         37 |              0.027 |              0.058 |                       112 |  20011 |            0.032 |
| Neuquén                       |         461 |         13 |              0.023 |              0.028 |                       107 |   2471 |            0.187 |
| Santa Fe                      |         420 |          4 |              0.006 |              0.010 |                       108 |  13079 |            0.032 |
| SIN ESPECIFICAR               |         394 |          1 |              0.002 |              0.003 |                       100 |   1153 |            0.342 |
| Entre Ríos                    |         279 |          0 |              0.000 |              0.000 |                       105 |   2486 |            0.112 |
| Mendoza                       |         165 |         10 |              0.033 |              0.061 |                       111 |   3025 |            0.055 |
| Tierra del Fuego              |         136 |          1 |              0.006 |              0.007 |                       103 |   1629 |            0.083 |
| Chubut                        |         120 |          1 |              0.004 |              0.008 |                        91 |   1317 |            0.091 |
| Corrientes                    |         117 |          0 |              0.000 |              0.000 |                       103 |   3418 |            0.034 |

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
| Buenos Aires                  |       30181 | 132110 |        572 |               12.4 |              0.013 |              0.019 |            0.228 |           0.190 |                  0.021 |           0.008 |
| CABA                          |       26050 |  75916 |        491 |               14.1 |              0.015 |              0.019 |            0.343 |           0.253 |                  0.022 |           0.010 |
| Chaco                         |        1961 |  11638 |         94 |               14.2 |              0.032 |              0.048 |            0.168 |           0.123 |                  0.068 |           0.029 |
| Río Negro                     |         849 |   4150 |         41 |               12.7 |              0.044 |              0.048 |            0.205 |           0.442 |                  0.032 |           0.020 |
| Córdoba                       |         637 |  20011 |         37 |               24.3 |              0.027 |              0.058 |            0.032 |           0.196 |                  0.049 |           0.019 |
| Neuquén                       |         461 |   2471 |         13 |               18.1 |              0.023 |              0.028 |            0.187 |           0.601 |                  0.013 |           0.011 |
| Santa Fe                      |         420 |  13079 |          4 |               25.5 |              0.006 |              0.010 |            0.032 |           0.157 |                  0.033 |           0.017 |
| SIN ESPECIFICAR               |         394 |   1153 |          1 |               12.0 |              0.002 |              0.003 |            0.342 |           0.188 |                  0.015 |           0.008 |
| Entre Ríos                    |         279 |   2486 |          0 |                NaN |              0.000 |              0.000 |            0.112 |           0.258 |                  0.000 |           0.000 |
| Mendoza                       |         165 |   3025 |         10 |               13.1 |              0.033 |              0.061 |            0.055 |           0.933 |                  0.073 |           0.030 |
| Tierra del Fuego              |         136 |   1629 |          1 |               24.0 |              0.006 |              0.007 |            0.083 |           0.051 |                  0.022 |           0.022 |
| Chubut                        |         120 |   1317 |          1 |               19.0 |              0.004 |              0.008 |            0.091 |           0.033 |                  0.008 |           0.008 |
| Corrientes                    |         117 |   3418 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.009 |                  0.009 |           0.000 |
| Jujuy                         |          91 |   2629 |          1 |               22.0 |              0.002 |              0.011 |            0.035 |           0.022 |                  0.011 |           0.011 |
| La Rioja                      |          81 |   1878 |          8 |               12.0 |              0.067 |              0.099 |            0.043 |           0.185 |                  0.062 |           0.012 |
| Tucumán                       |          71 |   7604 |          4 |               14.2 |              0.011 |              0.056 |            0.009 |           0.254 |                  0.127 |           0.028 |
| Formosa                       |          70 |    763 |          0 |                NaN |              0.000 |              0.000 |            0.092 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    |          50 |    619 |          0 |                NaN |              0.000 |              0.000 |            0.081 |           0.420 |                  0.080 |           0.040 |
| Misiones                      |          40 |   1449 |          2 |                6.5 |              0.034 |              0.050 |            0.028 |           0.725 |                  0.150 |           0.075 |
| Salta                         |          30 |   1016 |          0 |                NaN |              0.000 |              0.000 |            0.030 |           0.767 |                  0.000 |           0.000 |
| Santiago del Estero           |          25 |   2644 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.040 |                  0.040 |           0.000 |
| San Luis                      |          11 |    528 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.727 |                  0.091 |           0.000 |
| La Pampa                      |           8 |    401 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.250 |                  0.000 |           0.000 |
| San Juan                      |           8 |    803 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.625 |                  0.125 |           0.000 |

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
#> INFO  [23:02:42.658] Processing {current.group: }
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
|             15 | 2020-06-28              |                       117 |        2371 |  20229 |       1284 |        170 |              0.057 |              0.072 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 | 2020-06-28              |                       121 |        3117 |  31802 |       1617 |        224 |              0.055 |              0.072 |            0.098 |           0.519 |                  0.082 |           0.044 |
|             17 | 2020-06-29              |                       124 |        4147 |  45838 |       2104 |        324 |              0.060 |              0.078 |            0.090 |           0.507 |                  0.075 |           0.039 |
|             18 | 2020-06-29              |                       124 |        5057 |  59014 |       2479 |        387 |              0.059 |              0.077 |            0.086 |           0.490 |                  0.068 |           0.036 |
|             19 | 2020-06-29              |                       124 |        6403 |  73132 |       3022 |        455 |              0.056 |              0.071 |            0.088 |           0.472 |                  0.063 |           0.032 |
|             20 | 2020-06-29              |                       124 |        8661 |  90474 |       3817 |        528 |              0.048 |              0.061 |            0.096 |           0.441 |                  0.056 |           0.028 |
|             21 | 2020-06-29              |                       124 |       12838 | 113843 |       5055 |        656 |              0.041 |              0.051 |            0.113 |           0.394 |                  0.049 |           0.025 |
|             22 | 2020-06-29              |                       124 |       17864 | 139149 |       6417 |        796 |              0.036 |              0.045 |            0.128 |           0.359 |                  0.044 |           0.021 |
|             23 | 2020-06-29              |                       124 |       23999 | 167293 |       7834 |        949 |              0.032 |              0.040 |            0.143 |           0.326 |                  0.040 |           0.019 |
|             24 | 2020-06-29              |                       124 |       33234 | 202099 |       9765 |       1091 |              0.027 |              0.033 |            0.164 |           0.294 |                  0.034 |           0.016 |
|             25 | 2020-06-29              |                       124 |       45526 | 242843 |      11712 |       1210 |              0.022 |              0.027 |            0.187 |           0.257 |                  0.029 |           0.013 |
|             26 | 2020-06-29              |                       124 |       60850 | 289212 |      13717 |       1277 |              0.016 |              0.021 |            0.210 |           0.225 |                  0.024 |           0.010 |
|             27 | 2020-06-29              |                       124 |       62255 | 293367 |      13845 |       1280 |              0.015 |              0.021 |            0.212 |           0.222 |                  0.024 |           0.010 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [23:03:00.936] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [23:03:09.671] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [23:03:15.540] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [23:03:16.528] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [23:03:19.221] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [23:03:20.999] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [23:03:25.061] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [23:03:27.746] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [23:03:30.069] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [23:03:31.695] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [23:03:33.856] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [23:03:35.784] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [23:03:37.790] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [23:03:39.989] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [23:03:41.879] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [23:03:43.972] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [23:03:46.294] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [23:03:48.790] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [23:03:50.950] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [23:03:53.018] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [23:03:55.051] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [23:03:58.058] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [23:04:00.063] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [23:04:02.073] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [23:04:04.259] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       15367 |       3076 |        342 |              0.015 |              0.022 |            0.242 |           0.200 |                  0.024 |           0.010 |
| Buenos Aires                  | F    |       14698 |       2638 |        228 |              0.010 |              0.016 |            0.215 |           0.179 |                  0.017 |           0.006 |
| CABA                          | F    |       13071 |       3271 |        214 |              0.013 |              0.016 |            0.328 |           0.250 |                  0.016 |           0.006 |
| CABA                          | M    |       12862 |       3288 |        269 |              0.017 |              0.021 |            0.360 |           0.256 |                  0.028 |           0.014 |
| Chaco                         | M    |         988 |        125 |         61 |              0.042 |              0.062 |            0.171 |           0.127 |                  0.080 |           0.040 |
| Chaco                         | F    |         971 |        117 |         33 |              0.023 |              0.034 |            0.166 |           0.120 |                  0.056 |           0.018 |
| Río Negro                     | F    |         429 |        186 |         13 |              0.027 |              0.030 |            0.192 |           0.434 |                  0.019 |           0.009 |
| Río Negro                     | M    |         420 |        189 |         28 |              0.060 |              0.067 |            0.220 |           0.450 |                  0.045 |           0.031 |
| Córdoba                       | M    |         326 |         54 |         18 |              0.026 |              0.055 |            0.033 |           0.166 |                  0.052 |           0.025 |
| Córdoba                       | F    |         309 |         70 |         19 |              0.027 |              0.061 |            0.031 |           0.227 |                  0.045 |           0.013 |
| Neuquén                       | F    |         238 |        144 |          6 |              0.020 |              0.025 |            0.198 |           0.605 |                  0.013 |           0.013 |
| Neuquén                       | M    |         223 |        133 |          7 |              0.025 |              0.031 |            0.176 |           0.596 |                  0.013 |           0.009 |
| SIN ESPECIFICAR               | F    |         214 |         34 |          0 |              0.000 |              0.000 |            0.316 |           0.159 |                  0.009 |           0.000 |
| Santa Fe                      | M    |         212 |         40 |          3 |              0.009 |              0.014 |            0.033 |           0.189 |                  0.047 |           0.028 |
| Santa Fe                      | F    |         208 |         26 |          1 |              0.003 |              0.005 |            0.031 |           0.125 |                  0.019 |           0.005 |
| SIN ESPECIFICAR               | M    |         178 |         39 |          0 |              0.000 |              0.000 |            0.383 |           0.219 |                  0.017 |           0.011 |
| Entre Ríos                    | M    |         145 |         43 |          0 |              0.000 |              0.000 |            0.114 |           0.297 |                  0.000 |           0.000 |
| Entre Ríos                    | F    |         133 |         29 |          0 |              0.000 |              0.000 |            0.110 |           0.218 |                  0.000 |           0.000 |
| CABA                          | NR   |         117 |         33 |          8 |              0.038 |              0.068 |            0.330 |           0.282 |                  0.051 |           0.034 |
| Buenos Aires                  | NR   |         116 |         18 |          2 |              0.009 |              0.017 |            0.280 |           0.155 |                  0.017 |           0.000 |
| Mendoza                       | M    |          88 |         83 |         10 |              0.065 |              0.114 |            0.056 |           0.943 |                  0.114 |           0.045 |
| Mendoza                       | F    |          77 |         71 |          0 |              0.000 |              0.000 |            0.053 |           0.922 |                  0.026 |           0.013 |
| Tierra del Fuego              | M    |          77 |          4 |          1 |              0.012 |              0.013 |            0.089 |           0.052 |                  0.039 |           0.039 |
| Corrientes                    | M    |          72 |          1 |          0 |              0.000 |              0.000 |            0.037 |           0.014 |                  0.000 |           0.000 |
| Chubut                        | M    |          70 |          3 |          1 |              0.008 |              0.014 |            0.100 |           0.043 |                  0.014 |           0.014 |
| Formosa                       | M    |          63 |          0 |          0 |              0.000 |              0.000 |            0.137 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.077 |           0.052 |                  0.000 |           0.000 |
| Chubut                        | F    |          49 |          1 |          0 |              0.000 |              0.000 |            0.080 |           0.020 |                  0.000 |           0.000 |
| Jujuy                         | M    |          48 |          2 |          1 |              0.004 |              0.021 |            0.028 |           0.042 |                  0.021 |           0.021 |
| Corrientes                    | F    |          45 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.022 |           0.000 |
| Tucumán                       | M    |          45 |         10 |          2 |              0.009 |              0.044 |            0.010 |           0.222 |                  0.067 |           0.000 |
| La Rioja                      | F    |          43 |         10 |          6 |              0.098 |              0.140 |            0.048 |           0.233 |                  0.070 |           0.023 |
| Jujuy                         | F    |          42 |          0 |          0 |              0.000 |              0.000 |            0.049 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | M    |          38 |          5 |          2 |              0.034 |              0.053 |            0.039 |           0.132 |                  0.053 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.088 |           0.387 |                  0.097 |           0.032 |
| Tucumán                       | F    |          26 |          8 |          2 |              0.013 |              0.077 |            0.009 |           0.308 |                  0.231 |           0.077 |
| Misiones                      | M    |          22 |         16 |          1 |              0.030 |              0.045 |            0.028 |           0.727 |                  0.182 |           0.091 |
| Salta                         | M    |          20 |         16 |          0 |              0.000 |              0.000 |            0.028 |           0.800 |                  0.000 |           0.000 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.071 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.038 |              0.056 |            0.027 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          17 |          1 |          0 |              0.000 |              0.000 |            0.009 |           0.059 |                  0.059 |           0.000 |
| Salta                         | F    |          10 |          7 |          0 |              0.000 |              0.000 |            0.033 |           0.700 |                  0.000 |           0.000 |

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
