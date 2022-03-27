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
tst <- import("data/csudhsample.rds")

# MODEL DATA ###############################################

# Create a CBA model using `CBA` from `arulesCBA`
fit <- RCAR(
  y ~ .,      
  data = trn)

# Check accuracy of the model on the testing data
confusionMatrix(      # Create a confusion matrix
  reference = tst$y,  # True values
  predict(            # Predicted values
    fit,              # Based on the training model
    newdata = tst     # Use the testing data
  )
)

#Confusion Matrix and Statistics

#Reference
#Prediction   Brittle NotBrittle
#Brittle         17         21
#NotBrittle      15        421

#Accuracy : 0.9241          
#95% CI : (0.8964, 0.9462)
#No Information Rate : 0.9325          
#P-Value [Acc > NIR] : 0.7975          

#Kappa : 0.445           

#Mcnemar's Test P-Value : 0.4047          
                                          
#            Sensitivity : 0.53125         
#           Specificity : 0.95249         
#         Pos Pred Value : 0.44737         
#         Neg Pred Value : 0.96560         
#             Prevalence : 0.06751         
#         Detection Rate : 0.03586         
#   Detection Prevalence : 0.08017         
#      Balanced Accuracy : 0.74187         
#                                          
#       'Positive' Class : Brittle         

fit2 <- RCAR(
  y ~ .,      
  data = trn,
  supp = .05,
  conf = 0.95)

# Check accuracy of the model on the testing data
confusionMatrix(      # Create a confusion matrix
  reference = tst$y,  # True values
  predict(            # Predicted values
    fit2,              # Based on the training model
    newdata = tst     # Use the testing data
  )
)

#Confusion Matrix and Statistics

#Reference
#Prediction   Brittle NotBrittle
#Brittle         13          8
#NotBrittle      19        434

#Accuracy : 0.943           
#95% CI : (0.9182, 0.9621)
#No Information Rate : 0.9325          
#P-Value [Acc > NIR] : 0.20737         

#Kappa : 0.4618          

#Mcnemar's Test P-Value : 0.05429         
                                          
#            Sensitivity : 0.40625         
#            Specificity : 0.98190         
#         Pos Pred Value : 0.61905         
#         Neg Pred Value : 0.95806         
#             Prevalence : 0.06751         
#         Detection Rate : 0.02743         
#   Detection Prevalence : 0.04430         
#      Balanced Accuracy : 0.69408         
#                                          
#       'Positive' Class : Brittle  

fit3 <- RIPPER_CBA(
  y ~ .,      
  data = trn,)

# Check accuracy of the model on the testing data
confusionMatrix(      # Create a confusion matrix
  reference = tst$y,  # True values
  predict(            # Predicted values
    fit3,              # Based on the training model
    newdata = tst     # Use the testing data
  )
)
