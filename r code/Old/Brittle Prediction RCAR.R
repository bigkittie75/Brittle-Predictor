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

# Import pre-processed penguin data
df <- import("data/lcpaper.rds") %>%
  print()

# Discretize data using the "Minimum Description Length
# Principle" (MDLP) algorithm and save to `df`; by naming
# the `Brittle` variable `y` (done earlier), it's easier to
# reuse code

df <- 
  discretizeDF.supervised(  # Function from `arulesCBA`
    y ~ .,                  # Brittle based on rest
    data = df,              # Data source
    method = "mdlp"         # Algorithm to use
  )
df %>% head()

# Split data into training (trn) and testing (tst) sets
df %<>% mutate(ID = row_number())  # Add row ID
trn <- df %>% sample_frac(.70)     # 70% in trn
tst <- df %>%                      # Start with df
  anti_join(trn, by = "ID") %>%    # Rest in tst
  select(-ID)                      # Remove id from tst
trn %<>% select(-ID)               # Remove id from trn

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

# ACCURACY #######################################

#Accuracy : 0.865        
#95% CI : (0.84, 0.888)
#No Information Rate : 0.859        
#P-Value [Acc > NIR] : 0.328        

#Kappa : 0.522        

#Mcnemar's Test P-Value : 2.5e-05      
                                       
#            Sensitivity : 0.719        
#            Specificity : 0.889        
#         Pos Pred Value : 0.516        
#         Neg Pred Value : 0.951        
#             Prevalence : 0.141        
#         Detection Rate : 0.101        
#   Detection Prevalence : 0.197        
#      Balanced Accuracy : 0.804          


# TEST MODEL ###############################################

# Check accuracy of the model on the testing data
confusionMatrix(      # Create a confusion matrix
  reference = tst$y,  # True values
  predict(            # Predicted values
    fit,              # Based on the training model
    newdata = tst     # Use the testing data
  )
)

# ACCURACY #######################################

#Accuracy : 0.85          
#95% CI : (0.808, 0.886)
#No Information Rate : 0.867         
#P-Value [Acc > NIR] : 0.848194      

#Kappa : 0.474         

#Mcnemar's Test P-Value : 0.000527      
                                        
#            Sensitivity : 0.7174        
#            Specificity : 0.8700        
#         Pos Pred Value : 0.4583        
#         Neg Pred Value : 0.9526        
#             Prevalence : 0.1329        
#         Detection Rate : 0.0954        
#   Detection Prevalence : 0.2081        
#      Balanced Accuracy : 0.7937        


# CLEAN UP #################################################

# Clear data
rm(list = ls())  # Removes all objects from the environment

# Clear packages
p_unload(all)    # Remove all contributed packages

# Clear plots
graphics.off()   # Clears plots, closes all graphics devices

# Clear console
cat("\014")      # Mimics ctrl+L

# Clear R
#   You may want to use Session > Restart R, as well, which 
#   resets changed options, relative paths, dependencies, 
#   and so on to let you start with a clean slate

# Clear mind :)

