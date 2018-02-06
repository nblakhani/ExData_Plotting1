
# 1. Prepare data for processing


zipfile <- 'exdata%2Fdata%2Fhousehold_power_consumption.zip'
url <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip'

if (!file.exists(zipfile)) {
    download.file(url,zipfile, mode="wb")
    unzip (zipfile)
    file.remove(zipfile)
}

# read text data into table and filter out data for the 2 days in 2007

epc_data <- read.table('household_power_consumption.txt',header=TRUE,sep=';',stringsAsFactors = FALSE)
epc_data <- subset(epc_data,Date== '1/2/2007'| Date== '2/2/2007')
str(epc_data)

# remove rows with NA

epc_data <- epc_data[complete.cases(epc_data),]
colSums(is.na(epc_data))

# convert appropriate columns to numeric 

ColNames <- names(epc_data[3:9])
numericList <- c(ColNames)
epc_data[, numericList] <- lapply(epc_data[, numericList], function(x) as.numeric(as.character(x)))

# concatenate date and time into one field 'datetime'
epc_data$datetime <- as.POSIXct(paste(epc_data$Date,epc_data$Time,sep=';'),format='%d/%m/%Y;%H:%M:%S')

epc_data$Date <- NULL
epc_data$Time <- NULL
                                  


# 2. Making plot 1 and saving in device plot1.png 


png(file='plot1.png',width=480,height=480)

with(epc_data, hist(Global_active_power,col='red',main='Global Active Power',xlab='Global Active Power (kilowatts)',breaks='sturges'))

dev.off()
