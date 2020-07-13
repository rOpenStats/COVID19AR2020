library(COVID19AR)

log.dir <- file.path(getEnv("data_dir"), "logs")
dir.create(log.dir, recursive = TRUE, showWarnings = FALSE)
log.file <- file.path(log.dir, "covid19arSampleGen.log")
lgr::get_logger("root")$add_appender(AppenderFile$new(log.file))
lgr::threshold("info", lgr::get_logger("root"))
lgr::threshold("info", lgr::get_logger("COVID19ARSampleGenerator"))
lgr::threshold("debug", lgr::get_logger("COVID19ARSampleGenerator"))
lgr::threshold("debug", lgr::get_logger("COVID19ARCurator"))


covid19.report.diff.summarizer <- COVID19ARDailyReports$new(min.rebuilt.date = "2020-06-16",
                                                            report.diff.dir = "../COVID19ARdata/sources/COVID19AR")

dummy <- covid19.report.diff.summarizer$buildCasosPlan()
covid19.report.diff.summarizer$casos.plan

report.diff.summary <- covid19.report.diff.summarizer$report.diff.summary
dir.create(file.path("../COVID19ARdata/dev/samples"), recursive = TRUE, showWarnings = FALSE)
dir.create(file.path("../COVID19ARdata/dev/samples", "sample001S0"), recursive = TRUE, showWarnings = FALSE)
sample.gen <- COVID19ARSampleGenerator$new(daily.reports = covid19.report.diff.summarizer,
                                           sample.name = "sample001S0",
                                           sample.ratio = 0.01, seed = 0,
                                           output.dir = "../COVID19ARdata/dev/samples",
                                           min.date = "2020-06-16")
sample.gen$genSampleBatch(max.n = 0, min.date = "2020-07-05")



# Now build the diff file from samples
#
covid19.report.diff.summarizer <- COVID19ARDailyReports$new(min.rebuilt.date = "2020-06-16",
                                                            report.diff.dir = "../COVID19ARdata/sources/COVID19AR")

self <- covid19.report.diff.summarizer
covid19.report.diff.summarizer$buildCasosPlan()
covid19.report.diff.summarizer$buildCasosPlan(casos.dir = "../COVID19ARdata/dev/samples/sample001S0/")
covid19.report.diff.summarizer$casos.plan
covid19.report.diff.summarizer$resetMerge()
#covid19.report.diff.summarizer$loadReportDiffSummary()
file.path(covid19.report.diff.summarizer$report.diff.dir, covid19.report.diff.summarizer$report.diff.summary.filename)

#covid19.report.diff.summarizer$report.diff.builder$report.diff
#covid19.report.diff.summarizer$buildCasosReport(max.n = 2, min.date = "2020-06-16")
covid19.report.diff.summarizer$buildCasosReport(max.n = 0, min.date = "2020-06-16")
self <- covid19.report.diff.summarizer$report.diff.builder

report.diff.summary <- covid19.report.diff.summarizer$report.diff.summary



