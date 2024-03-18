library(dplyr)
library(tidyverse)
library(caret)

churn <- read.csv("churn.csv")

head(churn)

# Change to factor
churn$churn <- factor(churn$churn)

## 1. split data
train_test_split <- function(data, size=0.8) {
  set.seed(42)
  n <- nrow(data)
  train_id <- sample(1:n, size*n)
  train_df <- data[train_id, ]
  test_df <- data[-train_id, ]
  return( list(train_df, test_df) )
}

prep_df <- train_test_split(churn, size=0.8)

## 2. train model
## cv stands for K-Fold CV
ctrl <- trainControl(method = "cv",
                     number = 10)

model <- train(churn ~ internationalplan + voicemailplan + accountlength + numbercustomerservicecalls,
               data = prep_df[[1]],
               method = "glm",
               trControl = ctrl)

## 3. score model
pred_churn <- predict(model, newdata = prep_df[[2]])

## 4. evaluate model
actual_churn <- prep_df[[2]]$churn

conf <- confusionMatrix(pred_churn, actual_churn)
