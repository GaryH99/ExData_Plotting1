##
##  Plots by date & time the 3 "sub_metering" columns of data from 
##      “Individual household electric power consumption Data Set”
##      found on the UCI Irvine Machine Learning Repository
##  Writes plot to "plot3.png" in the working directory of R
##
plot3 <- function () {
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
    #    any kind of handler.  Again, just don't want to put the effort into it now)  TODO: add NA handler
    
    require("sqldf")        # loads "sqldf" package only if necessary
    data <- read.csv.sql("PA1 data\\household_power_consumption.txt", sep=";", 
            sql = "select * from file where Date in ('1/2/2007', '2/2/2007')")

    displayStr = "Energy sub metering"          # used for y-axis label
    dateTime<-paste(data[,"Date"],data[,"Time"])                    # get date & time together for processing
    dateTime<-strptime(dateTime, format="%d/%m/%Y %H:%M:%S")        # change to formatted POSIXlt class
    
    #
    # open the png, write the plot, close the png
    #
    png("plot3.png")    # opens png for writing

    # start the plot w/o plotting any points (type="n"), then add the data 1 series at a time (3 series)
    plot(dateTime,data$Sub_metering_1, type="n", xlab="", ylab=displayStr)
    points(dateTime, data$Sub_metering_1, type="l", col="black")
    points(dateTime, data$Sub_metering_2, type="l", col="red")
    points(dateTime, data$Sub_metering_3, type="l", col="blue")
    
    # add the legend
    legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
            lty="solid", col=c("black","red","blue"))

    dev.off()       # closes the writing of the png
    
    a<-"Finished normally"
    a
}