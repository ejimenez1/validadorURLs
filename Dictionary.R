#install.packages("tm")
#install.packages("wordcloud")

library(tm)
library(wordcloud)
library(MASS)

source("Util.R")

setwd("C:/Users/R2D2/Desktop/DataSetUrl")

# guarantee same sample
set.seed(2017)

# read data from source
data <- read.csv("DataSetRaw.csv", stringsAsFactors = FALSE)
colnames(data) <- c("y","url")

# 50% of dataset will be used as generate dictionary (Training Set Equivalent)
data <- data[sample(nrow(data)),]
data <- data[1:2499];

# get list of malicious URLs
malicious_urls = subset(data, data$y == "1")

# combine all URLs in a single text chunk
url_text <- paste(malicious_urls$url, collapse = " ")

# URL text tokenization (n-word elements tokens)
url_text_tokenized = tokenizer(url_text, G_TOKEN_SIZE)

# source & corpus
url_source <- VectorSource(url_text_tokenized)
corpus <- Corpus(url_source)

# URL text cleaning
corpus <- tm_map(corpus, content_transformer(tolower))
corpus <- tm_map(corpus, removePunctuation)
corpus <- tm_map(corpus, stripWhitespace)
corpus <- tm_map(corpus, removeWords, c("com", "www", "post", "org", "html", "net", stopwords("english")))

# create document-term matrix
dtm <- DocumentTermMatrix(corpus)
dtm2 <- as.matrix(dtm)

# find most frequent terms
frequency <- colSums(dtm2)
frequency <- sort(frequency, decreasing = TRUE)

# persist frequency table to CSV
frequencyMat <- as.matrix(frequency)

# tunning (just add to dictionary those words with +30)
frequencyMat <- frequencyMat[frequencyMat[,1] > 30,]

write.csv(frequencyMat, 'Dictionary.csv')

# This script generates Dictionary.csv which is 
# the entry point for Main.R. The dictionary just
# needs to be generated once, this file is only 
# used to create the dictionaty csv

# ---------------------------------------------

























