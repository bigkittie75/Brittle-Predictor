pacman::p_load(  # Use p_load function from pacman
  arulesCBA,        # for disc
  RWeka,         # For Ripper Rule Classification
  caret,         # Confusion matrix for predictions
  magrittr,      # Pipes
  pacman,        # Load/unload packages
  rio,           # Import/export data
  tidyverse,     # So many reasons
  #plyr,          
  doParallel     
)

# use if training on split data from same sample
# lcpaper <- import("data/lcpaper.rds")
# trainIndex <- createDataPartition(lcpaper$y, p=.8,
#                                   list = FLASE, 
#                                   times = 1)

trn <- import("data/lcpaper.rds")
tst <- import("data/csudhsample.rds")

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
    method = "mdlp"         # Algorithm to use
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
cl <- makePSOCKcluster(8) #replace # with results from detectCores()
registerDoParallel(cl) #start parallel
####################

set.seed(420)

#length is = (n_repeats*nresampling)+1
seeds <- vector(mode = "list", length = 11)

#(4 is the number of tuning parameter)
for(i in 1:10) seeds[[i]]<- sample.int(n=1000, 75)

#for the last model
seeds[[11]]<-sample.int(1000, 1)

fitControl <- trainControl(method = "repeatedcv",
                           number = 10,   ## 10-fold CV
                           repeats = 1,   ## Repeated n times
                           seeds = seeds,
                           classProbs = TRUE,
                           summaryFunction = twoClassSummary)  

JRipFit1 <- train(y ~ ., data = trn, 
                 method = "JRip", 
                 trControl = fitControl)

JRipFit1

JRipGrid <- expand.grid(NumOpt = seq(1, 5, 1),
                       NumFolds = seq(2, 4, 1),
                       MinWeights = seq(1, 5, 1))

JRipFit2 <- train(y ~ ., data = trn, 
                 method = "JRip", 
                 trControl = fitControl, 
                 #verbose = FALSE, 
                 tuneGrid = JRipGrid,
                 metric = "ROC")

JRipFit2

whichTwoPct <- tolerance(JRipFit2$results, metric = "Sens", 
                         tol = 2, maximize = TRUE) 

JRipFit2$results[whichTwoPct,1:6]
JRipFit2$finalModel

# Check accuracy of the model on the training data
confusionMatrix(      # Create a confusion matrix
  reference = tst$y,  # True values
  predict(            # Predicted values
    #JRipFit1,              # Based on the training model 1
    JRipFit2$finalModel,              # Based on the training model 2
    newdata = tst,    # Use the training data
    type = 'class'
  )
)


stopCluster(cl) #stop parallel

