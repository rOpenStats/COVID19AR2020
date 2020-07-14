
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
#> INFO  [08:46:52.811] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [08:46:56.789] Normalize 
#> INFO  [08:46:57.539] checkSoundness 
#> INFO  [08:46:57.971] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-13"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-13"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-13"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-13              |      103252 |       1903 |              0.013 |              0.018 |                       138 | 400363 |            0.258 |

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
| Buenos Aires                  |       55502 |        933 |              0.012 |              0.017 |                       137 | 191291 |            0.290 |
| CABA                          |       38472 |        710 |              0.015 |              0.018 |                       136 | 102700 |            0.375 |
| Chaco                         |        2601 |        115 |              0.032 |              0.044 |                       124 |  15410 |            0.169 |
| Río Negro                     |        1123 |         47 |              0.035 |              0.042 |                       119 |   5142 |            0.218 |
| Córdoba                       |         960 |         37 |              0.019 |              0.039 |                       126 |  23620 |            0.041 |
| SIN ESPECIFICAR               |         879 |          2 |              0.002 |              0.002 |                       114 |   2310 |            0.381 |
| Neuquén                       |         740 |         19 |              0.021 |              0.026 |                       121 |   3262 |            0.227 |
| Santa Fe                      |         538 |          6 |              0.006 |              0.011 |                       122 |  15314 |            0.035 |
| Entre Ríos                    |         535 |          0 |              0.000 |              0.000 |                       119 |   3186 |            0.168 |
| Jujuy                         |         468 |          1 |              0.000 |              0.002 |                       115 |   3916 |            0.120 |
| Mendoza                       |         305 |         10 |              0.018 |              0.033 |                       125 |   3944 |            0.077 |
| Chubut                        |         210 |          2 |              0.004 |              0.010 |                       104 |   1966 |            0.107 |
| Tierra del Fuego              |         148 |          2 |              0.009 |              0.014 |                       116 |   1722 |            0.086 |
| La Rioja                      |         147 |         11 |              0.052 |              0.075 |                       110 |   2790 |            0.053 |
| Corrientes                    |         128 |          0 |              0.000 |              0.000 |                       116 |   3735 |            0.034 |
| Salta                         |         111 |          2 |              0.011 |              0.018 |                       114 |   1317 |            0.084 |

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
| Buenos Aires                  |       55502 | 191291 |        933 |               12.8 |              0.012 |              0.017 |            0.290 |           0.151 |                  0.017 |           0.007 |
| CABA                          |       38472 | 102700 |        710 |               14.3 |              0.015 |              0.018 |            0.375 |           0.233 |                  0.020 |           0.009 |
| Chaco                         |        2601 |  15410 |        115 |               14.5 |              0.032 |              0.044 |            0.169 |           0.106 |                  0.058 |           0.023 |
| Río Negro                     |        1123 |   5142 |         47 |               13.3 |              0.035 |              0.042 |            0.218 |           0.389 |                  0.028 |           0.019 |
| Córdoba                       |         960 |  23620 |         37 |               24.3 |              0.019 |              0.039 |            0.041 |           0.135 |                  0.033 |           0.013 |
| SIN ESPECIFICAR               |         879 |   2310 |          2 |               34.5 |              0.002 |              0.002 |            0.381 |           0.123 |                  0.007 |           0.003 |
| Neuquén                       |         740 |   3262 |         19 |               17.5 |              0.021 |              0.026 |            0.227 |           0.605 |                  0.014 |           0.008 |
| Santa Fe                      |         538 |  15314 |          6 |               20.5 |              0.006 |              0.011 |            0.035 |           0.145 |                  0.035 |           0.015 |
| Entre Ríos                    |         535 |   3186 |          0 |                NaN |              0.000 |              0.000 |            0.168 |           0.245 |                  0.006 |           0.002 |
| Jujuy                         |         468 |   3916 |          1 |               22.0 |              0.000 |              0.002 |            0.120 |           0.006 |                  0.002 |           0.002 |
| Mendoza                       |         305 |   3944 |         10 |               13.1 |              0.018 |              0.033 |            0.077 |           0.813 |                  0.043 |           0.020 |
| Chubut                        |         210 |   1966 |          2 |               10.5 |              0.004 |              0.010 |            0.107 |           0.048 |                  0.014 |           0.010 |
| Tierra del Fuego              |         148 |   1722 |          2 |               19.0 |              0.009 |              0.014 |            0.086 |           0.047 |                  0.020 |           0.020 |
| La Rioja                      |         147 |   2790 |         11 |               11.8 |              0.052 |              0.075 |            0.053 |           0.116 |                  0.027 |           0.007 |
| Corrientes                    |         128 |   3735 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.008 |                  0.008 |           0.000 |
| Salta                         |         111 |   1317 |          2 |                2.5 |              0.011 |              0.018 |            0.084 |           0.315 |                  0.018 |           0.009 |
| Tucumán                       |          91 |   8809 |          4 |               14.2 |              0.008 |              0.044 |            0.010 |           0.253 |                  0.099 |           0.022 |
| Formosa                       |          78 |    785 |          0 |                NaN |              0.000 |              0.000 |            0.099 |           0.013 |                  0.000 |           0.000 |
| Santa Cruz                    |          64 |    720 |          0 |                NaN |              0.000 |              0.000 |            0.089 |           0.453 |                  0.078 |           0.047 |
| Misiones                      |          43 |   1664 |          2 |                6.5 |              0.025 |              0.047 |            0.026 |           0.698 |                  0.140 |           0.070 |
| Santiago del Estero           |          41 |   3306 |          0 |                NaN |              0.000 |              0.000 |            0.012 |           0.049 |                  0.049 |           0.000 |
| Catamarca                     |          39 |   1442 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.000 |                  0.000 |           0.000 |
| San Luis                      |          14 |    639 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.571 |                  0.071 |           0.000 |
| San Juan                      |           8 |    881 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           0.625 |                  0.125 |           0.000 |
| La Pampa                      |           7 |    492 |          0 |                NaN |              0.000 |              0.000 |            0.014 |           0.143 |                  0.000 |           0.000 |

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
#> INFO  [08:48:14.871] Processing {current.group: }
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
|             14 | 2020-07-13              |                       106 |        1743 |  11526 |        957 |        110 |              0.051 |              0.063 |            0.151 |           0.549 |                  0.095 |           0.057 |
|             15 | 2020-07-13              |                       127 |        2391 |  20237 |       1293 |        170 |              0.057 |              0.071 |            0.118 |           0.541 |                  0.091 |           0.051 |
|             16 | 2020-07-13              |                       135 |        3155 |  31836 |       1631 |        225 |              0.056 |              0.071 |            0.099 |           0.517 |                  0.081 |           0.044 |
|             17 | 2020-07-13              |                       138 |        4211 |  45885 |       2129 |        326 |              0.061 |              0.077 |            0.092 |           0.506 |                  0.074 |           0.039 |
|             18 | 2020-07-13              |                       138 |        5150 |  59071 |       2513 |        389 |              0.059 |              0.076 |            0.087 |           0.488 |                  0.067 |           0.036 |
|             19 | 2020-07-13              |                       138 |        6534 |  73192 |       3071 |        460 |              0.056 |              0.070 |            0.089 |           0.470 |                  0.062 |           0.032 |
|             20 | 2020-07-13              |                       138 |        8845 |  90544 |       3892 |        540 |              0.049 |              0.061 |            0.098 |           0.440 |                  0.056 |           0.029 |
|             21 | 2020-07-13              |                       138 |       13082 | 113941 |       5166 |        674 |              0.042 |              0.052 |            0.115 |           0.395 |                  0.049 |           0.025 |
|             22 | 2020-07-13              |                       138 |       18182 | 139274 |       6553 |        828 |              0.038 |              0.046 |            0.131 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-13              |                       138 |       24438 | 167473 |       8033 |       1008 |              0.034 |              0.041 |            0.146 |           0.329 |                  0.040 |           0.019 |
|             24 | 2020-07-13              |                       138 |       33805 | 202434 |      10065 |       1193 |              0.029 |              0.035 |            0.167 |           0.298 |                  0.035 |           0.016 |
|             25 | 2020-07-13              |                       138 |       46379 | 243521 |      12253 |       1404 |              0.025 |              0.030 |            0.190 |           0.264 |                  0.030 |           0.014 |
|             26 | 2020-07-13              |                       138 |       63650 | 294779 |      14997 |       1652 |              0.022 |              0.026 |            0.216 |           0.236 |                  0.026 |           0.011 |
|             27 | 2020-07-13              |                       138 |       81430 | 343876 |      17204 |       1809 |              0.018 |              0.022 |            0.237 |           0.211 |                  0.023 |           0.010 |
|             28 | 2020-07-13              |                       138 |      101551 | 395761 |      19214 |       1899 |              0.015 |              0.019 |            0.257 |           0.189 |                  0.020 |           0.008 |
|             29 | 2020-07-13              |                       138 |      103252 | 400363 |      19384 |       1903 |              0.013 |              0.018 |            0.258 |           0.188 |                  0.020 |           0.008 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [08:48:44.059] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [08:48:57.027] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [08:49:06.359] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [08:49:07.680] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [08:49:10.712] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [08:49:12.355] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [08:49:15.946] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [08:49:18.000] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [08:49:19.938] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [08:49:21.231] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [08:49:23.193] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [08:49:24.917] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [08:49:26.701] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [08:49:28.642] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [08:49:30.298] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [08:49:32.119] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [08:49:34.169] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [08:49:35.920] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [08:49:37.583] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [08:49:39.317] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [08:49:41.126] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [08:49:43.954] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [08:49:45.766] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [08:49:47.564] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [08:49:49.490] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       28319 |       4563 |        539 |              0.014 |              0.019 |            0.307 |           0.161 |                  0.020 |           0.009 |
| Buenos Aires                  | F    |       26974 |       3815 |        391 |              0.010 |              0.014 |            0.274 |           0.141 |                  0.014 |           0.005 |
| CABA                          | F    |       19306 |       4434 |        306 |              0.013 |              0.016 |            0.358 |           0.230 |                  0.015 |           0.006 |
| CABA                          | M    |       19007 |       4464 |        392 |              0.017 |              0.021 |            0.393 |           0.235 |                  0.026 |           0.012 |
| Chaco                         | F    |        1301 |        134 |         44 |              0.025 |              0.034 |            0.168 |           0.103 |                  0.048 |           0.014 |
| Chaco                         | M    |        1298 |        143 |         71 |              0.040 |              0.055 |            0.169 |           0.110 |                  0.069 |           0.032 |
| Río Negro                     | F    |         575 |        220 |         17 |              0.025 |              0.030 |            0.208 |           0.383 |                  0.017 |           0.010 |
| Río Negro                     | M    |         548 |        217 |         30 |              0.046 |              0.055 |            0.231 |           0.396 |                  0.038 |           0.027 |
| Córdoba                       | M    |         487 |         55 |         18 |              0.019 |              0.037 |            0.042 |           0.113 |                  0.035 |           0.016 |
| SIN ESPECIFICAR               | F    |         481 |         54 |          0 |              0.000 |              0.000 |            0.355 |           0.112 |                  0.004 |           0.000 |
| Córdoba                       | F    |         471 |         74 |         19 |              0.019 |              0.040 |            0.039 |           0.157 |                  0.032 |           0.008 |
| SIN ESPECIFICAR               | M    |         394 |         53 |          1 |              0.002 |              0.003 |            0.418 |           0.135 |                  0.008 |           0.005 |
| Neuquén                       | F    |         385 |        233 |          9 |              0.020 |              0.023 |            0.240 |           0.605 |                  0.010 |           0.008 |
| Neuquén                       | M    |         355 |        215 |         10 |              0.023 |              0.028 |            0.215 |           0.606 |                  0.017 |           0.008 |
| Jujuy                         | M    |         274 |          3 |          1 |              0.001 |              0.004 |            0.115 |           0.011 |                  0.004 |           0.004 |
| Entre Ríos                    | M    |         272 |         73 |          0 |              0.000 |              0.000 |            0.171 |           0.268 |                  0.007 |           0.004 |
| Santa Fe                      | M    |         270 |         47 |          5 |              0.011 |              0.019 |            0.036 |           0.174 |                  0.048 |           0.026 |
| Santa Fe                      | F    |         268 |         31 |          1 |              0.002 |              0.004 |            0.034 |           0.116 |                  0.022 |           0.004 |
| Entre Ríos                    | F    |         262 |         58 |          0 |              0.000 |              0.000 |            0.165 |           0.221 |                  0.004 |           0.000 |
| Buenos Aires                  | NR   |         209 |         25 |          3 |              0.008 |              0.014 |            0.320 |           0.120 |                  0.029 |           0.005 |
| Jujuy                         | F    |         193 |          0 |          0 |              0.000 |              0.000 |            0.128 |           0.000 |                  0.000 |           0.000 |
| CABA                          | NR   |         159 |         54 |         12 |              0.042 |              0.075 |            0.336 |           0.340 |                  0.057 |           0.044 |
| Mendoza                       | M    |         153 |        129 |         10 |              0.039 |              0.065 |            0.077 |           0.843 |                  0.072 |           0.033 |
| Mendoza                       | F    |         150 |        117 |          0 |              0.000 |              0.000 |            0.077 |           0.780 |                  0.013 |           0.007 |
| Chubut                        | M    |         112 |          6 |          1 |              0.004 |              0.009 |            0.111 |           0.054 |                  0.009 |           0.009 |
| Chubut                        | F    |          95 |          4 |          1 |              0.005 |              0.011 |            0.101 |           0.042 |                  0.021 |           0.011 |
| Tierra del Fuego              | M    |          88 |          4 |          2 |              0.014 |              0.023 |            0.095 |           0.045 |                  0.034 |           0.034 |
| La Rioja                      | F    |          80 |         10 |          6 |              0.054 |              0.075 |            0.060 |           0.125 |                  0.038 |           0.013 |
| Corrientes                    | M    |          78 |          1 |          0 |              0.000 |              0.000 |            0.037 |           0.013 |                  0.000 |           0.000 |
| Salta                         | M    |          69 |         24 |          2 |              0.017 |              0.029 |            0.077 |           0.348 |                  0.029 |           0.014 |
| Formosa                       | M    |          67 |          1 |          0 |              0.000 |              0.000 |            0.142 |           0.015 |                  0.000 |           0.000 |
| La Rioja                      | M    |          67 |          7 |          5 |              0.050 |              0.075 |            0.047 |           0.104 |                  0.015 |           0.000 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.074 |           0.051 |                  0.000 |           0.000 |
| Tucumán                       | M    |          55 |         12 |          2 |              0.007 |              0.036 |            0.010 |           0.218 |                  0.055 |           0.000 |
| Corrientes                    | F    |          50 |          0 |          0 |              0.000 |              0.000 |            0.031 |           0.000 |                  0.020 |           0.000 |
| Salta                         | F    |          42 |         11 |          0 |              0.000 |              0.000 |            0.101 |           0.262 |                  0.000 |           0.000 |
| Santa Cruz                    | M    |          40 |         15 |          0 |              0.000 |              0.000 |            0.098 |           0.375 |                  0.100 |           0.050 |
| Tucumán                       | F    |          36 |         11 |          2 |              0.010 |              0.056 |            0.011 |           0.306 |                  0.167 |           0.056 |
| Santiago del Estero           | M    |          32 |          1 |          0 |              0.000 |              0.000 |            0.014 |           0.031 |                  0.031 |           0.000 |
| Catamarca                     | M    |          24 |          0 |          0 |              0.000 |              0.000 |            0.027 |           0.000 |                  0.000 |           0.000 |
| Santa Cruz                    | F    |          24 |         14 |          0 |              0.000 |              0.000 |            0.077 |           0.583 |                  0.042 |           0.042 |
| Misiones                      | M    |          23 |         17 |          1 |              0.024 |              0.043 |            0.026 |           0.739 |                  0.174 |           0.087 |
| Misiones                      | F    |          20 |         13 |          1 |              0.026 |              0.050 |            0.026 |           0.650 |                  0.100 |           0.050 |
| Catamarca                     | F    |          15 |          0 |          0 |              0.000 |              0.000 |            0.027 |           0.000 |                  0.000 |           0.000 |
| San Luis                      | M    |          12 |          6 |          0 |              0.000 |              0.000 |            0.033 |           0.500 |                  0.083 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |

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
