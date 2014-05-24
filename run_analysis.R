# Assumption: 
 
# 1) The current working directory contains this R file and "UCI HAR Dataset" folder
# 2) The folder structure of the UCI HAR Dataset remain unchange as the zip file
# 3) The output file will be created in the current working directory

# Reference: Reshaping Data - http://www.statmethods.net/management/reshape.html


# getCleanHARDataset 
#   - merge the training and testing datasets to one dataset
#   - the tidy dataset with average of each variable (mean and standard deviation measurement) for each activity and each subject
# parameter: dataSetOuputFileName: (character) set the output file name

CreateTidyDataSet <- function(dataSetOuputFileName="TidyDataSet.txt"){
  library(reshape) # For melt & cast operations that come later. Ensure reshape package is installed first.
  
  #checking
  if (!file.exists(file.path(getwd(), "UCI HAR Dataset")))
    stop("Cannot find dataset folder 'UCI HAR Dataset' in the working directory")
  if (!file.exists(file.path(getwd(), "UCI HAR Dataset/train/X_train.txt")))
    stop("Cannot find X_train.txt in train folder")
  if (!file.exists(file.path(getwd(), "UCI HAR Dataset/train/y_train.txt")))
    stop("Cannot find y_train.txt in train folder")
  if (!file.exists(file.path(getwd(), "UCI HAR Dataset/train/subject_train.txt")))
    stop("Cannot find subject_train.txt in train folder")
  if (!file.exists(file.path(getwd(), "UCI HAR Dataset/test/X_test.txt")))
    stop("Cannot find X_test.txt in test folder")
  if (!file.exists(file.path(getwd(), "UCI HAR Dataset/test/y_test.txt")))
    stop("Cannot find y_test.txt in test folder")
  if (!file.exists(file.path(getwd(), "UCI HAR Dataset/test/subject_test.txt")))
    stop("Cannot find subject_test.txt in test folder")
  
  #ADR dataset folder
  ADRFolder = "UCI HAR Dataset"
  
  #preparation
  # get activity names and convert the activity name to lower case     
  activityNames <-read.table(file.path(ADRFolder, "activity_labels.txt"))
  activityNames[, 2] <- tolower(activityNames[, 2])
  
  # get mean and std related features, the feature name in camel case without symbol such as open and close brace, minus symbol    
  feature <- read.table(file.path(ADRFolder, "features.txt"))
  validCol <- grepl("*(mean|std)\\(\\)*", feature[, 2]) # check which column with 'mean()' or 'std()'
  feature <- feature[validCol, ] # filter irrevlant feature
  feature[, 2] <- gsub("mean\\(\\)", "Mean", feature[, 2]) #mean() -> Mean
  feature[, 2] <- gsub("std\\(\\)", "Std", feature[, 2]) #std() -> Std
  feature[, 2] <- gsub("-", "", feature[, 2]) #remove "-"
  
  #merge dataset
  # get X_train and X_test data    
  ds <- read.table(file.path(ADRFolder, "train/X_train.txt"))[, validCol] #add train data set first
  ds <- rbind(ds, read.table(file.path(ADRFolder, "test/X_test.txt"))[, validCol]) #row bind test data set    
  colnames(ds) <- as.character(feature[, 2]) # set the column names (about feature)
  
  
  # prepare subject column and insert into ds
  sub <- rbind(read.table(file.path(ADRFolder, "train/subject_train.txt")), read.table(file.path(ADRFolder, "test/subject_test.txt")))    
  ds <- cbind(sub, ds) #insert as the 1st column to ds
  colnames(ds)[1] <- c("subjectID")
  
  # prepare activity column and insert into ds
  act <- rbind(read.table(file.path(ADRFolder, "train/y_train.txt")), read.table(file.path(ADRFolder, "test/y_test.txt")))
  act <- sapply(act, function(idx) activityNames[idx, 2]) #update with descriptive activity name
  ds <- cbind(act, ds) # insert as the 1st column in ds
  colnames(ds)[1] <- "activity" #set the column name as "activity"
  
  
  # create tidy dataset with the average of each variable for each activity and each subject
  molten = melt(ds, id=c("activity", "subjectID")) #create molten data    
  dsWithAvgVars = cast(molten, activity + subjectID ~ variable, mean) #cast the melted data
  
  #save the file
  write.table(dsWithAvgVars, dataSetOuputFileName)
  
}