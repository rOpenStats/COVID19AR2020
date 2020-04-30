retrieveURL <- function(url, dest.dir = getEnv("data_dir"), force = FALSE){
 url.splitted <- strsplit(url, split = "/")[[1]]
 filename <- url.splitted[length(url.splitted)]
 dest.path <- file.path(dest.dir, filename)
 ret <- FALSE
 if (!file.exists(dest.path) | force){
   download.file(url = url, destfile = dest.path)
   ret <- TRUE
 }
 ret
}


#'
#' @import rvest
#' @export
retrieveArgentinasDeathsStatistics <- function(){
 data.dir <- getEnv("data_dir")
 #http://www.deis.msal.gov.ar/index.php/base-de-datos/
 deaths.stats.html <- read_html("http://www.deis.msal.gov.ar/index.php/base-de-datos/")
 deaths.stats.html %>% html_nodes("") %>% html_attr('href')
 deaths.stats.html %>% html_attr('href')

 retrieveURL("http://www.deis.msal.gov.ar/wp-content/uploads/2019/01/DescDef1.xlsx")
 retrieveURL(url = "http://www.deis.msal.gov.ar/wp-content/uploads/2020/01/DefWeb18.csv")
 retrieveURL(url = "http://www.deis.msal.gov.ar/wp-content/uploads/2019/01/DefWeb17.csv")
 retrieveURL(url = "http://www.deis.msal.gov.ar/wp-content/uploads/2018/06/DefWeb16.csv")
 retrieveURL(url = "http://www.deis.msal.gov.ar/wp-content/uploads/2018/06/DefWeb15.csv")
 # http://www.deis.msal.gov.ar/wp-content/uploads/2018/06/DefWeb14.csv
 # http://www.deis.msal.gov.ar/wp-content/uploads/2018/06/DefWeb13.csv
 # http://www.deis.msal.gov.ar/wp-content/uploads/2018/06/DefWeb12.csv
}


