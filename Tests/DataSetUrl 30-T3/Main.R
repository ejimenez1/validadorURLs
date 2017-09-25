library(tm)
library(MASS)
library(ISLR)

source("Util.R")


# ---- 1 - Load Training Set ---------------

# load tokens from csv (term dictonary)
TrainingSet <- read.csv('TrainingSet_1.csv')
# remove X column
TrainingSet$X <- NULL

# load validation set
ValidationSet <- read.csv('ValidationSet_2.csv')
# remove X column
ValidationSet$X <- NULL

# ---- Build Logit Model ---------------

# Create a Logistic regression model and exclude X
glm.fit = glm(V1 ~. , data = TrainingSet, family = binomial)
#summary(glm.fit)

# create a dummy entry
dic <- getDictionary()
n <- length(dic$token)

# Test Prediction
# mal_url <-"want to have sex, call rightnow"
#features <- urlFeatures(processUrl(tokenizer(mal_url, G_TOKEN_SIZE), dic),n)
#df <- data.frame(matrix(ncol = n, nrow = 1))
#colnames(df) <- colnames(TrainingSet[,2:ncol(TrainingSet)])
#df[1,] = features


#### Training Set Accuracy (83%)
pt <- predict(glm.fit, newdata = TrainingSet,  type="response")
pt[pt >= 0.5] = 1
pt[pt < 0.5] = 0

training_acc <- TrainingSet$V1 - pt
training_acc <- length(training_acc[training_acc == 0]) / nrow(TrainingSet) 

#### Validation Set Accuracy (82%)
pv <- predict(glm.fit, newdata = ValidationSet,  type="response")
pv[pv >= 0.5] = 1
pv[pv < 0.5] = 0

validation_acc <- ValidationSet$V1 - pv
validation_acc <- length(validation_acc[validation_acc == 0]) / nrow(ValidationSet) 



