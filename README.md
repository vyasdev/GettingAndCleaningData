## Assumptions
1. The working directory contains run_analysis.R file and "UCI HAR Dataset" folder
2. The folder structure of the UCI HAR Dataset is the same as you extracted the dataset zip file
3. The output file will be created in the current working directory

## Requirement
1. package reshape 
  - To install reshape package, please issue ```install.packages("reshape")``` in R
	- To use reshape package, please issue ```library(reshape)``` in R

## To Run this script
1. Download the UCI HAR Dataset  from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
2. Extract the zip file in the working directory. Please DON'T make any change in the folder structure of the dataset. For example, the train folder should be located at <working directory>/UCI HAR Dataset/train/
3. Download and run run_analysis.R in working directory
4. The tidy dataset (TidyDataSet.txt) will then be created in the working directory.

## How script works?
1. Check if the UCI HAR Dataset file structure correct and related file exists 
2. Preparation Tasks
	1. Get the activity names and convert the activity names to lower case
	2. Get the feature name, extract mean and standard deviation only, change the name as camel case without open brace, close brace and minus sign
3. Merge Train and Test Datasets
	1. Get X_train and X_test data, filter irrevlant columns and store in a single dataset (variable named as ds)
	2. Get subject name and insert into single dataset (ds) as the first column
	3. Get activity name and insert into single dataset (ds) as the first column
4. Create tidy dataset with average of each variable for each activity and each subject
	1. "melt" the single dataset (ds) so each row is a unique (activity,subject)-variable combination.
	2. "cast" the melted data to calculate the mean of each variable, so each row is re-shaped as (activity, subject)-all variables
5. Save the casted data