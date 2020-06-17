
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

First add variable with your preferred data dir configuration in
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
covid19.curator <- COVID19ARCurator$new(download.new.data = FALSE)

dummy <- covid19.curator$loadData()
#> INFO  [00:14:07.855] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [00:14:09.694] Normalize 
#> INFO  [00:14:10.098] checkSoundness 
#> INFO  [00:14:10.229] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-16"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-16"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-16"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)

covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% filter(confirmados >= 100)
# Provinces with > 100 confirmed cases
covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre
#>  [1] "Buenos Aires"     "CABA"             "Chaco"            "Córdoba"         
#>  [5] "Corrientes"       "Entre Ríos"       "Mendoza"          "Neuquén"         
#>  [9] "Río Negro"        "Santa Fe"         "SIN ESPECIFICAR"  "Tierra del Fuego"
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
| CABA                          |       15582 | 50928 |        310 |               13.6 |              0.015 |              0.020 |            0.306 |           0.290 |                  0.025 |           0.012 |
| Buenos Aires                  |       14509 | 86964 |        390 |               12.2 |              0.017 |              0.027 |            0.167 |           0.252 |                  0.028 |           0.012 |
| Chaco                         |        1387 |  8633 |         77 |               14.1 |              0.035 |              0.056 |            0.161 |           0.149 |                  0.061 |           0.035 |
| Río Negro                     |         581 |  3030 |         29 |               14.5 |              0.045 |              0.050 |            0.192 |           0.561 |                  0.034 |           0.017 |
| Córdoba                       |         498 | 16398 |         35 |               23.1 |              0.031 |              0.070 |            0.030 |           0.237 |                  0.060 |           0.024 |
| Santa Fe                      |         288 | 11057 |          4 |               25.5 |              0.008 |              0.014 |            0.026 |           0.191 |                  0.045 |           0.021 |
| Neuquén                       |         240 |  1847 |          6 |                9.4 |              0.020 |              0.025 |            0.130 |           0.504 |                  0.017 |           0.017 |
| SIN ESPECIFICAR               |         228 |   766 |          2 |                9.5 |              0.007 |              0.009 |            0.298 |           0.250 |                  0.022 |           0.013 |
| Tierra del Fuego              |         136 |  1559 |          0 |                NaN |              0.000 |              0.000 |            0.087 |           0.051 |                  0.015 |           0.015 |
| Mendoza                       |         115 |  2283 |          9 |               13.3 |              0.039 |              0.078 |            0.050 |           0.948 |                  0.096 |           0.043 |
| Corrientes                    |         105 |  3024 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.019 |                  0.010 |           0.000 |
| Entre Ríos                    |         100 |  1702 |          0 |                NaN |              0.000 |              0.000 |            0.059 |           0.280 |                  0.000 |           0.000 |
| La Rioja                      |          64 |  1461 |          8 |               12.0 |              0.077 |              0.125 |            0.044 |           0.172 |                  0.062 |           0.016 |
| Chubut                        |          62 |   699 |          1 |               19.0 |              0.009 |              0.016 |            0.089 |           0.048 |                  0.016 |           0.016 |
| Tucumán                       |          55 |  5949 |          4 |               14.2 |              0.012 |              0.073 |            0.009 |           0.164 |                  0.073 |           0.036 |
| Santa Cruz                    |          50 |   552 |          0 |                NaN |              0.000 |              0.000 |            0.091 |           0.420 |                  0.080 |           0.040 |
| Misiones                      |          38 |  1250 |          2 |                6.5 |              0.033 |              0.053 |            0.030 |           0.737 |                  0.132 |           0.079 |
| Formosa                       |          34 |   732 |          0 |                NaN |              0.000 |              0.000 |            0.046 |           0.000 |                  0.000 |           0.000 |
| Santiago del Estero           |          22 |  2200 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.045 |                  0.045 |           0.000 |
| Salta                         |          21 |   787 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.667 |                  0.000 |           0.000 |
| San Luis                      |          11 |   431 |          0 |                NaN |              0.000 |              0.000 |            0.026 |           0.727 |                  0.091 |           0.000 |
| Jujuy                         |           7 |  2282 |          1 |               22.0 |              0.007 |              0.143 |            0.003 |           0.286 |                  0.143 |           0.143 |
| San Juan                      |           7 |   714 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.714 |                  0.143 |           0.000 |
| La Pampa                      |           6 |   294 |          0 |                NaN |              0.000 |              0.000 |            0.020 |           0.167 |                  0.000 |           0.000 |

``` r
getDepartamentosExponentialGrowthPlot(covid19.curator)
#> Parsed with column specification:
#> cols(
#>   .default = col_double(),
#>   residencia_provincia_nombre = col_character(),
#>   residencia_departamento_nombre = col_character(),
#>   fecha_apertura = col_date(format = "")
#> )
#> See spec(...) for full column specifications.
#> Scale for 'y' is already present. Adding another scale for 'y', which will
#> replace the existing scale.
```

<img src="man/figures/README-exponential_growth-1.png" width="100%" />

``` r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("sepi_apertura"))
#> INFO  [00:14:38.902] Processing {current.group: }
nrow(covid19.ar.summary)
#> [1] 21
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
kable(covid19.ar.summary %>% filter(confirmados > 0) %>% arrange(sepi_apertura, desc(confirmados)) %>% select_at(c("sepi_apertura", "sepi_apertura", "confirmados", "tests", "internados", "fallecidos",  porc.cols)))
```

| sepi\_apertura | confirmados |  tests | internados | fallecidos | letalidad.min.porc | letalidad.max.porc | positividad.porc | internados.porc | cuidado.intensivo.porc | respirador.porc |
| -------------: | ----------: | -----: | ---------: | ---------: | -----------------: | -----------------: | ---------------: | --------------: | ---------------------: | --------------: |
|             10 |          15 |     85 |          9 |          1 |              0.045 |              0.067 |            0.176 |           0.600 |                  0.133 |           0.133 |
|             11 |          92 |    666 |         63 |          8 |              0.060 |              0.087 |            0.138 |           0.685 |                  0.130 |           0.065 |
|             12 |         406 |   2048 |        251 |         16 |              0.031 |              0.039 |            0.198 |           0.618 |                  0.094 |           0.054 |
|             13 |        1068 |   5509 |        592 |         60 |              0.046 |              0.056 |            0.194 |           0.554 |                  0.096 |           0.057 |
|             14 |        1729 |  11519 |        951 |        109 |              0.051 |              0.063 |            0.150 |           0.550 |                  0.096 |           0.056 |
|             15 |        2359 |  20221 |       1278 |        168 |              0.056 |              0.071 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 |        3088 |  31783 |       1602 |        221 |              0.054 |              0.072 |            0.097 |           0.519 |                  0.083 |           0.044 |
|             17 |        4097 |  45808 |       2085 |        317 |              0.059 |              0.077 |            0.089 |           0.509 |                  0.076 |           0.039 |
|             18 |        4985 |  58980 |       2457 |        376 |              0.058 |              0.075 |            0.085 |           0.493 |                  0.069 |           0.036 |
|             19 |        6314 |  73096 |       2989 |        440 |              0.054 |              0.070 |            0.086 |           0.473 |                  0.063 |           0.032 |
|             20 |        8541 |  90404 |       3762 |        506 |              0.047 |              0.059 |            0.094 |           0.440 |                  0.056 |           0.028 |
|             21 |       12668 | 113746 |       4969 |        619 |              0.039 |              0.049 |            0.111 |           0.392 |                  0.048 |           0.024 |
|             22 |       17626 | 138996 |       6260 |        727 |              0.033 |              0.041 |            0.127 |           0.355 |                  0.042 |           0.021 |
|             23 |       23596 | 166964 |       7529 |        818 |              0.028 |              0.035 |            0.141 |           0.319 |                  0.037 |           0.018 |
|             24 |       32282 | 199988 |       9092 |        873 |              0.021 |              0.027 |            0.161 |           0.282 |                  0.030 |           0.014 |
|             25 |       34146 | 206034 |       9308 |        878 |              0.017 |              0.026 |            0.166 |           0.273 |                  0.029 |           0.013 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [00:14:43.153] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [00:14:45.828] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [00:14:47.877] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [00:14:49.214] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [00:14:50.661] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [00:14:51.927] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [00:14:53.641] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [00:14:55.064] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [00:14:56.421] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [00:14:57.825] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [00:14:59.087] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [00:15:00.349] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [00:15:01.685] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [00:15:03.097] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [00:15:04.514] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [00:15:05.817] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [00:15:07.228] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [00:15:08.525] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [00:15:09.850] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [00:15:11.130] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [00:15:12.436] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [00:15:14.176] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [00:15:15.453] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [00:15:16.895] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [00:15:18.328] Processing {current.group: residencia_provincia_nombre = Tucumán}
nrow(covid19.ar.summary)
#> [1] 401
porc.cols <- names(covid19.ar.summary)[grep("porc", names(covid19.ar.summary))]
````

``` r
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
| CABA                          | F    |        7903 |       2269 |        134 |              0.013 |              0.017 |            0.295 |           0.287 |                  0.017 |           0.007 |
| CABA                          | M    |        7608 |       2233 |        172 |              0.018 |              0.023 |            0.318 |           0.294 |                  0.032 |           0.018 |
| Buenos Aires                  | M    |        7467 |       1932 |        228 |              0.020 |              0.031 |            0.178 |           0.259 |                  0.033 |           0.014 |
| Buenos Aires                  | F    |        6980 |       1713 |        161 |              0.014 |              0.023 |            0.156 |           0.245 |                  0.023 |           0.009 |
| Chaco                         | M    |         698 |        104 |         49 |              0.045 |              0.070 |            0.164 |           0.149 |                  0.072 |           0.049 |
| Chaco                         | F    |         687 |        102 |         28 |              0.025 |              0.041 |            0.158 |           0.148 |                  0.051 |           0.020 |
| Río Negro                     | M    |         293 |        165 |         17 |              0.052 |              0.058 |            0.205 |           0.563 |                  0.041 |           0.020 |
| Río Negro                     | F    |         288 |        161 |         12 |              0.037 |              0.042 |            0.180 |           0.559 |                  0.028 |           0.014 |
| Córdoba                       | F    |         250 |         69 |         18 |              0.032 |              0.072 |            0.030 |           0.276 |                  0.056 |           0.016 |
| Córdoba                       | M    |         246 |         48 |         17 |              0.031 |              0.069 |            0.031 |           0.195 |                  0.065 |           0.033 |
| Santa Fe                      | M    |         151 |         34 |          3 |              0.011 |              0.020 |            0.028 |           0.225 |                  0.060 |           0.033 |
| Santa Fe                      | F    |         137 |         21 |          1 |              0.004 |              0.007 |            0.024 |           0.153 |                  0.029 |           0.007 |
| SIN ESPECIFICAR               | F    |         125 |         26 |          0 |              0.000 |              0.000 |            0.280 |           0.208 |                  0.016 |           0.000 |
| Neuquén                       | F    |         121 |         58 |          3 |              0.020 |              0.025 |            0.136 |           0.479 |                  0.025 |           0.025 |
| Neuquén                       | M    |         119 |         63 |          3 |              0.019 |              0.025 |            0.124 |           0.529 |                  0.008 |           0.008 |
| SIN ESPECIFICAR               | M    |         101 |         30 |          1 |              0.008 |              0.010 |            0.327 |           0.297 |                  0.020 |           0.020 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.093 |           0.052 |                  0.026 |           0.026 |
| CABA                          | NR   |          71 |         18 |          4 |              0.030 |              0.056 |            0.298 |           0.254 |                  0.042 |           0.028 |
| Corrientes                    | M    |          67 |          1 |          0 |              0.000 |              0.000 |            0.039 |           0.015 |                  0.000 |           0.000 |
| Mendoza                       | M    |          63 |         59 |          9 |              0.071 |              0.143 |            0.053 |           0.937 |                  0.143 |           0.063 |
| Buenos Aires                  | NR   |          62 |         11 |          1 |              0.009 |              0.016 |            0.250 |           0.177 |                  0.032 |           0.000 |
| Entre Ríos                    | M    |          60 |         22 |          0 |              0.000 |              0.000 |            0.069 |           0.367 |                  0.000 |           0.000 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.080 |           0.052 |                  0.000 |           0.000 |
| Mendoza                       | F    |          52 |         50 |          0 |              0.000 |              0.000 |            0.048 |           0.962 |                  0.038 |           0.019 |
| Chubut                        | M    |          39 |          2 |          1 |              0.016 |              0.026 |            0.101 |           0.051 |                  0.026 |           0.026 |
| Entre Ríos                    | F    |          39 |          6 |          0 |              0.000 |              0.000 |            0.047 |           0.154 |                  0.000 |           0.000 |
| Corrientes                    | F    |          38 |          1 |          0 |              0.000 |              0.000 |            0.029 |           0.026 |                  0.026 |           0.000 |
| La Rioja                      | F    |          36 |          8 |          6 |              0.107 |              0.167 |            0.050 |           0.222 |                  0.083 |           0.028 |
| Formosa                       | M    |          34 |          0 |          0 |              0.000 |              0.000 |            0.078 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | M    |          33 |          5 |          2 |              0.010 |              0.061 |            0.009 |           0.152 |                  0.030 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.098 |           0.387 |                  0.097 |           0.032 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.042 |              0.071 |            0.038 |           0.107 |                  0.036 |           0.000 |
| Chubut                        | F    |          23 |          1 |          0 |              0.000 |              0.000 |            0.074 |           0.043 |                  0.000 |           0.000 |
| Tucumán                       | F    |          22 |          4 |          2 |              0.017 |              0.091 |            0.010 |           0.182 |                  0.136 |           0.091 |
| Misiones                      | M    |          20 |         15 |          1 |              0.029 |              0.050 |            0.029 |           0.750 |                  0.150 |           0.100 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.081 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.038 |              0.056 |            0.032 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          15 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.067 |                  0.067 |           0.000 |
| Salta                         | M    |          12 |          9 |          0 |              0.000 |              0.000 |            0.022 |           0.750 |                  0.000 |           0.000 |

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
#> Warning: Removed 53 rows containing missing values (position_stack).
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
#> Warning: Removed 14 rows containing missing values (position_stack).
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
#> Warning: Removed 14 rows containing missing values (position_stack).
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
#> Warning: Removed 3 rows containing missing values (position_stack).
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
