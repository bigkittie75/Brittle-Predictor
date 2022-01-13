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
fit <- RCAR(
  y ~ .,      
  data = trn,
  supp = .01,
  conf = 0.65)

# Basic info on the model in `fit`
fit       

# Check the rules
options(digits = 2)  # Reset R session when done
inspect(rules(fit))  # Need a (very) wide Console window

# Check accuracy of the model on the training data
confusionMatrix(      # Create a confusion matrix
  reference = trn$y,  # True values
  predict(            # Predicted values
    fit,              # Based on the training model
    newdata = trn     # Use the training data
  )
)

### Accuracy #################################
#Reference
#Prediction   Brittle NotBrittle
#Brittle        120        105
#NotBrittle      40        889

#Accuracy : 0.874         
#95% CI : (0.854, 0.893)
#No Information Rate : 0.861         
#P-Value [Acc > NIR] : 0.107         

#Kappa : 0.551         

#Mcnemar's Test P-Value : 1.07e-07      
                                        
#            Sensitivity : 0.750         
#            Specificity : 0.894         
#         Pos Pred Value : 0.533         
#         Neg Pred Value : 0.957         
#             Prevalence : 0.139         
#         Detection Rate : 0.104         
#   Detection Prevalence : 0.195         
#      Balanced Accuracy : 0.822         
                                        
#       'Positive' Class : Brittle       


# Check accuracy of the model on the testing data
confusionMatrix(      # Create a confusion matrix
  reference = tst$y,  # True values
  predict(            # Predicted values
    fit,              # Based on the training model
    newdata = tst     # Use the testing data
  )
)

###Accuracy ######################
#Confusion Matrix and Statistics

#Reference
#Prediction   Brittle NotBrittle
#Brittle         23         55
#NotBrittle      26        223

#Accuracy : 0.752         
#95% CI : (0.702, 0.798)
#No Information Rate : 0.85          
#P-Value [Acc > NIR] : 1.00000       

#Kappa : 0.218         

#Mcnemar's Test P-Value : 0.00186       
                                        
#            Sensitivity : 0.4694        
#            Specificity : 0.8022        
#         Pos Pred Value : 0.2949        
#         Neg Pred Value : 0.8956        
#             Prevalence : 0.1498        
#         Detection Rate : 0.0703        
#   Detection Prevalence : 0.2385        
#      Balanced Accuracy : 0.6358        
                                        
#       'Positive' Class : Brittle  