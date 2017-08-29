# ----- 1 - Load Dictionary -----------

dic <- getDictionary()

# ---- 2 - Build Training Set ---------------

# 2.1 read data from source
data <- read.csv("DataSetRaw.csv", stringsAsFactors = FALSE)
colnames(data) <- c("y","url")

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
write.csv(ds, 'TrainingSet.csv')

# The training set has been created from the DataSetRaw.csv this can now be used
# to create predictions with an R-based algorithms such as Logistic Regression
# with glm
