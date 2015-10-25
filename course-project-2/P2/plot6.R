################################################################################
# Compare emissions from motor vehicle sources in Baltimore City with emissions 
# from motor vehicle sources in Los Angeles County, California (fips == "06037"). 
# Which city has seen greater changes over time in motor vehicle emissions?
################################################################################

# Load the data
print("This will likely take a few seconds. Be patient!")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Counties data frame
counties <- data.frame(fips=c("06037","24510"),
                       county=c("Los Angeles County","Baltimore City"))

# Motor vehicle sources
vehicles <- SCC[SCC$Data.Category=="Onroad",]

# Get only data from counties needed
counties.data <- merge(NEI, counties, by.x="fips", by.y="fips")

# Get only data from counties needed and from motor vehicle sources
vehicles.data <- merge(counties.data,vehicles,by.x="SCC",by.y="SCC")


# Create the data for the plot
library(plyr)

total.emissions <- ddply(vehicles.data,
                         .(as.factor(year), county),
                         summarize, 
                         total=sum(Emissions)) # sum to tons

# Give column names
colnames <- c("year","county","tons")
colnames(total.emissions) <- colnames

# Create the plot
library(ggplot2)

png(filename = "plot6.png", width = 640, height = 342) ## Create my plots in a PNG file

qplot(year, 
      data = total.emissions, 
      facets = . ~ county, 
      geom="bar", 
      weight=tons, 
      main=expression("Total emissions from PM"[2.5]*
                          " from motor vehicle sources"),
      xlab="Years",
      ylab = expression("Amount of PM"[2.5]*" emitted, in tons"),
      fill = county)

dev.off()  ## Don't forget to close the PNG device!
