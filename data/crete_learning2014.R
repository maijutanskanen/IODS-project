
mydata <- read.table('http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt', header = TRUE)
head(mydata)
dim(mydata)
str(mydata)

# it's a data with 183 observations and 60 variables


install.packages("dplyr")

library(dplyr)

# questions related to deep, surface and strategic learning
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# deep learning 
deep_columns <- select(mydata, one_of(deep_questions))
mydata$deep <- rowMeans(deep_columns)

# surface learning 
surface_columns <- select(mydata, one_of(surface_questions))
mydata$surf <- rowMeans(surface_columns)

# strategic learning 
strategic_columns <- select(mydata, one_of(strategic_questions))
mydata$stra <- rowMeans(strategic_columns)

#variables in a new dataset
keep_variables <- c("gender", "Age", "Attitude", 
"deep", "stra", "surf", "Points")

#creating a new dataset
mydata_new <- select(mydata, one_of(keep_variables))

mydata_new$Points

# filtering out observations with points = 0
mydata_new <- filter(mydata_new, Points != 0)

#saving analysis data

setwd("/Users/maijutanskanen/IODS-project 8.58.53/data")

write.table(mydata_new, file="learning2014.csv")

#checking if ok

read.table("learning2014.csv")

data1 <- read.table("learning2014.csv")

str(data1)
head(data1)

#scaling attitude (forgot to do earlier)

data1$Attitude <- data1$Attitude / 10

write.table(data1, file="learning2014.csv")

analysis_data <- read.table("learning2014.csv")

head(analysis_data)

#everything ok for analysis

#installing packages

install.packages("ggplot2")
install.packages("GGally")

library(GGally)
library(ggplot2)

#plots and summaries

pairs(analysis_data[-1], col = analysis_data$gender)


p <- ggpairs(analysis_data, mapping = aes(col= gender, alpha = 0.3),
lower = list(combo = wrap("facethist", bins = 20)))

p

summary(analysis_data)

# createting a regression model with multiple explanatory variables
my_model1 <- lm(Points ~ Attitude + Age + deep, data = analysis_data)

my_model2 <- lm(Points ~ Attitude, data = analysis_data)

# printing out a summary of the models
summary(my_model1)
summary(my_model2)

plot(my_model2, which = c(1, 2, 5), par(mfrow = c(2,2)))
