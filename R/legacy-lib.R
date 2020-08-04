#' COVID19ARLegacyCompressor
#' @author kenarab
#' @importFrom R6 R6Class
#' @import dplyr
#' @export
COVID19ARLegacyCompressor <- R6Class("COVID19ARLegacyCompressor",
  public = list(
   report.source.dir    = NA,
   report.snapshots.dir = NA,
   temp.dir             = NA,
   # state
   casos.df             = NA,
   max.date             = NA,
   casos.mapping        = NA,
   logger               = NA,
   initialize = function(report.source.dir = "~/.R/COVID19AR/",
                         report.snapshots.dir = "../COVID19ARdata/sources/msalnacion"){
    self$report.source.dir    <- report.source.dir
    self$report.snapshots.dir <- report.snapshots.dir
    self$temp.dir             <- file.path(tempdir(), "COVID19AR")
    self$logger               <- genLogger(self)
    self
   },
   buildCasosMapping = function(){
    casos.mapping <- data.frame(git.id = "7903a570c65736ad931ac25e05c92c4c7315cd8d", update.date = as.Date("2020-06-24"))
    casos.mapping <- rbind(casos.mapping,
                           c("6732da9116949a47eb5d76230565ebaa1552a250", "2020-06-23"))
    casos.mapping <- rbind(casos.mapping,
                           c("302a212eddb1c7b21a8806c2d589868e58c8c63a", "2020-06-22"))
    casos.mapping <- rbind(casos.mapping,
                           c("92086347aa6eb88e57cf6bee5c4ddd6cc17e26f3", "2020-06-21"))
    casos.mapping <- rbind(casos.mapping,
                           c("9f334f0d679f0af8731c6c5d001a36bf61f7e360", "2020-06-20"))
    casos.mapping <- rbind(casos.mapping,
                           c("3d9409aae05c14d6ba6fc570e866eac24e404b6e", "2020-06-19"))
    casos.mapping <- rbind(casos.mapping,
                           c("c61cdf724c8676ed9a995f69b624a9cc4fc526ac", "2020-06-18"))
    casos.mapping <- rbind(casos.mapping,
                           c("1f3dfe30d87d18530b53205c83dbddb7b17578c7", "2020-06-17"))
    casos.mapping <- rbind(casos.mapping,
                           c("414090f440649265bd5e9e6835271306f318208f", "2020-06-16"))
    casos.mapping <- rbind(casos.mapping,
                           c("9de131e67b913b0aeae1e7e5b4db2d5f6d7d4cef", "2020-06-15"))
    casos.mapping <- rbind(casos.mapping,
                           c("7f24d251521c371b09eaba351ba2b1e630dbfc0", "2020-06-14"))
    casos.mapping <- rbind(casos.mapping,
                           c("c52a91fa61e5131ca5a3da27932430424455ab33", "2020-06-13"))
    casos.mapping <- rbind(casos.mapping,
                           c("580a00b169c125e21ae4dfc2a9962b52825a0243", "2020-06-12"))
    casos.mapping <- rbind(casos.mapping,
                           c("a0ace6c7bb8393d67d142f0c3d4f67785f32258f", "2020-06-25"))
    casos.mapping <- rbind(casos.mapping,
                           c("224b24155b79e13a4edbb76a367f5cf326ab3194", "2020-06-26"))
    casos.mapping <- rbind(casos.mapping,
                           c("1f001f367d63b4413497ea7fb68b8704e710995f", "2020-06-27"))
    casos.mapping <- rbind(casos.mapping,
                           c("5e121f76e31ddae57f5d991e7dd9296de453b952", "2020-06-28"))
    casos.mapping <- rbind(casos.mapping,
                           c("f217d13707738a0b2f9442365460bce4a538b9ab", "2020-06-29"))
    casos.mapping <- rbind(casos.mapping,
                           c("8ca97731452fa62d6755c4ace9141acf7d68bc7d", "2020-06-30"))
    casos.mapping <- rbind(casos.mapping,
                           c("c7051a08952f48b747ba4b0eadfd4ba15aa0ddbb", "2020-07-01"))
    casos.mapping <- rbind(casos.mapping,
                           c("d0fa4b764fd742c9d8c846e245c80700b759c302", "2020-07-02"))

    casos.mapping <- rbind(casos.mapping,
                           c("25b8d6b7a2e51b988f65900dd2738494bb318e3d", "2020-07-03"))
    casos.mapping <- rbind(casos.mapping,
                           c("8e0d93a5ede2c4a55ed053e4bea1071a2b1a7125", "2020-07-04"))
    casos.mapping <- rbind(casos.mapping,
                           c("e0c4bca62362d9b10278d94209538f18cd1c5cfa", "2020-07-05"))
    #362739 Covid19CasosReporte20200705.csv but max(date) = 2020-07-04
    #360610 Covid19CasosReporte20200704.csv
    casos.mapping <- rbind(casos.mapping,
                           c("3120ce6dab8515195d977b9d4933a162c3507ce9", "2020-07-06"))
    casos.mapping <- rbind(casos.mapping,
                           c("64ece3070f1ebedbd57b3605b92a323eae1c9068", "2020-07-07"))
    casos.mapping <- rbind(casos.mapping,
                           c("973232f299d8185fbb63a5f7ca917242597d726e", "2020-07-08"))
    casos.mapping <- rbind(casos.mapping,
                           c("cfdafefc1f023ed032ad434058683328928780b0", "2020-07-09"))
    casos.mapping <- rbind(casos.mapping,
                           c("5cb28eee2aaba93e457705742bd97b5dc1707ccc", "2020-07-10"))
    casos.mapping <- rbind(casos.mapping,
                           c("e7f3ec1b851b485d6066519cf5b2b9b502053387", "2020-07-11"))
    casos.mapping <- rbind(casos.mapping,
                           c("f0afdfeab9547f3fe90aa255f4be5849e46d359e", "2020-07-12"))
    casos.mapping <- rbind(casos.mapping,
                           c("a397b8c6367529dbff2af2f452f81ebd3ac8937b", "2020-07-13"))
    casos.mapping <- rbind(casos.mapping,
                           c("e642ea259bb343da478c41665a62c667ba468d0f", "2020-07-14"))
    casos.mapping <- rbind(casos.mapping,
                           c("4f6c4f5b08e265982b17cf6ce02fd8014d22d22e", "2020-07-15"))
    # From 2020-07-16 to 2020-08-03 was copied from local files
    casos.mapping %<>% arrange(update.date)
    self$casos.mapping <- casos.mapping
    self$casos.mapping
   },
   getReportUrl = function(commit.id){
    paste("https://raw.githubusercontent.com/rOpenStats/COVID19ARdata",
          commit.id,
          "sources/msalnacion/Covid19Casos.csv", sep = "/")
   },
   compressSnapshot = function(snapshot.date, dest.filename = NULL){
    logger <- getLogger(self)
    snapshot.date <- as.Date(snapshot.date)
    dir.create(self$temp.dir, showWarnings = FALSE, recursive = TRUE)
    snapshot.caso <- self$casos.mapping %>% filter(update.date == snapshot.date)
    covid19casos.filename <- "Covid19Casos.csv"
    dest.filepath <- ""
    if (nrow(snapshot.caso) == 1){
     current.url <- self$getReportUrl(snapshot.caso$git.id)
     if (is.null(dest.filename)){
      url.splitted <- strsplit(current.url, split = "/")[[1]]
      dest.filename <- url.splitted[length(url.splitted)]
     }
     logger$info("Downloading url", url = current.url)
     file.path <- retrieveURL(data.url = current.url,
                              dest.dir = self$temp.dir,
                              dest.filename = dest.filename,
                              col.types = self$cols.specifications[[self$specification]],
                              force.download = TRUE)
     dest.filepath <- file.path(self$temp.dir, dest.filename)
    }
    else{
     if (nrow(snapshot.caso) == 0){
      source.filepath <- file.path(self$report.source.dir,
                                   paste("Covid19Casos.", as.character(snapshot.date, format = "%y%m%d"), ".csv", sep = ""))
      dest.filepath <- file.path(self$temp.dir, covid19casos.filename)
      logger$info("Copying file from", source = source.filepath, dest = dest.filepath)
      copied <- file.copy(source.filepath, dest.filepath, overwrite = TRUE)
      if (!copied){
       stop(paste("File not copied"))
      }
     }
     else{
      stop(paste("Snapshot definition should be unique but found", nrow(snapshot.caso, "for snapshot.date", snapshot.date)))
     }
    }
    #Translate from UTF16 if corresponds
    dest.filepath <- fixEncoding(dest.filepath)
    covid19casos.filepath <- file.path(self$temp.dir , covid19casos.filename)
    # Check last update
    self$casos.df <- read_csv(file = covid19casos.filepath)
    self$max.date <- max(self$casos.df$fecha_apertura, na.rm = TRUE)
    if (self$max.date < snapshot.date){
     stop(paste("Snapshot saved does not reach snapshot.date", as.character(snapshot.date),
                "max(fecha.apertura) = ", self$max.date))
    }
    path.splitted <- strsplit(covid19casos.filepath, split = "/")[[1]]
    covid19casos.filename <- path.splitted[length(path.splitted)]
    logger$info("Compressing file from", source.dir = self$temp.dir,
                filename = covid19casos.filename,
                dest.dir = self$report.snapshots.dir)
    zipFile(source.dir = self$temp.dir, current.file = covid19casos.filename,
            dest.dir = self$report.snapshots.dir,
            flags = "-j",
            rm.original = FALSE,
            overwrite = TRUE)

   }))

