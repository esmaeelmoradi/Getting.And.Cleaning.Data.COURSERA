library(reshape2)

#set your work directory
#setwd("/Users/.../getcleandata.project")

filename <- "get.clean.data.project.zip"

## getting data and make it ready for starting the project
if (!file.exists(filename)){
        fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip "
        download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")) { 
        unzip(filename) 
}

# loading features and activity lables
activity_lables <- read.table("UCI HAR Dataset/activity_labels.txt")
activity_lables[,2] <- as.character(activity_lables[,2])
features <- read.table("UCI HAR Dataset/features.txt")
features[,2] <- as.character(features[,2])

# use the data on mean and standard deviation and remove others
featuresName.Index <- grep("mean|std", features[,2])
length(featuresName.Index)
featuresName.Used <- features[featuresName.Index,2]
featuresName.Used <- gsub("-mean", "Mean", featuresName.Used)
featuresName.Used <- gsub("-std", "Std", featuresName.Used)
featuresName.Used <- gsub("[-()]", "", featuresName.Used)

# creating train and test data sets
train <- read.table("UCI HAR Dataset/train/X_train.txt")[featuresName.Index]
Y_train <- read.table("UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train <- cbind(subject_train, Y_train, train)

test <- read.table("UCI HAR Dataset/test/X_test.txt")[featuresName.Index]
Y_test <- read.table("UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test <- cbind(subject_test, Y_test, test)

# merging data sets and creating variable names
Project_Data <- rbind(train, test)
colnames(Project_Data) <- c("subject", "activity", featuresName.Used)

# factorizing activities and subjects
Project_Data$activity <- factor(Project_Data$activity, levels = activity_lables[,1], labels = activity_lables[,2])
Project_Data$subject <- as.factor(Project_Data$subject)


#finalizing the data set as tidy
Project_Data_Melted <- melt(Project_Data, id = c("subject", "activity"))
Project_Data_Melted <- dcast(Project_Data_Melted, subject + activity ~ variable, mean)
write.table(Project_Data_Melted, "tidy.txt", row.names = FALSE, quote = FALSE)