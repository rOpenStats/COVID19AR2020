#' getEnv
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
#' @export
retrieveURL <- function(url, dest.dir = getEnv("data_dir"), force = FALSE){
  logger <- lgr
  url.splitted <- strsplit(url, split = "/")[[1]]
  filename <- url.splitted[length(url.splitted)]
  dest.path <- file.path(dest.dir, filename)
  ret <- FALSE
  exists.dest.path <- file.exists(dest.path)
  lgr$info("Exists dest path?", dest.path = dest.path, exists.dest.path = exists.dest.path)
  if (!exists.dest.path | force){
    lgr$info("Retrieving", url = url, dest.path = dest.path)
    download.file(url = url, destfile = dest.path)
    ret <- TRUE
  }
  dest.path
}

#' getPackagePrefix
#' @export
getPackagePrefix <- function(){
 "COVID19AR_"
}

#' getAPIKey
#' @export
getAPIKey <- function(){
 ret <- list()
 ret[["client_id"]] <- getEnv("client_id")
 ret[["client_secret"]] <- getEnv("client_secret")
 ret
}


#' apiCall
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
#' @export
genDateSubdir <- function(home.dir, create.dir = TRUE){
 current.date <- Sys.Date()
 ret <- file.path(home.dir, as.character(current.date, "%Y"), as.character(current.date, "%m"), as.character(current.date, "%d"))
 dir.create(ret, recursive = TRUE, showWarnings = FALSE)

 ret
}


#' zipFile
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
#' @export
removeAccents<-function(text){
  #debug
  text.debug <<- text
  ret <- iconv(text, to='ASCII//TRANSLIT')
  ret <- gsub("'|\\~","",ret)
  ret
}

#' normalizeString
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
#' @author kenarab
#' @export
getLogger <- function(r6.object){
  #debug
  #r6.object <<- r6.object
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


#' installAnalytics
#' @export
installAnalytics <- function(){
  devtools::install_github("RopenStats/COVID19analytics")
}
