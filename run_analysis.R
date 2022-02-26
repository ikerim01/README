library(dplyr)
filename <- "Coursera_DS3_Final.zip"
if (!file.exists(filename)){
             fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
             download.file(fileURL, filename, method="curl")
}  
if (!file.exists("UCI HAR Dataset")){
         unzip(filename)
}
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")
X<- rbind(x_train,x_test)
Y<-rbind(y_train, y_test)
Subject<-rbind(subject_train, subject_test)
Mdata<-cbind(Subject,X,Y)
Tdata <- Mdata %>% select(subject, code, contains("mean"), contains("std"))
Tdata$code<-activities[Tdata$code,2]
names(Tdata)[2]="activity"
names(Tdata)<-gsub("Acc", "Accelerometer", names(Tdata))
names(Tdata)<-gsub("Gyro", "Gyroscope", names(Tdata))
names(Tdata)<-gsub("BodyBody", "Body", names(Tdata))
names(Tdata)<-gsub("Mag", "Magnitude", names(Tdata))
names(Tdata)<-gsub("^t", "Time", names(Tdata))
names(Tdata)<-gsub("^f", "Frequency", names(Tdata))
names(Tdata)<-gsub("tBody", "TimeBody", names(Tdata))
names(Tdata)<-gsub("-mean()", "Mean", names(Tdata), ignore.case = TRUE)
names(Tdata)<-gsub("-std()", "STD", names(Tdata), ignore.case = TRUE)
names(Tdata)<-gsub("-freq()", "Frequency", names(Tdata), ignore.case = TRUE)
names(Tdata)<-gsub("angle", "Angle", names(Tdata))
names(Tdata)<-gsub("gravity", "Gravity", names(Tdata))
Fulldata <- Tdata %>%
         group_by(subject, activity) %>%
         summarise_all(funs(mean))
write.table(Fulldata, "Fulldata.txt", row.name=FALSE)
str(Fulldata)