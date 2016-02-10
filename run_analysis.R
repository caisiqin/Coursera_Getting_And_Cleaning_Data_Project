# Coursera---Data Scientist---Getting and Cleaning Data Project

# 1.Merges the training and the test sets to create one data set.
train_data <- read.table("./UCI HAR Dataset/train/X_train.txt") # 7352*561
test_data <- read.table("./UCI HAR Dataset/test/X_test.txt") # 2947*561
data_merged <- rbind(train_data,test_data) # 10299*561

train_label <- read.table("./UCI HAR Dataset/train/y_train.txt") #7352*1
test_label <- read.table("./UCI HAR Dataset/test/y_test.txt") #2947*1
label_merged <- rbind(train_label,test_label) # 10299*1

train_subject <- read.table("./UCI HAR Dataset/train/subject_train.txt")
test_subject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_merged <- rbind(train_subject,test_subject) # 10299*1

# 2.Extracts only the measurements on the mean and sd for each measurement.
features <- read.table("./UCI HAR Dataset/features.txt",header = FALSE,col.names = c("ID","names"))
features_selected_col<- grep("mean\\(\\)|std\\(\\)", features$name) # 68
data_selected <- data_merged[,features_selected_col] # 10299*66
names(data_selected) <- features[features$ID %in% features_selected_col,2]

# 3.Uses descriptive activity names to name the activities in the data set
activity <- read.table("./UCI HAR Dataset/activity_labels.txt",header = FALSE,col.names = c("ID","names"))
label_merged[,1] <- activity[label_merged[,1],2]
names(label_merged) <- "activity"

# 4.Appropriately labels the data set with descriptive variable names
names(subject_merged) <- "subject"
whole_data_selected <- cbind(subject_merged,label_merged,data_selected)
write.table(whole_data_selected,"whole_dataset_w_mean_std.txt")

# 5.creates a second, independent tidy data set with the average of each 
#   variable for each activity and each subject.
new_measurements <- whole_data_selected[, 3:dim(whole_data_selected)[2]]
tidy_dataset <- aggregate(new_measurements, list(whole_data_selected$subject, whole_data_selected$activity), mean)
names(tidy_dataset)[1:2] <- c('subject', 'activity')
write.table(tidy_dataset, "tidy_dataset.txt")
