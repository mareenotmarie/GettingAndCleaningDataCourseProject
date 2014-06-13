# The data represent data collected from the accelerometers from the 
# Samsung Galaxy S smartphone. A full description is available at 
# the site where the data was obtained: 
# http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

# create temp file and download source data zip to temp file
temp <- tempfile()
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,temp)

# extract activity labels, training data, test data, features, subject files (test and train) 
# and activity files (test and train) to the environment
activity_labels <- read.table(unz(temp, "UCI HAR Dataset/activity_labels.txt"))
train_data <- read.table(unz(temp, "UCI HAR Dataset/train/X_train.txt"))
test_data <- read.table(unz(temp, "UCI HAR Dataset/test/X_test.txt"))
features <- read.table(unz(temp, "UCI HAR Dataset/features.txt"))
test_subjects <- read.table(unz(temp, "UCI HAR Dataset/test/subject_test.txt"))
train_subjects <- read.table(unz(temp, "UCI HAR Dataset/train/subject_train.txt"))
test_activities <- read.table(unz(temp, "UCI HAR Dataset/test/y_test.txt"))
train_activities <- read.table(unz(temp, "UCI HAR Dataset/train/y_train.txt"))

# release tempfile at the first opportunity
unlink(temp) 

# 1. Merge the training and test data sets to create one dataset
# bind subject, activity and data columns for train and test datasets and combine rows as all_data
train_data <- cbind(train_subjects, train_activities, train_data)
test_data <- cbind(test_subjects, test_activities, test_data)
all_data <- rbind(train_data,test_data)

# 2. Extract only the measurements on the mean and standaard deviation for each measurement
# determine columns we want (mean and standard deviation)
cols <- union(c(features[grepl("-mean()",features$V2,fixed=TRUE),1]), 
              c(features[grepl("-std()",features$V2,fixed=TRUE),1]))
# cols are offset by two because of the subject and activity columns added to all data
cols.offset <- c(1,2,sapply(cols, function(x) x+2))
# subset only the columns we want
mean_std_data <- all_data[,cols.offset]

# 3. Use descriptive activity names to name the activities in the dataset
# these names have been pulled from the activity labels file
mean_std_data[,2] <- as.character(activity_labels[mean_std_data[,2],2])

# 4. Appropriately label the dataset with descriptive variable names
col.names.to.change <- as.character(features[cols,2])
col.names.to.change <- sub("^t", "time.domain.", col.names.to.change)
col.names.to.change <- sub("^f", "frequency.domain.", col.names.to.change)
col.names.to.change <- sub("BodyBody", "Body", col.names.to.change, fixed=TRUE) # fixing error
col.names.to.change <- sub("Body", "body.", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("Gravity", "gravity.", col.names.to.change, fixed=TRUE)

col.names.to.change <- sub("AccJerkMag", "accelerometer.jerk.magnitude.", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("AccMag", "accelerometer.magnitude.", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("AccJerk", "accelerometer.jerk.signal.", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("Acc", "accelerometer.signal.", col.names.to.change, fixed=TRUE)

col.names.to.change <- sub("GyroJerkMag", "gyroscope.jerk.magnitude.", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("GyroMag", "gyroscope.magnitude.", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("GyroJerk", "gyroscope.jerk.signal.", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("Gyro", "gyroscope.signal.", col.names.to.change, fixed=TRUE)

col.names.to.change <- sub("-mean()", "mean", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("-std()", "std", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("-X", ".x", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("-Y", ".y", col.names.to.change, fixed=TRUE)
col.names.to.change <- sub("-Z", ".z", col.names.to.change, fixed=TRUE)

names(mean_std_data) <- c("subject", "activity", col.names.to.change)

# 5. Creates a second, independent tidy data set with the 
# average of each variable for each activity and each subject
means <- aggregate(mean_std_data[3:length(mean_std_data)],
                   by=mean_std_data[c("subject", "activity")],FUN=mean)
# rename column headings as averages
names(means)[3:length(means)] <- paste("average", names(means)[3:length(means)], sep=".")

write.csv(means, "means.csv")
write.table(means, "means.txt", sep="\t", row.names=F)