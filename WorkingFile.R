library(ggplot2);
unzip("activity.zip");
rawData<-read.csv("activity.csv");
rawData$date <- as.Date(rawData$date, "%Y-%m-%d");

stepsTotal <- tapply(rawData$steps, rawData$date, sum);
hist(stepsTotal,  breaks=15, xlab = "Total Steps by Day", ylab = "Frequency", 
     main = "Total Step Histogram", col="red");
stepMean<-mean(rawData$steps,na.rm=TRUE);
stepMedian<-median(rawData$steps,na.rm=TRUE);
stepMedian;
stepsIntervalMean <- tapply(rawData$steps, rawData$interval, mean, na.rm = TRUE);
plot(row.names(stepsIntervalMean),stepsIntervalMean, type="l",xlab="Five Minute Interval",
     ylab="Avg. Number of Steps", main="Average Steps per Five Minute Interval", col="red");
maxSlice <- names(which.max(stepsIntervalMean));
incompleteRowCount <- length(which(!complete.cases(rawData)));
incompleteRowIndex <- which(!complete.cases(rawData));

enrichData <- rawData
enrichData$steps[is.na(enrichData$steps)] <- stepsIntervalMean;
stepsEnrichTotal <- tapply(enrichData$steps, enrichData$date, sum);
hist(stepsEnrichTotal,  breaks=15, xlab = "Total Steps by Day", ylab = "Frequency", 
     main = "Total Step Histogram replacing NA's", col="red");
stepEnrichMean<-mean(enrichData$steps,na.rm=TRUE);
stepEnrichMedian<-median(enrichData$steps,na.rm=TRUE);
stepMedian;
