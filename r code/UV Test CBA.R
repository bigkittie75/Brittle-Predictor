# Install and/or load packages with pacman
pacman::p_load(  # Use p_load function from pacman
  arulesCBA,     # Classification Based on Association
  caret,         # Confusion matrix for predictions
  magrittr,      # Pipes
  pacman,        # Load/unload packages
  rio,           # Import/export data
  tidyverse      # So many reasons
)

# LOAD AND PREPARE DATA ####################################

# Set random seed for reproducibility in processes like
# splitting the data. You can use any number.
set.seed(1)

# Import pre-processed data
trn <- import("data/lcpaper.rds")
tst <- import("data/lcpaperUV.rds")

# Add group column for future splitting after disc
trn$group <- as.factor("F")
tst$group <- as.factor("UV")

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
trn <- as.data.frame(df[!(df$group=="UV"),])
trn <- select(trn, -group)

tst <- as.data.frame(df[!(df$group=="F"),])
tst <- select(tst, -group)

# MODEL DATA ###############################################

# Create a CBA model using `CBA` from `arulesCBA`
fit <- CBA(
  y ~ .,      
  data = trn)

# Check accuracy of the model on the training data
confusionMatrix(      # Create a confusion matrix
  reference = trn$y,  # True values
  predict(            # Predicted values
    fit,              # Based on the training model
    newdata = trn     # Use the training data
  )
)

### Accuracy #######################################
#Confusion Matrix and Statistics

#Reference
#Prediction   Brittle NotBrittle
#Brittle         89         69
#NotBrittle      71        925

#Accuracy : 0.8787         
#95% CI : (0.8584, 0.897)
#No Information Rate : 0.8614         
#P-Value [Acc > NIR] : 0.04644        

#Kappa : 0.4894         

#Mcnemar's Test P-Value : 0.93265        
                                         
#            Sensitivity : 0.55625        
#            Specificity : 0.93058        
#         Pos Pred Value : 0.56329        
#         Neg Pred Value : 0.92871        
#             Prevalence : 0.13865        
#         Detection Rate : 0.07712        
#   Detection Prevalence : 0.13692        
#      Balanced Accuracy : 0.74342        
                                         
#       'Positive' Class : Brittle

# Check accuracy of the model on the testing data
confusionMatrix(      # Create a confusion matrix
  reference = tst$y,  # True values
  predict(            # Predicted values
    fit,              # Based on the training model
    newdata = tst     # Use the testing data
  )
)
### Accuracy #######################################
#Reference
#Prediction   Brittle NotBrittle
#Brittle         11         25
#NotBrittle      38        253

#Accuracy : 0.8073          
#95% CI : (0.7604, 0.8487)
#No Information Rate : 0.8502          
#P-Value [Acc > NIR] : 0.9855          

#Kappa : 0.1511          

#Mcnemar's Test P-Value : 0.1306          
                                          
#            Sensitivity : 0.22449         
#            Specificity : 0.91007         
#         Pos Pred Value : 0.30556         
#         Neg Pred Value : 0.86942         
#             Prevalence : 0.14985         
#         Detection Rate : 0.03364         
#   Detection Prevalence : 0.11009         
#      Balanced Accuracy : 0.56728         
                                          
#       'Positive' Class : Brittle   