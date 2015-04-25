
# This R script is created as part of the coursera getting and cleaning data course project work
# run_analysis.R that does the following: 
# Step 1 - Merges the training and the test sets to create one data set.
# Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
# Step 3 - Uses descriptive activity names to name the activities in the data set
# Step 4 - Appropriately labels the data set with descriptive variable names. 
# Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# code START

# Clean up workspace
rm(list=ls())

## assigning the working directory to UCI HAR dataset folder
directory <- "UCI HAR Dataset"
wd <- getwd()
newWd <- paste(wd, directory, sep = "/")
setwd(newWd)

# Step 1 - Merges the training and the test sets to create one data set

subjectTrain = read.table('./train/subject_train.txt') 
subjectTest = read.table('./test/subject_test.txt') 

xTrain       = read.table('./train/x_train.txt')
xTest       = read.table('./test/x_test.txt') 

yTrain       = read.table('./train/y_train.txt')
yTest       = read.table('./test/y_test.txt')

features     = read.table('./features.txt')
activityType = read.table('./activity_labels.txt')

colnames(subjectTrain)  = "subjectId"
colnames(subjectTest) = "subjectId"

colnames(xTrain)        = features[,2]
colnames(xTest)       = features[,2]

colnames(yTrain)        = "activityId"
colnames(yTest)       = "activityId"

colnames(activityType)  = c('activityId','activityType')


trainingData = cbind(subjectTrain,xTrain,yTrain)
testData = cbind(subjectTest,xTest,yTest)
mergedData = rbind(trainingData, testData)
colNames  = colnames(mergedData)

# Step 2 - Extracts only the measurements on the mean and standard deviation for each measurement. 
Vector_1 = (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames))
mergedData = mergedData[Vector_1==TRUE]

# Step 3 - Uses descriptive activity names to name the activities in the data set
mergedData = merge(mergedData,activityType,by='activityId',all.x=TRUE)
colNames  = colnames(mergedData)

# Step 4 - Appropriately labels the data set with descriptive variable names. 
for (i in 1:length(colNames)) 
{
  colNames[i] = gsub("\\()","",colNames[i])
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","time",colNames[i])
  colNames[i] = gsub("^(f)","freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
};
colnames(mergedData) = colNames

# Step 5 - From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
mergedDataNoActivityType  = mergedData[,names(mergedData) != 'activityType']
tidyData    = aggregate(mergedDataNoActivityType[,names(mergedDataNoActivityType) != c('activityId','subjectId')],by=list(activityId=mergedDataNoActivityType$activityId,subjectId = mergedDataNoActivityType$subjectId),mean)
tidyData    = merge(tidyData,activityType,by='activityId',all.x=TRUE)
write.table(tidyData, './tidyData.txt',row.names=TRUE,sep='\t')

# Reset wd path to original
setwd(wd)

# code END