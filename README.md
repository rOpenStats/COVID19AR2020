
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
#> INFO  [16:46:03.610] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [16:46:08.062] Normalize 
#> INFO  [16:46:08.753] checkSoundness 
#> INFO  [16:46:09.066] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-07-17"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-07-17"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-07-17"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = NULL)

kable(covid19.ar.summary %>% select(max_fecha_diagnostico, confirmados, fallecidos, letalidad.min.porc, letalidad.max.porc, count_fecha_diagnostico, tests, positividad.porc))
```

| max\_fecha\_diagnostico | confirmados | fallecidos | letalidad.min.porc | letalidad.max.porc | count\_fecha\_diagnostico |  tests | positividad.porc |
| :---------------------- | ----------: | ---------: | -----------------: | -----------------: | ------------------------: | -----: | ---------------: |
| 2020-07-17              |      119288 |       2178 |              0.013 |              0.018 |                       142 | 440880 |            0.271 |

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
| Buenos Aires                  |       65957 |       1080 |              0.011 |              0.016 |                       141 | 213752 |            0.309 |
| CABA                          |       42541 |        808 |              0.016 |              0.019 |                       140 | 111648 |            0.381 |
| Chaco                         |        2858 |        118 |              0.029 |              0.041 |                       128 |  16837 |            0.170 |
| Río Negro                     |        1272 |         54 |              0.037 |              0.042 |                       123 |   5631 |            0.226 |
| Córdoba                       |        1109 |         38 |              0.016 |              0.034 |                       130 |  25214 |            0.044 |
| SIN ESPECIFICAR               |        1085 |          3 |              0.002 |              0.003 |                       118 |   2735 |            0.397 |
| Neuquén                       |         840 |         22 |              0.021 |              0.026 |                       125 |   3552 |            0.236 |
| Jujuy                         |         673 |          1 |              0.000 |              0.001 |                       119 |   4849 |            0.139 |
| Santa Fe                      |         632 |          8 |              0.008 |              0.013 |                       126 |  16532 |            0.038 |
| Entre Ríos                    |         600 |          5 |              0.005 |              0.008 |                       123 |   3510 |            0.171 |
| Mendoza                       |         403 |         14 |              0.021 |              0.035 |                       129 |   4420 |            0.091 |
| Chubut                        |         226 |          2 |              0.004 |              0.009 |                       108 |   2237 |            0.101 |
| Tierra del Fuego              |         201 |          2 |              0.007 |              0.010 |                       121 |   1809 |            0.111 |
| La Rioja                      |         164 |         15 |              0.059 |              0.091 |                       114 |   2993 |            0.055 |
| Salta                         |         135 |          2 |              0.007 |              0.015 |                       118 |   1450 |            0.093 |
| Corrientes                    |         132 |          0 |              0.000 |              0.000 |                       120 |   3788 |            0.035 |
| Santa Cruz                    |         106 |          0 |              0.000 |              0.000 |                       115 |    819 |            0.129 |

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
| Buenos Aires                  |       65957 | 213752 |       1080 |               13.2 |              0.011 |              0.016 |            0.309 |           0.143 |                  0.016 |           0.006 |
| CABA                          |       42541 | 111648 |        808 |               14.6 |              0.016 |              0.019 |            0.381 |           0.227 |                  0.020 |           0.009 |
| Chaco                         |        2858 |  16837 |        118 |               14.8 |              0.029 |              0.041 |            0.170 |           0.101 |                  0.055 |           0.021 |
| Río Negro                     |        1272 |   5631 |         54 |               14.2 |              0.037 |              0.042 |            0.226 |           0.384 |                  0.029 |           0.019 |
| Córdoba                       |        1109 |  25214 |         38 |               23.6 |              0.016 |              0.034 |            0.044 |           0.118 |                  0.029 |           0.011 |
| SIN ESPECIFICAR               |        1085 |   2735 |          3 |               24.3 |              0.002 |              0.003 |            0.397 |           0.109 |                  0.006 |           0.003 |
| Neuquén                       |         840 |   3552 |         22 |               18.6 |              0.021 |              0.026 |            0.236 |           0.652 |                  0.012 |           0.007 |
| Jujuy                         |         673 |   4849 |          1 |               22.0 |              0.000 |              0.001 |            0.139 |           0.012 |                  0.003 |           0.003 |
| Santa Fe                      |         632 |  16532 |          8 |               19.4 |              0.008 |              0.013 |            0.038 |           0.131 |                  0.030 |           0.013 |
| Entre Ríos                    |         600 |   3510 |          5 |                7.8 |              0.005 |              0.008 |            0.171 |           0.228 |                  0.008 |           0.002 |
| Mendoza                       |         403 |   4420 |         14 |               11.6 |              0.021 |              0.035 |            0.091 |           0.725 |                  0.042 |           0.015 |
| Chubut                        |         226 |   2237 |          2 |               10.5 |              0.004 |              0.009 |            0.101 |           0.062 |                  0.018 |           0.013 |
| Tierra del Fuego              |         201 |   1809 |          2 |               19.0 |              0.007 |              0.010 |            0.111 |           0.035 |                  0.015 |           0.015 |
| La Rioja                      |         164 |   2993 |         15 |               13.2 |              0.059 |              0.091 |            0.055 |           0.104 |                  0.024 |           0.006 |
| Salta                         |         135 |   1450 |          2 |                2.5 |              0.007 |              0.015 |            0.093 |           0.363 |                  0.015 |           0.007 |
| Corrientes                    |         132 |   3788 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.030 |                  0.008 |           0.000 |
| Santa Cruz                    |         106 |    819 |          0 |                NaN |              0.000 |              0.000 |            0.129 |           0.283 |                  0.047 |           0.028 |
| Tucumán                       |          99 |   9176 |          4 |               14.2 |              0.007 |              0.040 |            0.011 |           0.273 |                  0.091 |           0.020 |
| Formosa                       |          78 |    792 |          0 |                NaN |              0.000 |              0.000 |            0.098 |           0.013 |                  0.000 |           0.000 |
| Catamarca                     |          54 |   1568 |          0 |                NaN |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           |          43 |   3680 |          0 |                NaN |              0.000 |              0.000 |            0.012 |           0.070 |                  0.047 |           0.000 |
| Misiones                      |          42 |   1766 |          2 |                6.5 |              0.018 |              0.048 |            0.024 |           0.690 |                  0.143 |           0.071 |
| San Luis                      |          16 |    670 |          0 |                NaN |              0.000 |              0.000 |            0.024 |           0.500 |                  0.062 |           0.000 |
| San Juan                      |          14 |    912 |          0 |                NaN |              0.000 |              0.000 |            0.015 |           0.357 |                  0.071 |           0.000 |
| La Pampa                      |           8 |    540 |          0 |                NaN |              0.000 |              0.000 |            0.015 |           0.125 |                  0.000 |           0.000 |

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
#> INFO  [16:47:19.751] Processing {current.group: }
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
|             11 | 2020-07-15              |                        36 |          95 |    666 |         65 |          9 |              0.066 |              0.095 |            0.143 |           0.684 |                  0.126 |           0.063 |
|             12 | 2020-07-15              |                        56 |         409 |   2048 |        253 |         17 |              0.033 |              0.042 |            0.200 |           0.619 |                  0.093 |           0.054 |
|             13 | 2020-07-16              |                        85 |        1077 |   5514 |        597 |         62 |              0.048 |              0.058 |            0.195 |           0.554 |                  0.095 |           0.057 |
|             14 | 2020-07-17              |                       111 |        1753 |  11529 |        962 |        112 |              0.052 |              0.064 |            0.152 |           0.549 |                  0.095 |           0.056 |
|             15 | 2020-07-17              |                       132 |        2404 |  20241 |       1300 |        173 |              0.058 |              0.072 |            0.119 |           0.541 |                  0.090 |           0.051 |
|             16 | 2020-07-17              |                       139 |        3173 |  31841 |       1639 |        228 |              0.056 |              0.072 |            0.100 |           0.517 |                  0.081 |           0.044 |
|             17 | 2020-07-17              |                       142 |        4239 |  45890 |       2140 |        329 |              0.061 |              0.078 |            0.092 |           0.505 |                  0.074 |           0.039 |
|             18 | 2020-07-17              |                       142 |        5190 |  59076 |       2525 |        392 |              0.060 |              0.076 |            0.088 |           0.487 |                  0.067 |           0.035 |
|             19 | 2020-07-17              |                       142 |        6586 |  73200 |       3088 |        466 |              0.056 |              0.071 |            0.090 |           0.469 |                  0.062 |           0.032 |
|             20 | 2020-07-17              |                       142 |        8909 |  90558 |       3910 |        547 |              0.050 |              0.061 |            0.098 |           0.439 |                  0.056 |           0.029 |
|             21 | 2020-07-17              |                       142 |       13177 | 113962 |       5193 |        682 |              0.042 |              0.052 |            0.116 |           0.394 |                  0.049 |           0.025 |
|             22 | 2020-07-17              |                       142 |       18306 | 139301 |       6590 |        841 |              0.038 |              0.046 |            0.131 |           0.360 |                  0.044 |           0.022 |
|             23 | 2020-07-17              |                       142 |       24594 | 167511 |       8081 |       1031 |              0.035 |              0.042 |            0.147 |           0.329 |                  0.040 |           0.019 |
|             24 | 2020-07-17              |                       142 |       34002 | 202517 |      10138 |       1231 |              0.030 |              0.036 |            0.168 |           0.298 |                  0.035 |           0.017 |
|             25 | 2020-07-17              |                       142 |       46625 | 243710 |      12366 |       1462 |              0.026 |              0.031 |            0.191 |           0.265 |                  0.031 |           0.014 |
|             26 | 2020-07-17              |                       142 |       64004 | 295170 |      15205 |       1743 |              0.023 |              0.027 |            0.217 |           0.238 |                  0.026 |           0.012 |
|             27 | 2020-07-17              |                       142 |       82040 | 344698 |      17607 |       1964 |              0.020 |              0.024 |            0.238 |           0.215 |                  0.024 |           0.010 |
|             28 | 2020-07-17              |                       142 |      103995 | 401018 |      20051 |       2125 |              0.017 |              0.020 |            0.259 |           0.193 |                  0.021 |           0.009 |
|             29 | 2020-07-17              |                       142 |      119288 | 440880 |      21402 |       2178 |              0.013 |              0.018 |            0.271 |           0.179 |                  0.019 |           0.008 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [16:47:48.015] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [16:48:00.673] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [16:48:08.953] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [16:48:10.131] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [16:48:13.243] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [16:48:14.959] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [16:48:18.936] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [16:48:21.008] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [16:48:23.028] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [16:48:24.432] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [16:48:26.579] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [16:48:28.301] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [16:48:30.288] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [16:48:32.489] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [16:48:35.476] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [16:48:37.566] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [16:48:39.756] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [16:48:41.546] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [16:48:43.225] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [16:48:44.975] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [16:48:46.671] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [16:48:49.561] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [16:48:51.412] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [16:48:53.236] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [16:48:55.176] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| Buenos Aires                  | M    |       33692 |       5109 |        630 |              0.013 |              0.019 |            0.326 |           0.152 |                  0.019 |           0.008 |
| Buenos Aires                  | F    |       32017 |       4302 |        446 |              0.010 |              0.014 |            0.292 |           0.134 |                  0.013 |           0.004 |
| CABA                          | F    |       21333 |       4757 |        343 |              0.013 |              0.016 |            0.364 |           0.223 |                  0.015 |           0.006 |
| CABA                          | M    |       21029 |       4854 |        453 |              0.018 |              0.022 |            0.400 |           0.231 |                  0.026 |           0.012 |
| Chaco                         | F    |        1435 |        140 |         45 |              0.022 |              0.031 |            0.170 |           0.098 |                  0.045 |           0.013 |
| Chaco                         | M    |        1421 |        149 |         73 |              0.036 |              0.051 |            0.170 |           0.105 |                  0.064 |           0.030 |
| Río Negro                     | F    |         652 |        246 |         19 |              0.026 |              0.029 |            0.216 |           0.377 |                  0.017 |           0.009 |
| Río Negro                     | M    |         620 |        242 |         35 |              0.049 |              0.056 |            0.238 |           0.390 |                  0.042 |           0.029 |
| SIN ESPECIFICAR               | F    |         607 |         60 |          1 |              0.001 |              0.002 |            0.375 |           0.099 |                  0.005 |           0.000 |
| Córdoba                       | M    |         561 |         56 |         19 |              0.016 |              0.034 |            0.045 |           0.100 |                  0.030 |           0.014 |
| Córdoba                       | F    |         546 |         74 |         19 |              0.015 |              0.035 |            0.043 |           0.136 |                  0.027 |           0.007 |
| SIN ESPECIFICAR               | M    |         474 |         57 |          1 |              0.002 |              0.002 |            0.430 |           0.120 |                  0.006 |           0.004 |
| Neuquén                       | F    |         432 |        291 |         12 |              0.023 |              0.028 |            0.247 |           0.674 |                  0.009 |           0.007 |
| Jujuy                         | M    |         414 |          8 |          1 |              0.001 |              0.002 |            0.147 |           0.019 |                  0.005 |           0.005 |
| Neuquén                       | M    |         408 |        257 |         10 |              0.020 |              0.025 |            0.227 |           0.630 |                  0.015 |           0.007 |
| Santa Fe                      | M    |         320 |         52 |          6 |              0.013 |              0.019 |            0.040 |           0.162 |                  0.041 |           0.022 |
| Santa Fe                      | F    |         312 |         31 |          2 |              0.004 |              0.006 |            0.037 |           0.099 |                  0.019 |           0.003 |
| Entre Ríos                    | M    |         301 |         75 |          3 |              0.006 |              0.010 |            0.173 |           0.249 |                  0.010 |           0.003 |
| Entre Ríos                    | F    |         298 |         62 |          2 |              0.004 |              0.007 |            0.169 |           0.208 |                  0.007 |           0.000 |
| Jujuy                         | F    |         257 |          0 |          0 |              0.000 |              0.000 |            0.128 |           0.000 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |         248 |         30 |          4 |              0.009 |              0.016 |            0.342 |           0.121 |                  0.028 |           0.008 |
| Mendoza                       | M    |         204 |        150 |         13 |              0.040 |              0.064 |            0.092 |           0.735 |                  0.064 |           0.025 |
| Mendoza                       | F    |         197 |        140 |          1 |              0.003 |              0.005 |            0.090 |           0.711 |                  0.020 |           0.005 |
| CABA                          | NR   |         179 |         61 |         12 |              0.038 |              0.067 |            0.349 |           0.341 |                  0.050 |           0.039 |
| Tierra del Fuego              | M    |         141 |          4 |          2 |              0.011 |              0.014 |            0.142 |           0.028 |                  0.021 |           0.021 |
| Chubut                        | M    |         122 |          9 |          1 |              0.003 |              0.008 |            0.105 |           0.074 |                  0.016 |           0.016 |
| Chubut                        | F    |         101 |          5 |          1 |              0.004 |              0.010 |            0.095 |           0.050 |                  0.020 |           0.010 |
| La Rioja                      | F    |          86 |         10 |          7 |              0.054 |              0.081 |            0.060 |           0.116 |                  0.035 |           0.012 |
| Salta                         | M    |          84 |         30 |          2 |              0.012 |              0.024 |            0.086 |           0.357 |                  0.024 |           0.012 |
| Corrientes                    | M    |          79 |          3 |          0 |              0.000 |              0.000 |            0.037 |           0.038 |                  0.000 |           0.000 |
| La Rioja                      | M    |          78 |          7 |          8 |              0.065 |              0.103 |            0.051 |           0.090 |                  0.013 |           0.000 |
| Formosa                       | M    |          67 |          1 |          0 |              0.000 |              0.000 |            0.141 |           0.015 |                  0.000 |           0.000 |
| Santa Cruz                    | M    |          64 |         16 |          0 |              0.000 |              0.000 |            0.138 |           0.250 |                  0.062 |           0.031 |
| Tierra del Fuego              | F    |          59 |          3 |          0 |              0.000 |              0.000 |            0.073 |           0.051 |                  0.000 |           0.000 |
| Tucumán                       | M    |          59 |         14 |          2 |              0.006 |              0.034 |            0.010 |           0.237 |                  0.051 |           0.000 |
| Corrientes                    | F    |          53 |          1 |          0 |              0.000 |              0.000 |            0.032 |           0.019 |                  0.019 |           0.000 |
| Salta                         | F    |          51 |         19 |          0 |              0.000 |              0.000 |            0.109 |           0.373 |                  0.000 |           0.000 |
| Santa Cruz                    | F    |          42 |         14 |          0 |              0.000 |              0.000 |            0.119 |           0.333 |                  0.024 |           0.024 |
| Tucumán                       | F    |          40 |         13 |          2 |              0.009 |              0.050 |            0.011 |           0.325 |                  0.150 |           0.050 |
| Catamarca                     | M    |          33 |          0 |          0 |              0.000 |              0.000 |            0.034 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           | M    |          33 |          2 |          0 |              0.000 |              0.000 |            0.013 |           0.061 |                  0.030 |           0.000 |
| Misiones                      | M    |          22 |         16 |          1 |              0.017 |              0.045 |            0.023 |           0.727 |                  0.182 |           0.091 |
| Catamarca                     | F    |          21 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| Misiones                      | F    |          20 |         13 |          1 |              0.020 |              0.050 |            0.024 |           0.650 |                  0.100 |           0.050 |
| San Luis                      | M    |          14 |          6 |          0 |              0.000 |              0.000 |            0.036 |           0.429 |                  0.071 |           0.000 |
| Formosa                       | F    |          11 |          0 |          0 |              0.000 |              0.000 |            0.035 |           0.000 |                  0.000 |           0.000 |
| San Juan                      | M    |          10 |          2 |          0 |              0.000 |              0.000 |            0.019 |           0.200 |                  0.000 |           0.000 |
| Santiago del Estero           | F    |          10 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.100 |                  0.100 |           0.000 |

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
