library(dplyr)
library(tidyverse)
library(caret)

churn <- read.csv("churn.csv")
tibble(churn)

# Change to factor
churn$churn <- factor(churn$churn)

## 1. split data
set.seed(42)
n <- nrow(churn)
train_id <- sample(1:n, size = 0.8*n)
train_df <- churn[train_id, ]
test_df <- churn[-train_id, ]

## 2. train model
set.seed(42)

ctrl <- trainControl(method="cv",
                     number=5,
                     summaryFunction = prSummary,
                     classProbs = TRUE)

logis_model <- train(churn ~ .,
                     data = train_df,
                     method = "glm",
                     metric = "AUC",
                     trControl = ctrl)

## 3. score model
predict_logis <- predict(logis_model, newdata = test_df)

## 4. evaluate model
mean(predict_logis == test_df$churn)

## confusion matrix
con_logis <- confusionMatrix(predict_logis,
                test_df$churn,
                positive="Yes",
                mode="prec_recall")

table(test_df$churn, predict_logis, dnn=c("actual", "predict"))

## knn
set.seed(42)
knn_model <- train(churn ~ .,
                   data = train_df,
                   method = "knn",
                   metric = "AUC",
                   trControl = ctrl,
                   tuneLength = 4)

predict_knn <- predict(knn_model, newdata = test_df)

con_knn <- confusionMatrix(predict_knn,
                          test_df$churn,
                          positive="Yes",
                          mode="prec_recall")


## min max scaling [0, 1]
transformer <- preProcess(train_df,
                          method=c("range"))

train_df_z <- predict(transformer, train_df)
test_df_z <- predict(transformer, test_df)
