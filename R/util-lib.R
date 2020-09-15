#' getEnv
#' @author kenarab
#' @export
getEnv <- function(variable.name, package.prefix = getPackagePrefix(),  fail.on.empty = TRUE, env.file = "~/.Renviron", call.counter = 0){
 prefixed.variable.name <- paste(package.prefix, variable.name, sep ="")
 ret <- Sys.getenv(prefixed.variable.name)
 if (nchar(ret) == 0){
  if (call.counter == 0){
    readRenviron(env.file)
    ret <- getEnv(variable.name = variable.name, package.prefix = package.prefix,
                  fail.on.empty = fail.on.empty, env.file = env.file,
                  call.counter = call.counter + 1)
  }
  else{
    stop(paste("Must configure variable", prefixed.variable.name, " in", env.file))
  }

 }
 ret
}

#' retrieveURL
#' @import lgr
#' @author kenarab
#' @export
retrieveURL <- function(data.url, col.types,
                        dest.filename,
                        dest.dir = getEnv("data_dir"),
                        force.download = FALSE,
                        download.new.data = TRUE,
                        daily.update.time = "20:00:00"){
  logger <- lgr
  dest.path <- file.path(dest.dir, dest.filename)
  ret <- FALSE
  exists.dest.path <- file.exists(dest.path)
  lgr$info("Exists dest path?", dest.path = dest.path, exists.dest.path = exists.dest.path)
  download.flag <- dir.exists(dest.dir)
  if (download.flag){
      download.flag <- !file.exists(dest.path)
      if (!download.flag & file.exists(dest.path)){
        if (download.new.data){
          dest.path.check <- dest.path
          dest.path.check  <- fixEncoding(dest.path.check)
          data.check <- read_csv(dest.path.check, col_types = col.types)
          max.date <- getMaxDate(data.check)
          current.datetime <- Sys.time()
          current.date <- as.Date(current.datetime, tz = Sys.timezone())
          current.time <- format(current.datetime, format = "%H:%M:%S")
          if (max.date < current.date - 1 | (max.date < current.date & current.time >= daily.update.time)){
            download.flag <- TRUE
          }
          logger$info("Checking required downloaded ", downloaded.max.date = max.date,
                      daily.update.time = daily.update.time,
                      current.datetime = current.datetime,
                      download.flag = download.flag)
        }
      }
    }
    else{
        stop(paste("Dest dir does not exists", dest.dir = dest.dir))
    }
  if (download.flag | force.download){
    lgr$info("Retrieving", url = data.url, dest.path = dest.path)
    download.file(url = data.url, destfile = dest.path)
    ret <- TRUE
  }
  dest.path
}

#' getPackagePrefix
#' @author kenarab
#' @export
getPackagePrefix <- function(){
 "COVID19AR_"
}

#' getAPIKey
#' @author kenarab
#' @export
getAPIKey <- function(){
 ret <- list()
 ret[["client_id"]] <- getEnv("client_id")
 ret[["client_secret"]] <- getEnv("client_secret")
 ret
}


#' apiCall
#' @import httr
#' @import jsonlite
#' @author kenarab
#' @export
apiCall <- function(url){
 tmp <- getAPIKey()
 request <-
  GET(
   url = url,
   query = list(client_id = tmp[["client_id"]],
                client_secret = tmp[["client_secret"]])
  )
 ret <- NULL
 if (request$status_code == 200){
  response <- content(request, as = "text", encoding = "UTF-8")
  ret <- fromJSON(response) %>% data.frame()
 }
 else{
  message(paste("Request returned code =", request$status_code, ".Cannot parse content" ))
  ret <- request
 }
 ret
}

#' genDateSubdir
#' @author kenarab
#' @export
genDateSubdir <- function(home.dir, create.dir = TRUE){
 current.date <- Sys.Date()
 ret <- file.path(home.dir, as.character(current.date, "%Y"), as.character(current.date, "%m"), as.character(current.date, "%d"))
 dir.create(ret, recursive = TRUE, showWarnings = FALSE)

 ret
}


#' zipFile
#' @import utils
#' @author kenarab
#' @export
zipFile <- function(home.dir, current.file, rm.original = TRUE, overwrite = FALSE, minimum.size.accepted = 2000){
 logger <- lgr
 # Do not zip zip files
 if (!grepl("zip$", current.file)){
  current.filepath <- file.path(home.dir, current.file)
  if (file.exists(current.filepath)){
   file.info.current.filepath <- file.info(current.filepath)

   # TODO change 10000 with a statistics based threshold
   if (file.info.current.filepath$size < minimum.size.accepted){
    message <- paste("Cannot process file", current.filepath, " with less than", minimum.size.accepted, "size. And was", file.info.current.filepath$size)
    logger$error(message)
    stop(message)
   }
   # Original file has to exists
   current.file.zipped <- paste(current.filepath, "zip", sep = ".")

   current.filepath <- gsub("\\/\\/", "/", current.filepath)
   current.file.zipped <- gsub("\\/\\/", "/", current.file.zipped)

   if (!file.exists(current.file.zipped) | overwrite){
    # Expand paths
    current.filepath <- path.expand(current.filepath)
    current.file.zipped <- path.expand(current.file.zipped)
    #current.filepath <- normalizePath(current.filepath)
    lgr$info(paste("Zipping", current.filepath))
    ret <- utils::zip(current.file.zipped, files = current.filepath)
    if (rm.original){
     unlink(current.filepath)
    }
   }
  }
 }
}


#' removeAccents
#' @author kenarab
#' @export
removeAccents<-function(text){
  ret <- iconv(text, to='ASCII//TRANSLIT')
  ret <- gsub("'|\\~","",ret)
  ret
}

#' normalizeString
#' @author kenarab
#' @export
normalizeString<-function(text,lowercase=TRUE){
  text <- removeAccents(trimws(text))
  if (lowercase){
    text <- tolower(text)
  }
  else {
    text <- toupper(text)
  }
}

#' genLogger
#' @author kenarab
#' @export
genLogger <- function(r6.object){
  lgr::get_logger(class(r6.object)[[1]])
}

#' getLogger
#' @import lgr
#' @author kenarab
#' @export
getLogger <- function(r6.object){
  #TODO check if not a better solution
  ret <- r6.object$logger
  if (is.null(ret)){
    class <- class(r6.object)[[1]]
    stop(paste("Class", class, "don't seems to have a configured logger"))
  }
  else{
    ret.class <- class(ret)[[1]]
    if (ret.class == "logical"){
      stop(paste("Class", class, "needs to initialize logger: self$logger <- genLogger(self)"))
    }
  }
  ret
}

#' fixEncoding return filepath with encoding in UTF8
#' @import readr
#' @author kenarab
#' @export
fixEncoding <- function(file.path){
  filename <- strsplit(file.path, split = "/")[[1]]
  filename <- filename[length(filename)]
  encoding.matches <- guess_encoding(file.path)
  encoding.utf16 <- FALSE
  best.match <- encoding.matches[1,]
  if (grepl("(utf16|utf-16)", tolower(best.match[,"encoding"])) & best.match[,"confidence"] > 0.8){
    encoding.utf16 <- TRUE
  }
  if (encoding.utf16){
    # Has utf16 encoding
    file.path.original <- file.path
    file.path <- gsub("\\.csv$", ".utf8.csv", file.path)
    current.os <- getOS()
    if (current.os == "macos"){
      utf16.encoding <- "utf-16"
      utf8.encoding  <- "utf-8"
    }
    if (current.os == "linux"){
      utf16.encoding <- "UTF16"
      utf8.encoding  <- "UTF8"
    }
    if (current.os == "windows"){
      stop("File encoding conversion from UTF16 to UTF8 not implemented yet in Windows OS")
    }

    # iconv -f UTF16 -t UTF8 Covid19Casos.csv > Covid19Casos.utf8.csv
    iconv.command <- paste("iconv -f", utf16.encoding, "-t", utf8.encoding, file.path.original, ">", file.path)
    command.result <- system(iconv.command, intern = TRUE)
  }
  file.path
}

#' mutate_cond
#' @export
mutate_cond <- function(.data, condition, ..., envir = parent.frame()) {
  condition <- eval(substitute(condition), .data, envir)
  .data[condition, ] <- .data[condition, ] %>% mutate(...)
  .data
}

#' getOS returns linux, windows or macos
#' @author kenarab
#' @export
getOS <- function(){
  sysinf <- Sys.info()
  if (!is.null(sysinf)){
    os <- sysinf['sysname']
    if (os == 'Darwin')
      os <- "MacOS"
  } else { ## mystery machine
    os <- .Platform$OS.type
    if (grepl("^darwin", R.version$os))
      os <- "MacOS"
    if (grepl("linux-gnu", R.version$os))
      os <- "linux"
  }
  tolower(os)
}

#' getMaxDate
#' @author kenarab
#' @export
getMaxDate <- function(covid19ar.data, report.date){
  logger <- lgr
  data.fields <- names(covid19ar.data)
  date.fields <- data.fields[grep("fecha\\_", data.fields)]
  covid19ar.data$max.date <- apply(covid19ar.data[,date.fields], MARGIN = 1, FUN = function(x){max(x, na.rm = TRUE)})
  future.rows <- covid19ar.data %>% filter(max.date > report.date)
  future.rows.agg <- future.rows %>% group_by(max.date) %>% summarise(n = n())
  for (i in seq_len(nrow(future.rows.agg))){
    future.row <- future.rows.agg[i,]
    logger$info("Future rows", date = future.row$max.date, n = future.row$n)
  }
  covid19ar.data <- covid19ar.data %>% filter(max.date <= report.date)
  max.dates <- apply(covid19ar.data[,date.fields], MARGIN = 2, FUN = function(x){max(x, na.rm = TRUE)})
  max.date <- max(max.dates)
  max.date
}
