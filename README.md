# COVIDAR

A package for analysing COVID-19 Argentina's outbreak

 <!-- . -->




# Package

| Release | Usage | Development |
|:--------|:------|:------------|
| | [![minimal R version](https://img.shields.io/badge/R%3E%3D-3.6.0-blue.svg)](https://cran.r-project.org/) | [![Travis](https://travis-ci.org/kenarab/COVIDAR.svg?branch=master)](https://travis-ci.org/kenarab/COVIDAR) |
| [![CRAN](http://www.r-pkg.org/badges/version/COVIDAR)](https://cran.r-project.org/package=COVIDAR) | | [![codecov](https://codecov.io/gh/kenarab/COVIDAR/branch/master/graph/badge.svg)](https://codecov.io/gh/kenarab/COVIDAR) |
|||[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](https://www.repostatus.org/badges/latest/active.svg)](https://www.repostatus.org/#active)|




# How to get started (Development version)

Install the R package using the following commands on the R console:

The repository is private so it have to be cloned first for installation
```R
# install.packages("devtools")
devtools::install()
```

# How to use it

First add variable with data dir in `~/.Renviron`. You will recieve a message if you didn't do it. 

```.Renviron
COVID19AR_data_dir = "~/.R/COVID19AR"
```
You have to manually create the destination folder

# Example script for calculating proportion of influenza/Neumonia deaths in total deaths by year

```R
library(COVIDAR)
library(kable)
# Downloads csv from official source at:
# http://www.deis.msal.gov.ar/index.php/base-de-datos/
retrieveArgentinasDeathsStatistics()


consolidated.deaths.stats <- ConsolidatedDeathsData.class$new()
# Consolidates all years and includes the different codes as factor in the data frame
data.deaths <- consolidated.deaths.stats$consolidate()

# How many records do we have?
nrow(data.deaths)
# [1] 347549

# Cases with missing codes in CAUSA
kable(consolidated.deaths.stats$warnings)
```
| year|field |message                            |missed.codes | cases|
|----:|:-----|:----------------------------------|:------------|-----:|
| 2012|CAUSA |Codes I84 in field CAUSA not coded |I84          |     1|
| 2013|CAUSA |Codes I84 in field CAUSA not coded |I84          |     1|
| 2014|CAUSA |Codes I84 in field CAUSA not coded |I84          |     2|
| 2015|CAUSA |Codes I84 in field CAUSA not coded |I84          |     3|
| 2016|CAUSA |Codes R97 in field CAUSA not coded |R97          |    10|


```
regexp.neumonia.influenza <- "^J(09|1[0-8])"
regexp.otras.respiratorias <- "^J"

# List all Causas related to Influenza|Neumonía considered for classification

causas.descriptions <- sort(unique(data.deaths$codigo.causas))
> causas.descriptions[grep(regexp.neumonia.influenza, causas.descriptions, ignore.case = TRUE)]
[1] "J09|Influenza debida a ciertos virus de la influenza identificados"                   
[2] "J10|Influenza debida a otro virus de la influenza identificado"                       
[3] "J11|Influenza debida a virus no identificado"                                         
[4] "J12|Neumonía viral no clasificada en otra parte"                                      
[5] "J13|Neumonía debida a Streptococcus pneumoniae"                                       
[6] "J14|Neumonía debida a Haemophilus influenzae"                                         
[7] "J15|Neumonía bacteriana no clasificada en otra parte"                                 
[8] "J16|Neumonía debida a otros microorganismos infecciosos no clasificados en otra parte"
[9] "J18|Neumonía organismo no especificado" 

data.deaths$causa_agg <- "Otra"
data.deaths[grep(regexp.neumonia.influenza, data.deaths$codigo.causa, ignore.case = TRUE),]$causa_agg <- "Influenza_Neumonia"
data.deaths[which(grepl(regexp.otras.respiratorias, data.deaths$codigo.causa, ignore.case = TRUE) & data.deaths$causa_agg == "Otra"),]$causa_agg <- "Otras_respiratorias"

influenza.deaths <- data.deaths %>%
                      group_by(year, causa_agg) %>%
                      summarize (total = sum(CUENTA),
                                 edad.media = mean(EDAD_MEDIA, na.rm = TRUE))
influenza.deaths %>% filter(year == 2015)

influenza.deaths.tab <- dcast(influenza.deaths, formula = year~causa_agg, value.var = "total")
influenza.deaths.tab$total <- apply(influenza.deaths.tab[,2:4], MARGIN = 1, FUN = sum)
influenza.deaths.tab$Influenza_Neumonia.perc <- round(influenza.deaths.tab[,"Influenza_Neumonia"]/influenza.deaths.tab$total, 2)
influenza.deaths.tab$Otra.perc <- round(influenza.deaths.tab[,"Otra"]/influenza.deaths.tab$total, 2)
influenza.deaths.tab$Otras_respiratorias.perc <- round(influenza.deaths.tab[,"Otras_respiratorias"]/influenza.deaths.tab$total, 2)
kable(influenza.deaths.tab)
```

| year| Influenza_Neumonia|   Otra| Otras_respiratorias|  total| Influenza_Neumonia.perc| Otra.perc| Otras_respiratorias.perc|
|----:|------------------:|------:|-------------------:|------:|-----------------------:|---------:|------------------------:|
| 2012|              20009| 270283|               29247| 319539|                    0.06|      0.85|                     0.09|
| 2013|              23389| 273675|               29133| 326197|                    0.07|      0.84|                     0.09|
| 2014|              24583| 271289|               29667| 325539|                    0.08|      0.83|                     0.09|
| 2015|              27804| 276506|               29097| 333407|                    0.08|      0.83|                     0.09|
| 2016|              33632| 287807|               31553| 352992|                    0.10|      0.82|                     0.09|
| 2017|              33504| 276819|               31365| 341688|                    0.10|      0.81|                     0.09|
| 2018|              31916| 275155|               29752| 336823|                    0.09|      0.82|                     0.09|
```
influenza.deaths.edad.tab <- dcast(influenza.deaths, formula = year~causa_agg, value.var = "edad.media")
# Edad media is aproximated by the average of the mean of age ranges
kable(influenza.deaths.edad.tab)
```

| year| Influenza_Neumonia|     Otra| Otras_respiratorias|
|----:|------------------:|--------:|-------------------:|
| 2012|           46.15945| 50.16380|            53.24300|
| 2013|           46.59759| 50.37501|            54.32957|
| 2014|           47.00361| 50.50093|            53.47351|
| 2015|           47.91418| 50.75700|            54.46687|
| 2016|           46.37225| 50.67127|            53.76223|
| 2017|           47.20525| 50.68764|            54.23077|
| 2018|           46.79927| 50.86007|            54.53614|


