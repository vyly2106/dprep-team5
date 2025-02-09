#-----------------#
#Data Downloading #
#-----------------#

## Load packages
library(googledrive)
library(tidyverse)
options(warn = -1)


## Importing Google Sheet as CSV in R. 
### Note: Click Session (on menu bar) -> Set Working Directory -> To Source File Location
### Generate data folder
if (!dir.exists("../../data")) {
  dir.create("../../data")
} else {
  print("Directory already exists!")
}

### Parse listings from Google Sheet to data folder
drive_id <- "1BHtCZokCgAtHWBDZOI-meOIWLIBp6nbhU4MurlzVHlg"
drive_download(as_id(drive_id), path = "../../data/Airbnb_listings.csv", overwrite = TRUE)
Airbnb_links <- read.csv("../../data/Airbnb_listings.csv", encoding = "UTF-8")

airbnb_urls <- as.character(Airbnb_links$URL)
airbnb_country <- as.character(Airbnb_links$Country_code)

## Reading datasets for all countries
tbl <- lapply(airbnb_urls, function(airbnb_urls) {
  print(paste0('Now downloading ... ', airbnb_urls))
  d <- read.csv(airbnb_urls)
  city = tolower(as.character(Airbnb_links$City[match(airbnb_urls, Airbnb_links$URL)]))
  d$city <- city
  country_code = as.character(Airbnb_links$Country_code[match(airbnb_urls, Airbnb_links$URL)])
  d$country_code <- country_code
  return(d)
})

## Combining data into a single data frame
combined_data = do.call('rbind', tbl)
head(combined_data)
glimpse(combined_data)

## Writing data into csv file and creating directory if nonexistent
if (!dir.exists("../../gen")) {
  dir.create("../../gen")
} else {
  print("Directory already exists!")
}

if (!dir.exists("../../gen/temp")) {
  dir.create("../../gen/temp")
} else {
  print("Directory already exists!")
}
write.csv(combined_data,
          paste0("../../gen/temp/combined_city_data.csv"),
          row.names = F)

## Congrats you finish downloading script, next is cleaning!


