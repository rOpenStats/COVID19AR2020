
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
#> INFO  [21:16:10.366] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [21:16:14.141] Normalize 
#> INFO  [21:16:14.726] checkSoundness 
#> INFO  [21:16:15.054] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-09"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-09"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-09"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-09              |       90680 |       1720 |              0.014 |              0.019 |                       134 | 368359 |            0.246 |

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
| Buenos Aires                  |       47655 |        834 |              0.012 |              0.018 |                       133 | 173970 |            0.274 |
| CABA                          |       35002 |        634 |              0.015 |              0.018 |                       132 |  95441 |            0.367 |
| Chaco                         |        2446 |        113 |              0.032 |              0.046 |                       120 |  14242 |            0.172 |
| Río Negro                     |        1031 |         46 |              0.040 |              0.045 |                       115 |   4908 |            0.210 |
| Córdoba                       |         826 |         37 |              0.021 |              0.045 |                       122 |  22557 |            0.037 |
| Neuquén                       |         649 |         18 |              0.023 |              0.028 |                       117 |   2997 |            0.217 |
| SIN ESPECIFICAR               |         612 |          2 |              0.002 |              0.003 |                       110 |   1667 |            0.367 |
| Santa Fe                      |         480 |          6 |              0.008 |              0.013 |                       118 |  14635 |            0.033 |
| Entre Ríos                    |         376 |          0 |              0.000 |              0.000 |                       115 |   2909 |            0.129 |
| Jujuy                         |         313 |          1 |              0.001 |              0.003 |                       111 |   3068 |            0.102 |
| Mendoza                       |         252 |         10 |              0.021 |              0.040 |                       121 |   3624 |            0.070 |
| Chubut                        |         194 |          1 |              0.003 |              0.005 |                       101 |   1692 |            0.115 |
| Tierra del Fuego              |         142 |          1 |              0.006 |              0.007 |                       113 |   1686 |            0.084 |
| La Rioja                      |         126 |          9 |              0.048 |              0.071 |                       106 |   2513 |            0.050 |
| Corrientes                    |         125 |          0 |              0.000 |              0.000 |                       112 |   3560 |            0.035 |

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
| Buenos Aires                  |       47655 | 173970 |        834 |               13.0 |              0.012 |              0.018 |            0.274 |           0.161 |                  0.018 |           0.007 |
| CABA                          |       35002 |  95441 |        634 |               14.0 |              0.015 |              0.018 |            0.367 |           0.238 |                  0.021 |           0.009 |
| Chaco                         |        2446 |  14242 |        113 |               14.3 |              0.032 |              0.046 |            0.172 |           0.112 |                  0.062 |           0.025 |
| Río Negro                     |        1031 |   4908 |         46 |               13.5 |              0.040 |              0.045 |            0.210 |           0.399 |                  0.029 |           0.020 |
| Córdoba                       |         826 |  22557 |         37 |               24.3 |              0.021 |              0.045 |            0.037 |           0.156 |                  0.038 |           0.015 |
| Neuquén                       |         649 |   2997 |         18 |               18.1 |              0.023 |              0.028 |            0.217 |           0.550 |                  0.012 |           0.009 |
| SIN ESPECIFICAR               |         612 |   1667 |          2 |               34.5 |              0.002 |              0.003 |            0.367 |           0.158 |                  0.010 |           0.005 |
| Santa Fe                      |         480 |  14635 |          6 |               20.5 |              0.008 |              0.013 |            0.033 |           0.154 |                  0.040 |           0.017 |
| Entre Ríos                    |         376 |   2909 |          0 |                NaN |              0.000 |              0.000 |            0.129 |           0.234 |                  0.005 |           0.003 |
| Jujuy                         |         313 |   3068 |          1 |               22.0 |              0.001 |              0.003 |            0.102 |           0.010 |                  0.003 |           0.003 |
| Mendoza                       |         252 |   3624 |         10 |               13.1 |              0.021 |              0.040 |            0.070 |           0.877 |                  0.048 |           0.020 |
| Chubut                        |         194 |   1692 |          1 |               19.0 |              0.003 |              0.005 |            0.115 |           0.031 |                  0.005 |           0.005 |
| Tierra del Fuego              |         142 |   1686 |          1 |               24.0 |              0.006 |              0.007 |            0.084 |           0.049 |                  0.021 |           0.021 |
| La Rioja                      |         126 |   2513 |          9 |               11.7 |              0.048 |              0.071 |            0.050 |           0.127 |                  0.040 |           0.008 |
| Corrientes                    |         125 |   3560 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.008 |                  0.008 |           0.000 |
| Tucumán                       |          86 |   8472 |          4 |               14.2 |              0.008 |              0.047 |            0.010 |           0.233 |                  0.105 |           0.023 |
| Salta                         |          82 |   1244 |          2 |                2.5 |              0.015 |              0.024 |            0.066 |           0.354 |                  0.024 |           0.012 |
| Formosa                       |          75 |    775 |          0 |                NaN |              0.000 |              0.000 |            0.097 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    |          60 |    691 |          0 |                NaN |              0.000 |              0.000 |            0.087 |           0.383 |                  0.083 |           0.050 |
| Misiones                      |          42 |   1652 |          2 |                6.5 |              0.031 |              0.048 |            0.025 |           0.690 |                  0.143 |           0.071 |
| Santiago del Estero           |          40 |   3163 |          0 |                NaN |              0.000 |              0.000 |            0.013 |           0.050 |                  0.050 |           0.000 |
| Catamarca                     |          37 |    950 |          0 |                NaN |              0.000 |              0.000 |            0.039 |           0.000 |                  0.000 |           0.000 |
| San Luis                      |          12 |    597 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.667 |                  0.083 |           0.000 |
| San Juan                      |          10 |    866 |          0 |                NaN |              0.000 |              0.000 |            0.012 |           0.500 |                  0.100 |           0.000 |
| La Pampa                      |           7 |    480 |          0 |                NaN |              0.000 |              0.000 |            0.015 |           0.143 |                  0.000 |           0.000 |

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
#> INFO  [21:17:18.384] Processing {current.group: }
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
|             17 | 2020-07-09              |                       134 |        4193 |  45876 |       2120 |        326 |              0.061 |              0.078 |            0.091 |           0.506 |                  0.074 |           0.039 |
|             18 | 2020-07-09              |                       134 |        5129 |  59057 |       2503 |        389 |              0.059 |              0.076 |            0.087 |           0.488 |                  0.067 |           0.035 |
|             19 | 2020-07-09              |                       134 |        6504 |  73176 |       3057 |        459 |              0.056 |              0.071 |            0.089 |           0.470 |                  0.062 |           0.032 |
|             20 | 2020-07-09              |                       134 |        8803 |  90528 |       3873 |        539 |              0.049 |              0.061 |            0.097 |           0.440 |                  0.056 |           0.029 |
|             21 | 2020-07-09              |                       134 |       13021 | 113919 |       5141 |        672 |              0.042 |              0.052 |            0.114 |           0.395 |                  0.049 |           0.025 |
|             22 | 2020-07-09              |                       134 |       18106 | 139250 |       6520 |        823 |              0.037 |              0.045 |            0.130 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-09              |                       134 |       24326 | 167422 |       7987 |        994 |              0.034 |              0.041 |            0.145 |           0.328 |                  0.040 |           0.019 |
|             24 | 2020-07-09              |                       134 |       33658 | 202352 |      10003 |       1171 |              0.029 |              0.035 |            0.166 |           0.297 |                  0.035 |           0.016 |
|             25 | 2020-07-09              |                       134 |       46185 | 243371 |      12149 |       1364 |              0.025 |              0.030 |            0.190 |           0.263 |                  0.030 |           0.013 |
|             26 | 2020-07-09              |                       134 |       63330 | 294344 |      14795 |       1582 |              0.021 |              0.025 |            0.215 |           0.234 |                  0.026 |           0.011 |
|             27 | 2020-07-09              |                       134 |       80687 | 342488 |      16848 |       1697 |              0.017 |              0.021 |            0.236 |           0.209 |                  0.023 |           0.009 |
|             28 | 2020-07-09              |                       134 |       90680 | 368359 |      17792 |       1720 |              0.014 |              0.019 |            0.246 |           0.196 |                  0.021 |           0.009 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [21:17:42.852] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [21:17:53.725] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [21:18:00.585] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [21:18:01.728] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [21:18:04.699] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [21:18:06.783] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [21:18:10.454] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [21:18:12.419] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [21:18:14.461] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [21:18:15.863] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [21:18:17.874] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [21:18:19.638] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [21:18:21.452] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [21:18:23.596] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [21:18:25.411] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [21:18:27.454] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [21:18:29.608] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [21:18:31.494] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [21:18:33.254] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [21:18:35.031] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [21:18:37.246] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [21:18:40.704] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [21:18:42.570] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [21:18:44.517] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [21:18:46.534] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       24335 |       4151 |        478 |              0.014 |              0.020 |            0.290 |           0.171 |                  0.021 |           0.009 |
| Buenos Aires                  | F    |       23131 |       3490 |        353 |              0.010 |              0.015 |            0.259 |           0.151 |                  0.015 |           0.005 |
| CABA                          | F    |       17562 |       4123 |        278 |              0.013 |              0.016 |            0.350 |           0.235 |                  0.015 |           0.006 |
| CABA                          | M    |       17298 |       4158 |        347 |              0.017 |              0.020 |            0.385 |           0.240 |                  0.026 |           0.012 |
| Chaco                         | F    |        1230 |        134 |         43 |              0.024 |              0.035 |            0.172 |           0.109 |                  0.050 |           0.015 |
| Chaco                         | M    |        1214 |        140 |         70 |              0.040 |              0.058 |            0.172 |           0.115 |                  0.074 |           0.035 |
| Río Negro                     | F    |         529 |        208 |         17 |              0.029 |              0.032 |            0.199 |           0.393 |                  0.019 |           0.011 |
| Río Negro                     | M    |         502 |        203 |         29 |              0.051 |              0.058 |            0.224 |           0.404 |                  0.040 |           0.030 |
| Córdoba                       | M    |         425 |         55 |         18 |              0.021 |              0.042 |            0.038 |           0.129 |                  0.040 |           0.019 |
| Córdoba                       | F    |         399 |         73 |         19 |              0.021 |              0.048 |            0.035 |           0.183 |                  0.035 |           0.010 |
| Neuquén                       | F    |         340 |        186 |          8 |              0.020 |              0.024 |            0.231 |           0.547 |                  0.009 |           0.009 |
| SIN ESPECIFICAR               | F    |         336 |         49 |          0 |              0.000 |              0.000 |            0.341 |           0.146 |                  0.006 |           0.000 |
| Neuquén                       | M    |         309 |        171 |         10 |              0.026 |              0.032 |            0.203 |           0.553 |                  0.016 |           0.010 |
| SIN ESPECIFICAR               | M    |         274 |         47 |          1 |              0.003 |              0.004 |            0.408 |           0.172 |                  0.011 |           0.007 |
| Santa Fe                      | M    |         242 |         45 |          5 |              0.013 |              0.021 |            0.034 |           0.186 |                  0.054 |           0.029 |
| Santa Fe                      | F    |         238 |         29 |          1 |              0.003 |              0.004 |            0.032 |           0.122 |                  0.025 |           0.004 |
| Entre Ríos                    | M    |         201 |         49 |          0 |              0.000 |              0.000 |            0.137 |           0.244 |                  0.010 |           0.005 |
| Buenos Aires                  | NR   |         189 |         22 |          3 |              0.009 |              0.016 |            0.315 |           0.116 |                  0.026 |           0.005 |
| Jujuy                         | M    |         182 |          3 |          1 |              0.001 |              0.005 |            0.091 |           0.016 |                  0.005 |           0.005 |
| Entre Ríos                    | F    |         174 |         39 |          0 |              0.000 |              0.000 |            0.121 |           0.224 |                  0.000 |           0.000 |
| CABA                          | NR   |         142 |         47 |          9 |              0.034 |              0.063 |            0.327 |           0.331 |                  0.056 |           0.042 |
| Jujuy                         | F    |         130 |          0 |          0 |              0.000 |              0.000 |            0.124 |           0.000 |                  0.000 |           0.000 |
| Mendoza                       | M    |         128 |        115 |         10 |              0.043 |              0.078 |            0.070 |           0.898 |                  0.078 |           0.031 |
| Mendoza                       | F    |         122 |        104 |          0 |              0.000 |              0.000 |            0.069 |           0.852 |                  0.016 |           0.008 |
| Chubut                        | M    |         107 |          5 |          1 |              0.005 |              0.009 |            0.124 |           0.047 |                  0.009 |           0.009 |
| Chubut                        | F    |          86 |          1 |          0 |              0.000 |              0.000 |            0.106 |           0.012 |                  0.000 |           0.000 |
| Tierra del Fuego              | M    |          82 |          4 |          1 |              0.010 |              0.012 |            0.091 |           0.049 |                  0.037 |           0.037 |
| Corrientes                    | M    |          77 |          1 |          0 |              0.000 |              0.000 |            0.038 |           0.013 |                  0.000 |           0.000 |
| La Rioja                      | F    |          68 |         10 |          6 |              0.063 |              0.088 |            0.057 |           0.147 |                  0.044 |           0.015 |
| Formosa                       | M    |          64 |          0 |          0 |              0.000 |              0.000 |            0.138 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.075 |           0.051 |                  0.000 |           0.000 |
| La Rioja                      | M    |          58 |          6 |          3 |              0.033 |              0.052 |            0.045 |           0.103 |                  0.034 |           0.000 |
| Salta                         | M    |          53 |         20 |          2 |              0.023 |              0.038 |            0.062 |           0.377 |                  0.038 |           0.019 |
| Tucumán                       | M    |          51 |         11 |          2 |              0.007 |              0.039 |            0.010 |           0.216 |                  0.059 |           0.000 |
| Corrientes                    | F    |          48 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.021 |           0.000 |
| Santa Cruz                    | M    |          38 |         13 |          0 |              0.000 |              0.000 |            0.096 |           0.342 |                  0.105 |           0.053 |
| Tucumán                       | F    |          35 |          9 |          2 |              0.010 |              0.057 |            0.011 |           0.257 |                  0.171 |           0.057 |
| Santiago del Estero           | M    |          30 |          1 |          0 |              0.000 |              0.000 |            0.014 |           0.033 |                  0.033 |           0.000 |
| Salta                         | F    |          29 |          9 |          0 |              0.000 |              0.000 |            0.076 |           0.310 |                  0.000 |           0.000 |
| Misiones                      | M    |          23 |         16 |          1 |              0.029 |              0.043 |            0.026 |           0.696 |                  0.174 |           0.087 |
| Catamarca                     | M    |          22 |          0 |          0 |              0.000 |              0.000 |            0.039 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    | F    |          22 |         10 |          0 |              0.000 |              0.000 |            0.074 |           0.455 |                  0.045 |           0.045 |
| Misiones                      | F    |          19 |         13 |          1 |              0.033 |              0.053 |            0.025 |           0.684 |                  0.105 |           0.053 |
| Catamarca                     | F    |          15 |          0 |          0 |              0.000 |              0.000 |            0.039 |           0.000 |                  0.000 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | M    |          10 |          6 |          0 |              0.000 |              0.000 |            0.029 |           0.600 |                  0.100 |           0.000 |
| Santiago del Estero           | F    |          10 |          1 |          0 |              0.000 |              0.000 |            0.011 |           0.100 |                  0.100 |           0.000 |

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
