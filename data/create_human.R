## Maiju Tanskanen
## Data Wrangling Exercise 16.2.2017

# downloading the datasets
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

# exploring the data
str(hd)
str(gii)
dim(hd)
dim(gii)
summary(hd)
summary(gii)

#renaming variables

colnames(hd) <- c("rankhdi", "country", "hdi", "life", "expedu", "meanedu", "gni", "gnihdi")

colnames(gii) <- c("rankgii", "country", "gii", "matmort", "adobirth", "parliament", "seceduf", "secedum", "labourf", "labourm")

#counting new variables and adding them to the data
eduratio <- (gii$seceduf/gii$secedum)
labourratio <- (gii$labourf/gii$labourm)

gii$eduratio <- eduratio
gii$labourratio <- labourratio

join_by <- c("country")

# joining the two datasets by country
human <- inner_join(hd, gii, by = join_by)

#saving the dataset

setwd("/Users/maijutanskanen/IODS-project 8.58.53/data")
write.table(human, file = "human.csv", sep = ";", row.names = FALSE)

