library(tidyverse)
library(jsonlite)
cat("Darbinė direktorija:", getwd())

args <- commandArgs(trailingOnly = TRUE)

if (length(args) > 0) {
  file_format <- args[1]
} else {
  file_format <- "csv"
}

if (file_format == "csv"){
  download.file("https://atvira.sodra.lt/imones/downloads/2023/monthly-2023.csv.zip", "../data/temp")
  unzip("../data/temp",  exdir = "../data/")
  readLines("../data/monthly-2023.csv", 2)
  data <- read_delim("../data/monthly-2023.csv", delim = ";")
  names(data) <- str_extract(names(data), "(?<=\\().*(?=\\))")
  data %>%
    filter(`ecoActCode` == 451100) %>%
    saveRDS("../data/kaunas15.rds")
  file.remove("../data/temp")
  file.remove("../data/monthly-2023.csv")
} else {
  download.file("https://atvira.sodra.lt/imones/downloads/2023/monthly-2023.json.zip", "../data/temp")
  unzip("../data/temp",  exdir = "../data/")
  readLines("../data/monthly-2023.json", 20)
  data <- fromJSON("../data/monthly-2023.json")
  data %>%
    filter(`ecoActCode` == 451100) %>%
    saveRDS("../data/kaunas.rds")
  file.remove("../data/temp")
  file.remove("../data/monthly-2023.json")
}

