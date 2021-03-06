##  Contains the scratch pad of raw code used in preparation of puttin the RMD file
##  This is only a scratch pad with no comments and thus should not be part
##  of the grading process.  The RMD contains the proper documentation.
library(ggplot2);
library(plyr);
library(lattice);
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
dayData <- rawData;
dayName <- weekdays(rawData$date);
dayData$dayTypeIndicator <- as.factor(ifelse(dayName %in% c("Saturday","Sunday"), "Weekend", 
                                   "Weekday"));
summedDayData <- ddply(dayData, .(interval, dayTypeIndicator),
                       summarise,
                       intervalMean = mean(steps, na.rm=TRUE)); 
xyplot(intervalMean ~ interval | dayTypeIndicator,
       ylab="Avg. Steps per Interval",
       xlab ="5 Minute Interval Number",
       main ="Weekend vs. Weekday Steps per Interval",
       data = summedDayData,
       type = "l", 
       col="red",
       layout = c(1, 2));


