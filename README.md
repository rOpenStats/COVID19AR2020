
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
#> INFO  [08:42:26.628] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [08:42:30.968] Normalize 
#> INFO  [08:42:31.492] checkSoundness 
#> INFO  [08:42:31.786] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-12"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-12"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-12"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-12              |      100153 |       1845 |              0.014 |              0.018 |                       137 | 392476 |            0.255 |

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
| Buenos Aires                  |       53508 |        907 |              0.012 |              0.017 |                       136 | 186950 |            0.286 |
| CABA                          |       37655 |        679 |              0.015 |              0.018 |                       135 | 101065 |            0.373 |
| Chaco                         |        2577 |        115 |              0.033 |              0.045 |                       123 |  15180 |            0.170 |
| Río Negro                     |        1096 |         47 |              0.039 |              0.043 |                       118 |   5084 |            0.216 |
| Córdoba                       |         916 |         37 |              0.020 |              0.040 |                       125 |  23295 |            0.039 |
| SIN ESPECIFICAR               |         829 |          2 |              0.002 |              0.002 |                       113 |   2178 |            0.381 |
| Neuquén                       |         693 |         19 |              0.022 |              0.027 |                       120 |   3176 |            0.218 |
| Santa Fe                      |         527 |          6 |              0.007 |              0.011 |                       121 |  15134 |            0.035 |
| Entre Ríos                    |         493 |          0 |              0.000 |              0.000 |                       118 |   3126 |            0.158 |
| Jujuy                         |         463 |          1 |              0.000 |              0.002 |                       114 |   3683 |            0.126 |
| Mendoza                       |         292 |         10 |              0.021 |              0.034 |                       124 |   3877 |            0.075 |
| Chubut                        |         206 |          2 |              0.005 |              0.010 |                       104 |   1888 |            0.109 |
| Tierra del Fuego              |         148 |          1 |              0.006 |              0.007 |                       116 |   1722 |            0.086 |
| La Rioja                      |         141 |         11 |              0.056 |              0.078 |                       109 |   2712 |            0.052 |
| Corrientes                    |         125 |          0 |              0.000 |              0.000 |                       115 |   3680 |            0.034 |
| Salta                         |         103 |          2 |              0.012 |              0.019 |                       113 |   1302 |            0.079 |

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
| Buenos Aires                  |       53508 | 186950 |        907 |               12.8 |              0.012 |              0.017 |            0.286 |           0.153 |                  0.017 |           0.007 |
| CABA                          |       37655 | 101065 |        679 |               14.2 |              0.015 |              0.018 |            0.373 |           0.232 |                  0.020 |           0.009 |
| Chaco                         |        2577 |  15180 |        115 |               14.5 |              0.033 |              0.045 |            0.170 |           0.106 |                  0.059 |           0.023 |
| Río Negro                     |        1096 |   5084 |         47 |               13.3 |              0.039 |              0.043 |            0.216 |           0.395 |                  0.028 |           0.019 |
| Córdoba                       |         916 |  23295 |         37 |               24.3 |              0.020 |              0.040 |            0.039 |           0.142 |                  0.035 |           0.013 |
| SIN ESPECIFICAR               |         829 |   2178 |          2 |               34.5 |              0.002 |              0.002 |            0.381 |           0.124 |                  0.007 |           0.004 |
| Neuquén                       |         693 |   3176 |         19 |               17.5 |              0.022 |              0.027 |            0.218 |           0.620 |                  0.014 |           0.009 |
| Santa Fe                      |         527 |  15134 |          6 |               20.5 |              0.007 |              0.011 |            0.035 |           0.150 |                  0.036 |           0.015 |
| Entre Ríos                    |         493 |   3126 |          0 |                NaN |              0.000 |              0.000 |            0.158 |           0.247 |                  0.006 |           0.002 |
| Jujuy                         |         463 |   3683 |          1 |               22.0 |              0.000 |              0.002 |            0.126 |           0.006 |                  0.002 |           0.002 |
| Mendoza                       |         292 |   3877 |         10 |               13.1 |              0.021 |              0.034 |            0.075 |           0.825 |                  0.041 |           0.017 |
| Chubut                        |         206 |   1888 |          2 |               10.5 |              0.005 |              0.010 |            0.109 |           0.044 |                  0.010 |           0.005 |
| Tierra del Fuego              |         148 |   1722 |          1 |               24.0 |              0.006 |              0.007 |            0.086 |           0.047 |                  0.020 |           0.020 |
| La Rioja                      |         141 |   2712 |         11 |               11.8 |              0.056 |              0.078 |            0.052 |           0.128 |                  0.028 |           0.007 |
| Corrientes                    |         125 |   3680 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.008 |                  0.008 |           0.000 |
| Salta                         |         103 |   1302 |          2 |                2.5 |              0.012 |              0.019 |            0.079 |           0.301 |                  0.019 |           0.010 |
| Tucumán                       |          89 |   8722 |          4 |               14.2 |              0.008 |              0.045 |            0.010 |           0.225 |                  0.101 |           0.022 |
| Formosa                       |          76 |    778 |          0 |                NaN |              0.000 |              0.000 |            0.098 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    |          64 |    712 |          0 |                NaN |              0.000 |              0.000 |            0.090 |           0.438 |                  0.078 |           0.047 |
| Misiones                      |          43 |   1664 |          2 |                6.5 |              0.025 |              0.047 |            0.026 |           0.698 |                  0.140 |           0.070 |
| Santiago del Estero           |          41 |   3183 |          0 |                NaN |              0.000 |              0.000 |            0.013 |           0.049 |                  0.049 |           0.000 |
| Catamarca                     |          39 |   1375 |          0 |                NaN |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| San Luis                      |          13 |    629 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.615 |                  0.077 |           0.000 |
| La Pampa                      |           8 |    490 |          0 |                NaN |              0.000 |              0.000 |            0.016 |           0.125 |                  0.000 |           0.000 |
| San Juan                      |           8 |    871 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.625 |                  0.125 |           0.000 |

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
#> INFO  [08:43:55.302] Processing {current.group: }
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
|             11 | 2020-06-18              |                        35 |          93 |    666 |         64 |          8 |              0.060 |              0.086 |            0.140 |           0.688 |                  0.129 |           0.065 |
|             12 | 2020-06-18              |                        54 |         407 |   2048 |        252 |         16 |              0.032 |              0.039 |            0.199 |           0.619 |                  0.093 |           0.054 |
|             13 | 2020-07-09              |                        81 |        1074 |   5511 |        596 |         61 |              0.047 |              0.057 |            0.195 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-07-11              |                       105 |        1743 |  11525 |        957 |        110 |              0.051 |              0.063 |            0.151 |           0.549 |                  0.095 |           0.056 |
|             15 | 2020-07-11              |                       126 |        2391 |  20236 |       1293 |        170 |              0.057 |              0.071 |            0.118 |           0.541 |                  0.091 |           0.051 |
|             16 | 2020-07-12              |                       134 |        3154 |  31834 |       1630 |        225 |              0.056 |              0.071 |            0.099 |           0.517 |                  0.081 |           0.044 |
|             17 | 2020-07-12              |                       137 |        4208 |  45883 |       2127 |        326 |              0.061 |              0.077 |            0.092 |           0.505 |                  0.074 |           0.039 |
|             18 | 2020-07-12              |                       137 |        5145 |  59068 |       2511 |        389 |              0.059 |              0.076 |            0.087 |           0.488 |                  0.067 |           0.035 |
|             19 | 2020-07-12              |                       137 |        6527 |  73187 |       3068 |        460 |              0.056 |              0.070 |            0.089 |           0.470 |                  0.062 |           0.032 |
|             20 | 2020-07-12              |                       137 |        8836 |  90539 |       3889 |        540 |              0.049 |              0.061 |            0.098 |           0.440 |                  0.056 |           0.029 |
|             21 | 2020-07-12              |                       137 |       13068 | 113934 |       5162 |        674 |              0.042 |              0.052 |            0.115 |           0.395 |                  0.049 |           0.025 |
|             22 | 2020-07-12              |                       137 |       18163 | 139267 |       6546 |        827 |              0.038 |              0.046 |            0.130 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-12              |                       137 |       24416 | 167450 |       8022 |       1003 |              0.034 |              0.041 |            0.146 |           0.329 |                  0.040 |           0.019 |
|             24 | 2020-07-12              |                       137 |       33772 | 202405 |      10049 |       1186 |              0.029 |              0.035 |            0.167 |           0.298 |                  0.035 |           0.016 |
|             25 | 2020-07-12              |                       137 |       46329 | 243482 |      12222 |       1391 |              0.025 |              0.030 |            0.190 |           0.264 |                  0.030 |           0.013 |
|             26 | 2020-07-12              |                       137 |       63559 | 294607 |      14942 |       1629 |              0.021 |              0.026 |            0.216 |           0.235 |                  0.026 |           0.011 |
|             27 | 2020-07-12              |                       137 |       81259 | 343491 |      17106 |       1768 |              0.018 |              0.022 |            0.237 |           0.211 |                  0.023 |           0.010 |
|             28 | 2020-07-12              |                       137 |       99932 | 391791 |      18895 |       1843 |              0.014 |              0.018 |            0.255 |           0.189 |                  0.020 |           0.008 |
|             29 | 2020-07-12              |                       137 |      100153 | 392476 |      18911 |       1845 |              0.014 |              0.018 |            0.255 |           0.189 |                  0.020 |           0.008 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [08:44:34.033] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [08:44:50.410] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [08:45:02.923] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [08:45:05.383] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [08:45:10.511] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [08:45:13.813] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [08:45:20.892] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [08:45:26.853] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [08:45:30.103] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [08:45:32.157] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [08:45:36.148] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [08:45:38.419] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [08:45:41.110] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [08:45:43.123] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [08:45:44.925] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [08:45:46.812] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [08:45:48.924] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [08:45:50.752] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [08:45:52.450] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [08:45:54.211] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [08:45:56.113] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [08:45:59.139] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [08:46:00.992] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [08:46:02.802] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [08:46:04.746] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 435
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
| Buenos Aires                  | M    |       27277 |       4452 |        522 |              0.014 |              0.019 |            0.303 |           0.163 |                  0.021 |           0.009 |
| Buenos Aires                  | F    |       26025 |       3709 |        382 |              0.010 |              0.015 |            0.271 |           0.143 |                  0.014 |           0.005 |
| CABA                          | F    |       18889 |       4331 |        292 |              0.013 |              0.015 |            0.356 |           0.229 |                  0.015 |           0.006 |
| CABA                          | M    |       18608 |       4366 |        375 |              0.017 |              0.020 |            0.391 |           0.235 |                  0.025 |           0.012 |
| Chaco                         | F    |        1292 |        134 |         44 |              0.025 |              0.034 |            0.170 |           0.104 |                  0.048 |           0.014 |
| Chaco                         | M    |        1283 |        140 |         71 |              0.041 |              0.055 |            0.170 |           0.109 |                  0.070 |           0.033 |
| Río Negro                     | F    |         559 |        217 |         17 |              0.027 |              0.030 |            0.204 |           0.388 |                  0.018 |           0.011 |
| Río Negro                     | M    |         537 |        216 |         30 |              0.051 |              0.056 |            0.229 |           0.402 |                  0.039 |           0.028 |
| Córdoba                       | M    |         465 |         55 |         18 |              0.020 |              0.039 |            0.040 |           0.118 |                  0.037 |           0.017 |
| SIN ESPECIFICAR               | F    |         456 |         52 |          0 |              0.000 |              0.000 |            0.356 |           0.114 |                  0.004 |           0.000 |
| Córdoba                       | F    |         449 |         74 |         19 |              0.021 |              0.042 |            0.038 |           0.165 |                  0.033 |           0.009 |
| SIN ESPECIFICAR               | M    |         369 |         50 |          1 |              0.002 |              0.003 |            0.417 |           0.136 |                  0.008 |           0.005 |
| Neuquén                       | F    |         359 |        226 |          9 |              0.021 |              0.025 |            0.230 |           0.630 |                  0.011 |           0.008 |
| Neuquén                       | M    |         334 |        204 |         10 |              0.024 |              0.030 |            0.207 |           0.611 |                  0.018 |           0.009 |
| Jujuy                         | M    |         272 |          3 |          1 |              0.001 |              0.004 |            0.119 |           0.011 |                  0.004 |           0.004 |
| Santa Fe                      | M    |         267 |         48 |          5 |              0.012 |              0.019 |            0.036 |           0.180 |                  0.049 |           0.026 |
| Santa Fe                      | F    |         260 |         31 |          1 |              0.002 |              0.004 |            0.033 |           0.119 |                  0.023 |           0.004 |
| Entre Ríos                    | M    |         256 |         68 |          0 |              0.000 |              0.000 |            0.164 |           0.266 |                  0.008 |           0.004 |
| Entre Ríos                    | F    |         236 |         54 |          0 |              0.000 |              0.000 |            0.152 |           0.229 |                  0.004 |           0.000 |
| Buenos Aires                  | NR   |         206 |         25 |          3 |              0.008 |              0.015 |            0.321 |           0.121 |                  0.029 |           0.005 |
| Jujuy                         | F    |         190 |          0 |          0 |              0.000 |              0.000 |            0.138 |           0.000 |                  0.000 |           0.000 |
| CABA                          | NR   |         158 |         53 |         12 |              0.043 |              0.076 |            0.339 |           0.335 |                  0.057 |           0.044 |
| Mendoza                       | M    |         147 |        125 |         10 |              0.043 |              0.068 |            0.076 |           0.850 |                  0.068 |           0.027 |
| Mendoza                       | F    |         143 |        114 |          0 |              0.000 |              0.000 |            0.075 |           0.797 |                  0.014 |           0.007 |
| Chubut                        | M    |         111 |          6 |          1 |              0.004 |              0.009 |            0.114 |           0.054 |                  0.009 |           0.009 |
| Chubut                        | F    |          92 |          3 |          1 |              0.006 |              0.011 |            0.103 |           0.033 |                  0.011 |           0.000 |
| Tierra del Fuego              | M    |          88 |          4 |          1 |              0.010 |              0.011 |            0.095 |           0.045 |                  0.034 |           0.034 |
| La Rioja                      | F    |          77 |         10 |          6 |              0.058 |              0.078 |            0.059 |           0.130 |                  0.039 |           0.013 |
| Corrientes                    | M    |          76 |          1 |          0 |              0.000 |              0.000 |            0.037 |           0.013 |                  0.000 |           0.000 |
| Salta                         | M    |          67 |         22 |          2 |              0.019 |              0.030 |            0.075 |           0.328 |                  0.030 |           0.015 |
| Formosa                       | M    |          65 |          0 |          0 |              0.000 |              0.000 |            0.139 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | M    |          64 |          8 |          5 |              0.054 |              0.078 |            0.046 |           0.125 |                  0.016 |           0.000 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.074 |           0.051 |                  0.000 |           0.000 |
| Tucumán                       | M    |          53 |         11 |          2 |              0.007 |              0.038 |            0.010 |           0.208 |                  0.057 |           0.000 |
| Corrientes                    | F    |          49 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.020 |           0.000 |
| Santa Cruz                    | M    |          40 |         15 |          0 |              0.000 |              0.000 |            0.099 |           0.375 |                  0.100 |           0.050 |
| Salta                         | F    |          36 |          9 |          0 |              0.000 |              0.000 |            0.089 |           0.250 |                  0.000 |           0.000 |
| Tucumán                       | F    |          36 |          9 |          2 |              0.010 |              0.056 |            0.011 |           0.250 |                  0.167 |           0.056 |
| Santiago del Estero           | M    |          32 |          1 |          0 |              0.000 |              0.000 |            0.015 |           0.031 |                  0.031 |           0.000 |
| Catamarca                     | M    |          24 |          0 |          0 |              0.000 |              0.000 |            0.028 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    | F    |          24 |         13 |          0 |              0.000 |              0.000 |            0.078 |           0.542 |                  0.042 |           0.042 |
| Misiones                      | M    |          23 |         17 |          1 |              0.024 |              0.043 |            0.026 |           0.739 |                  0.174 |           0.087 |
| Misiones                      | F    |          20 |         13 |          1 |              0.026 |              0.050 |            0.026 |           0.650 |                  0.100 |           0.050 |
| Catamarca                     | F    |          15 |          0 |          0 |              0.000 |              0.000 |            0.029 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | M    |          11 |          6 |          0 |              0.000 |              0.000 |            0.030 |           0.545 |                  0.091 |           0.000 |

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
