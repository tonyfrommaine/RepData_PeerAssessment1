unzip("activity.zip");
rawData<-read.csv("activity.csv");
rawData$date <- as.Date(rawData$date, "%Y-%m-%d");

stepsTotal <- tapply(rawData$steps, rawData$date, sum);
hist(stepsTotal,  breaks=15, xlab = "Total Steps by Day", ylab = "Frequency", 
     main = "Total Step Histogram", col="red");
stepMean<-mean(rawData$steps,na.rm=TRUE);
stepMedian<-median(rawData$steps,na.rm=TRUE);
stepMedian;