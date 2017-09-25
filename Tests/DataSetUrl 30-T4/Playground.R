source("Util.R")

# ----- Single URL Feature Extraction -----------

dic <- getDictionary()

# ----------- Dictionary Tag Cloud --------------------

# load tokens from csv (term dictonary)
frequencyMat2 <- read.csv('Dictionary.csv')
colnames(frequencyMat2) <- c("token","count")

# display word cloud (visualization of harmful tokens)
words <- frequencyMat2$token
count <- frequencyMat2$count
wordcloud(words[1:100], count[1:100])