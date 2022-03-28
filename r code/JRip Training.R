pacman::p_load(  # Use p_load function from pacman
  arulesCBA,     # for disc
  RWeka,         # For Ripper Rule Classification
  caret,         # Confusion matrix for predictions
  magrittr,      # Pipes
  pacman,        # Load/unload packages
  rio,           # Import/export data
  tidyverse,     # So many reasons
  dplyr
  #doParallel,   # If using grid, for parallel processing    
  #tictoc        # If training time calculation needed
)

set.seed(1)

# Import
df <- import("data/lcpaper.rds")

# Uncomment if you want to remove features
df <- select(df, -PlaceCode)
#df <- select(df, -PubDate)
#df <- select(df, -Region)

# Discretize
df <- 
  discretizeDF.supervised(  # Function from `arulesCBA`
    y ~ .,                  # Brittle based on rest
    data = df,              # Data source
    method = "chimerge"         # Algorithm to use chi2, chimerge, mdlp
  )

# Training Split
trainIndex <- createDataPartition(df$y, p=.8,
                                  list = FALSE, 
                                  times = 1)

trn <- df[ trainIndex,]
tst <- df[ -trainIndex,]

# fitControl
fitControl <- trainControl(method = "boot",
                           number = 10,
                           summaryFunction = twoClassSummary,
                           classProbs = TRUE,
                           sampling = "smote") 

# Train Model
JRipFit1 <- train(y ~ ., data = trn, 
                  method = "JRip", 
                  metric = "ROC",
                  trControl = fitControl)

JRipFit1

# Test & Confusion Matrix
confusionMatrix(      # Create a confusion matrix
  reference = tst$y,  # True values
  predict(            # Predicted values
    JRipFit1,              # Based on the training model 1
    newdata = tst,    # Use the training data
  )
)


# Test on CSUDH data
tstdh <- import("data/csudhsample.rds")
tstdh <- select(tstdh, -PlaceCode) # remove place code
tstdh <- relocate(tstdh, y, .after = last_col()) #relocate y to match training data for disc
tstdh <- discretizeDF(tstdh, methods = df) #disc using df as breaks

confusionMatrix(      # Create a confusion matrix
  reference = tstdh$y,  # True values
  predict(            # Predicted values
    JRipFit1,              # Based on the training model 1
    newdata = tstdh,    # Use the training data
  )
)

# Test on U-V data
tstuv <- import("data/lcpaperUV.rds")
tstuv <- select(tstuv, -PlaceCode) # remove place code
tstuv <- relocate(tstuv, y, .after = last_col()) # relocate y to match training data for disc
tstuv <- discretizeDF(tstuv, methods = df) # disc using df as breaks
tstuv <- tstuv[complete.cases(tstuv),] # removing missing values

confusionMatrix(      # Create a confusion matrix
  reference = tstuv$y,  # True values
  predict(            # Predicted values
    JRipFit1,              # Based on the training model 1
    newdata = tstuv,    # Use the training data
  )
)
