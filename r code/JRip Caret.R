# disc method matters, currently chimerge works best
# minimal, but noticable performance boost by removing Region
# down sampling improves results due to imbalance of classifiers, need to test other sampling options in the future
#

pacman::p_load(  # Use p_load function from pacman
  arulesCBA,        # for disc
  RWeka,         # For Ripper Rule Classification
  caret,         # Confusion matrix for predictions
  magrittr,      # Pipes
  pacman,        # Load/unload packages
  rio,           # Import/export data
  tidyverse,     # So many reasons
  #plyr,          
  doParallel,
  tictoc
)

# use if training on split data from same sample
# lcpaper <- import("data/lcpaper.rds")
# trainIndex <- createDataPartition(lcpaper$y, p=.8,
#                                   list = FLASE, 
#                                   times = 1)

trn <- import("data/lcpaper.rds")
tst <- import("data/csudhsample.rds")

trn <- select(trn, -Region)
tst <- select(tst, -Region)

####### Grouping and disc

set.seed(1)

# Add group column for future splitting after disc
trn$group <- as.factor("LC")
tst$group <- as.factor("DH")

# rbind for disc
df <- rbind(trn, tst)

#disc
df <- 
  discretizeDF.supervised(  # Function from `arulesCBA`
    y ~ .,                  # Brittle based on rest
    data = df,              # Data source
    method = "chimerge"         # Algorithm to use chi2, chimerge, mdlp
  )

# Splitting on group column for training and testing sample
trn <- as.data.frame(df[!(df$group=="DH"),])
trn <- select(trn, -group)

tst <- as.data.frame(df[!(df$group=="LC"),])
tst <- select(tst, -group)

rm(df)
#########################

## init parallel
numCores <- detectCores()
cl <- makePSOCKcluster(16) #replace # with results from detectCores()
registerDoParallel(cl) #start parallel
####################

set.seed(420)

#length is = (n_repeats*nresampling)+1
seeds <- vector(mode = "list", length = 11)

#(4 is the number of tuning parameter)
for(i in 1:10) seeds[[i]]<- sample.int(n=100000, 25000)

#for the last model
seeds[[11]]<-sample.int(100000, 1)

fitControl <- trainControl(method = "boot",
                           number = 10,   ## 10-fold CV
                           #repeats = 3,   ## Repeated n times
                           #seeds = seeds, ##uncomment for JRIP2 remove ")" and add comma for JRIP2
                           #classProbs = TRUE, ##uncomment for JRIP2
                           #summaryFunction = twoClassSummary,  ##uncomment for JRIP2
                           sampling = "down") 

JRipFit1 <- train(y ~ ., data = trn, 
                 method = "JRip", 
                 trControl = fitControl)

JRipFit1

JRipGrid <- expand.grid(NumOpt = seq(1, 10, 1),
                       NumFolds = 10,
                       MinWeights = 10)

tic("25000 models time:")
JRipFit2 <- train(y ~ ., data = trn, 
                 method = "JRip", 
                 trControl = fitControl, 
                 #verbose = FALSE, 
                 tuneGrid = JRipGrid,
                 metric = "Sens")
toc()
#25000 models took 4.65 hours
#1 model took 19.68 seconds
#10 models took 23.33 seconds

JRipFit2

#JRipFit2 %>% saveRDS("data/JRipFit(ROC).rds")

#whichTwoPct <- tolerance(JRipFit2$results, metric = "ROC", 
#                         tol = 2, maximize = TRUE) 

#JRipFit2$results[whichTwoPct,1:6]
#JRipFit2$finalModel

# Check accuracy of the model on the training data
confusionMatrix(      # Create a confusion matrix
  reference = tst$y,  # True values
  predict(            # Predicted values
    JRipFit1,              # Based on the training model 1
    #JRipFit2$finalModel,              # Based on the training model 2
    newdata = tst,    # Use the training data
  )
)


stopCluster(cl) #stop parallel

