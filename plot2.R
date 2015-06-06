##
##  Plots by date & time "Global_active_power" column of data from 
##      “Individual household electric power consumption Data Set”
##      found on the UCI Irvine Machine Learning Repository
##  Writes plot to "plot2.png" in the working directory of R
##
plot2 <- function () {
#    if(!file.exists("PA1 data"))           # keeps from having to download file every time during development
#    {
        # getting data from Coursera's "Exploratory Data Analysis" website
        url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
        download.file(url, "PA1 data.zip")
        
        # unzip text file to "working directory/PA1 data"
        unzip("PA1 data.zip", "household_power_consumption.txt", exdir="PA1 data")
#    }

    # using read.csv.sql to only get desired dates since reading the whole data takes a while
    #   I should be accounting for NAs ('?' in this file) but since read.csv.sql doesn't seem
    #   to support na.strings="?" like read.table and -- on inspection -- there don't seem to be any
    #   '?' on these dates, I'm taking the lazy way on this & not handling NAs.
    #   (Since there aren't any in these dates, I'd have to go into other dates just to test
    #    any kind of handler.  Again, just don't want to put the effort into it now)

    require("sqldf")        # loads "sqldf" package only if necessary
    data <- read.csv.sql("PA1 data\\household_power_consumption.txt", sep=";", 
            sql = "select * from file where Date in ('1/2/2007', '2/2/2007')")

    displayStr = "Global Active Power (kilowatts)"          # used for y-axis label

    # open the png, write the plot, close the png
    png("plot2.png")
    dateTime<-paste(data[,"Date"],data[,"Time"])                    # get date & time together for processing
    dateTime<-strptime(dateTime, format="%d/%m/%Y %H:%M:%S")        # change to formatted POSIXlt class
    plot(dateTime,data$Global_active_power, type="l", xlab="", ylab=displayStr)
    dev.off()
    
    a<-"Finished normally"
    a
}