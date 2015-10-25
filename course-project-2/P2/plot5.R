################################################################################
# How have emissions from motor vehicle sources changed from 1999–2008 in 
# Baltimore City?
################################################################################

# Load the data
print("This will likely take a few seconds. Be patient!")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Subsetting data. Getting motor vehicle sources data
vehicles <- SCC[SCC$Data.Category=="Onroad",]

# Get Baltimore City, Maryland (fips == "24510")
baltimore.data <- NEI[NEI$fips == "24510",]

# Merging data
vehicles.baltimore.data = merge(baltimore.data,vehicles,by.x="SCC",by.y="SCC")

library(plyr)

# Create the data for the plot
vehicles.emissions <- ddply(vehicles.baltimore.data,
                            .(as.character(year)), # convert number to character
                            summarize, 
                            total=sum(Emissions)) # sum to tons

# Give column names
colnames <- c("year","tons")
colnames(vehicles.emissions) <- colnames

# Create the plot
png(filename = "plot5.png", width = 640, height = 480) ## Create my plots in a PNG file

par(ps=12, mar=c(5.1,5.1,4.1,2.1))

barplot(vehicles.emissions$tons,
        col="firebrick3",
        main=expression("Total emissions from PM"[2.5]*
                            " from motor vehicle sources in the Baltimore City, Maryland"),
        xlab="Years",
        ylab=expression("Amount of PM"[2.5]*" emitted, in tons"),
        names.arg=vehicles.emissions$year)

# Making png file
dev.off()  ## Don't forget to close the PNG device!

