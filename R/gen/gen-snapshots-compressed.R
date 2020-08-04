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

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-16")
# Manual commit
# git commit -am "[bugfix] Updated CovidCasos.csv.zip up to 2020-06-16"
# 2bf177b4087db97337c3956f30127eb3a279ed2e
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-17")
# Manual commit
# git commit -am "[bugfix] Updated CovidCasos.csv.zip up to 2020-06-17"
#ce9c7004ba377019fd3c106fe4a526b4371488ab
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-18")
# git commit -am "[bugfix] Updated CovidCasos.csv.zip up to 2020-06-18"
#56a25dbd7061268308aa037e1a3aa7c207b57cc1
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-19")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-19"
#cd04f193142edcf502bb5667a136a037abeea2ba
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-20")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-20"
# ec6d44768f4af6c73bd9cfc1492cbdd52c513519
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-21")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-21"
# 41c024877da0ba0c58bd737ecb2adb2a7a75437f
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-22")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-22"
# 6af5a72e3c828d4e6e6375b1593f87f344343d63
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-23")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-23"
# 34b0f225559246caf2b04da95cbab7f99abd79e5
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-24")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-24"
# e9cb0d849b63aa0fb33b7dbeb4455d2202fb683a
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-25")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-25"
# 66cba3767a29d2452fff0dd62cd1e0352051aa2a
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-26")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-26"
# 58a3faf65dd00b48137703bc648dbbf5616677bd
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-27")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-27"
# 2e7591cf97443260d08be64c115328de2cd85411
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-28")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-28"
# 051bad4f7e40f81102ce89036c65f75150a1ad9f
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-29")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-29"
# f04b4510e3bc70d2d302fbc0d351c20d21360e7f
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-06-30")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-06-30"
# 0187dbfe02bc6c6e2267065cf68b7a8537e83f94
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-01")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-01"
# ad8cd697f9023788d8d422cc52b714efe90e0b8e
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-02")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-02"
# d638ed9082ac1afbc414e2a4ba78609e0f9cb66f
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-03")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-03"
# 3509223f1cfd29954132f11c246229946b6aec10
covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-04")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-03"
# 3509223f1cfd29954132f11c246229946b6aec10
