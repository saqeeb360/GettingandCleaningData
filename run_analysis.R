



# Reading X_test file
con_test <- file("./UCI HAR Dataset/test/X_test.txt")
txt_test <- readLines(con_test ,encoding = "UTF-8")
close(con_test)

#Removing multiple spaces in the text
txt_test <- gsub("  "," ",txt_test)
txt_test <- gsub("^ ","",txt_test)

#spliting into list
list_test <- strsplit(txt_test," ")
list_test <- lapply(list_test, as.numeric)

#Storing it into dataframe
df_test <- data.frame(matrix(unlist(list_test),byrow = T,nrow= length(list_test)),stringsAsFactors = F)

#Reading feature names
cnam <- read.delim("./UCI HAR Dataset/features.txt", sep = " ",header = F,stringsAsFactors = F)
cnam <- cnam$V2

#Assigning column names
colnames(df_test) <- cnam


#str(df_test[,1:4])
#summary(df_test[,1:4])
# any(is.na(df_test))

#--------------------------------------------#

# Reading X_train
con_train <- file("./UCI HAR Dataset/train/X_train.txt")
txt_train <- readLines(con_train ,encoding = "UTF-8")
close(con_train)

#Removing multiple spaces in the text
txt_train <- gsub("  "," ",txt_train)
txt_train <- gsub("^ ","",txt_train)

#spliting into list
list_train <- strsplit(txt_train," ")
list_train <- lapply(list_train, as.numeric)

#Storing it into dataframe
df_train <- data.frame(matrix(unlist(list_train),byrow = T,nrow= length(list_train)),stringsAsFactors = F)

#Assigning column names
colnames(df_train) <- cnam

# str(df_train[,1:4])
# summary(df_train[,1:4])


#--------------------------------------------#

# Combining the dataframes df_train,df_test
df <- rbind(df_train,df_test)
#str(df[,1:4])
#summary(df[,1:4])

#--------------------------------------------#

# Filtering the dataframe df on the basis of column mean and std
filter.name <- grep("mean..-.|std..-.", cnam, value = T)
df.filtered <- df[,filter.name]

#--------------------------------------------#

# Reading Subject file
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject <- rbind(subject_train,subject_test)

#--------------------------------------------#

# Reading Activity file
activity_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
activity <- rbind(activity_train,activity_test)
activity$V1 <- factor(activity$V1, labels = c("WALKING", "WALKING_UPSTAIRS", "WALKING_DOWNSTAIRS", "SITTING", "STANDING", "LAYING"))
activity[1:5,]

#--------------------------------------------#

# Removing useless objects
remove(activity_test,activity_train,subject_test,subject_train,df_test,df_train,df,list_test,list_train)

#--------------------------------------------#

# Adding activity and subject column to the dataframe df
df.filtered$activityLabel <- activity$V1
df.filtered$subject <- subject$V1

#--------------------------------------------#

# Creating a tidy dataset with mean values for each subject and activity
df.melt <- melt(df.filtered, id = c('activityLabel', 'subject'), measure.vars = filter.name)
df.tidy <- dcast(df.melt, activityLabel + subject ~ variable, mean)

#--------------------------------------------#

#creating a tidy dataset file  
write.table(df.tidy, file = "tidydataset.txt" ,row.names = FALSE)

#--------------------------------------------#















