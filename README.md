
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
#> INFO  [22:10:44.412] Exists dest path? {dest.path: ~/.R/COVID19AR/Covid19Casos.csv, exists.dest.path: TRUE}
dummy <- covid19.curator$curateData()
#> INFO  [22:10:46.052] Normalize 
#> INFO  [22:10:46.434] checkSoundness 
#> INFO  [22:10:46.554] Mutating data
# Dates of current processed file
max(covid19.curator$data$fecha_apertura, na.rm = TRUE)
#> [1] "2020-06-15"
# Inicio de síntomas

max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)
#> [1] "2020-06-15"

# Ultima muerte
max(covid19.curator$data$fecha_fallecimiento,  na.rm = TRUE)
#> [1] "2020-06-15"

report.date <- max(covid19.curator$data$fecha_inicio_sintomas,  na.rm = TRUE)

covid19.ar.provincia.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre"))
covid19.ar.provincia.summary.100.confirmed <- covid19.ar.provincia.summary %>% filter(confirmados >= 100)
# Provinces with > 100 confirmed cases
covid19.ar.provincia.summary.100.confirmed$residencia_provincia_nombre
#>  [1] "Buenos Aires"     "CABA"             "Chaco"            "Córdoba"         
#>  [5] "Corrientes"       "Mendoza"          "Neuquén"          "Río Negro"       
#>  [9] "Santa Fe"         "SIN ESPECIFICAR"  "Tierra del Fuego"
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
| CABA                          |       15104 | 49700 |        299 |               13.7 |              0.015 |              0.020 |            0.304 |           0.292 |                  0.025 |           0.012 |
| Buenos Aires                  |       13710 | 84503 |        385 |               12.3 |              0.018 |              0.028 |            0.162 |           0.258 |                  0.029 |           0.012 |
| Chaco                         |        1364 |  8487 |         72 |               14.0 |              0.035 |              0.053 |            0.161 |           0.148 |                  0.061 |           0.034 |
| Río Negro                     |         564 |  2929 |         29 |               14.5 |              0.043 |              0.051 |            0.193 |           0.576 |                  0.035 |           0.018 |
| Córdoba                       |         497 | 16241 |         35 |               23.1 |              0.034 |              0.070 |            0.031 |           0.237 |                  0.060 |           0.024 |
| Santa Fe                      |         285 | 11005 |          3 |               25.0 |              0.007 |              0.011 |            0.026 |           0.193 |                  0.042 |           0.018 |
| SIN ESPECIFICAR               |         216 |   736 |          2 |                9.5 |              0.007 |              0.009 |            0.293 |           0.250 |                  0.023 |           0.014 |
| Neuquén                       |         212 |  1806 |          5 |                9.4 |              0.018 |              0.024 |            0.117 |           0.566 |                  0.014 |           0.014 |
| Tierra del Fuego              |         136 |  1558 |          0 |                NaN |              0.000 |              0.000 |            0.087 |           0.051 |                  0.015 |           0.015 |
| Mendoza                       |         112 |  2237 |          9 |               13.3 |              0.040 |              0.080 |            0.050 |           0.938 |                  0.098 |           0.045 |
| Corrientes                    |         104 |  2975 |          0 |                NaN |              0.000 |              0.000 |            0.035 |           0.019 |                  0.010 |           0.000 |
| Entre Ríos                    |          88 |  1653 |          0 |                NaN |              0.000 |              0.000 |            0.053 |           0.318 |                  0.000 |           0.000 |
| La Rioja                      |          64 |  1459 |          8 |               12.0 |              0.085 |              0.125 |            0.044 |           0.172 |                  0.062 |           0.016 |
| Chubut                        |          61 |   691 |          1 |               19.0 |              0.010 |              0.016 |            0.088 |           0.049 |                  0.016 |           0.016 |
| Tucumán                       |          56 |  5884 |          4 |               14.2 |              0.014 |              0.071 |            0.010 |           0.161 |                  0.071 |           0.036 |
| Santa Cruz                    |          50 |   544 |          0 |                NaN |              0.000 |              0.000 |            0.092 |           0.420 |                  0.080 |           0.040 |
| Misiones                      |          39 |  1249 |          2 |                6.5 |              0.034 |              0.051 |            0.031 |           0.718 |                  0.128 |           0.077 |
| Formosa                       |          34 |   731 |          0 |                NaN |              0.000 |              0.000 |            0.047 |           0.000 |                  0.000 |           0.000 |
| Salta                         |          23 |   774 |          0 |                NaN |              0.000 |              0.000 |            0.030 |           0.652 |                  0.000 |           0.000 |
| Santiago del Estero           |          22 |  2120 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.045 |                  0.045 |           0.000 |
| San Luis                      |          11 |   414 |          0 |                NaN |              0.000 |              0.000 |            0.027 |           0.727 |                  0.091 |           0.000 |
| Jujuy                         |           7 |  2232 |          1 |               22.0 |              0.007 |              0.143 |            0.003 |           0.286 |                  0.143 |           0.143 |
| San Juan                      |           7 |   702 |          0 |                NaN |              0.000 |              0.000 |            0.010 |           0.714 |                  0.143 |           0.000 |
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
#> INFO  [22:11:18.603] Processing {current.group: }
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
|             13 |        1067 |   5509 |        591 |         60 |              0.046 |              0.056 |            0.194 |           0.554 |                  0.096 |           0.057 |
|             14 |        1728 |  11519 |        950 |        109 |              0.051 |              0.063 |            0.150 |           0.550 |                  0.096 |           0.056 |
|             15 |        2358 |  20221 |       1277 |        168 |              0.056 |              0.071 |            0.117 |           0.542 |                  0.092 |           0.051 |
|             16 |        3087 |  31783 |       1601 |        221 |              0.054 |              0.072 |            0.097 |           0.519 |                  0.083 |           0.044 |
|             17 |        4092 |  45807 |       2082 |        317 |              0.059 |              0.077 |            0.089 |           0.509 |                  0.076 |           0.039 |
|             18 |        4979 |  58979 |       2454 |        376 |              0.058 |              0.076 |            0.084 |           0.493 |                  0.069 |           0.036 |
|             19 |        6308 |  73095 |       2986 |        440 |              0.054 |              0.070 |            0.086 |           0.473 |                  0.063 |           0.032 |
|             20 |        8534 |  90402 |       3756 |        506 |              0.046 |              0.059 |            0.094 |           0.440 |                  0.056 |           0.028 |
|             21 |       12657 | 113739 |       4960 |        617 |              0.039 |              0.049 |            0.111 |           0.392 |                  0.048 |           0.024 |
|             22 |       17609 | 138984 |       6246 |        724 |              0.033 |              0.041 |            0.127 |           0.355 |                  0.042 |           0.020 |
|             23 |       23571 | 166927 |       7506 |        810 |              0.028 |              0.034 |            0.141 |           0.318 |                  0.037 |           0.017 |
|             24 |       31999 | 198935 |       8976 |        854 |              0.020 |              0.027 |            0.161 |           0.281 |                  0.030 |           0.014 |
|             25 |       32772 | 201411 |       9063 |        855 |              0.018 |              0.026 |            0.163 |           0.277 |                  0.029 |           0.014 |

```` 

```r
covid19.ar.summary <- covid19.curator$makeSummary(group.vars = c("residencia_provincia_nombre", "sepi_apertura"))
#> INFO  [22:11:22.762] Processing {current.group: residencia_provincia_nombre = Buenos Aires}
#> INFO  [22:11:25.691] Processing {current.group: residencia_provincia_nombre = CABA}
#> INFO  [22:11:28.139] Processing {current.group: residencia_provincia_nombre = Catamarca}
#> INFO  [22:11:29.649] Processing {current.group: residencia_provincia_nombre = Chaco}
#> INFO  [22:11:30.983] Processing {current.group: residencia_provincia_nombre = Chubut}
#> INFO  [22:11:32.210] Processing {current.group: residencia_provincia_nombre = Córdoba}
#> INFO  [22:11:33.794] Processing {current.group: residencia_provincia_nombre = Corrientes}
#> INFO  [22:11:35.101] Processing {current.group: residencia_provincia_nombre = Entre Ríos}
#> INFO  [22:11:36.637] Processing {current.group: residencia_provincia_nombre = Formosa}
#> INFO  [22:11:38.168] Processing {current.group: residencia_provincia_nombre = Jujuy}
#> INFO  [22:11:39.505] Processing {current.group: residencia_provincia_nombre = La Pampa}
#> INFO  [22:11:40.815] Processing {current.group: residencia_provincia_nombre = La Rioja}
#> INFO  [22:11:42.411] Processing {current.group: residencia_provincia_nombre = Mendoza}
#> INFO  [22:11:43.882] Processing {current.group: residencia_provincia_nombre = Misiones}
#> INFO  [22:11:45.112] Processing {current.group: residencia_provincia_nombre = Neuquén}
#> INFO  [22:11:46.392] Processing {current.group: residencia_provincia_nombre = Río Negro}
#> INFO  [22:11:47.757] Processing {current.group: residencia_provincia_nombre = Salta}
#> INFO  [22:11:49.123] Processing {current.group: residencia_provincia_nombre = San Juan}
#> INFO  [22:11:50.426] Processing {current.group: residencia_provincia_nombre = San Luis}
#> INFO  [22:11:51.730] Processing {current.group: residencia_provincia_nombre = Santa Cruz}
#> INFO  [22:11:53.016] Processing {current.group: residencia_provincia_nombre = Santa Fe}
#> INFO  [22:11:54.506] Processing {current.group: residencia_provincia_nombre = Santiago del Estero}
#> INFO  [22:11:55.785] Processing {current.group: residencia_provincia_nombre = SIN ESPECIFICAR}
#> INFO  [22:11:57.243] Processing {current.group: residencia_provincia_nombre = Tierra del Fuego}
#> INFO  [22:11:58.661] Processing {current.group: residencia_provincia_nombre = Tucumán}
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
| CABA                          | F    |        7659 |       2213 |        127 |              0.013 |              0.017 |            0.293 |           0.289 |                  0.017 |           0.007 |
| CABA                          | M    |        7376 |       2177 |        168 |              0.018 |              0.023 |            0.316 |           0.295 |                  0.033 |           0.017 |
| Buenos Aires                  | M    |        7038 |       1866 |        225 |              0.021 |              0.032 |            0.173 |           0.265 |                  0.035 |           0.015 |
| Buenos Aires                  | F    |        6614 |       1660 |        159 |              0.015 |              0.024 |            0.152 |           0.251 |                  0.023 |           0.009 |
| Chaco                         | M    |         684 |        100 |         44 |              0.043 |              0.064 |            0.164 |           0.146 |                  0.070 |           0.048 |
| Chaco                         | F    |         678 |        102 |         28 |              0.027 |              0.041 |            0.158 |           0.150 |                  0.052 |           0.021 |
| Río Negro                     | M    |         283 |        164 |         17 |              0.050 |              0.060 |            0.206 |           0.580 |                  0.042 |           0.021 |
| Río Negro                     | F    |         281 |        161 |         12 |              0.035 |              0.043 |            0.181 |           0.573 |                  0.028 |           0.014 |
| Córdoba                       | F    |         250 |         69 |         18 |              0.035 |              0.072 |            0.030 |           0.276 |                  0.056 |           0.016 |
| Córdoba                       | M    |         245 |         48 |         17 |              0.033 |              0.069 |            0.031 |           0.196 |                  0.065 |           0.033 |
| Santa Fe                      | M    |         149 |         34 |          3 |              0.014 |              0.020 |            0.028 |           0.228 |                  0.060 |           0.034 |
| Santa Fe                      | F    |         136 |         21 |          0 |              0.000 |              0.000 |            0.024 |           0.154 |                  0.022 |           0.000 |
| SIN ESPECIFICAR               | F    |         119 |         25 |          0 |              0.000 |              0.000 |            0.277 |           0.210 |                  0.017 |           0.000 |
| Neuquén                       | F    |         106 |         57 |          2 |              0.014 |              0.019 |            0.122 |           0.538 |                  0.019 |           0.019 |
| Neuquén                       | M    |         106 |         63 |          3 |              0.021 |              0.028 |            0.113 |           0.594 |                  0.009 |           0.009 |
| SIN ESPECIFICAR               | M    |          95 |         28 |          1 |              0.008 |              0.011 |            0.322 |           0.295 |                  0.021 |           0.021 |
| Tierra del Fuego              | M    |          77 |          4 |          0 |              0.000 |              0.000 |            0.093 |           0.052 |                  0.026 |           0.026 |
| CABA                          | NR   |          69 |         16 |          4 |              0.030 |              0.058 |            0.299 |           0.232 |                  0.043 |           0.029 |
| Corrientes                    | M    |          66 |          1 |          0 |              0.000 |              0.000 |            0.039 |           0.015 |                  0.000 |           0.000 |
| Mendoza                       | M    |          62 |         57 |          9 |              0.076 |              0.145 |            0.053 |           0.919 |                  0.145 |           0.065 |
| Entre Ríos                    | M    |          59 |         22 |          0 |              0.000 |              0.000 |            0.069 |           0.373 |                  0.000 |           0.000 |
| Buenos Aires                  | NR   |          58 |         11 |          1 |              0.009 |              0.017 |            0.243 |           0.190 |                  0.034 |           0.000 |
| Tierra del Fuego              | F    |          58 |          3 |          0 |              0.000 |              0.000 |            0.080 |           0.052 |                  0.000 |           0.000 |
| Mendoza                       | F    |          50 |         48 |          0 |              0.000 |              0.000 |            0.047 |           0.960 |                  0.040 |           0.020 |
| Chubut                        | M    |          38 |          2 |          1 |              0.016 |              0.026 |            0.100 |           0.053 |                  0.026 |           0.026 |
| Corrientes                    | F    |          38 |          1 |          0 |              0.000 |              0.000 |            0.029 |           0.026 |                  0.026 |           0.000 |
| La Rioja                      | F    |          36 |          8 |          6 |              0.118 |              0.167 |            0.050 |           0.222 |                  0.083 |           0.028 |
| Formosa                       | M    |          34 |          0 |          0 |              0.000 |              0.000 |            0.078 |           0.000 |                  0.000 |           0.000 |
| Tucumán                       | M    |          34 |          5 |          2 |              0.010 |              0.059 |            0.009 |           0.147 |                  0.029 |           0.000 |
| Santa Cruz                    | M    |          31 |         12 |          0 |              0.000 |              0.000 |            0.099 |           0.387 |                  0.097 |           0.032 |
| Entre Ríos                    | F    |          29 |          6 |          0 |              0.000 |              0.000 |            0.036 |           0.207 |                  0.000 |           0.000 |
| La Rioja                      | M    |          28 |          3 |          2 |              0.047 |              0.071 |            0.038 |           0.107 |                  0.036 |           0.000 |
| Chubut                        | F    |          23 |          1 |          0 |              0.000 |              0.000 |            0.074 |           0.043 |                  0.000 |           0.000 |
| Tucumán                       | F    |          22 |          4 |          2 |              0.021 |              0.091 |            0.010 |           0.182 |                  0.136 |           0.091 |
| Misiones                      | M    |          21 |         15 |          1 |              0.030 |              0.048 |            0.031 |           0.714 |                  0.143 |           0.095 |
| Santa Cruz                    | F    |          19 |          9 |          0 |              0.000 |              0.000 |            0.082 |           0.474 |                  0.053 |           0.053 |
| Misiones                      | F    |          18 |         13 |          1 |              0.038 |              0.056 |            0.032 |           0.722 |                  0.111 |           0.056 |
| Santiago del Estero           | M    |          15 |          1 |          0 |              0.000 |              0.000 |            0.010 |           0.067 |                  0.067 |           0.000 |
| Salta                         | M    |          13 |         10 |          0 |              0.000 |              0.000 |            0.024 |           0.769 |                  0.000 |           0.000 |
| Salta                         | F    |          10 |          5 |          0 |              0.000 |              0.000 |            0.042 |           0.500 |                  0.000 |           0.000 |

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
#> Warning: Removed 35 rows containing missing values (position_stack).
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
#> Warning: Removed 13 rows containing missing values (position_stack).
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
#> Warning: Removed 13 rows containing missing values (position_stack).
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
#> Warning: Removed 5 rows containing missing values (position_stack).
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
