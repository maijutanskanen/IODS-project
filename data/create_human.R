## Maiju Tanskanen
## Data Wrangling Exercise 16.2.2017 & 23.2.2017

# PART 1
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

# PART 2

human <- read.csv(file = "human.csv", sep = ";", header = TRUE)

# string manipulation; factor variable into numeric

human$gni <- str_replace(human$gni, pattern=",", replace ="")%>%as.numeric

# keeping only 9 variables in the data
keep <- c("country", "eduratio", "labourratio", "life", "expedu", "gni", "matmort", "adobirth", "parliament")
human <- select(human, one_of(keep))


# filtering out cases with missing values

complete.cases(human)

data.frame(human[-1], comp = complete.cases(human))

human_ <- filter(human, complete.cases(human) == TRUE)

# deleting cases that are not countries but larger areas
tail(human_, 10)

last <- nrow(human_) - 155

human_ <- human_[1:155, ]

# add countries as rownames and saving the data
rownames(human_) <- human_$country
human_ <- select(human_, -country)

write.table(human_, file = "human.csv", sep = ";", row.names = TRUE)

