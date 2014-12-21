library(dplyr)

sourceURL <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

tmpFile <- F#tempfile(); download.file(sourceURL ,tmpFile)

readFile <- function(fileName,...) {
  if(tmpFile == FALSE )
    read.delim(fileName,header=FALSE,sep="",...)
  else
    read.delim(unz(tmpFile,fileName),header=FALSE,sep="",...)
}

readPart <- function(partName) {
  baseDir <- "UCI HAR Dataset/"
  headersFile  <- paste(sep="",baseDir,"features.txt")
  labelsFile   <- paste(sep="",baseDir,"activity_labels.txt")
  mainDataFile <- paste(sep="",baseDir,partName,"/X_",partName,".txt")
  subjectsFile <- paste(sep="",baseDir,partName,"/subject_",partName,".txt")
  activityFile <- paste(sep="",baseDir,partName,"/y_",partName,".txt")
  
  activityLabels <- readFile(labelsFile,col.names = c("Activity ID","Activity"))

  allHeaders <- readFile(headersFile,col.names = c("num","label"))
  
  niceHeaders <- gsub("\\.$","",
                 gsub("\\.\\.",".",
                 gsub("\\(\\)|-",".",
                      allHeaders$label)))
  
  allMetrics <- readFile(mainDataFile,col.names = niceHeaders)
  
  subjects <- readFile(subjectsFile,col.names = c("Subject"))
  
  activityIDs <- readFile(activityFile,col.names = c("Activity ID"))
  
  untidy <- cbind(subjects,activityIDs,allMetrics)
  
  tidy <- untidy %>%
    inner_join(activityLabels) %>%
    select(Subject,Activity,-Activity.ID,matches("mean|std",ignore.case=TRUE))
  
  tidy
}

test <- readPart("test")
train<- readPart("train")

if(tmpFile != FALSE) unlink(tmpFile)

all <- rbind(test,train)

metricNames <- colnames(all)[3:81]
meanExpressions <- paste(collapse=", ",gsub("(.*)","\"Mean_of_\\1\"=mean(`\\1`)",metricNames))

averages <- eval(parse(text=paste(sep="","summarize(group_by(all,Subject,Activity),",meanExpressions,")")))
