
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
covid19.curator <- COVID19ARCurator$new()

dummy <- covid19.curator$loadData()
#> INFO  [21:09:22.812] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [21:09:23.589] Normalize 
#> INFO  [21:09:23.803] checkSoundness 
#> INFO  [21:09:23.935] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-03"

# Inicio de síntomas
max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-03"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-03"

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
| CABA                          |        9198 | 34629 |        194 |               13.5 |              0.016 |              0.021 |            0.266 |           0.327 |                  0.028 |           0.014 |
| Buenos Aires                  |        7050 | 58411 |        249 |               12.2 |              0.021 |              0.035 |            0.121 |           0.323 |                  0.037 |           0.015 |
| Chaco                         |         926 |  6476 |         59 |               12.2 |              0.040 |              0.064 |            0.143 |           0.178 |                  0.075 |           0.042 |
| Córdoba                       |         460 | 13417 |         31 |               21.5 |              0.021 |              0.067 |            0.034 |           0.250 |                  0.063 |           0.026 |
| Río Negro                     |         426 |  2286 |         18 |               16.1 |              0.039 |              0.042 |            0.186 |           0.610 |                  0.035 |           0.016 |
| Santa Fe                      |         268 |  9272 |          3 |               25.0 |              0.007 |              0.011 |            0.029 |           0.201 |                  0.045 |           0.019 |
| Neuquén                       |         150 |  1467 |          5 |                9.4 |              0.026 |              0.033 |            0.102 |           0.673 |                  0.020 |           0.020 |
| SIN ESPECIFICAR               |         142 |   505 |          1 |                7.0 |              0.005 |              0.007 |            0.281 |           0.289 |                  0.035 |           0.021 |
| Tierra del Fuego              |         136 |  1470 |          0 |                NaN |              0.000 |              0.000 |            0.093 |           0.051 |                  0.015 |           0.015 |
| Mendoza                       |         100 |  1887 |          9 |               13.3 |              0.048 |              0.090 |            0.053 |           0.940 |                  0.110 |           0.050 |
| Corrientes                    |          96 |  2625 |          0 |                NaN |              0.000 |              0.000 |            0.037 |           0.010 |                  0.010 |           0.000 |
| La Rioja                      |          63 |  1261 |          7 |               13.0 |              0.065 |              0.111 |            0.050 |           0.159 |                  0.063 |           0.016 |
| Santa Cruz                    |          49 |   465 |          0 |                NaN |              0.000 |              0.000 |            0.105 |           0.429 |                  0.082 |           0.041 |
| Tucumán                       |          47 |  4598 |          4 |               14.2 |              0.011 |              0.085 |            0.010 |           0.213 |                  0.085 |           0.043 |
| Entre Ríos                    |          35 |  1205 |          0 |                NaN |              0.000 |              0.000 |            0.029 |           0.457 |                  0.000 |           0.000 |
| Misiones                      |          31 |  1033 |          1 |               10.0 |              0.021 |              0.032 |            0.030 |           0.742 |                  0.065 |           0.032 |
| Santiago del Estero           |          22 |  1434 |          0 |                NaN |              0.000 |              0.000 |            0.015 |           0.045 |                  0.045 |           0.000 |
| Salta                         |          15 |   588 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.467 |                  0.000 |           0.000 |
| Chubut                        |          11 |   394 |          0 |                NaN |              0.000 |              0.000 |            0.028 |           0.273 |                  0.091 |           0.091 |
| San Luis                      |          11 |   340 |          0 |                NaN |              0.000 |              0.000 |            0.032 |           0.727 |                  0.091 |           0.000 |
| Jujuy                         |           9 |  1815 |          0 |                NaN |              0.000 |              0.000 |            0.005 |           0.222 |                  0.111 |           0.111 |
| La Pampa                      |           5 |   234 |          0 |                NaN |              0.000 |              0.000 |            0.021 |           0.200 |                  0.000 |           0.000 |
| San Juan                      |           5 |   602 |          0 |                NaN |              0.000 |              0.000 |            0.008 |           1.000 |                  0.200 |           0.000 |

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
#> INFO  [21:09:39.892] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 19
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(sepi_apertura, desc(confirmados)) %>% select_at(c("sepi_apertura", "sepi_apertura", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))
```

| sepi\_apertura | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| -------------: | ----------: | -----: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
|             10 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 |          92 |    666 |         63 |          8 |              0.060 |              0.087 |            0.138 |           0.685 |                  0.130 |           0.065 |
|             12 |         406 |   2048 |        251 |         16 |              0.031 |              0.039 |            0.198 |           0.618 |                  0.094 |           0.054 |
|             13 |        1064 |   5506 |        589 |         60 |              0.046 |              0.056 |            0.193 |           0.554 |                  0.096 |           0.057 |
|             14 |        1721 |  11511 |        944 |        109 |              0.050 |              0.063 |            0.150 |           0.549 |                  0.096 |           0.056 |
|             15 |        2348 |  20210 |       1268 |        168 |              0.056 |              0.072 |            0.116 |           0.540 |                  0.092 |           0.050 |
|             16 |        3071 |  31765 |       1590 |        217 |              0.053 |              0.071 |            0.097 |           0.518 |                  0.083 |           0.044 |
|             17 |        4067 |  45742 |       2062 |        309 |              0.057 |              0.076 |            0.089 |           0.507 |                  0.075 |           0.039 |
|             18 |        4942 |  58837 |       2426 |        360 |              0.054 |              0.073 |            0.084 |           0.491 |                  0.069 |           0.035 |
|             19 |        6247 |  72818 |       2934 |        416 |              0.050 |              0.067 |            0.086 |           0.470 |                  0.063 |           0.031 |
|             20 |        8446 |  90020 |       3671 |        469 |              0.042 |              0.056 |            0.094 |           0.435 |                  0.055 |           0.027 |
|             21 |       12505 | 113129 |       4797 |        540 |              0.033 |              0.043 |            0.111 |           0.384 |                  0.046 |           0.022 |
|             22 |       17300 | 137910 |       5885 |        576 |              0.025 |              0.033 |            0.125 |           0.340 |                  0.038 |           0.018 |
|             23 |       19255 | 147422 |       6228 |        581 |              0.019 |              0.030 |            0.131 |           0.323 |                  0.036 |           0.016 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [21:09:42.393] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [21:09:44.347] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [21:09:45.942] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [21:09:46.985] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [21:09:48.161] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [21:09:49.243] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [21:09:50.698] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [21:09:51.837] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [21:09:52.973] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [21:09:54.176] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [21:09:55.225] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [21:09:56.273] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [21:09:57.468] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [21:09:58.659] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [21:09:59.611] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [21:10:00.692] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [21:10:01.811] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [21:10:02.854] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [21:10:03.895] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [21:10:04.950] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [21:10:06.020] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [21:10:07.286] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [21:10:08.368] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [21:10:09.563] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [21:10:10.759] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
#> [1] 79
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable((covid19.ar.summary %>% filter(confirmados >= 10) %>% arrange(desc(confirmados))) %>% select_at(c("residencia_provincia_nombre", "sexo", "confirmados", "internados", "fallecidos",  porc.cols)))
```

| residencia\_provincia\_nombre | sexo | confirmados | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| :---------------------------- | :--- | ----------: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
| CABA                          | F    |        4632 |       1517 |         86 |              0.014 |              0.019 |            0.256 |           0.328 |                  0.020 |           0.009 |
| CABA                          | M    |        4529 |       1483 |        105 |              0.017 |              0.023 |            0.276 |           0.327 |                  0.036 |           0.019 |
| Buenos Aires                  | M    |        3612 |       1199 |        147 |              0.025 |              0.041 |            0.128 |           0.332 |                  0.044 |           0.019 |
| Buenos Aires                  | F    |        3416 |       1067 |        102 |              0.017 |              0.030 |            0.114 |           0.312 |                  0.029 |           0.011 |
| Chaco                         | M    |         472 |         84 |         37 |              0.051 |              0.078 |            0.149 |           0.178 |                  0.083 |           0.059 |
| Chaco                         | F    |         452 |         81 |         22 |              0.030 |              0.049 |            0.137 |           0.179 |                  0.066 |           0.024 |
| Córdoba                       | F    |         233 |         68 |         16 |              0.021 |              0.069 |            0.034 |           0.292 |                  0.060 |           0.017 |
| Córdoba                       | M    |         225 |         46 |         15 |              0.022 |              0.067 |            0.035 |           0.204 |                  0.067 |           0.036 |
| Río Negro                     | M    |         220 |        135 |         10 |              0.043 |              0.045 |            0.201 |           0.614 |                  0.032 |           0.014 |
| Río Negro                     | F    |         206 |        125 |          8 |              0.035 |              0.039 |            0.173 |           0.607 |                  0.039 |           0.019 |
| Santa Fe                      | M    |         139 |         33 |          3 |              0.014 |              0.022 |            0.031 |           0.237 |                  0.065 |           0.036 |
| Santa Fe                      | F    |         129 |         21 |          0 |              0.000 |              0.000 |            0.027 |           0.163 |                  0.023 |           0.000 |
| SIN ESPECIFICAR               | F    |          81 |         22 |          0 |              0.000 |              0.000 |            0.279 |           0.272 |                  0.037 |           0.012 |
| Neuquén                       | M    |          80 |         53 |          3 |              0.031 |              0.038 |            0.102 |           0.662 |                  0.013 |           0.013 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.097 |           0.052 |                  0.026 |           0.026 |
| Neuquén                       | F    |          70 |         48 |          2 |              0.022 |              0.029 |            0.102 |           0.686 |                  0.029 |           0.029 |
| Corrientes                    | M    |          62 |          0 |          0 |              0.000 |              0.000 |            0.042 |           0.000 |                  0.000 |           0.000 |
| SIN ESPECIFICAR               | M    |          60 |         19 |          1 |              0.012 |              0.017 |            0.291 |           0.317 |                  0.033 |           0.033 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.086 |           0.052 |                  0.000 |           0.000 |
| Mendoza                       | M    |          52 |         49 |          9 |              0.088 |              0.173 |            0.053 |           0.942 |                  0.173 |           0.077 |
| Mendoza                       | F    |          48 |         45 |          0 |              0.000 |              0.000 |            0.053 |           0.938 |                  0.042 |           0.021 |
| La Rioja                      | F    |          35 |          7 |          5 |              0.088 |              0.143 |            0.056 |           0.200 |                  0.086 |           0.029 |
| Corrientes                    | F    |          34 |          1 |          0 |              0.000 |              0.000 |            0.030 |           0.029 |                  0.029 |           0.000 |
| Santa Cruz                    | M    |          30 |         12 |          0 |              0.000 |              0.000 |            0.112 |           0.400 |                  0.100 |           0.033 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.039 |              0.071 |            0.045 |           0.107 |                  0.036 |           0.000 |
| Tucumán                       | M    |          27 |          5 |          2 |              0.009 |              0.074 |            0.010 |           0.185 |                  0.037 |           0.000 |
| CABA                          | A    |          26 |          5 |          3 |              0.091 |              0.115 |            0.268 |           0.192 |                  0.038 |           0.038 |
| Entre Ríos                    | M    |          23 |         12 |          0 |              0.000 |              0.000 |            0.037 |           0.522 |                  0.000 |           0.000 |
| Tucumán                       | F    |          20 |          5 |          2 |              0.015 |              0.100 |            0.011 |           0.250 |                  0.150 |           0.100 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.096 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | M    |          18 |         13 |          1 |              0.036 |              0.056 |            0.032 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          15 |          1 |          0 |              0.000 |              0.000 |            0.016 |           0.067 |                  0.067 |           0.000 |
| Misiones                      | F    |          13 |         10 |          0 |              0.000 |              0.000 |            0.028 |           0.769 |                  0.000 |           0.000 |
| Entre Ríos                    | F    |          12 |          4 |          0 |              0.000 |              0.000 |            0.021 |           0.333 |                  0.000 |           0.000 |
| Buenos Aires                  | A    |          11 |          4 |          0 |              0.000 |              0.000 |            0.175 |           0.364 |                  0.182 |           0.000 |
| Buenos Aires                  | NA   |          11 |          5 |          0 |              0.000 |              0.000 |            0.180 |           0.455 |                  0.000 |           0.000 |
| CABA                          | NA   |          11 |          3 |          0 |              0.000 |              0.000 |            0.200 |           0.273 |                  0.000 |           0.000 |

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
#> Warning: Removed 8 rows containing missing values (position_stack).
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
#> Warning: Removed 8 rows containing missing values (position_stack).
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
#> Warning: Removed 1 rows containing missing values (position_stack).
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
