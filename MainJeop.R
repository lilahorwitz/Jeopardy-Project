#clear environment and load necessary packages
#set wd in console where Rproj and .csv data are located
rm(list = ls())
library(tidyverse)
library(tokenizers)
library(tm)
library(quanteda)
library(quanteda.textplots)
library(stm)
library(seededlda)
library(lubridate)
library(here)

#load metadata
metadata2<- read_csv("jeopardy2.csv")

#create new numeric date variable
metadata2$numericdate <- as.numeric(as.Date(metadata2$`Air Date`, format = "%Y-%m-%d"))

#reduce data to January 1, 2000 and after 
jan1<-as.numeric(as.Date("2000-01-01", format = "%Y-%m-%d"))
metadata1 <- subset(metadata2,metadata2$numericdate>=10957)

#create new date and year variables
metadata1$date <- as.Date(metadata1$`Air Date`, format = "%Y-%m-%d")
metadata1$year <-year(metadata1$date)
metadata1

#sort by year 
metadata <- metadata1[order(metadata1$year), ]
metadata

#election years
beg2000<-as.numeric(as.Date("2000-01-01", format = "%Y-%m-%d"))
end2000<-as.numeric(as.Date("2000-12-31", format = "%Y-%m-%d"))
beg2004<-as.numeric(as.Date("2004-01-01", format = "%Y-%m-%d"))
end2004<-as.numeric(as.Date("2004-12-31", format = "%Y-%m-%d"))
beg2008<-as.numeric(as.Date("2008-01-01", format = "%Y-%m-%d"))
end2008<-as.numeric(as.Date("2008-12-31", format = "%Y-%m-%d"))
beg2012<-as.numeric(as.Date("2012-01-01", format = "%Y-%m-%d"))
end2012<-as.numeric(as.Date("2012-12-31", format = "%Y-%m-%d"))

#new variable that denotes whether Question was used during an election year
metadata$elyear <- ifelse(metadata$numericdate>=beg2000&metadata$numericdate<=end2000 | metadata$numericdate>=beg2004&metadata$numericdate<=end2004 |metadata$numericdate>=beg2008&metadata$numericdate<=end2008 |metadata$numericdate>=beg2012&metadata$numericdate<=end2012,"Yes","No")
metadata$elyearnum <- ifelse(metadata$elyear=="Yes", 1, 0)
metadata

#Process the data to put it in STM textProcessor
temp <- textProcessor(documents = metadata$Question, metadata = metadata,)

# prepDocuments 
out <- prepDocuments(temp$documents, temp$vocab, temp$meta)

#STM model, add max.em.its = no_of_iterations_desired to test model 
model.stm <- stm(out$documents, out$vocab, K = 10, prevalence = ~elyear + s(year),
                 data = out$meta, max.em.its =2 ) 

#labelTopics
labelTopics(model.stm)

#just for my own visualization
plot(model.stm, n=10)

#labelTopics and findThoughts for each topic ????
labelTopics(model.stm, topics=1, n=10) #geography
findThoughts(model.stm, texts=out$meta$Question, topics=1, n=5)
labelTopics(model.stm, topics=2, n=10) #food
findThoughts(model.stm, texts=out$meta$Question, topics=2, n=14)
labelTopics(model.stm, topics=3, n=10) #innovation
findThoughts(model.stm, texts=out$meta$Question, topics=3, n=10)
labelTopics(model.stm, topics=4, n=10) #history/rulers
findThoughts(model.stm, texts=out$meta$Question, topics=4, n=10)
labelTopics(model.stm, topics=5, n=10) #images
findThoughts(model.stm, texts=out$meta$Question, topics=5, n=10)
labelTopics(model.stm, topics=6, n=10) #culture
findThoughts(model.stm, texts=out$meta$Question, topics=6, n=18)
labelTopics(model.stm, topics=7, n=10) #fictional characters
findThoughts(model.stm, texts=out$meta$Question, topics=7, n=14)
labelTopics(model.stm, topics=8, n=10) #politics/ political questions
findThoughts(model.stm, texts=out$meta$Question, topics=8, n=10)
labelTopics(model.stm, topics=9, n=10) #famous works// 
findThoughts(model.stm, texts=out$meta$Question, topics=9, n=10)
labelTopics(model.stm, topics=10, n=10) #science
findThoughts(model.stm, texts=out$meta$Question, topics=10, n=10)


#estimateEffect & plot difference 
model.stm.ee <- estimateEffect(1:10 ~ elyear + s(year), model.stm, meta = out$meta)

#plot difference between topics by election years vs non-election years
plot(model.stm.ee, "elyear", method="difference", cov.value1="Yes", cov.value2="No")
#plot prevalence of topics over years by topic
plot(model.stm.ee, "year", method="continuous", topics=3)
plot(model.stm.ee, "year", method="continuous", topics=5)
plot(model.stm.ee, "year", method="continuous", topics=7)
plot(model.stm.ee, "year", method="continuous", topics=10)

#political topic throughout the years
plot(model.stm.ee, "year", method="continuous", topics=8, xlab = "Year", main = "Expected Proportion of Political Questions")
#beginning of election year
abline(v = c(2000, 2004, 2008, 2012), col = "blue", lty = "dashed")
#end of election year
abline(v = c(2001, 2005, 2009), col = "darkblue", lty = "dashed")
