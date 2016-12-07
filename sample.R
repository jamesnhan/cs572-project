#!/usr/bin/env Rscript


# load the 1071 library containing vm
library("e1071")

# preview the data set
head(iris, 5)
attach(iris)
x <- subset(iris, select=-Species)
y <- Species

# using svm to get the model
svm_model <- svm(Species ~ ., data=iris)
summary(svm_model)

# another way to get the model
svm_model1 <- svm(x,y)
summary(svm_model1)

# predict using the same data
pred <- predict(svm_model1,x)
system.time(pred <- predict(svm_model1,x))

# table will give the precision and recall
table(pred,y)

error <- y - pred
svrPredictionRMSE <- rmse(error)


# using the "tune" function to automatic select the best using cross validation
svm_tune <- tune(svm, train.x=x, train.y=y, 
              kernel="radial", ranges=list(cost=10^(-1:2), gamma=c(.5,1,2)))
print(svm_tune)

## use the cost and gamma parameter got from tune,
## re-generate the model
svm_model_after_tune <-
    svm(Species ~ ., data=iris, kernel="radial", cost=1, gamma=0.5)
summary(svm_model_after_tune)

# re-run the prediction
pred <- predict(svm_model_after_tune,x)
system.time(predict(svm_model_after_tune,x))
# see the result
table(pred,y)




# load the libraries
library(caret)
library(klaR)
# load the iris dataset
data(iris)
# define an 80%/20% train/test split of the dataset
split=0.80
trainIndex <- createDataPartition(iris$Species, p=split, list=FALSE)
data_train <- iris[ trainIndex,]
data_test <- iris[-trainIndex,]
# train a naive bayes model
model <- NaiveBayes(Species~., data=data_train)
# make predictions
x_test <- data_test[,1:4]
y_test <- data_test[,5]
predictions <- predict(model, x_test)
# summarize results
confusionMatrix(predictions$class, y_test)
