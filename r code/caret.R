pacman::p_load(  # Use p_load function from pacman
  arulesCBA,     # Classification Based on Association
  caret,         # Confusion matrix for predictions
  magrittr,      # Pipes
  pacman,        # Load/unload packages
  rio,           # Import/export data
  tidyverse,     # So many reasons
  plyr,          # Classification model
  doParallel     
)

# use if training on split data from same sample
# lcpaper <- import("data/lcpaper.rds")
# trainIndex <- createDataPartition(lcpaper$y, p=.8,
#                                   list = FLASE, 
#                                   times = 1)

trn <- import("data/lcpaper.rds")
tst <- import("data/csudhsample.rds")

numCores <- detectCores()
registerDoParallel(numCores) #start parallel

fitControl <- trainControl(method = "repeatedcv",
                           number = 10,   ## 10-fold CV
                           repeats = 10)  ## repeated ten times

set.seed(69)
rrfFit1 <- train(y ~ ., data = trn, 
                 method = "JRip", 
                 trControl = fitControl)

rrfGrid <- expand.grid(mtry = 2,
                       coefReg = 8,
                       coefImp = seq(0.65, 0.75, 0.01))

rrfFit2 <- train(y ~ ., data = trn, 
                 method = "RRF", 
                 trControl = fitControl, 
                 verbose = FALSE, 
                 tuneGrid = rrfGrid)


stopCluster(cl) #stop parallel

