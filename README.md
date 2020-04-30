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
regexp.neumonia.influenza <- "Influenz|neumon"

# List all Causas related to Influenza|Neumonía considered for classification

causas.descriptions <- sort(unique(data.deaths$CAUSA_description))
causas.descriptions[grep(regexp.neumonia.influenza, causas.descriptions, ignore.case = TRUE)]

 [1] Influenza debida a ciertos virus de la influenza identificados                   
 [2] Influenza debida a otro virus de la influenza identificado                       
 [3] Influenza debida a virus no identificado                                         
 [4] Neumonía bacteriana no clasificada en otra parte                                 
 [5] Neumonía congénita                                                               
 [6] Neumonía debida a Haemophilus influenzae                                         
 [7] Neumonía debida a otros microorganismos infecciosos no clasificados en otra parte
 [8] Neumonía debida a Streptococcus pneumoniae                                       
 [9] Neumonía organismo no especificado                                               
[10] Neumonía viral no clasificada en otra parte                                      
[11] Neumonitis debida a hipersensibilidad al polvo orgánico                          
[12] Neumonitis debida a sólidos y líquidos    

data.deaths$causa_agg <- "Otra"
data.deaths[grep(regexp.neumonia.influenza, data.deaths$CAUSA_description, ignore.case = TRUE),]$causa_agg <- "Influenza_Neumonia"

influenza.deaths <- data.deaths %>%
                      group_by(year, causa_agg) %>%
                      summarize (total = sum(CUENTA),
                                 edad.media = mean(EDAD_MEDIA, na.rm = TRUE))

influenza.deaths.tab <- dcast(influenza.deaths, formula = year~causa_agg, value.var = "total")
influenza.deaths.tab$total <- apply(influenza.deaths.tab[,2:3], MARGIN = 1, FUN = sum)
influenza.deaths.tab$Influenza_Neumonia.perc <- round(influenza.deaths.tab[,"Influenza_Neumonia"]/influenza.deaths.tab$total, 2)
influenza.deaths.tab$Otra.perc <- round(influenza.deaths.tab[,"Otra"]/influenza.deaths.tab$total, 2)
kable(influenza.deaths.tab)
```
| year| Influenza_Neumonia|   Otra|  total| Influenza_Neumonia.perc| Otra.perc|
|----:|------------------:|------:|------:|-----------------------:|---------:|
| 2012|              22971| 296568| 319539|                    0.07|      0.93|
| 2013|              26470| 299727| 326197|                    0.08|      0.92|
| 2014|              27854| 297685| 325539|                    0.09|      0.91|
| 2015|              31457| 301950| 333407|                    0.09|      0.91|
| 2016|              37445| 315547| 352992|                    0.11|      0.89|
| 2017|              36947| 304741| 341688|                    0.11|      0.89|
| 2018|              35169| 301654| 336823|                    0.10|      0.90|

```
influenza.deaths.edad.tab <- dcast(influenza.deaths, formula = year~causa_agg, value.var = "edad.media")
# Edad media is aproximated by the mean of age ranges
kable(influenza.deaths.edad.tab)
```

| year| Influenza_Neumonia|     Otra|
|----:|------------------:|--------:|
| 2012|           47.10167| 50.34319|
| 2013|           47.82090| 50.60034|
| 2014|           47.78061| 50.68185|
| 2015|           49.16512| 50.95847|
| 2016|           47.36900| 50.85284|
| 2017|           48.38045| 50.88867|
| 2018|           47.84594| 51.07340|



