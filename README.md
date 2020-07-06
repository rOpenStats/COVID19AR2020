
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
#> INFO  [12:40:55.274] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [12:40:57.965] Normalize 
#> INFO  [12:40:58.494] checkSoundness 
#> INFO  [12:40:58.644] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-05"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-04"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-04"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-04              |       76513 |       1490 |              0.014 |              0.019 |                       129 | 332283 |             0.23 |

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
| Buenos Aires                  |       39140 |        689 |              0.012 |              0.018 |                       128 | 154397 |            0.254 |
| CABA                          |       30409 |        564 |              0.015 |              0.019 |                       127 |  85890 |            0.354 |
| Chaco                         |        2297 |        107 |              0.033 |              0.047 |                       115 |  13011 |            0.177 |
| Río Negro                     |         963 |         41 |              0.038 |              0.043 |                       110 |   4561 |            0.211 |
| Córdoba                       |         688 |         37 |              0.023 |              0.054 |                       117 |  21218 |            0.032 |
| Neuquén                       |         552 |         16 |              0.021 |              0.029 |                       112 |   2634 |            0.210 |
| SIN ESPECIFICAR               |         475 |          2 |              0.003 |              0.004 |                       105 |   1330 |            0.357 |
| Santa Fe                      |         437 |          6 |              0.008 |              0.014 |                       113 |  13865 |            0.032 |
| Entre Ríos                    |         324 |          0 |              0.000 |              0.000 |                       110 |   2714 |            0.119 |
| Mendoza                       |         190 |         10 |              0.029 |              0.053 |                       116 |   3319 |            0.057 |
| Jujuy                         |         162 |          1 |              0.001 |              0.006 |                       106 |   2819 |            0.057 |
| Chubut                        |         150 |          1 |              0.004 |              0.007 |                        96 |   1499 |            0.100 |
| Tierra del Fuego              |         141 |          1 |              0.006 |              0.007 |                       109 |   1664 |            0.085 |
| Corrientes                    |         119 |          0 |              0.000 |              0.000 |                       108 |   3474 |            0.034 |

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
| Buenos Aires                  |       39140 | 154397 |        689 |               12.4 |              0.012 |              0.018 |            0.254 |           0.171 |                  0.020 |           0.007 |
| CABA                          |       30409 |  85890 |        564 |               13.9 |              0.015 |              0.019 |            0.354 |           0.245 |                  0.022 |           0.010 |
| Chaco                         |        2297 |  13011 |        107 |               14.0 |              0.033 |              0.047 |            0.177 |           0.114 |                  0.064 |           0.026 |
| Río Negro                     |         963 |   4561 |         41 |               12.7 |              0.038 |              0.043 |            0.211 |           0.403 |                  0.028 |           0.018 |
| Córdoba                       |         688 |  21218 |         37 |               24.3 |              0.023 |              0.054 |            0.032 |           0.188 |                  0.045 |           0.017 |
| Neuquén                       |         552 |   2634 |         16 |               18.0 |              0.021 |              0.029 |            0.210 |           0.553 |                  0.014 |           0.011 |
| SIN ESPECIFICAR               |         475 |   1330 |          2 |               34.5 |              0.003 |              0.004 |            0.357 |           0.183 |                  0.013 |           0.006 |
| Santa Fe                      |         437 |  13865 |          6 |               20.5 |              0.008 |              0.014 |            0.032 |           0.158 |                  0.039 |           0.018 |
| Entre Ríos                    |         324 |   2714 |          0 |                NaN |              0.000 |              0.000 |            0.119 |           0.247 |                  0.003 |           0.000 |
| Mendoza                       |         190 |   3319 |         10 |               13.1 |              0.029 |              0.053 |            0.057 |           0.926 |                  0.063 |           0.026 |
| Jujuy                         |         162 |   2819 |          1 |               22.0 |              0.001 |              0.006 |            0.057 |           0.012 |                  0.006 |           0.006 |
| Chubut                        |         150 |   1499 |          1 |               19.0 |              0.004 |              0.007 |            0.100 |           0.033 |                  0.007 |           0.007 |
| Tierra del Fuego              |         141 |   1664 |          1 |               24.0 |              0.006 |              0.007 |            0.085 |           0.050 |                  0.021 |           0.021 |
| Corrientes                    |         119 |   3474 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.008 |                  0.008 |           0.000 |
| La Rioja                      |          98 |   2226 |          9 |               11.7 |              0.048 |              0.092 |            0.044 |           0.153 |                  0.051 |           0.010 |
| Tucumán                       |          84 |   8052 |          4 |               14.2 |              0.009 |              0.048 |            0.010 |           0.214 |                  0.107 |           0.024 |
| Formosa                       |          76 |    773 |          0 |                NaN |              0.000 |              0.000 |            0.098 |           0.013 |                  0.000 |           0.000 |
| Salta                         |          56 |   1169 |          0 |                NaN |              0.000 |              0.000 |            0.048 |           0.446 |                  0.018 |           0.000 |
| Santa Cruz                    |          51 |    644 |          0 |                NaN |              0.000 |              0.000 |            0.079 |           0.412 |                  0.078 |           0.039 |
| Misiones                      |          41 |   1559 |          2 |                6.5 |              0.032 |              0.049 |            0.026 |           0.707 |                  0.146 |           0.073 |
| Santiago del Estero           |          26 |   2886 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.038 |                  0.038 |           0.000 |
| San Luis                      |          12 |    569 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.667 |                  0.083 |           0.000 |
| San Juan                      |           8 |    834 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.625 |                  0.125 |           0.000 |
| Catamarca                     |           7 |    723 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.000 |                  0.000 |           0.000 |
| La Pampa                      |           7 |    453 |          0 |                NaN |              0.000 |              0.000 |            0.015 |           0.143 |                  0.000 |           0.000 |

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
#> INFO  [12:41:50.637] Processing {current.group: }
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
|             12 | 2020-06-18              |                        54 |         407 |   2048 |        252 |         16 |              0.031 |              0.039 |            0.199 |           0.619 |                  0.093 |           0.054 |
|             13 | 2020-07-01              |                        79 |        1072 |   5510 |        595 |         61 |              0.047 |              0.057 |            0.195 |           0.555 |                  0.095 |           0.057 |
|             14 | 2020-07-01              |                       102 |        1741 |  11523 |        956 |        110 |              0.051 |              0.063 |            0.151 |           0.549 |                  0.095 |           0.056 |
|             15 | 2020-07-03              |                       121 |        2384 |  20233 |       1289 |        170 |              0.056 |              0.071 |            0.118 |           0.541 |                  0.091 |           0.051 |
|             16 | 2020-07-03              |                       126 |        3138 |  31825 |       1625 |        225 |              0.055 |              0.072 |            0.099 |           0.518 |                  0.082 |           0.044 |
|             17 | 2020-07-03              |                       128 |        4173 |  45872 |       2112 |        325 |              0.061 |              0.078 |            0.091 |           0.506 |                  0.075 |           0.039 |
|             18 | 2020-07-04              |                       129 |        5103 |  59052 |       2491 |        388 |              0.059 |              0.076 |            0.086 |           0.488 |                  0.068 |           0.036 |
|             19 | 2020-07-04              |                       129 |        6463 |  73170 |       3041 |        458 |              0.056 |              0.071 |            0.088 |           0.471 |                  0.062 |           0.032 |
|             20 | 2020-07-04              |                       129 |        8742 |  90517 |       3846 |        532 |              0.049 |              0.061 |            0.097 |           0.440 |                  0.056 |           0.029 |
|             21 | 2020-07-04              |                       129 |       12935 | 113902 |       5085 |        661 |              0.041 |              0.051 |            0.114 |           0.393 |                  0.049 |           0.025 |
|             22 | 2020-07-04              |                       129 |       17990 | 139225 |       6456 |        807 |              0.037 |              0.045 |            0.129 |           0.359 |                  0.044 |           0.022 |
|             23 | 2020-07-04              |                       129 |       24170 | 167385 |       7906 |        970 |              0.033 |              0.040 |            0.144 |           0.327 |                  0.040 |           0.019 |
|             24 | 2020-07-04              |                       129 |       33473 | 202300 |       9895 |       1131 |              0.028 |              0.034 |            0.165 |           0.296 |                  0.035 |           0.016 |
|             25 | 2020-07-04              |                       129 |       45916 | 243239 |      11956 |       1291 |              0.023 |              0.028 |            0.189 |           0.260 |                  0.030 |           0.013 |
|             26 | 2020-07-04              |                       129 |       62745 | 293725 |      14363 |       1432 |              0.019 |              0.023 |            0.214 |           0.229 |                  0.025 |           0.011 |
|             27 | 2020-07-04              |                       129 |       76513 | 332283 |      15798 |       1490 |              0.014 |              0.019 |            0.230 |           0.206 |                  0.022 |           0.009 |
|             28 | 2020-07-04              |                       129 |       76513 | 332283 |      15798 |       1490 |              0.014 |              0.019 |            0.230 |           0.206 |                  0.022 |           0.009 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [12:42:11.443] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [12:42:21.479] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [12:42:27.365] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [12:42:28.377] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [12:42:30.886] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [12:42:32.611] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [12:42:35.724] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [12:42:37.672] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [12:42:39.605] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [12:42:40.902] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [12:42:42.972] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [12:42:44.789] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [12:42:46.702] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [12:42:48.709] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [12:42:50.419] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [12:42:52.362] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [12:42:54.560] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [12:42:56.426] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [12:42:58.190] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [12:43:00.084] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [12:43:01.959] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [12:43:04.742] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [12:43:06.704] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [12:43:08.750] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [12:43:10.979] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 387
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
#> [1] 59
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| Buenos Aires                  | M    |       19951 |       3602 |        399 |              0.014 |              0.020 |            0.269 |           0.181 |                  0.023 |           0.009 |
| Buenos Aires                  | F    |       19033 |       3076 |        288 |              0.010 |              0.015 |            0.239 |           0.162 |                  0.016 |           0.006 |
| CABA                          | F    |       15236 |       3703 |        249 |              0.013 |              0.016 |            0.338 |           0.243 |                  0.016 |           0.006 |
| CABA                          | M    |       15038 |       3723 |        307 |              0.017 |              0.020 |            0.372 |           0.248 |                  0.027 |           0.013 |
| Chaco                         | F    |        1151 |        128 |         41 |              0.025 |              0.036 |            0.175 |           0.111 |                  0.053 |           0.016 |
| Chaco                         | M    |        1144 |        134 |         66 |              0.040 |              0.058 |            0.178 |           0.117 |                  0.074 |           0.036 |
| Río Negro                     | F    |         490 |        193 |         13 |              0.024 |              0.027 |            0.200 |           0.394 |                  0.016 |           0.008 |
| Río Negro                     | M    |         473 |        195 |         28 |              0.054 |              0.059 |            0.225 |           0.412 |                  0.040 |           0.027 |
| Córdoba                       | M    |         353 |         55 |         18 |              0.024 |              0.051 |            0.034 |           0.156 |                  0.048 |           0.023 |
| Córdoba                       | F    |         333 |         73 |         19 |              0.023 |              0.057 |            0.031 |           0.219 |                  0.042 |           0.012 |
| Neuquén                       | F    |         288 |        159 |          7 |              0.018 |              0.024 |            0.224 |           0.552 |                  0.010 |           0.010 |
| Neuquén                       | M    |         264 |        146 |          9 |              0.024 |              0.034 |            0.196 |           0.553 |                  0.019 |           0.011 |
| SIN ESPECIFICAR               | F    |         257 |         43 |          0 |              0.000 |              0.000 |            0.332 |           0.167 |                  0.008 |           0.000 |
| Santa Fe                      | M    |         222 |         43 |          5 |              0.013 |              0.023 |            0.033 |           0.194 |                  0.054 |           0.032 |
| SIN ESPECIFICAR               | M    |         216 |         43 |          1 |              0.004 |              0.005 |            0.397 |           0.199 |                  0.014 |           0.009 |
| Santa Fe                      | F    |         215 |         26 |          1 |              0.003 |              0.005 |            0.030 |           0.121 |                  0.023 |           0.005 |
| Entre Ríos                    | M    |         172 |         47 |          0 |              0.000 |              0.000 |            0.126 |           0.273 |                  0.006 |           0.000 |
| Buenos Aires                  | NR   |         156 |         20 |          2 |              0.007 |              0.013 |            0.304 |           0.128 |                  0.026 |           0.000 |
| Entre Ríos                    | F    |         151 |         33 |          0 |              0.000 |              0.000 |            0.112 |           0.219 |                  0.000 |           0.000 |
| CABA                          | NR   |         135 |         39 |          8 |              0.034 |              0.059 |            0.333 |           0.289 |                  0.052 |           0.037 |
| Mendoza                       | M    |          97 |         92 |         10 |              0.058 |              0.103 |            0.057 |           0.948 |                  0.103 |           0.041 |
| Jujuy                         | M    |          93 |          2 |          1 |              0.002 |              0.011 |            0.050 |           0.022 |                  0.011 |           0.011 |
| Mendoza                       | F    |          93 |         84 |          0 |              0.000 |              0.000 |            0.058 |           0.903 |                  0.022 |           0.011 |
| Chubut                        | M    |          83 |          4 |          1 |              0.008 |              0.012 |            0.107 |           0.048 |                  0.012 |           0.012 |
| Tierra del Fuego              | M    |          81 |          4 |          1 |              0.011 |              0.012 |            0.091 |           0.049 |                  0.037 |           0.037 |
| Corrientes                    | M    |          74 |          1 |          0 |              0.000 |              0.000 |            0.038 |           0.014 |                  0.000 |           0.000 |
| Jujuy                         | F    |          68 |          0 |          0 |              0.000 |              0.000 |            0.072 |           0.000 |                  0.000 |           0.000 |
| Chubut                        | F    |          66 |          1 |          0 |              0.000 |              0.000 |            0.093 |           0.015 |                  0.000 |           0.000 |
| Formosa                       | M    |          63 |          0 |          0 |              0.000 |              0.000 |            0.137 |           0.000 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.076 |           0.051 |                  0.000 |           0.000 |
| La Rioja                      | F    |          51 |         10 |          6 |              0.062 |              0.118 |            0.048 |           0.196 |                  0.059 |           0.020 |
| Tucumán                       | M    |          51 |         10 |          2 |              0.008 |              0.039 |            0.010 |           0.196 |                  0.059 |           0.000 |
| La Rioja                      | M    |          47 |          5 |          3 |              0.033 |              0.064 |            0.041 |           0.106 |                  0.043 |           0.000 |
| Corrientes                    | F    |          45 |          0 |          0 |              0.000 |              0.000 |            0.030 |           0.000 |                  0.022 |           0.000 |
| Salta                         | M    |          34 |         17 |          0 |              0.000 |              0.000 |            0.042 |           0.500 |                  0.029 |           0.000 |
| Tucumán                       | F    |          33 |          8 |          2 |              0.011 |              0.061 |            0.011 |           0.242 |                  0.182 |           0.061 |
| Santa Cruz                    | M    |          32 |         12 |          0 |              0.000 |              0.000 |            0.086 |           0.375 |                  0.094 |           0.031 |
| Misiones                      | M    |          23 |         16 |          1 |              0.029 |              0.043 |            0.027 |           0.696 |                  0.174 |           0.087 |
| Salta                         | F    |          22 |          8 |          0 |              0.000 |              0.000 |            0.063 |           0.364 |                  0.000 |           0.000 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.070 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.037 |              0.056 |            0.025 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          18 |          1 |          0 |              0.000 |              0.000 |            0.009 |           0.056 |                  0.056 |           0.000 |
| Formosa                       | F    |          13 |          1 |          0 |              0.000 |              0.000 |            0.042 |           0.077 |                  0.000 |           0.000 |
| San Luis                      | M    |          10 |          6 |          0 |              0.000 |              0.000 |            0.031 |           0.600 |                  0.100 |           0.000 |

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
