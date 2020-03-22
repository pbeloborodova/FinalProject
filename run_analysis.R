### PREPROCESSING OF DATA ###

# Change settings and load packages ---------------------------------------------

options(stringsAsFactors = FALSE)
library(dplyr)

# Download data archive ---------------------------------------------------------

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, "data.zip", method = "curl")

# Explore contents of archive ---------------------------------------------------

# Make a vector of files in archive
contents <- unzip("data.zip", list = TRUE)[,1]  # Need only 1st column with file names
print(contents)

# Load data files from archive: (1) Main folder ---------------------------------

# Create a vector of file paths
main_contents <- contents[1:2]

# Create a vector of file names
main_names <- gsub("UCI HAR Dataset/|.txt", "", contents[1:2])

# Create separate data frames for data files in the folder
for (i in 1:2) {
  conn <- unz("data.zip", main_contents[i])
  df <- read.table(conn, header = F, sep = " ")
  assign(main_names[i], df)
}

# Load data files from archive: (2) Test folder ---------------------------------

# Create a vector of file paths
test_contents <- contents[16:18]

# Create a vector of file names
test_names <- gsub("UCI HAR Dataset/test/|.txt", "", contents[16:18])

# Create separate data frames for data files in the folder
for (i in 1:3) {
  conn <- unz("data.zip", test_contents[i])
  df <- read.table(text = gsub("  ", " ", readLines(conn)))
  assign(test_names[i], df)
}

# Load data files from archive: (3) Train folder -------------------------------

# Create a vector of file paths
train_contents <- contents[30:32]

# Create a vector of file names
train_names <- gsub("UCI HAR Dataset/train/|.txt", "", contents[30:32])

# Create separate data frames for all data files
for (i in 1:3) {
  conn <- unz("data.zip", train_contents[i])
  df <- read.table(text = gsub("  ", " ", readLines(conn)))
  assign(train_names[i], df)
}

# Remove auxiliary objects from the environment ---------------------------------

rm(df, conn, i, url)
rm(list=ls(pattern="contents"))
rm(list=ls(pattern="names"))

### END OF PREPROCESSING, STARTING ON ASSIGNMENT NOW ###

### ASSIGNMENT PART 2 ###

# Create a list of mean and std variables ---------------------------------------

selected_features <- features[grep("mean|std", features$V2), ]

# Make sure there are no duplicated names
sum(duplicated(selected_features[,2]))

# Subset test and train data using selected features' numbers -------------------

selected_X_test <- X_test[,selected_features[,1]]
selected_X_train <- X_train[,selected_features[,1]]

colnames(selected_X_test) <- selected_features[,2]
colnames(selected_X_train) <- selected_features[,2]

### ASSIGNMENT PART 1 ###

# Attach participants' numbers and activity labels ------------------------------

# Test data
subject_test <- rename(subject_test, id = V1)
y_test <- rename(y_test, activity_number = V1)
selected_X_test <- cbind(subject_test, y_test, selected_X_test)

# Train data
subject_train <- rename(subject_train, id = V1)
y_train <- rename(y_train, activity_number = V1)
selected_X_train <- cbind(subject_train, y_train, selected_X_train)

# Merge test and train data -----------------------------------------------------

selected_X <- rbind(selected_X_test, selected_X_train)

# Remove data frames no longer needed -------------------------------------------

rm(selected_X_test, selected_X_train,
   features, selected_features,
   subject_test, subject_train,
   X_test, X_train,
   y_test, y_train)

### ASSIGNMENT PART 3 ###

# Create activity names variable ------------------------------------------------

# Duplicate activity number variable
selected_X$activity_name <- selected_X$activity_number

# Change numbers to names
selected_X$activity_name[selected_X$activity_number %in% activity_labels[,1]] <-
  activity_labels[,2][match(selected_X$activity_number, activity_labels[,1])]

rm(activity_labels)  # Remove data frame no longer needed

### ASSIGNMENT PART 4 ###

# Edit variable names ----------------------------------------------------------

colnames(selected_X) <- gsub("\\(\\)|-", "", colnames(selected_X))
colnames(selected_X) <- gsub('mean', 'Mean', colnames(selected_X))
colnames(selected_X) <- gsub("std", "Std", colnames(selected_X))

### ASSIGNMENT PART 5 ###

# Create new data frame with means of all variables grouped by subject and activity
tidy_data <-
  selected_X[,-2] %>%
  group_by(id, activity_name) %>%
  summarize_each(funs(mean))

# Save data in .txt file
write.table(tidy_data, "tidy_data.txt", sep = " ", dec = ".",
            row.names = TRUE, col.names = TRUE)
