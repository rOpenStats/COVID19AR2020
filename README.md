
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
#> INFO  [21:27:33.800] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [21:27:36.083] Normalize 
#> INFO  [21:27:36.442] checkSoundness 
#> INFO  [21:27:36.689] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-23"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-23"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-23"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-06-23              |       47203 |       1078 |              0.016 |              0.023 |                       118 | 249497 |            0.189 |

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
| Buenos Aires                  |       21639 |        470 |              0.014 |              0.022 |                       117 | 109282 |            0.198 |
| CABA                          |       20542 |        408 |              0.015 |              0.020 |                       116 |  63303 |            0.325 |
| Chaco                         |        1656 |         86 |              0.031 |              0.052 |                       104 |  10130 |            0.163 |
| Río Negro                     |         718 |         39 |              0.046 |              0.054 |                        99 |   3568 |            0.201 |
| Córdoba                       |         599 |         36 |              0.025 |              0.060 |                       106 |  18530 |            0.032 |
| Santa Fe                      |         369 |          4 |              0.006 |              0.011 |                       102 |  12065 |            0.031 |
| Neuquén                       |         352 |          8 |              0.018 |              0.023 |                       101 |   2167 |            0.162 |
| SIN ESPECIFICAR               |         311 |          2 |              0.005 |              0.006 |                        94 |    956 |            0.325 |
| Entre Ríos                    |         178 |          0 |              0.000 |              0.000 |                        99 |   2055 |            0.087 |
| Mendoza                       |         141 |          9 |              0.033 |              0.064 |                       105 |   2665 |            0.053 |
| Tierra del Fuego              |         136 |          0 |              0.000 |              0.000 |                        97 |   1597 |            0.085 |
| Corrientes                    |         116 |          0 |              0.000 |              0.000 |                        97 |   3312 |            0.035 |

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
| Buenos Aires                  |       21639 | 109282 |        470 |               12.3 |              0.014 |              0.022 |            0.198 |           0.216 |                  0.023 |           0.009 |
| CABA                          |       20542 |  63303 |        408 |               14.4 |              0.015 |              0.020 |            0.325 |           0.271 |                  0.024 |           0.011 |
| Chaco                         |        1656 |  10130 |         86 |               14.2 |              0.031 |              0.052 |            0.163 |           0.133 |                  0.054 |           0.031 |
| Río Negro                     |         718 |   3568 |         39 |               12.5 |              0.046 |              0.054 |            0.201 |           0.503 |                  0.038 |           0.024 |
| Córdoba                       |         599 |  18530 |         36 |               24.9 |              0.025 |              0.060 |            0.032 |           0.205 |                  0.050 |           0.020 |
| Santa Fe                      |         369 |  12065 |          4 |               25.5 |              0.006 |              0.011 |            0.031 |           0.171 |                  0.038 |           0.019 |
| Neuquén                       |         352 |   2167 |          8 |               22.7 |              0.018 |              0.023 |            0.162 |           0.776 |                  0.017 |           0.014 |
| SIN ESPECIFICAR               |         311 |    956 |          2 |                9.5 |              0.005 |              0.006 |            0.325 |           0.206 |                  0.019 |           0.010 |
| Entre Ríos                    |         178 |   2055 |          0 |                NaN |              0.000 |              0.000 |            0.087 |           0.287 |                  0.000 |           0.000 |
| Mendoza                       |         141 |   2665 |          9 |               13.3 |              0.033 |              0.064 |            0.053 |           0.929 |                  0.078 |           0.035 |
| Tierra del Fuego              |         136 |   1597 |          0 |                NaN |              0.000 |              0.000 |            0.085 |           0.051 |                  0.015 |           0.015 |
| Corrientes                    |         116 |   3312 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.017 |                  0.009 |           0.000 |
| Chubut                        |          99 |   1009 |          1 |               19.0 |              0.004 |              0.010 |            0.098 |           0.040 |                  0.010 |           0.010 |
| La Rioja                      |          65 |   1541 |          8 |               12.0 |              0.071 |              0.123 |            0.042 |           0.185 |                  0.062 |           0.015 |
| Tucumán                       |          58 |   6867 |          4 |               14.2 |              0.009 |              0.069 |            0.008 |           0.224 |                  0.138 |           0.034 |
| Santa Cruz                    |          51 |    584 |          0 |                NaN |              0.000 |              0.000 |            0.087 |           0.412 |                  0.078 |           0.039 |
| Formosa                       |          46 |    743 |          0 |                NaN |              0.000 |              0.000 |            0.062 |           0.000 |                  0.000 |           0.000 |
| Misiones                      |          38 |   1336 |          2 |                6.5 |              0.035 |              0.053 |            0.028 |           0.737 |                  0.132 |           0.079 |
| Santiago del Estero           |          23 |   2362 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.043 |                  0.043 |           0.000 |
| Salta                         |          22 |    880 |          0 |                NaN |              0.000 |              0.000 |            0.025 |           0.773 |                  0.000 |           0.000 |
| Jujuy                         |          17 |   2404 |          1 |               22.0 |              0.008 |              0.059 |            0.007 |           0.118 |                  0.059 |           0.059 |
| San Luis                      |          13 |    479 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.615 |                  0.077 |           0.000 |
| San Juan                      |           8 |    748 |          0 |                NaN |              0.000 |              0.000 |            0.011 |           0.625 |                  0.125 |           0.000 |
| La Pampa                      |           6 |    349 |          0 |                NaN |              0.000 |              0.000 |            0.017 |           0.167 |                  0.000 |           0.000 |

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
#> INFO  [21:28:19.231] Processing {current.group: }
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
|             14 | 2020-06-22              |                        96 |        1733 |  11521 |        953 |        110 |              0.051 |              0.063 |            0.150 |           0.550 |                  0.096 |           0.056 |
|             15 | 2020-06-23              |                       112 |        2365 |  20224 |       1281 |        170 |              0.056 |              0.072 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 | 2020-06-23              |                       116 |        3101 |  31789 |       1608 |        224 |              0.055 |              0.072 |            0.098 |           0.519 |                  0.083 |           0.044 |
|             17 | 2020-06-23              |                       118 |        4120 |  45820 |       2092 |        324 |              0.060 |              0.079 |            0.090 |           0.508 |                  0.075 |           0.039 |
|             18 | 2020-06-23              |                       118 |        5021 |  58994 |       2466 |        386 |              0.059 |              0.077 |            0.085 |           0.491 |                  0.069 |           0.036 |
|             19 | 2020-06-23              |                       118 |        6356 |  73111 |       3004 |        454 |              0.056 |              0.071 |            0.087 |           0.473 |                  0.063 |           0.032 |
|             20 | 2020-06-23              |                       118 |        8601 |  90445 |       3790 |        525 |              0.048 |              0.061 |            0.095 |           0.441 |                  0.057 |           0.028 |
|             21 | 2020-06-23              |                       118 |       12755 | 113806 |       5010 |        645 |              0.040 |              0.051 |            0.112 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-06-23              |                       118 |       17745 | 139098 |       6345 |        778 |              0.036 |              0.044 |            0.128 |           0.358 |                  0.043 |           0.021 |
|             23 | 2020-06-23              |                       118 |       23814 | 167189 |       7705 |        914 |              0.031 |              0.038 |            0.142 |           0.324 |                  0.039 |           0.018 |
|             24 | 2020-06-23              |                       118 |       32918 | 201819 |       9526 |       1019 |              0.025 |              0.031 |            0.163 |           0.289 |                  0.032 |           0.015 |
|             25 | 2020-06-23              |                       118 |       44472 | 240573 |      11248 |       1071 |              0.019 |              0.024 |            0.185 |           0.253 |                  0.027 |           0.012 |
|             26 | 2020-06-23              |                       118 |       47203 | 249497 |      11635 |       1078 |              0.016 |              0.023 |            0.189 |           0.246 |                  0.026 |           0.011 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [21:28:35.655] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [21:28:43.195] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [21:28:48.445] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [21:28:49.388] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [21:28:52.020] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [21:28:54.800] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [21:28:58.620] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [21:29:00.611] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [21:29:02.608] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [21:29:03.894] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [21:29:05.843] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [21:29:07.628] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [21:29:09.639] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [21:29:11.727] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [21:29:13.376] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [21:29:15.277] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [21:29:17.418] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [21:29:19.324] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [21:29:21.082] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [21:29:23.004] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [21:29:24.936] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [21:29:27.598] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [21:29:29.402] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [21:29:31.208] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [21:29:33.149] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       11044 |       2487 |        279 |              0.016 |              0.025 |            0.211 |           0.225 |                  0.028 |           0.012 |
| Buenos Aires                  | F    |       10509 |       2167 |        190 |              0.011 |              0.018 |            0.186 |           0.206 |                  0.019 |           0.007 |
| CABA                          | F    |       10338 |       2754 |        172 |              0.013 |              0.017 |            0.311 |           0.266 |                  0.017 |           0.006 |
| CABA                          | M    |       10106 |       2773 |        230 |              0.018 |              0.023 |            0.340 |           0.274 |                  0.031 |           0.016 |
| Chaco                         | M    |         830 |        111 |         55 |              0.039 |              0.066 |            0.166 |           0.134 |                  0.064 |           0.043 |
| Chaco                         | F    |         824 |        110 |         31 |              0.023 |              0.038 |            0.161 |           0.133 |                  0.045 |           0.019 |
| Río Negro                     | F    |         362 |        177 |         13 |              0.031 |              0.036 |            0.190 |           0.489 |                  0.022 |           0.011 |
| Río Negro                     | M    |         356 |        184 |         26 |              0.062 |              0.073 |            0.215 |           0.517 |                  0.053 |           0.037 |
| Córdoba                       | M    |         309 |         52 |         17 |              0.024 |              0.055 |            0.034 |           0.168 |                  0.052 |           0.026 |
| Córdoba                       | F    |         288 |         70 |         19 |              0.027 |              0.066 |            0.031 |           0.243 |                  0.049 |           0.014 |
| Santa Fe                      | M    |         188 |         38 |          3 |              0.009 |              0.016 |            0.032 |           0.202 |                  0.053 |           0.032 |
| Santa Fe                      | F    |         181 |         25 |          1 |              0.003 |              0.006 |            0.029 |           0.138 |                  0.022 |           0.006 |
| Neuquén                       | F    |         178 |        142 |          4 |              0.018 |              0.022 |            0.170 |           0.798 |                  0.017 |           0.017 |
| Neuquén                       | M    |         174 |        131 |          4 |              0.017 |              0.023 |            0.155 |           0.753 |                  0.017 |           0.011 |
| SIN ESPECIFICAR               | F    |         173 |         29 |          0 |              0.000 |              0.000 |            0.307 |           0.168 |                  0.017 |           0.000 |
| SIN ESPECIFICAR               | M    |         136 |         34 |          1 |              0.005 |              0.007 |            0.357 |           0.250 |                  0.015 |           0.015 |
| Entre Ríos                    | M    |         101 |         31 |          0 |              0.000 |              0.000 |            0.096 |           0.307 |                  0.000 |           0.000 |
| CABA                          | NR   |          98 |         30 |          6 |              0.032 |              0.061 |            0.329 |           0.306 |                  0.051 |           0.031 |
| Buenos Aires                  | NR   |          86 |         16 |          1 |              0.006 |              0.012 |            0.263 |           0.186 |                  0.023 |           0.000 |
| Mendoza                       | M    |          77 |         73 |          9 |              0.063 |              0.117 |            0.055 |           0.948 |                  0.117 |           0.052 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.091 |           0.052 |                  0.026 |           0.026 |
| Entre Ríos                    | F    |          76 |         20 |          0 |              0.000 |              0.000 |            0.076 |           0.263 |                  0.000 |           0.000 |
| Corrientes                    | M    |          71 |          1 |          0 |              0.000 |              0.000 |            0.038 |           0.014 |                  0.000 |           0.000 |
| Mendoza                       | F    |          64 |         58 |          0 |              0.000 |              0.000 |            0.051 |           0.906 |                  0.031 |           0.016 |
| Chubut                        | M    |          58 |          3 |          1 |              0.008 |              0.017 |            0.104 |           0.052 |                  0.017 |           0.017 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.078 |           0.052 |                  0.000 |           0.000 |
| Corrientes                    | F    |          45 |          1 |          0 |              0.000 |              0.000 |            0.031 |           0.022 |                  0.022 |           0.000 |
| Formosa                       | M    |          44 |          0 |          0 |              0.000 |              0.000 |            0.099 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | F    |          39 |          1 |          0 |              0.000 |              0.000 |            0.087 |           0.026 |                  0.000 |           0.000 |
| La Rioja                      | F    |          37 |          9 |          6 |              0.100 |              0.162 |            0.049 |           0.243 |                  0.081 |           0.027 |
| Tucumán                       | M    |          34 |          7 |          2 |              0.007 |              0.059 |            0.008 |           0.206 |                  0.088 |           0.000 |
| Santa Cruz                    | M    |          32 |         12 |          0 |              0.000 |              0.000 |            0.096 |           0.375 |                  0.094 |           0.031 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.039 |              0.071 |            0.036 |           0.107 |                  0.036 |           0.000 |
| Tucumán                       | F    |          24 |          6 |          2 |              0.012 |              0.083 |            0.009 |           0.250 |                  0.208 |           0.083 |
| Misiones                      | M    |          20 |         15 |          1 |              0.033 |              0.050 |            0.027 |           0.750 |                  0.150 |           0.100 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.076 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.037 |              0.056 |            0.030 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          16 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.062 |                  0.062 |           0.000 |
| Salta                         | M    |          12 |         10 |          0 |              0.000 |              0.000 |            0.020 |           0.833 |                  0.000 |           0.000 |
| Jujuy                         | M    |          10 |          2 |          1 |              0.015 |              0.100 |            0.006 |           0.200 |                  0.100 |           0.100 |
| Salta                         | F    |          10 |          7 |          0 |              0.000 |              0.000 |            0.036 |           0.700 |                  0.000 |           0.000 |
| San Luis                      | M    |          10 |          6 |          0 |              0.000 |              0.000 |            0.036 |           0.600 |                  0.100 |           0.000 |

``` r

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))

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
#> Warning: Removed 47 rows containing missing values (position_stack).
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
