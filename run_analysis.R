# setting a working directory after downloading the data
getwd()
setwd("C:/Users/David/Desktop/Coursera/3 Getting and cleaning data/UCI HAR Dataset")
list.files()

# Reading feature names and subsetting only those with mean and std
names_features <- read.table("C:/Users/David/Desktop/Coursera/3 Getting and cleaning data/UCI HAR Dataset/features.txt")
names(names_features)
id_features <- grep("mean|std", names_features$V2)
id_features

# Reading train and test feature and subsetting only those with mean and std
train_features <- read.table("C:/Users/David/Desktop/Coursera/3 Getting and cleaning data/UCI HAR Dataset/train/X_train.txt")
id_train_features <- train_features[,id_features]
names(id_train_features)
test_features <- read.table("C:/Users/David/Desktop/Coursera/3 Getting and cleaning data/UCI HAR Dataset/test/X_test.txt")
id_test_features <- test_features[,id_features]
names(id_test_features)

# Combining the two datasets into one + check
merged_features <- rbind(id_train_features, id_test_features)
nrow(merged_features) == nrow(id_train_features) + nrow(id_test_features)

# Assigning column names to features
head(merged_features, 2)
colnames(merged_features) <- names_features[id_features, 2]
head(merged_features, 2)

# Reading and combining train and test activity codes + check
train_activities <- read.table("C:/Users/David/Desktop/Coursera/3 Getting and cleaning data/UCI HAR Dataset/train/y_train.txt")
test_activities <- read.table("C:/Users/David/Desktop/Coursera/3 Getting and cleaning data/UCI HAR Dataset/test/y_test.txt")
merged_activities <- rbind(train_activities, test_activities)
names(merged_activities)
nrow(merged_activities) == nrow(train_activities) + nrow(test_activities)

# Reading activity labels and attaching them to activity codes
activity_labels <- read.table("C:/Users/David/Desktop/Coursera/3 Getting and cleaning data/UCI HAR Dataset/activity_labels.txt")
merged_activities$activity <- factor(merged_activities$V1, levels = activity_labels$V1, labels = activity_labels$V2)
head(merged_activities, 3)

# Reading and combining train and test subject ids + check
train_subjects <- read.table("C:/Users/David/Desktop/Coursera/3 Getting and cleaning data/UCI HAR Dataset/train/subject_train.txt")
test_subjects <- read.table("C:/Users/David/Desktop/Coursera/3 Getting and cleaning data/UCI HAR Dataset/test/subject_test.txt")
merged_subjects <- rbind(train_subjects, test_subjects)

# Combining subjects and activities
merged_subjects_activities <- cbind(merged_subjects, merged_activities$activity)
colnames(merged_subjects_activities) <- c("subject_id", "activity")
head(merged_subjects_activities)

# Combine with features
merged <- cbind(merged_subjects_activities, merged_features)
head(merged)
dim(merged$subject_id)

# Computing and reporting means, grouped by subject_id and by activity
output <- aggregate(merged[,3:81], by = list(merged$subject_id, merged$activity), FUN = mean)
colnames(output)[1:2] <- c("subject.id", "activity")
write.table(output, file="mean_measures.txt", row.names = FALSE)
