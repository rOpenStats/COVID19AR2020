library(COVID19AR)
data.dir <- getEnv("data_dir")
data.files <- dir(data.dir)
data.files


retrieveArgentinasDeathsStatistics()

deaths.metadata <- readMetadata(file.path = file.path(data.dir, "DescDef1.xlsx"))

data.deaths.2018 <- readDeathsStats(data.dir, "DefWeb18.csv", metadata = deaths.metadata)
data.deaths.2017 <- readDeathsStats(data.dir, "DefWeb17.csv", metadata = deaths.metadata)
data.deaths <- rbind(data.deaths.2017, data.deaths.2018)
nrow(data.deaths)
head(data.deaths.2018)

causas <- sort(unique(data.deaths$CAUSA_description))
causas[grep("Influenz|neumon", causas, ignore.case = TRUE)]
regexp.neumonia.influenza <- "Influenz|neumon"
data.deaths$causa_neumonia_influenza <- FALSE
data.deaths[grep(regexp.neumonia.influenza, data.deaths$CAUSA_description, ignore.case = TRUE),]$causa_neumonia_influenza <- TRUE

data.deaths %>%
 group_by(year, causa_neumonia_influenza) %>%
 summarize (total = sum(CUENTA))



data.deaths <- consolidateDeathsData()


consolidated.deaths.stats <- ConsolidatedDeathsData.class$new()
data.deaths <- consolidated.deaths.stats$consolidate()

consolidated.deaths.stats$warnings


regexp.neumonia.influenza <- "Influenz|neumon"
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

influenza.deaths.edad.tab <- dcast(influenza.deaths, formula = year~causa_agg, value.var = "edad.media")




