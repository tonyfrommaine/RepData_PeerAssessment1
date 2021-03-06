# Reproducible Research: Peer Assessment 1
This program is for the peer assignment of Reproducubile Research Assessment 1  
The exact instructions are in the GitHub under the "doc"" directory, in a  
file instructions.pdf  

**Note on downloading the initial dataset: **   
As per the instructions, it is assumed that the file has already been downloaded  
and in the working directory.   If, though the file would need to be downloaded 
again the url is:  
https://d396qusza40orc.cloudfront.net/repdata%2Fdata%2Factivity.zip 

As per the instructions:  
The variables included in this dataset are:  

* steps: Number of steps taking in a 5-minute interval (missing values are coded as NA)  
* date: The date on which the measurement was taken in YYYY-MM-DD format  
* interval: Identifier for the 5-minute interval in which measurement was taken  

The dataset is stored in a comma-separated-value (CSV) file and there are a total  
of 17,568 observations in this dataset.

First, load required packages:   

```r
require(plyr);
```

```
## Loading required package: plyr
```

```r
require(lattice);
```

```
## Loading required package: lattice
```

## Loading and preprocessing the data  
Overview of steps in this phase:  
1. Unzip the local file (see note on downloading above)   
2. Read the CSV  
3. Format the Date  


```r
unzip("activity.zip");
rawData<-read.csv("activity.csv");
rawData$date <- as.Date(rawData$date, "%Y-%m-%d");
```

Now check the data looks correct  

```r
head(rawData);
```

```
##   steps       date interval
## 1    NA 2012-10-01        0
## 2    NA 2012-10-01        5
## 3    NA 2012-10-01       10
## 4    NA 2012-10-01       15
## 5    NA 2012-10-01       20
## 6    NA 2012-10-01       25
```


## What is mean total number of steps taken per day?  
Overview of steps in this phase:  
1. Aggregate the steps by date  
2. Create a histogram based on this aggregated data 
3. Calculate the median and mean  


```r
stepsTotal <- tapply(rawData$steps, rawData$date, sum);
hist(stepsTotal,  breaks=15, xlab = "Total Steps by Day", ylab = "Frequency", 
     main = "Total Step Histogram", col="red");
```

![](PA1_template_files/figure-html/unnamed-chunk-4-1.png) 
  
Calculate the mean removing the NA's  

```r
stepMean<-mean(stepsTotal,na.rm=TRUE);
stepMean;
```

```
## [1] 10766.19
```

Calculate the median removing the NA's  

```r
stepMedian<-median(stepsTotal,na.rm=TRUE);
stepMedian;
```

```
## [1] 10765
```

## What is the average daily activity pattern?
Since the data is already broken out by 5 minute intervals for each day, it should be  
aggregated by the time intervals.  

Overview of steps in this phase:  
1. Build the 5 minute slices  
2. Calculate the mean for each 5 minute interval  
3. Create a plot to reprsent the 5 minute intervals across all days  
4. Calculate and display the 5 minute interval with the highest amount of steps  

Build slices and mean by slice  

```r
stepsIntervalMean <- tapply(rawData$steps, rawData$interval, mean, na.rm = TRUE)
```
Create a simple plot of type="l"  

```r
plot(row.names(stepsIntervalMean),stepsIntervalMean,
     type="l",
     xlab="Five Minute Interval",
     ylab="Avg. Number of Steps",
     main="Average Steps per Five Minute Interval",
     col="red");
```

![](PA1_template_files/figure-html/unnamed-chunk-8-1.png) 

Find the slice with the maximum number of steps  

```r
maxSlice <- names(which.max(stepsIntervalMean));
maxSlice;
```

```
## [1] "835"
```
## Imputing missing values  
Overview of steps in this phase:  
1.  Find and display the number of observations without complete cases 
2.  Fill in values for incomplete cases with derived value in a new dataset named enrichData  
3.  Confirm the NA's have been removed  
4.  Create histogram for number of steps  
5.  Calcualte the mean and median  
6.  Report on observed difference.  

Calcualte and display rows with NA's  

```r
incompleteRowCount <- length(which(!complete.cases(rawData)));
incompleteRowCount;
```

```
## [1] 2304
```
Fill in NA's with derived value from interval mean which was previously calculated.  
This method was chosen as it can closely mimic the time interval by filling with the  
appropriate value.  Other methods considered, but not chosen include: overall mean for  
all times and all days,  mean for the day for all intervals, medians were also considered.  

```r
enrichData <- rawData
enrichData$steps[is.na(enrichData$steps)] <- stepsIntervalMean;
stepsEnrichTotal <- tapply(enrichData$steps, enrichData$date, sum);
```
Confirm no more NA's exist  

```r
incompleteRowCount <- length(which(!complete.cases(enrichData)));
incompleteRowCount;
```

```
## [1] 0
```
Create histogram with NA's taken out  

```r
hist(stepsEnrichTotal,  breaks=15, xlab = "Total Steps by Day", ylab = "Frequency", 
     main = "Total Step Histogram replacing NA's", col="red");
```

![](PA1_template_files/figure-html/unnamed-chunk-13-1.png) 

Calculate Mean and Median fo the enriched data.   
First create the total steps per date.

```r
stepsEnrichTotal <- tapply(enrichData$steps, enrichData$date, sum);
```
Calculate the mean removing the NA's  

```r
stepMean<-mean(stepsEnrichTotal,na.rm=TRUE);
stepMean;
```

```
## [1] 10766.19
```

Calculate the median removing the NA's  

```r
stepMedian<-median(stepsEnrichTotal,na.rm=TRUE);
stepMedian;
```

```
## [1] 10766.19
```
The result is that the mean remains unchanged, but the median shifts to the right.  

## Are there differences in activity patterns between weekdays and weekends?  
Note:  This analysis will use the original data before replacement of the NA's, **not  
the enriched data** from the previous step which overwrote the NA's.  
This is to remain consistent with results of the  first step in this analysis  
and provide a true comparison.  

Overview of steps in this phase:  
1.  Create the two level factor for weeekday and weekend 
2.  Summarize using dplyr based on factor for intervals   
3.  Create the paneled plot comparing Weekend to Weekday    
4.  Report observations    

Create the levels  

```r
dayData <- rawData;
dayName <- weekdays(rawData$date);
dayData$dayTypeIndicator <- as.factor(ifelse(dayName %in% c("Saturday","Sunday"), "Weekend", 
                                   "Weekday"));
```
Summarize and check the head to ensure it is correct  

```r
summedDayData <- ddply(dayData, .(interval, dayTypeIndicator),
                       summarise,
                       intervalMean = mean(steps, na.rm=TRUE));  
head(summedDayData);
```

```
##   interval dayTypeIndicator intervalMean
## 1        0          Weekday    2.3333333
## 2        0          Weekend    0.0000000
## 3        5          Weekday    0.4615385
## 4        5          Weekend    0.0000000
## 5       10          Weekday    0.1794872
## 6       10          Weekend    0.0000000
```
Create the plot using lattice package  

```r
xyplot(intervalMean ~ interval | dayTypeIndicator,
       ylab="Avg. Steps per Interval",
       xlab ="5 Minute Interval Number",
       main ="Weekend vs. Weekday Steps per Interval",
       data = summedDayData,
       type = "l", 
       col="red",
       layout = c(1, 2));
```

![](PA1_template_files/figure-html/unnamed-chunk-19-1.png) 

**Observations:**    
-  Weekday has faster ramp up of activity in the morning.  
-  Weekend has more sustained activity mid-day.  
-  Weekend activity lasts longer into the night than weekday.  
-  Overall activity on weekend is more sustained.
