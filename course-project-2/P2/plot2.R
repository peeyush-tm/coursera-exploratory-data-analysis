################################################################################
# Have total emissions from PM2.5 decreased in the Baltimore City, Maryland 
# (fips == "24510") from 1999 to 2008? 
# Use the base plotting system to make a plot answering this question.
################################################################################

# Load the data
print("This will likely take a few seconds. Be patient!")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Subsetting data. Get Baltimore City, Maryland (fips == "24510")
baltimore.data <- NEI[NEI$fips == "24510",]

library(plyr)

# Create the data for the plot
total.emissions <- ddply(baltimore.data,
                         .(as.character(year)), # convert number to character
                         summarize, 
                         total=sum(Emissions)) # sum to tons
# Give column names
colnames <- c("year","tons")
colnames(total.emissions) <- colnames

# Create the plot
par(ps=12, mar=c(5.1,5.1,4.1,2.1))

barplot(total.emissions$tons,
        col="gold2",
        main=expression("Total emissions from PM"[2.5]*
                            " in the Baltimore City, Maryland"),
        xlab="Years",
        ylab=expression("Amount of PM"[2.5]*" emitted, in tons"),
        names.arg=total.emissions$year)

# Making png file
dev.copy(png, file = "plot2.png")
dev.off()  ## Don't forget to close the PNG device!
