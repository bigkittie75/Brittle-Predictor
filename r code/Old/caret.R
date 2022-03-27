pacman::p_load(  # Use p_load function from pacman
  arulesCBA,     # Classification Based on Association
  caret,         # Confusion matrix for predictions
  magrittr,      # Pipes
  pacman,        # Load/unload packages
  rio,           # Import/export data
  tidyverse,     # So many reasons
  plyr,
  tictoc,        #for counting time
  supervisedPRIM,# Classification model
  foreach,
  doParallel
)

# use if training on split data from same sample
# lcpaper <- import("data/lcpaper.rds")
# trainIndex <- createDataPartition(lcpaper$y, p=.8,
#                                   list = FLASE, 
#                                   times = 1)

trn <- import("data/lcpaper.rds")
tst <- import("data/csudhsample.rds")

numCores <- 16
cl <- makePSOCKcluster(numCores)
registerDoParallel(cl) #start parallel

fitControl <- trainControl(method = "repeatedcv",
                           number = 10,   ## 10-fold CV
                           repeats = 3)  ## repeated ten times

set.seed(69)

tic("training time")
rrfFit1 <- train(y ~ ., data = trn, 
                 method = "PRIM", 
                 trControl = fitControl)
toc()

rrfGrid <- expand.grid(peel.alpha = 2,
                       paste.alpha = 8,
                       mass.min = seq(0.65, 0.75, 0.01))

rrfFit2 <- train(y ~ ., data = trn, 
                 method = "RRF", 
                 trControl = fitControl, 
                 verbose = FALSE, 
                 tuneGrid = rrfGrid)


stopCluster(cl) #stop parallel

