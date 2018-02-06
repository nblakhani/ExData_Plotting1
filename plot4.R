# 1. Prepare data for processing


zipfile <- 'exdata%2Fdata%2Fhousehold_power_consumption.zip'
url <- 'https://archive.ics.uci.edu/ml/machine-learning-databases/00235/household_power_consumption.zip'

if (!file.exists(zipfile)) {
    download.file(url,zipfile, mode="wb")
    unzip (zipfile)
    file.remove(zipfile)
}

epc_data <- read.table('household_power_consumption.txt',header=TRUE,sep=';',stringsAsFactors = FALSE)
epc_data <- subset(epc_data,Date== '1/2/2007'| Date== '2/2/2007')
str(epc_data)

epc_data <- epc_data[complete.cases(epc_data),]
colSums(is.na(epc_data))

ColNames <- names(epc_data[3:9])
numericList <- c(ColNames)
epc_data[, numericList] <- lapply(epc_data[, numericList], function(x) as.numeric(as.character(x)))


epc_data$datetime <- as.POSIXct(paste(epc_data$Date,epc_data$Time,sep=';'),format='%d/%m/%Y;%H:%M:%S')

epc_data$Date <- NULL
epc_data$Time <- NULL


# 2. Plot data and save in file device



png(file='plot4.png',width=480,height=480)
par(mfrow=c(2,2))


with(epc_data, hist(Global_active_power,col='red',main='Global Active Power',xlab='Global Active Power (kilowatts)',breaks='sturges'))

with (epc_data,plot(epc_data$datetime,epc_data$Global_active_power,type="l",ylab='Global Active Power kilowatt',xlab=''))


plot(epc_data$datetime, epc_data$Sub_metering_1, type = "l", col = "black", xlab = "", ylab = "Global Active Power (kilowatts)")
lines(epc_data$datetime, epc_data$Sub_metering_2, type = "l", col = "red")
lines(epc_data$datetime, epc_data$Sub_metering_3, type = "l", col = "blue")
legend("topright", c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lty = c(1, 1, 1), col = c("black", "red", "blue"))


with (epc_data,plot(epc_data$datetime,epc_data$Global_reactive_power,type="l",ylab='Global reactive Power kilowatt',xlab='datetime'))

dev.off()

