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
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-04"
# 58a091be24048aac50c4a0535193f070150acb4a

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-05")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-05"
# e03aa80d9a85ec2c78434e4091cbde9ad2d0f216

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-06")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-06"
# b7e6a50f61cb6fe7a9c8fd786d8085da36bd3ab4

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-07")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-07"
# 73c12d7b38c1e3592a765deb7e6032fcf8b91e3b

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-08")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-08"
# dc5b1f06ed524d7d16f81b3532319f1400639fe7

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-09")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-09"
# 6032f75358d27dfcdf546aaa029bfecd4f428246

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-10")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-10"
# 4acd00d2d81a87348bc3c9adecec4190dc3ee5cb

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-11")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-11"
# 6d411a1aa38916d8ef0869f46a07ba3eda5fd76f

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-12")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-12"
# 51c705de5a0a42bdaf7b45a9dcf61acdae455870

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-13")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-13"
# feabb601d2579e8f96dbebe31c0f9166f4d4c906

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-14")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-14"
# 3733ef007ed74ec782c43bd99c89a2ab8b60d8a9

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-15")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-15"
# 509d21b76a9ffb0e33500a9f1c1cd82a70644d9c

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-16")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-16"
# 9f78c3f65cffb782e7dd43aebd3087c40a3da909

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-17")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-17"
# 0b63594df6a148da9aab5b139432221603740828

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-18")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-18"
#

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-20")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-20"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-21")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-21"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-22")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-22"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-23")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-23"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-24")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-24"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-25")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-25"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-26")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-26"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-27")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-27"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-28")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-28"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-29")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-29"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-30")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-30"

covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-31")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-31"


covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-19")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-18"



covid19.report.legacy.compressor$compressSnapshot(snapshot.date = "2020-07-26")
# git commit -am " Updated CovidCasos.csv.zip up to 2020-07-18"
