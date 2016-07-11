# download the data zip pacakge.
URL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(URL,destfile = "smartphone.zip",method = "curl")
unzip("smartphone.zip")


activitylabels_raw <- read.table("./UCI HAR Dataset/activity_labels.txt")
features_raw <- read.table("./UCI HAR Dataset/features.txt")
activitylabels <- activitylabels_raw[,2]
featuresesnew <- grep(".*(mean|std).*",features_raw[,2])
features <- features_raw[featuresenew,2]
featuresclean <- gsub("[-()]","",features)


test <- read.table("./UCI HAR Dataset/test/X_test.txt")
testnew <- as.data.frame(test[,featuresnew])
testactivities <- read.table("./UCI HAR Dataset/test/Y_test.txt")                   
testsubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")

train <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainnew <- as.data.frame(train[,featuresnew])
trainactivities <- read.table("./UCI HAR Dataset/train/Y_train.txt")                   
trainsubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")

testdata <- cbind(testnew,testactivities,testsubjects)
traindata <- cbind(trainnew,trainactivities,trainsubjects)
smartphone <- rbind(testdata,traindata)
names(smartphone) <- c(as.character(featuresclean),"activities","subjects")
smartphone$activities <- factor(smartphone$activities,levels = activitylabels_raw[,1],labels = activitylabels_raw[,2])
smartphone$subjects <- factor(smartphone$subjects)

dim(smartphone)
splitsmart <- split(smartphone[,1:79],smartphone[,80:81])
splitmean <- sapply(splitsmart,colMeans)
smartphone.mean <- unlist(splitmean)
write.table(smartphone.mean, "tidy.txt", row.names = FALSE)
