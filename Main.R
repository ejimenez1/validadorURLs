library(tm)
library(MASS)
library(ISLR)

source("Util.R")


# ---- 1 - Load Training Set ---------------

# load tokens from csv (term dictonary)
TrainingSet <- read.csv('TrainingSet.csv')
# dim(TrainingSet)
# dim(data)

# ---- Build Logit Model ---------------

# Create a Logistic regression model and exclude X
glm.fit = glm(V1 ~. -X  , data = TrainingSet, family = binomial)
summary(glm.fit)

# create a dummy entry
# raw URL
mal_url <-"want to have sex, call rightnow"
# get url tokens
url_tokens <- tokenizer(mal_url, 3)
# tokens indexes
idx <- processUrl(url_tokens, dic)
# number of elements in dictionary
n <- length(dic$token)
# binary feature array
feature_array <- urlFeatures(idx, n) 

predict(glm.fit, feature_array,  type="response")

TrainingSet[1:10,1:4]



