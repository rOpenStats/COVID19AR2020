
<!-- README.md is generated from README.Rmd. Please edit that file -->

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

First add variable with your prefered data dir configuration in
`~/.Renviron`. You will receive a message if you didn’t.

``` .renviron
COVID19AR_data_dir = "~/.R/COVID19AR"
```

``` r
library(COVID19AR)
#> Loading required package: R6
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
#> Loading required package: ggplot2
#> Loading required package: readr
#> Loading required package: readxl
#> Loading required package: lgr
#> 
#> Attaching package: 'lgr'
#> The following object is masked from 'package:ggplot2':
#> 
#>     Layout
#> Warning: replacing previous import 'ggplot2::Layout' by 'lgr::Layout' when
#> loading 'COVID19AR'
#> Warning: replacing previous import 'readr::guess_encoding' by
#> 'rvest::guess_encoding' when loading 'COVID19AR'
#> Warning: replacing previous import 'readr::col_factor' by 'scales::col_factor'
#> when loading 'COVID19AR'
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
covid19.curator <- COVID19ARCurator$new()

dummy <- covid19.curator$loadData()
#> INFO  [23:10:22.136] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [23:10:22.818] Normalize 
#> INFO  [23:10:23.054] checkSoundness 
#> INFO  [23:10:23.191] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-02"

# Inicio de síntomas
max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-02"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-02"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)

covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% filter(confirmados >= 100)
# Provinces with > 100 confirmed cases
covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre
#>  [1] "Buenos Aires"     "CABA"             "Chaco"            "Córdoba"         
#>  [5] "Mendoza"          "Neuquén"          "Río Negro"        "Santa Fe"        
#>  [9] "SIN ESPECIFICAR"  "Tierra del Fuego"
```

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
nrow(covid19.ar.summary)
#> [1] 25
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(desc(confirmados))) %>% 
        select_at(c("residencia_provincia_nombre", "confirmados", "tests", "fallecidos", "dias.fallecimiento",porc.cols)))
```

| residencia\_provincia\_nombre | confirmados | tests | fallecidos | dias.fallecimiento | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | ----------: | ----: | ---------: | -----------------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                          |        8691 | 33202 |        189 |               13.5 |              0.016 |              0.022 |            0.262 |           0.331 |                  0.028 |           0.014 |
| Buenos Aires                  |        6539 | 56030 |        244 |               12.4 |              0.022 |              0.037 |            0.117 |           0.333 |                  0.039 |           0.016 |
| Chaco                         |         919 |  6323 |         58 |               12.3 |              0.042 |              0.063 |            0.145 |           0.177 |                  0.074 |           0.041 |
| Córdoba                       |         458 | 13183 |         30 |               19.8 |              0.020 |              0.066 |            0.035 |           0.245 |                  0.061 |           0.024 |
| Río Negro                     |         409 |  2232 |         18 |               16.1 |              0.040 |              0.044 |            0.183 |           0.616 |                  0.037 |           0.017 |
| Santa Fe                      |         265 |  9046 |          3 |               25.0 |              0.007 |              0.011 |            0.029 |           0.204 |                  0.045 |           0.019 |
| Neuquén                       |         140 |  1435 |          5 |                9.4 |              0.029 |              0.036 |            0.098 |           0.721 |                  0.021 |           0.021 |
| Tierra del Fuego              |         136 |  1457 |          0 |                NaN |              0.000 |              0.000 |            0.093 |           0.051 |                  0.015 |           0.015 |
| SIN ESPECIFICAR               |         132 |   482 |          1 |                7.0 |              0.005 |              0.008 |            0.274 |           0.295 |                  0.030 |           0.015 |
| Mendoza                       |         100 |  1836 |          9 |               13.3 |              0.048 |              0.090 |            0.054 |           0.940 |                  0.110 |           0.050 |
| Corrientes                    |          96 |  2534 |          0 |                NaN |              0.000 |              0.000 |            0.038 |           0.010 |                  0.010 |           0.000 |
| La Rioja                      |          63 |  1251 |          7 |               13.0 |              0.069 |              0.111 |            0.050 |           0.159 |                  0.063 |           0.016 |
| Santa Cruz                    |          49 |   441 |          0 |                NaN |              0.000 |              0.000 |            0.111 |           0.408 |                  0.082 |           0.041 |
| Tucumán                       |          47 |  4522 |          4 |               14.2 |              0.014 |              0.085 |            0.010 |           0.213 |                  0.085 |           0.043 |
| Entre Ríos                    |          33 |  1164 |          0 |                NaN |              0.000 |              0.000 |            0.028 |           0.485 |                  0.000 |           0.000 |
| Misiones                      |          28 |   983 |          1 |               10.0 |              0.021 |              0.036 |            0.028 |           0.821 |                  0.071 |           0.036 |
| Santiago del Estero           |          23 |  1348 |          0 |                NaN |              0.000 |              0.000 |            0.017 |           0.087 |                  0.087 |           0.000 |
| Salta                         |          11 |   559 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.636 |                  0.000 |           0.000 |
| San Luis                      |          11 |   331 |          0 |                NaN |              0.000 |              0.000 |            0.033 |           0.727 |                  0.091 |           0.000 |
| Chubut                        |          10 |   368 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.300 |                  0.100 |           0.100 |
| Jujuy                         |           8 |  1788 |          0 |                NaN |              0.000 |              0.000 |            0.004 |           0.125 |                  0.000 |           0.000 |
| La Pampa                      |           5 |   231 |          0 |                NaN |              0.000 |              0.000 |            0.022 |           0.200 |                  0.000 |           0.000 |
| San Juan                      |           5 |   580 |          0 |                NaN |              0.000 |              0.000 |            0.009 |           1.000 |                  0.200 |           0.000 |

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
#> INFO  [23:10:37.569] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 19
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(sepi_apertura, desc(confirmados)) %>% select_at(c("sepi_apertura", "sepi_apertura", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))
```

| sepi\_apertura | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| -------------: | ----------: | -----: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
|             10 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 |          92 |    666 |         63 |          8 |              0.060 |              0.087 |            0.138 |           0.685 |                  0.130 |           0.065 |
|             12 |         406 |   2048 |        250 |         16 |              0.031 |              0.039 |            0.198 |           0.616 |                  0.091 |           0.052 |
|             13 |        1063 |   5506 |        587 |         60 |              0.046 |              0.056 |            0.193 |           0.552 |                  0.095 |           0.056 |
|             14 |        1720 |  11510 |        942 |        109 |              0.050 |              0.063 |            0.149 |           0.548 |                  0.095 |           0.055 |
|             15 |        2346 |  20209 |       1265 |        167 |              0.055 |              0.071 |            0.116 |           0.539 |                  0.091 |           0.050 |
|             16 |        3068 |  31763 |       1587 |        216 |              0.053 |              0.070 |            0.097 |           0.517 |                  0.082 |           0.044 |
|             17 |        4062 |  45738 |       2058 |        307 |              0.057 |              0.076 |            0.089 |           0.507 |                  0.075 |           0.039 |
|             18 |        4936 |  58825 |       2421 |        358 |              0.054 |              0.073 |            0.084 |           0.490 |                  0.068 |           0.035 |
|             19 |        6240 |  72794 |       2928 |        414 |              0.049 |              0.066 |            0.086 |           0.469 |                  0.062 |           0.031 |
|             20 |        8436 |  89988 |       3659 |        466 |              0.042 |              0.055 |            0.094 |           0.434 |                  0.055 |           0.027 |
|             21 |       12481 | 113064 |       4768 |        535 |              0.033 |              0.043 |            0.110 |           0.382 |                  0.046 |           0.022 |
|             22 |       17201 | 137472 |       5810 |        568 |              0.025 |              0.033 |            0.125 |           0.338 |                  0.038 |           0.018 |
|             23 |       18178 | 142319 |       5990 |        569 |              0.020 |              0.031 |            0.128 |           0.330 |                  0.036 |           0.017 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [23:10:39.985] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [23:10:41.627] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [23:10:42.920] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [23:10:43.732] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [23:10:44.644] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [23:10:45.452] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [23:10:46.574] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [23:10:47.456] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [23:10:48.337] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [23:10:49.265] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [23:10:50.090] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [23:10:50.911] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [23:10:51.868] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [23:10:52.809] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [23:10:53.566] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [23:10:54.382] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [23:10:55.262] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [23:10:56.080] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [23:10:56.934] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [23:10:57.792] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [23:10:58.638] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [23:10:59.672] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [23:11:00.480] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [23:11:01.404] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [23:11:02.344] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 351
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
````

``` r
sepi.fechas <- covid19.curator$data %>% 
  group_by(sepi_apertura) %>% 
  summarize(ultima_fecha_sepi = max(fecha_apertura), .groups = "keep")


data2plot <- covid19.ar.summary %>%
                filter(residencia_provincia_nombre %in% covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre) %>%
                filter(confirmados > 0 )
                
data2plot %<>% inner_join(sepi.fechas, by = "sepi_apertura")
dates <- sort(unique(data2plot$ultima_fecha_sepi))

covplot <- data2plot %>%
 ggplot(aes(x = ultima_fecha_sepi, y = confirmados, color = "confirmados")) +
 geom_line() +
 facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
 labs(title = "Porcentajes de positividad, uso de UCI, respirador y letalidad\n en provincias > 100 confirmados")
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
```

<img src="man/figures/README-residencia_provincia_nombre-sepi_apertura-plot-tests-1.png" width="100%" />

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
#> [1] 70
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                          | F    |        4358 |       1455 |         83 |              0.014 |              0.019 |            0.252 |           0.334 |                  0.020 |           0.008 |
| CABA                          | M    |        4296 |       1418 |        103 |              0.018 |              0.024 |            0.273 |           0.330 |                  0.037 |           0.019 |
| Buenos Aires                  | M    |        3343 |       1152 |        144 |              0.026 |              0.043 |            0.123 |           0.345 |                  0.047 |           0.020 |
| Buenos Aires                  | F    |        3177 |       1019 |        100 |              0.018 |              0.031 |            0.110 |           0.321 |                  0.030 |           0.012 |
| Chaco                         | M    |         468 |         83 |         36 |              0.054 |              0.077 |            0.151 |           0.177 |                  0.081 |           0.058 |
| Chaco                         | F    |         449 |         80 |         22 |              0.032 |              0.049 |            0.140 |           0.178 |                  0.067 |           0.024 |
| Córdoba                       | F    |         233 |         67 |         15 |              0.020 |              0.064 |            0.034 |           0.288 |                  0.060 |           0.017 |
| Córdoba                       | M    |         223 |         44 |         15 |              0.021 |              0.067 |            0.035 |           0.197 |                  0.063 |           0.031 |
| Río Negro                     | M    |         209 |        129 |         10 |              0.044 |              0.048 |            0.196 |           0.617 |                  0.033 |           0.014 |
| Río Negro                     | F    |         200 |        123 |          8 |              0.036 |              0.040 |            0.171 |           0.615 |                  0.040 |           0.020 |
| Santa Fe                      | M    |         137 |         33 |          3 |              0.013 |              0.022 |            0.031 |           0.241 |                  0.066 |           0.036 |
| Santa Fe                      | F    |         128 |         21 |          0 |              0.000 |              0.000 |            0.028 |           0.164 |                  0.023 |           0.000 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.098 |           0.052 |                  0.026 |           0.026 |
| Neuquén                       | M    |          75 |         53 |          3 |              0.033 |              0.040 |            0.098 |           0.707 |                  0.013 |           0.013 |
| SIN ESPECIFICAR               | F    |          72 |         20 |          0 |              0.000 |              0.000 |            0.267 |           0.278 |                  0.028 |           0.000 |
| Neuquén                       | F    |          65 |         48 |          2 |              0.024 |              0.031 |            0.097 |           0.738 |                  0.031 |           0.031 |
| Corrientes                    | M    |          62 |          0 |          0 |              0.000 |              0.000 |            0.043 |           0.000 |                  0.000 |           0.000 |
| SIN ESPECIFICAR               | M    |          59 |         19 |          1 |              0.013 |              0.017 |            0.289 |           0.322 |                  0.034 |           0.034 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.087 |           0.052 |                  0.000 |           0.000 |
| Mendoza                       | M    |          52 |         49 |          9 |              0.088 |              0.173 |            0.055 |           0.942 |                  0.173 |           0.077 |
| Mendoza                       | F    |          48 |         45 |          0 |              0.000 |              0.000 |            0.055 |           0.938 |                  0.042 |           0.021 |
| CABA                          | NR   |          37 |          8 |          3 |              0.036 |              0.081 |            0.250 |           0.216 |                  0.027 |           0.027 |
| La Rioja                      | F    |          35 |          7 |          5 |              0.091 |              0.143 |            0.056 |           0.200 |                  0.086 |           0.029 |
| Corrientes                    | F    |          34 |          1 |          0 |              0.000 |              0.000 |            0.031 |           0.029 |                  0.029 |           0.000 |
| Santa Cruz                    | M    |          30 |         11 |          0 |              0.000 |              0.000 |            0.117 |           0.367 |                  0.100 |           0.033 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.043 |              0.071 |            0.045 |           0.107 |                  0.036 |           0.000 |
| Tucumán                       | M    |          27 |          5 |          2 |              0.011 |              0.074 |            0.010 |           0.185 |                  0.037 |           0.000 |
| Entre Ríos                    | M    |          22 |         12 |          0 |              0.000 |              0.000 |            0.036 |           0.545 |                  0.000 |           0.000 |
| Tucumán                       | F    |          20 |          5 |          2 |              0.019 |              0.100 |            0.011 |           0.250 |                  0.150 |           0.100 |
| Buenos Aires                  | NR   |          19 |          9 |          0 |              0.000 |              0.000 |            0.158 |           0.474 |                  0.105 |           0.000 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.103 |           0.474 |                  0.053 |           0.053 |
| Santiago del Estero           | M    |          16 |          2 |          0 |              0.000 |              0.000 |            0.018 |           0.125 |                  0.125 |           0.000 |
| Misiones                      | M    |          15 |         13 |          1 |              0.037 |              0.067 |            0.028 |           0.867 |                  0.133 |           0.067 |
| Misiones                      | F    |          13 |         10 |          0 |              0.000 |              0.000 |            0.029 |           0.769 |                  0.000 |           0.000 |
| Entre Ríos                    | F    |          11 |          4 |          0 |              0.000 |              0.000 |            0.020 |           0.364 |                  0.000 |           0.000 |

``` r

covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "edad.rango"))

 # Share per province
 provinces.deaths <-covid19.ar.summary %>%
    group_by(residencia_provincia_nombre) %>%
    summarise(fallecidos.total.provincia = sum(fallecidos), .groups = "keep")
 covid19.ar.summary %<>% inner_join(provinces.deaths, by = "residencia_provincia_nombre")
 covid19.ar.summary %<>% mutate(fallecidos.prop = fallecidos/fallecidos.total.provincia)

 # Data 2 plot
 data2plot <- covid19.ar.summary %>% filter(residencia_provincia_nombre %in% covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre)

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
#> Warning: Removed 17 rows containing missing values (position_stack).
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-1.png" width="100%" />

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
#> Warning: Removed 7 rows containing missing values (position_stack).
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-2.png" width="100%" />

``` r

 # ventilator rate
 covidplot <- data2plot %>%
   ggplot(aes(x = edad.rango, y = respirador.porc, fill = edad.rango)) +
   geom_bar(stat = "identity") +
   facet_wrap(~residencia_provincia_nombre, ncol = 2, scales = "free_y") +
   labs(title = "Porcentaje de pacientes con requerimientos de respirador mecánico por rango etario\n en provincias > 100 confirmados")
 covidplot <- setupTheme(covidplot, report.date = report.date, x.values = NULL, x.type = NULL,
                      total.colors = length(unique(data2plot$edad.rango)),
                      data.provider.abv = "@msalnacion", base.size = 6)
 covidplot
#> Warning: Removed 7 rows containing missing values (position_stack).
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-3.png" width="100%" />

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
#> Warning: Removed 2 rows containing missing values (position_stack).
```

<img src="man/figures/README-residencia_provincia_nombre-edad.rango-4.png" width="100%" />

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
