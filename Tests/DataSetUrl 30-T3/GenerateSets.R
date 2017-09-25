source("Util.R")

# ----- 1 - Load Dictionary -----------

dic <- getDictionary()

# ---- 2 - Build Training Set ---------------

# guarantee same sample
set.seed(2017)

# 2.1 read data from source
data <- read.csv("DataSetRaw.csv", stringsAsFactors = FALSE)
colnames(data) <- c("y","url")

# data contains 4998 rows
data <- data[sample(nrow(data)),]

# number of elements in dictionary
n <- length(dic$token)

# 2.2 create matrix with binary features from dataset
ds <- matrix(0, nrow=nrow(data), ncol=length(dic$token)+1)
for(i in 1:nrow(data))
{
  row <- data[i,]
  y <- row$y
  url_txt <- row$url
  features <- urlFeatures(processUrl(tokenizer(url_txt, G_TOKEN_SIZE), dic),n)
  ds[i,] <- c(y, features)
}

# 3.3 save matrix in CSV
# Training Set Size = 50% * 4998 = 2499
write.csv(ds[1:2499,], 'TrainingSet_1.csv')

# Validation Set Size = 25% * 4998 = round(4998 * 0.25) = 1250
write.csv(ds[2500:3750,], 'ValidationSet_2.csv')

# Test Set Size 25% * 4998 = 1248
write.csv(ds[3751:4998,], 'TestSet_3.csv')

# The training set has been created from the DataSetRaw.csv this can now be used
# to create predictions with an R-based algorithms such as Logistic Regression
# with glm or SVM


