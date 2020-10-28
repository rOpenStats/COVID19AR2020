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
    # casos.mapping <- data.frame(git.id = "", update.date = as.Date("2020-06-12"))
    # casos.mapping <- rbind(casos.mapping,
    #                        c("", "2020-06-13"))
    # casos.mapping <- rbind(casos.mapping,
    #                        c("", "2020-06-14"))
    # casos.mapping <- rbind(casos.mapping,
    #                        c("", "2020-06-15"))
    # casos.mapping <- rbind(casos.mapping,
    #                        c("", "2020-06-16"))
    # casos.mapping <- rbind(casos.mapping,
    #                        c("", "2020-06-17"))
    casos.mapping <- data.frame(git.id = "5933c7b1b1d6990fa57480062013394cebaed59a", update.date = as.Date("2020-06-18"))

    casos.mapping <- rbind(casos.mapping,
                           c("94201d690f62251b65af484bb9785881bfbebf76", "2020-06-19"))
    casos.mapping <- rbind(casos.mapping,
                           c("686f1affde7f75c4752fd6309203926e92ff0072", "2020-06-20"))
    casos.mapping <- rbind(casos.mapping,
                           c("ec98db9e295bbafb73936e4e6d131e40efc4f3ca", "2020-06-21"))
    casos.mapping <- rbind(casos.mapping,
                           c("c10ce7a0f7a35ca8ff2a3593e50bab3a2595f4a1", "2020-06-22"))
    casos.mapping <- rbind(casos.mapping,
                           c("462d1e2b4494a49c9b3affea968ed3bf2d93506a", "2020-06-23"))

    casos.mapping <- rbind(casos.mapping,
                           c("8cc8266992e51533a5adaedcbda0e3b9094202ee", "2020-06-24"))
    casos.mapping <- rbind(casos.mapping,
                           c("20d57bf9713b68efd810f3136cbc6c64307973eb", "2020-06-25"))
    casos.mapping <- rbind(casos.mapping,
                           c("aff53d099c28c3887b8db167c48955ca7cf5e3fe", "2020-06-26"))
    casos.mapping <- rbind(casos.mapping,
                           c("6761ae7c37df7825b5ea44ebabd760b4477637ca", "2020-06-27"))
    casos.mapping <- rbind(casos.mapping,
                           c("614f449554c33c44330354fe9bdd9f228ab42be5", "2020-06-28"))
    casos.mapping <- rbind(casos.mapping,
                           c("3d134935eddbbc9415b09ddafee7082452a3c3d4", "2020-06-29"))
    casos.mapping <- rbind(casos.mapping,
                           c("7dc36810896e00a48f6bff7b30fdbf7feceb7036", "2020-06-30"))
    casos.mapping <- rbind(casos.mapping,
                           c("e6688f4afdf57ba53b2120fed54a8eaac24f4c6f", "2020-07-01"))
    casos.mapping <- rbind(casos.mapping,
                           c("7992617b9770f03b6fe53ef2e38913b78cca11f6", "2020-07-02"))

    casos.mapping <- rbind(casos.mapping,
                           c("138a3b2b77588493d39f7f2d4062e5d89e36e1b8", "2020-07-03"))
    casos.mapping <- rbind(casos.mapping,
                           c("294b6d44e48395f1a62656aa33027f455fbf3e7a", "2020-07-04"))
    casos.mapping <- rbind(casos.mapping,
                           c("e1f6fb4f6a1b32385a82f4ba2536ae1a26a056b6", "2020-07-05"))
    #362739 Covid19CasosReporte20200705.csv but max(date) = 2020-07-04
    #360610 Covid19CasosReporte20200704.csv
    casos.mapping <- rbind(casos.mapping,
                           c("2604e022106ab630456ee3594501200b48ba3ca9", "2020-07-06"))
    casos.mapping <- rbind(casos.mapping,
                           c("27477ddd660979cd133dd8026be7659869a1ef33", "2020-07-07"))
    casos.mapping <- rbind(casos.mapping,
                           c("ad2c06faf1d920643ecc57c774b4e3760dcb39db", "2020-07-08"))
    casos.mapping <- rbind(casos.mapping,
                           c("f9403f480c539eef124a48b2e782baaa623ef9da", "2020-07-09"))
    casos.mapping <- rbind(casos.mapping,
                           c("71cef1e9a2ad2896b02b31ebbc3b9b1b87ce238e", "2020-07-10"))
    casos.mapping <- rbind(casos.mapping,
                           c("7f577d5c36dc4a730c3c12bb9004b51a52214e62", "2020-07-11"))
    casos.mapping <- rbind(casos.mapping,
                           c("921553b2705ca1e355b767b6ce3b3bda80860d30", "2020-07-12"))
    casos.mapping <- rbind(casos.mapping,
                           c("16873bed9a17996980a6dd839d362d2d8b464b30", "2020-07-13"))
    casos.mapping <- rbind(casos.mapping,
                           c("a9a39e8b4f68e2454be105df2d9a40f3c2c6fa4a", "2020-07-14"))
    casos.mapping <- rbind(casos.mapping,
                           c("5b8871269c032697bf8a3292ae9f98ae7d458a89", "2020-07-15"))
    casos.mapping <- rbind(casos.mapping,
                           c("58377545ff9a3fb064a065eb37341a5257829e57", "2020-07-16"))
    casos.mapping <- rbind(casos.mapping,
                           c("e1447dba1e1faf92dad6d8b143e1609feaa080c6", "2020-07-17"))
    #201021
    casos.mapping <- rbind(casos.mapping,
                           c("f50b9dec09ee96df05ec11da5f83aea69823cf18", "2020-07-18"))
    #TODO missing 2020-07-19
    casos.mapping <- rbind(casos.mapping,
                           c("cd78dfebef660ff3cff189407539e56b166c782e", "2020-07-20"))
    casos.mapping <- rbind(casos.mapping,
                           c("fc6d366cbbe3bfedd25285fe77cc7621b55908b7", "2020-07-21"))
    casos.mapping <- rbind(casos.mapping,
                           c("494c9ed39a263958d87e3ad5bd0f173928cfc2c0", "2020-07-22"))
    casos.mapping <- rbind(casos.mapping,
                           c("6d9b3d63ec83afa3deb1c573334d48fff3122722", "2020-07-23"))
    casos.mapping <- rbind(casos.mapping,
                           c("ed06e4e18ec5c67af1caed1a71cf82d2a5915dfa", "2020-07-24"))
    casos.mapping <- rbind(casos.mapping,
                           c("fca5f5baa387c990cfb689318410b122485af423", "2020-07-25"))
    casos.mapping <- rbind(casos.mapping,
                           c("d2c86a10ab54692d8f1a85a44a8c7fe46061aba0", "2020-07-26"))
    casos.mapping <- rbind(casos.mapping,
                           c("8f29a27d0db5c3ca328aaddcefc51706506bd3a8", "2020-07-27"))
    casos.mapping <- rbind(casos.mapping,
                           c("d39eb53f4f614beb50d033cab44e6ea2c455cb22", "2020-07-28"))
    casos.mapping <- rbind(casos.mapping,
                           c("2ae8f463b74e2bdda83c2ae1c810ef6575e40818", "2020-07-29"))
    casos.mapping <- rbind(casos.mapping,
                           c("c5aa08d73140de6e0c12a01ed26ffa9d939e462a", "2020-07-30"))
    casos.mapping <- rbind(casos.mapping,
                           c("76082e2393a697613f49b5ee3bf9e1dceccd753c", "2020-07-31"))

    #missing
    casos.mapping <- rbind(casos.mapping,
                           c("", "2020-07-19"))


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
    self$casos.df <- read_csv(file = covid19casos.filepath,
                              col_types = cols(
                                .default = col_character(),
                                id_evento_caso = col_double(),
                                edad = col_double(),
                                fecha_inicio_sintomas = col_date(format = ""),
                                fecha_apertura = col_date(format = ""),
                                sepi_apertura = col_double(),
                                fecha_internacion = col_date(format = ""),
                                fecha_cui_intensivo = col_date(format = ""),
                                fecha_fallecimiento = col_date(format = ""),
                                fecha_diagnostico = col_date(format = ""),
                                ultima_actualizacion = col_date(format = "")
                              ))
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

   },
   compressFilesInFolder = function(source.dir,
                                    dest.dir,
                                    max.files = Inf,
                                    matching.date.regexp = "[0-9]{6}",
                                    rm.original = FALSE, overwrite = FALSE){
     logger <- getLogger(self)
     covid.casos.regexp <- "Covid19Casos\\.([0-9]{6})\\.csv$"
     all.files <- dir(source.dir)
     files2process <- all.files[grep(covid.casos.regexp, all.files)]
     files2process.df <- data.frame(file = files2process, stringsAsFactors = FALSE)
     files2process.df$date <- gsub(covid.casos.regexp, "\\1", files2process.df$file)
     files2process.df %<>% filter(grepl(matching.date.regexp, date))
     files2process.df$size <- as.numeric(NA)
     nrow.files <- nrow(files2process.df)
     for (file2compress in files2process.df$file){
       file2compress.path <- file.path(source.dir, file2compress)
       file2compress.info <- file.info(file2compress.path)
       files2process.df %<>% mutate_cond( file == file2compress, size = round(file2compress.info$size/1000000, 2))
     }
     total.size <- sum(files2process.df$size)
     nrow.files <- min(nrow.files, max.files)
     logger$info("To start compressing files", nrow2process = nrow.files,
                 total.size = paste(total.size, "MB", sep = ""),
                 min.date = min(files2process.df$date), max.date = max(files2process.df$date))
     files2process.df$compressed <- FALSE
     for (i in seq_len(nrow.files)){
       file.df <- files2process.df[i,]
       logger$info("Compressing file", file = paste(names(file.df), file.df, sep = " = ", collapse = "|"))
       result <- self$compressFile(source.dir = source.dir, source.file = file.df$file, dest.dir = dest.dir,
                         rm.original = rm.original, overwrite = overwrite)
       print(result)
       files2process.df %<>% mutate_cond( file == file.df$file, compressed = result)
     }
     files2process.df
   },
   compressFile = function(source.dir, source.file, dest.dir = NULL,
                           rm.original = FALSE, overwrite = FALSE){
     logger <- getLogger(self)
     zipFile(source.dir = source.dir, current.file = source.file,
             dest.dir = dest.dir,
             flags = "-j",
             rm.original = rm.original,
             overwrite = overwrite)
   }))

