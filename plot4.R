##
##  Plots by date & time 4 groups of data on 4 plots (global_active_power, global_reactive_power, voltage plus
##      the 3 sub_metering series together on one plot) from
##      “Individual household electric power consumption Data Set”
##      found on the UCI Irvine Machine Learning Repository
##  Writes plot to "plot4.png" in the working directory of R
##
plot4 <- function () {
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

    dateTime<-paste(data[,"Date"],data[,"Time"])                    # get date & time together for processing
    dateTime<-strptime(dateTime, format="%d/%m/%Y %H:%M:%S")        # change to formatted POSIXlt class
    
    #
    # open the png, write the plot, close the png
    #
    png("plot4.png")    # opens png for writing

    par(mfrow = c(2,2))             # make 4 plots on a 2x2 grid
    
    # top left plot -- Global Active Power
    displayStr = "Global Active Power"          # used for y-axis label
    plot(dateTime,data$Global_active_power, type="l", xlab="", ylab=displayStr)
    
    # top right plot -- Voltage
    displayStr = "Voltage"          # used for y-axis label
    plot(dateTime,data$Voltage, type="l", xlab="datetime", ylab=displayStr)
    
    # bottom right plot -- 3 series of energy sub metering
    # start the plot w/o plotting any points (type="n"), then add the data 1 series at a time
    displayStr = "Energy sub metering"          # used for y-axis label
    plot(dateTime,data$Sub_metering_1, type="n", xlab="", ylab=displayStr)
    points(dateTime, data$Sub_metering_1, type="l", col="black")
    points(dateTime, data$Sub_metering_2, type="l", col="red")
    points(dateTime, data$Sub_metering_3, type="l", col="blue")
    
    # add the legend 
    legend("topright", legend=c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), 
            lty="solid", bty="n", col=c("black","red","blue"))

    # bottom right plot -- Global Active Power
    displayStr = "global_reactive_power"          # used for y-axis label
    plot(dateTime,data$Global_reactive_power, type="l", xlab="datetime", ylab=displayStr)
    
    dev.off()       # closes the writing of the png
    
    a<-"Finished normally"
    a
}