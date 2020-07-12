
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
#> INFO  [09:59:16.707] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [09:59:20.908] Normalize 
#> INFO  [09:59:21.630] checkSoundness 
#> INFO  [09:59:21.954] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-11"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-11"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-11"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-11              |       97492 |       1810 |              0.014 |              0.019 |                       136 | 385550 |            0.253 |

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
| Buenos Aires                  |       51878 |        885 |              0.012 |              0.017 |                       135 | 183278 |            0.283 |
| CABA                          |       36945 |        667 |              0.015 |              0.018 |                       134 |  99479 |            0.371 |
| Chaco                         |        2552 |        115 |              0.033 |              0.045 |                       122 |  14864 |            0.172 |
| Río Negro                     |        1082 |         46 |              0.038 |              0.043 |                       117 |   5050 |            0.214 |
| Córdoba                       |         882 |         37 |              0.020 |              0.042 |                       124 |  23086 |            0.038 |
| SIN ESPECIFICAR               |         776 |          2 |              0.002 |              0.003 |                       112 |   2054 |            0.378 |
| Neuquén                       |         676 |         19 |              0.023 |              0.028 |                       118 |   3120 |            0.217 |
| Santa Fe                      |         505 |          6 |              0.007 |              0.012 |                       120 |  14924 |            0.034 |
| Entre Ríos                    |         432 |          0 |              0.000 |              0.000 |                       117 |   3027 |            0.143 |
| Jujuy                         |         393 |          1 |              0.001 |              0.003 |                       113 |   3576 |            0.110 |
| Mendoza                       |         278 |         10 |              0.021 |              0.036 |                       123 |   3798 |            0.073 |
| Chubut                        |         205 |          2 |              0.005 |              0.010 |                       102 |   1822 |            0.113 |
| Tierra del Fuego              |         142 |          1 |              0.006 |              0.007 |                       114 |   1706 |            0.083 |
| La Rioja                      |         137 |         11 |              0.046 |              0.080 |                       108 |   2654 |            0.052 |
| Corrientes                    |         126 |          0 |              0.000 |              0.000 |                       114 |   3609 |            0.035 |
| Salta                         |         107 |          2 |              0.012 |              0.019 |                       112 |   1298 |            0.082 |

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
| Buenos Aires                  |       51878 | 183278 |        885 |               12.8 |              0.012 |              0.017 |            0.283 |           0.155 |                  0.018 |           0.007 |
| CABA                          |       36945 |  99479 |        667 |               14.1 |              0.015 |              0.018 |            0.371 |           0.234 |                  0.020 |           0.009 |
| Chaco                         |        2552 |  14864 |        115 |               14.5 |              0.033 |              0.045 |            0.172 |           0.107 |                  0.060 |           0.024 |
| Río Negro                     |        1082 |   5050 |         46 |               13.5 |              0.038 |              0.043 |            0.214 |           0.386 |                  0.028 |           0.019 |
| Córdoba                       |         882 |  23086 |         37 |               24.3 |              0.020 |              0.042 |            0.038 |           0.146 |                  0.035 |           0.014 |
| SIN ESPECIFICAR               |         776 |   2054 |          2 |               34.5 |              0.002 |              0.003 |            0.378 |           0.130 |                  0.008 |           0.004 |
| Neuquén                       |         676 |   3120 |         19 |               17.5 |              0.023 |              0.028 |            0.217 |           0.583 |                  0.015 |           0.009 |
| Santa Fe                      |         505 |  14924 |          6 |               20.5 |              0.007 |              0.012 |            0.034 |           0.152 |                  0.038 |           0.016 |
| Entre Ríos                    |         432 |   3027 |          0 |                NaN |              0.000 |              0.000 |            0.143 |           0.245 |                  0.005 |           0.002 |
| Jujuy                         |         393 |   3576 |          1 |               22.0 |              0.001 |              0.003 |            0.110 |           0.008 |                  0.003 |           0.003 |
| Mendoza                       |         278 |   3798 |         10 |               13.1 |              0.021 |              0.036 |            0.073 |           0.853 |                  0.043 |           0.018 |
| Chubut                        |         205 |   1822 |          2 |               10.5 |              0.005 |              0.010 |            0.113 |           0.044 |                  0.010 |           0.005 |
| Tierra del Fuego              |         142 |   1706 |          1 |               24.0 |              0.006 |              0.007 |            0.083 |           0.049 |                  0.021 |           0.021 |
| La Rioja                      |         137 |   2654 |         11 |               11.8 |              0.046 |              0.080 |            0.052 |           0.131 |                  0.036 |           0.007 |
| Corrientes                    |         126 |   3609 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.008 |                  0.008 |           0.000 |
| Salta                         |         107 |   1298 |          2 |                2.5 |              0.012 |              0.019 |            0.082 |           0.280 |                  0.019 |           0.009 |
| Tucumán                       |          89 |   8666 |          4 |               14.2 |              0.008 |              0.045 |            0.010 |           0.225 |                  0.101 |           0.022 |
| Formosa                       |          75 |    777 |          0 |                NaN |              0.000 |              0.000 |            0.097 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    |          63 |    702 |          0 |                NaN |              0.000 |              0.000 |            0.090 |           0.444 |                  0.079 |           0.048 |
| Misiones                      |          43 |   1660 |          2 |                6.5 |              0.025 |              0.047 |            0.026 |           0.674 |                  0.140 |           0.070 |
| Santiago del Estero           |          40 |   3181 |          0 |                NaN |              0.000 |              0.000 |            0.013 |           0.050 |                  0.050 |           0.000 |
| Catamarca                     |          38 |   1238 |          0 |                NaN |              0.000 |              0.000 |            0.031 |           0.000 |                  0.000 |           0.000 |
| San Luis                      |          12 |    624 |          0 |                NaN |              0.000 |              0.000 |            0.019 |           0.667 |                  0.083 |           0.000 |
| La Pampa                      |           8 |    490 |          0 |                NaN |              0.000 |              0.000 |            0.016 |           0.125 |                  0.000 |           0.000 |
| San Juan                      |           8 |    867 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.625 |                  0.125 |           0.000 |

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
#> INFO  [10:00:51.399] Processing {current.group: }
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
|             14 | 2020-07-11              |                       105 |        1743 |  11525 |        957 |        110 |              0.051 |              0.063 |            0.151 |           0.549 |                  0.095 |           0.056 |
|             15 | 2020-07-11              |                       126 |        2389 |  20236 |       1291 |        170 |              0.057 |              0.071 |            0.118 |           0.540 |                  0.091 |           0.051 |
|             16 | 2020-07-11              |                       133 |        3150 |  31832 |       1628 |        225 |              0.056 |              0.071 |            0.099 |           0.517 |                  0.082 |           0.044 |
|             17 | 2020-07-11              |                       136 |        4203 |  45881 |       2125 |        326 |              0.061 |              0.078 |            0.092 |           0.506 |                  0.074 |           0.039 |
|             18 | 2020-07-11              |                       136 |        5139 |  59066 |       2509 |        389 |              0.059 |              0.076 |            0.087 |           0.488 |                  0.067 |           0.035 |
|             19 | 2020-07-11              |                       136 |        6518 |  73185 |       3065 |        460 |              0.056 |              0.071 |            0.089 |           0.470 |                  0.062 |           0.032 |
|             20 | 2020-07-11              |                       136 |        8825 |  90537 |       3884 |        540 |              0.049 |              0.061 |            0.097 |           0.440 |                  0.056 |           0.028 |
|             21 | 2020-07-11              |                       136 |       13054 | 113932 |       5154 |        673 |              0.042 |              0.052 |            0.115 |           0.395 |                  0.049 |           0.025 |
|             22 | 2020-07-11              |                       136 |       18146 | 139265 |       6537 |        824 |              0.037 |              0.045 |            0.130 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-11              |                       136 |       24386 | 167446 |       8010 |        998 |              0.034 |              0.041 |            0.146 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-07-11              |                       136 |       33737 | 202389 |      10034 |       1179 |              0.029 |              0.035 |            0.167 |           0.297 |                  0.035 |           0.016 |
|             25 | 2020-07-11              |                       136 |       46287 | 243437 |      12203 |       1382 |              0.025 |              0.030 |            0.190 |           0.264 |                  0.030 |           0.013 |
|             26 | 2020-07-11              |                       136 |       63501 | 294540 |      14902 |       1615 |              0.021 |              0.025 |            0.216 |           0.235 |                  0.026 |           0.011 |
|             27 | 2020-07-11              |                       136 |       81142 | 343338 |      17028 |       1751 |              0.018 |              0.022 |            0.236 |           0.210 |                  0.023 |           0.010 |
|             28 | 2020-07-11              |                       136 |       97492 | 385550 |      18569 |       1810 |              0.014 |              0.019 |            0.253 |           0.190 |                  0.020 |           0.008 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [10:01:22.929] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [10:01:44.197] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [10:01:54.729] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [10:01:56.489] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [10:02:00.168] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [10:02:03.237] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [10:02:08.232] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [10:02:11.856] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [10:02:17.296] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [10:02:19.631] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [10:02:23.057] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [10:02:25.549] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [10:02:28.276] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [10:02:34.744] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [10:02:38.470] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [10:02:41.528] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [10:02:44.084] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [10:02:46.773] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [10:02:50.232] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [10:02:52.813] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [10:02:54.957] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [10:02:58.494] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [10:03:00.579] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [10:03:02.775] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [10:03:05.051] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       26461 |       4362 |        508 |              0.014 |              0.019 |            0.299 |           0.165 |                  0.021 |           0.009 |
| Buenos Aires                  | F    |       25215 |       3648 |        374 |              0.010 |              0.015 |            0.267 |           0.145 |                  0.014 |           0.005 |
| CABA                          | F    |       18551 |       4283 |        290 |              0.013 |              0.016 |            0.355 |           0.231 |                  0.015 |           0.006 |
| CABA                          | M    |       18240 |       4304 |        367 |              0.017 |              0.020 |            0.390 |           0.236 |                  0.026 |           0.012 |
| Chaco                         | F    |        1282 |        134 |         44 |              0.025 |              0.034 |            0.172 |           0.105 |                  0.048 |           0.014 |
| Chaco                         | M    |        1268 |        140 |         71 |              0.041 |              0.056 |            0.171 |           0.110 |                  0.071 |           0.033 |
| Río Negro                     | F    |         554 |        211 |         17 |              0.028 |              0.031 |            0.203 |           0.381 |                  0.018 |           0.011 |
| Río Negro                     | M    |         528 |        207 |         29 |              0.048 |              0.055 |            0.227 |           0.392 |                  0.038 |           0.028 |
| Córdoba                       | M    |         449 |         55 |         18 |              0.020 |              0.040 |            0.039 |           0.122 |                  0.038 |           0.018 |
| Córdoba                       | F    |         431 |         73 |         19 |              0.020 |              0.044 |            0.037 |           0.169 |                  0.032 |           0.009 |
| SIN ESPECIFICAR               | F    |         426 |         51 |          0 |              0.000 |              0.000 |            0.351 |           0.120 |                  0.005 |           0.000 |
| Neuquén                       | F    |         352 |        208 |          9 |              0.021 |              0.026 |            0.230 |           0.591 |                  0.011 |           0.009 |
| SIN ESPECIFICAR               | M    |         348 |         49 |          1 |              0.002 |              0.003 |            0.420 |           0.141 |                  0.009 |           0.006 |
| Neuquén                       | M    |         324 |        186 |         10 |              0.025 |              0.031 |            0.204 |           0.574 |                  0.019 |           0.009 |
| Santa Fe                      | M    |         256 |         47 |          5 |              0.012 |              0.020 |            0.035 |           0.184 |                  0.051 |           0.027 |
| Santa Fe                      | F    |         249 |         30 |          1 |              0.002 |              0.004 |            0.033 |           0.120 |                  0.024 |           0.004 |
| Jujuy                         | M    |         233 |          3 |          1 |              0.001 |              0.004 |            0.105 |           0.013 |                  0.004 |           0.004 |
| Entre Ríos                    | M    |         225 |         57 |          0 |              0.000 |              0.000 |            0.149 |           0.253 |                  0.009 |           0.004 |
| Entre Ríos                    | F    |         206 |         49 |          0 |              0.000 |              0.000 |            0.137 |           0.238 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |         202 |         24 |          3 |              0.008 |              0.015 |            0.321 |           0.119 |                  0.025 |           0.005 |
| Jujuy                         | F    |         159 |          0 |          0 |              0.000 |              0.000 |            0.120 |           0.000 |                  0.000 |           0.000 |
| CABA                          | NR   |         154 |         51 |         10 |              0.036 |              0.065 |            0.337 |           0.331 |                  0.052 |           0.039 |
| Mendoza                       | F    |         140 |        114 |          0 |              0.000 |              0.000 |            0.075 |           0.814 |                  0.014 |           0.007 |
| Mendoza                       | M    |         136 |        121 |         10 |              0.043 |              0.074 |            0.071 |           0.890 |                  0.074 |           0.029 |
| Chubut                        | M    |         110 |          6 |          1 |              0.005 |              0.009 |            0.119 |           0.055 |                  0.009 |           0.009 |
| Chubut                        | F    |          92 |          3 |          1 |              0.006 |              0.011 |            0.105 |           0.033 |                  0.011 |           0.000 |
| Tierra del Fuego              | M    |          82 |          4 |          1 |              0.010 |              0.012 |            0.090 |           0.049 |                  0.037 |           0.037 |
| Corrientes                    | M    |          77 |          1 |          0 |              0.000 |              0.000 |            0.038 |           0.013 |                  0.000 |           0.000 |
| La Rioja                      | F    |          74 |         10 |          6 |              0.047 |              0.081 |            0.058 |           0.135 |                  0.041 |           0.014 |
| Salta                         | M    |          71 |         21 |          2 |              0.018 |              0.028 |            0.080 |           0.296 |                  0.028 |           0.014 |
| Formosa                       | M    |          64 |          0 |          0 |              0.000 |              0.000 |            0.138 |           0.000 |                  0.000 |           0.000 |
| La Rioja                      | M    |          63 |          8 |          5 |              0.045 |              0.079 |            0.046 |           0.127 |                  0.032 |           0.000 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.074 |           0.051 |                  0.000 |           0.000 |
| Tucumán                       | M    |          53 |         11 |          2 |              0.007 |              0.038 |            0.010 |           0.208 |                  0.057 |           0.000 |
| Corrientes                    | F    |          49 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.020 |           0.000 |
| Santa Cruz                    | M    |          40 |         15 |          0 |              0.000 |              0.000 |            0.100 |           0.375 |                  0.100 |           0.050 |
| Salta                         | F    |          36 |          9 |          0 |              0.000 |              0.000 |            0.090 |           0.250 |                  0.000 |           0.000 |
| Tucumán                       | F    |          36 |          9 |          2 |              0.010 |              0.056 |            0.011 |           0.250 |                  0.167 |           0.056 |
| Santiago del Estero           | M    |          31 |          1 |          0 |              0.000 |              0.000 |            0.014 |           0.032 |                  0.032 |           0.000 |
| Catamarca                     | M    |          23 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | M    |          23 |         16 |          1 |              0.024 |              0.043 |            0.026 |           0.696 |                  0.174 |           0.087 |
| Santa Cruz                    | F    |          23 |         13 |          0 |              0.000 |              0.000 |            0.076 |           0.565 |                  0.043 |           0.043 |
| Misiones                      | F    |          20 |         13 |          1 |              0.026 |              0.050 |            0.026 |           0.650 |                  0.100 |           0.050 |
| Catamarca                     | F    |          15 |          0 |          0 |              0.000 |              0.000 |            0.033 |           0.000 |                  0.000 |           0.000 |
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
