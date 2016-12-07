#!/usr/bin/env Rscript

library(e1071)
library(arules)
library(discretization)
library(party)
library(caret)

df <- read.csv("whole.csv")
# removing the "key" column. All other columns should be numeric
df <- df[-1]
df <- na.omit(df)
## df <- subset(df, select=-fork)



##############################
## Linear Regression
##############################
subdf <- df[df$star<1000,]

# linear model, I'm interested in getting the p-values
lmodel <- lm(star~., data=subdf)
pred <- predict(lmodel, subdf[-1])
plot(pred, subdf$star)


# but how do I get a measure of the precision?

## using the fork along
lmodel <- lm(star~fork, data=subdf)
pred <- predict(lmodel, subdf)
plot(pred, subdf$star)


## now we limit the star to be less than 2000
subdf <- df[df$star<1000,]
## and normalize the data
## df <- scale(df)
# we also want to discretize the response to be categori
subdf$star <- discretize(subdf$star, categories = 3)

svm_model <- svm(star ~ ., data=subdf, cross=10)
summary(svm_model)
## predict(svm_model, subset(subdf, select=-star))
pred <- predict(svm_model, subdf)
## pred <- predict(svm_model, newdata = subdf[!rowSums(is.na(subdf)), ])
table(pred, subdf$star)
plot(pred, subdf$star)

##############################
## saving the star distribution graph
##############################
subdf <- df[df$star<4000,]
png("star-hist.png")
hist(subdf$star, main="Data set visualization", xlab="star")
dev.off()

##############################
## Table 1: different discretiz
##############################
## res <- data.frame(c(), c(), row.names=c("cate", "accuracy"))
cate <- c()
accuracy <- c()
## names(cate) <- "cate"
## names(accu) <- "accuracy"
for (cat in 2:10) {
    subdf <- df[df$star<4000,]
    ## subdf <- df
    subdf$star <- discretize(subdf$star, categories = cat)
    svm_model <- svm(star ~ ., data=subdf, cross=10)
    print(summary(svm_model)$tot.accuracy)
    cate <- c(cate, cat)
    accuracy <- c(accuracy, summary(svm_model)$tot.accuracy)
    ## pred <- predict(svm_model, subdf)
    ## print(table(pred, subdf$star))
}
res <- data.frame(cate, accuracy)
write.csv(res, file="res-cate.csv")

##############################
## Table 1.5: different discretiz and kernels
##############################
## res <- data.frame(c(), c(), row.names=c("cate", "accuracy"))
## cate <- c()
## accuracy <- c()
## names(cate) <- "cate"
## names(accu) <- "accuracy"
res <- data.frame(2:10)
for (k in c("linear", "polynomial", "radial", "sigmoid")) {
    accuracy <- c()
    for (cat in 2:10) {
        subdf <- df[df$star<4000,]
        ## subdf <- df
        subdf$star <- discretize(subdf$star, categories = cat)
        svm_model <- svm(star ~ ., data=subdf, cross=10, kernel=k)
        print(summary(svm_model)$tot.accuracy)
        accuracy <- c(accuracy, summary(svm_model)$tot.accuracy)
    }
    res[k] <- accuracy
}
## res <- data.frame(cate, accuracy)
write.csv(res, file="res-kernels.csv")


##############################
## table 2: different range
##############################

## 3 cate
lows <- c()
highs <- c()
num <- c()
accuracy <- c()
for (i in 0:4) {
    low <- i*500
    high <- (i+1)*500
    lows <- c(lows, low)
    highs <- c(highs, high)
    subdf <- df[df$star>low & df$star<high,]
    ## print(dim(subdf))
    num <- c(num, dim(subdf)[[1]])
    ## subdf <- df
    subdf$star <- discretize(subdf$star, categories = 3)
    svm_model <- svm(star ~ ., data=subdf, cross=10)
    print(summary(svm_model)$tot.accuracy)
    cate <- c(cate, cat)
    accuracy <- c(accuracy, summary(svm_model)$tot.accuracy)
}
res <- data.frame(lows, highs, num, accuracy)
write.csv(res, file="res-range.csv")


##############################
## Table 3: different model
##############################

##############################
## Table 4: different language
##############################

res <- data.frame(2:10)
for (file in c("c.csv", "php.csv",
               "java.csv", "javascript.csv",
               "shell.csv", "ruby.csv", "python.csv")) {
    print(file)
    newdf <- read.csv(file)
    ## removing the "key" column. All other columns should be numeric
    newdf <- newdf[-1]
    newdf <- na.omit(newdf)
    accuracy <- c()
    for (cat in 2:10) {
        ## this might need to adjust
        subdf <- newdf[newdf$star<4000,]
        ## subdf <- df
        subdf$star <- discretize(subdf$star, categories = cat)
        svm_model <- svm(star ~ ., data=subdf, cross=10)
        print(summary(svm_model)$tot.accuracy)
        accuracy <- c(accuracy, summary(svm_model)$tot.accuracy)
    }
    res[file] <- accuracy
}
## res <- data.frame(cate, accuracy)
write.csv(res, file="res-lang.csv")


## svm_model <- svm(star ~ fork, kernel="linear", data=subdf, cross=10)
## summary(svm_model)

## decision tree model

ctmodel <- ctree(star~., data=subdf)
pred <- predict(ctmodel, subdf)
confusionMatrix(pred, subdf$star)

table(pred, subdf$star)


plot(subdf$star, subdf$fork)



## x <- subset(df, select=-star)

## pred <- predict(svm_model,x)
## system.time(pred <- predict(svm_model,x))
## table(pred,y)

## x <- subset(df, select=-star)
## y <- df$star
## svm_model1 <- svm(x,y)
## summary(svm_model1)


## sqrt(mean((y-pred)^2))
