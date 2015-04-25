Step 1 - Merge the training and the test sets to create one data set.
-Read all tables and assign column names
-cbind Train tables and Test tables to create trainingdata and testing data sets
-rbind trainingdata and testing data sets 

Step 2 - Extract only the measurements on the mean and standard deviation for each measurement
-Create a vector and subset the data to show only ID, mean and stdev columns

Step 3 - Use descriptive activity names to name the activities in the data set
-Merge data subset with the activityType table to cinlude the descriptive activity names

Step 4 - Appropriately label the data set with descriptive activity names.
-Use gsub function for pattern replacement to clean up the data labels.

Step 5 - Create a second, independent tidy data set with the average of each variable for each activity and each subject.
-Aggregate, Merge and Write to produce data set with the average of each variable for each activity and subject