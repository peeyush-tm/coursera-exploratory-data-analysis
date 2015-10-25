################################################################################
# Across the United States, how have emissions from coal combustion-related 
# sources changed from 1999–2008?
################################################################################

# Load the data
print("This will likely take a few seconds. Be patient!")
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC <- readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

# Subsetting data. Getting coal combustion-related data
coal.combustion.sources <- SCC[grepl("Comb ", SCC$Short.Name) 
                            & grepl("Coal", SCC$Short.Name) ,]

coal.combustion.data = merge(NEI,coal.combustion.sources,by.x="SCC",by.y="SCC")

library(plyr)

# Create the data for the plot
coal.emissions <- ddply(NEI,
                        .(as.character(year)), # convert number to character
                        summarize, 
                        total=sum(Emissions)/1000000) # sum to million tons

# Give column names
colnames <- c("year","million.tons")
colnames(coal.emissions) <- colnames

# Create the plot
png(filename = "plot4.png", width = 600, height = 480) ## Create my plots in a PNG file

par(ps=12, mar=c(5.1,5.1,4.1,2.1))

barplot(coal.emissions$million.tons,
        col="slategrey",
        main=expression("Total emissions from PM"[2.5]*" from coal combustion-related in the United States"),
        xlab="Years",
        ylab=expression("Amount of PM"[2.5]*" emitted, in million tons"),
        names.arg=coal.emissions$year)

# Making png file
dev.off()  ## Don't forget to close the PNG device!


