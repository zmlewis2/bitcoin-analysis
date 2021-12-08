# install.packages('RSelenium')
# install.packages('here')
# install.packages('netstat')

library(RSelenium)
library(here)
library(netstat)

# The purpose of this program is to define a function called 
# 'downloadHistoricalPrices', which automates the process of downloading
# fresh price data for Bitcoin from the Wall Street Journal's website.

# The function initializes a browser using 'RSelenium', locates the page
# containing the data, downloads the file, and places the downloaded file in
# the working directory defined

# Define working directory
setwd("C:/Users/zachm/Desktop/Bitcoin Analysis")

downloadHistoricalPrices <- function() {
  # set the value of URL to be the WSJ page displaying historical data for Bitcoin
  url <- "https://www.wsj.com/market-data/quotes/fx/BTCUSD/historical-prices"
  
  # create a variable with the name WSJ gives the downloaded file
  filename <- 'HistoricalPrices.csv'
  
  # initialize file path to personal download folder
  download_location <- ("C:/Users/zachm/Downloads")
  
  # create the driver and browser
  driver <- rsDriver(port = free_port(), chromever = "95.0.4638.69", browser = "chrome")
  server <- driver$server
  browser <- driver$client
  
  # instruct the browser to navigate to the url provided above
  browser$navigate(url)
  
  # the webpage allows the user to input 'from' and 'to' dates for data selection
  # the following commands instruct the browser to find the 'from' date input box
  # and enter a date that will provide the entire historical data set (01/01/1900)
  input_date <- browser$findElement("#selectDateFrom", using = "css selector")
  input_date$clearElement()
  input_date$sendKeysToElement(list("01/01/1900"))
  
  # intitialize an empty list of buttons 
  buttons <- list()
  
  # use a while loop to find the element corresponding to the button
  # the loop avoids having R try to find the button before the page is loaded and the button is available
  while(length(buttons) == 0) {
    buttons <- browser$findElements("#dl_spreadsheet", using = "css selector")
  }
  
  # click the button to download the file
  buttons[[1]]$clickElement()
  
  # loop through a sleep command until the file exists in the downloads folder
  while(!file.exists(file.path(download_location, filename))) {
    Sys.sleep(0.1)
  }
  
  # once the file is available, move it to the working directory
  file.rename(file.path(download_location, filename), here(filename))
  
  
  # close the driver and browser
  rm(driver)
  gc()
  server$stop()
}

downloadHistoricalPrices()

# Reference
# https://stackoverflow.com/questions/56366491/how-to-use-r-to-download-a-file-from-webpage-when-there-is-no-specific-file-embe/56367795
