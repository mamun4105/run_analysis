README
============

This is the elaboration of run_anlysis.R script. This script will make a tidy dataframe of 180 observation on 81 variables.

For this purpose some steps are taken. Steps and associated codes are presented below:

##Importing/reading text files

```{r}
sub_train <- read.table("subject_train.txt")
X_train <- read.table("X_train.txt")
y_train <- read.table("y_train.txt")
sub_test <- read.table("subject_test.txt")
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
feature <- read.table("features.txt")
```

##Assigning variable names from the feature.txt file

```{r}
colnames(X_train) <- feature$V2
colnames(x_test) <- feature$V2
```

##Column binding the test and train data separately

```{r}
train <- cbind(sub_train, X_train, y_train)
test <- cbind(sub_test, x_test, y_test)
```

##Asigning variable names for sucject and activity variable

```{r}
colnames(train)[1] <- "Subject"
colnames(train)[563] <- "activity"
colnames(test)[1] <- "Subject"
colnames(test)[563] <- "activity"
```

##Merging into one big dataframe

```{r}
data <- rbind(train, test)
```

##Subsetting the mean() and std() data

```{r}
partial <- "mean()"
partial2 <- "std()"
subdata1 <- data[, grep(partial, colnames(data))]
subdata2 <- data[, grep(partial2, colnames(data))]
```

##Subsetting the subject variable from the big merged dataframe

```{r}
subdata3 <- data[, 1]
```

##Factoring the activity by qualitative names and assigning levels

```{r}
subdata4 <- factor(data$activity, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
subdata <- cbind(subdata3, subdata4, subdata1, subdata2)
```

##Assigning variable names of subject and activity

```{r}
colnames(subdata)[1:2] <- c("subject", "activity")
```

##Reshaping the subset by activity labels and then by subject

```{r}
require(reshape2)
tidy_data2 <- melt(subdata, id = c("subject", "activity"), na.rm = TRUE)
tidy_data3 <- dcast(tidy_data2, formula = activity + subject ~ variable)
```

##Writing the dataframe as csv
```{r}
write.csv(tidy_data3, "out.csv")
```
