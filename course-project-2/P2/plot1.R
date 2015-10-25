################################################################################
# Have total emissions from PM2.5 decreased in the United States from 1999 to 
# 2008? 
# Using the base plotting system, make a plot showing the total PM2.5 emission
# from all sources for each of the years 1999, 2002, 2005, and 2008.
################################################################################

# Load the data
print("This will likely take a few seconds. Be patient!")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

library(plyr)

# Create the data for the plot
total.emissions <- ddply(NEI,
                         .(as.character(year)), # convert number to character
                         summarize, 
                         total=sum(Emissions)/1000000) # sum to million tons
# Give column names
colnames <- c("year","million.tons")
colnames(total.emissions) <- colnames

# Create the plot
par(ps=12, mar=c(5.1,5.1,4.1,2.1))

barplot(total.emissions$million.tons,
        col="cadetblue4",
        main=expression("Total emissions from PM"[2.5]*" in the United States"),
        xlab="Years",
        ylab=expression("Amount of PM"[2.5]*" emitted, in million tons"),
        names.arg=total.emissions$year)

# Making png file
dev.copy(png, file = "plot1.png")
dev.off()  ## Don't forget to close the PNG device!
