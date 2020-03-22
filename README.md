---
title: "README"
output: 
  html_document: 
    fig_height: 4
    highlight: pygments
    theme: spacelab
    keep_md: true
---



## Preliminary notes

As a reminder, in this assignment we have to create one R script called run_analysis.R that does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The script consists of two parts: `Setup` and `Assignment`. In the `Setup` part I load packages and data and remove all auxiliary objects from the environment. In the `Assignment` part I walk throuh every step of the assignment.

## Setup

### Change settings and load packages

I am setting `stringsAsFactors` to `FALSE` as a default setting to avoid problems with character variables (such as the list of features) being converted to factors. Also loading `dplyr` package which I am going to use for data manipulation.

### Load data

Using `download.file()` function to download data archive. Then I explore the contents of the archive by creating a list of files and folders and printing it to the console.

After that, I load files from main folder, test and train folders separately. Using the `gsub()` function to create a vector of file names which I am using as data frame names in the `for` loop.

Finally, I remove auxiliary objects from the environment. This, I now have all necessary objects in the environment and removed extra objects to free the memory.

## Assignment

I found it more efficient to do part 2 (extract only the measurements on the mean and standard deviation for each measurement), and then part 1 (merge the training and the test sets to create one data set). The rest is done as indicated in the assignment.

### Part 2

I use `grep()` to create a list of variables containig means and standard deviations from the features file and make sure that none of the variables are duplicated.

Then I subset test and train data to include selected variables and change column names to features.

### Part 1

I attach participants' numbers and activity labels with cbind() function. Then I merge test and train data with `rbind()` function. Finally, I remove data frames that I no longer need.

### Part 3

I create activity names variable by first duplicating activity numbers and then changing them to activity names with `match()` function.

### Part 4

Following the recommendation from [this thread](https://www.coursera.org/learn/data-cleaning/discussions/weeks/4/threads/7yTCGiWNEeiGYRJR35RvhA) in the course forum, I believe that variable names from the features file are already descriptive enough to indicate what they mean if the user made themself familiar with the study by reading this README and checking the codebook where I break down variable names into parts and explain what they mean. Making variable names more human-readable would greatly increase character count and make them difficult to work with.

However, I remove brackets and dashes from variable names with `gsub()` function because they might later cause problems with the analysis.

### Part 5

In order to create a tidy data set with means of variables grouped by subject and activity, I  take the narrow data set approach which corresponds to the assignemnt requirements according to [this discussion](https://www.coursera.org/learn/data-cleaning/discussions/forums/h8cjA78DEeWtFA5RrsHG3Q/threads/-Cjtsip5Eea0DRLrrvCCTQ) in the course forum. Additionally, from my own research experience, I find it much easier to work with narrow data in terms of analysis and visualization.

I create new data frame which contains means of variables with `group_by()` and `summarize_each()` functions from `dplyr` package.

Finally, I save data in a .txt file.


__Congrats everyone on passing the course! :)__

