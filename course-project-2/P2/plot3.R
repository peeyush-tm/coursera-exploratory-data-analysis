################################################################################
# Of the four types of sources indicated by the type (point, nonpoint, onroad, 
# nonroad) variable, which of these four sources have seen decreases in 
# emissions from 1999–2008 for Baltimore City? 
# Which have seen increases in emissions from 1999–2008? 
# Use the ggplot2 plotting system to make a plot answer this question.
################################################################################

# Load the data
print("This will likely take a few seconds. Be patient!")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Subsetting data. Get Baltimore City, Maryland (fips == "24510")
baltimore.data <- NEI[NEI$fips == "24510",]

# Create the data for the plot
library(plyr)
total.emissions <- ddply(baltimore.data,
                         .(as.factor(year), as.factor(type)), # convert number to character
                         summarize, 
                         total=sum(Emissions)) # sum to million tons

# Give column names
colnames <- c("year","type", "tons")
colnames(total.emissions) <- colnames

# Create the plot
library(ggplot2)

png(filename = "plot3.png", width = 807, height = 342) ## Create my plots in a PNG file

qplot(year, 
      data = total.emissions, 
      facets = . ~ type, 
      geom="bar", 
      weight=tons, 
      main=expression("Total emissions from PM"[2.5]*
                          " in the Baltimore City, Maryland"),
      xlab="Years",
      ylab = expression("Amount of PM"[2.5]*" emitted, in tons"),
      fill = type)

dev.off()  ## Don't forget to close the PNG device!
