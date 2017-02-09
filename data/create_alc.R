# Maiju Tanskanen
# 9.2.2017
# data from:
# https://archive.ics.uci.edu/ml/machine-learning-databases/00356/

# setting working directory
setwd("/Users/maijutanskanen/IODS-project 8.58.53/data")

# reading datas
math <- read.table("student-mat.csv", sep = ";", header = TRUE)
por <- read.table("student-por.csv", sep = ";", header = TRUE)

#exploring datas
dim(math)
dim(por)

str(math)
str(por)

# access the dplyr library
library(dplyr)

# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# join the two datasets by the selected identifiers
math_por <- inner_join(math, por, by = join_by, suffix = c(".math", ".por"))

# see the new column names
colnames(math_por)

# glimpse at the data
glimpse(math_por)

# print out the column names of 'math_por'
colnames(math_por)

join_by

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))

# the columns in the datasets which were not used for joining the data
notjoined_columns <- colnames(math)[!colnames(math) %in% join_by]

# print out the columns not used for joining
notjoined_columns

# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse at the new combined data

glimpse(alc)

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define a new logical column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

#checking if ok

dim(alc)

head(alc)

write.table(alc, file = "alcoholdata.csv", sep = ";", row.names = FALSE)

alc <- read.table("alcoholdata.csv", sep = ";", header = TRUE)
