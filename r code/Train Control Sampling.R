pacman::p_load(ROSE, themis)

# Down
fitControl <- trainControl(method = "boot",
                           number = 10,
                           summaryFunction = twoClassSummary,
                           classProbs = TRUE,
                           sampling = "down") 

down_inside <- train(y ~ ., data = trn, 
                  method = "JRip", 
                  metric = "ROC",
                  trControl = fitControl)

# Up
fitControl$sampling <- "up"

up_inside <- train(y ~ ., data = trn, 
                   method = "JRip", 
                   metric = "ROC",
                   trControl = fitControl)

#rose
#fitControl$sampling <- "rose"

#rose_inside <- train(y ~ ., data = trn, 
#                   method = "JRip", 
#                   metric = "ROC",
#                   trControl = fitControl)

#smote
fitControl$sampling <- "smote"

smote_inside <- train(y ~ ., data = trn, 
                   method = "JRip", 
                   metric = "ROC",
                   trControl = fitControl)

#Results
inside_models <- list(original = JRipFit1,
                      down = down_inside,
                      up = up_inside,
                      SMOTE = smote_inside)
                      #ROSE = rose_inside)

inside_resampling <- resamples(inside_models)

inside_test <- lapply(inside_models, test_roc, data = imbal_test)
inside_test <- lapply(inside_test, as.vector)
inside_test <- do.call("rbind", inside_test)
colnames(inside_test) <- c("lower", "ROC", "upper")
inside_test <- as.data.frame(inside_test)

summary(inside_resampling, metric = "ROC")