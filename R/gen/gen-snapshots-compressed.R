library(COVID19AR)

log.dir <- file.path(getEnv("data_dir"), "logs")
dir.create(log.dir, recursive = TRUE, showWarnings = FALSE)
log.file <- file.path(log.dir, "covid19arLegacyCompressor.log")
lgr::get_logger("root")$add_appender(AppenderFile$new(log.file))
lgr::threshold("info", lgr::get_logger("root"))
lgr::threshold("info", lgr::get_logger("COVID19ARSampleGenerator"))
lgr::threshold("debug", lgr::get_logger("COVID19ARSampleGenerator"))
lgr::threshold("debug", lgr::get_logger("COVID19ARCurator"))




covid19.report.legacy.compressor <- COVID19ARLegacyCompressor$new()
# TODO remove
self <- covid19.report.legacy.compressor
dummy <- covid19.report.legacy.compressor$buildCasosMapping()
covid19.report.diff.summarizer$casos.mapping

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-16")
# Manual commit
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-17")
# Manual commit
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-18")
