#importing/reading text files
sub_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
sub_test <- read.table("subject_test.txt")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
feature <- read.table("features.txt")

#assigning variable names from the feature.txt file
colnames(X_train) <- feature$V2
colnames(x_test) <- feature$V2

#column binding the test and train data separately
train <- cbind(sub_train, X_train, y_train)
test <- cbind(sub_test, x_test, y_test)

#asigning variable names for sucject and activity variable
colnames(train)[1] <- "Subject"
colnames(train)[563] <- "activity"
colnames(test)[1] <- "Subject"
colnames(test)[563] <- "activity"

#merging into one big dataframe
data <- rbind(train, test)

#subsetting the mean() and std() data
partial <- "mean()"
partial2 <- "std()"
subdata1 <- data[, grep(partial, colnames(data))]
subdata2 <- data[, grep(partial2, colnames(data))]

#subsetting the subject variable from the big merged dataframe
subdata3 <- data[, 1]

#factoring the activity by qualitative names and assigning levels
subdata4 <- factor(data$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
subdata <- cbind(subdata3, subdata4, subdata1, subdata2)

#assigning variable names of subject and activity
colnames(subdata)[1:2] <- c("subject", "activity")

#reshaping the subset by activity labels and then by subject
require(reshape2)
tidy_data2 <- melt(subdata, id = c("subject", "activity"), na.rm = TRUE)
tidy_data3 <- dcast(tidy_data2, formula = activity + subject ~ variable)

#writing the dataframe as csv
write.csv(tidy_data3, "out.csv")
