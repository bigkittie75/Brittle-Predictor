# Brittle-Predictor
Training and testing classification-based association rule mining for predicting brittle paper in library collections.

## Summary of CBA Models
**CBA**
```
Training:
         Accuracy : 0.877
Balanced Accuracy : 0.7711
      Sensitivity : 0.6228        
      Specificity : 0.9193
   Pos Pred Value : 0.5591

Testing:
         Accuracy : 0.87
Balanced Accuracy : 0.7593
      Sensitivity : 0.6087        
      Specificity : 0.9100
   Pos Pred Value : 0.5091
```
***RCAR+***
```
Training:
         Accuracy : 0.865
Balanced Accuracy : 0.804
      Sensitivity : 0.719        
      Specificity : 0.889
   Pos Pred Value : 0.516

Testing:
         Accuracy : 0.85
Balanced Accuracy : 0.7937
      Sensitivity : 0.7174        
      Specificity : 0.4583
   Pos Pred Value : 0.5091
```

## Full Statistics of CBA Models
### Classification Based on Assocation Rules Algorithm (CBA)
**Training Data Confusion Matrix and Statistics**  

```
            Reference
Prediction   Brittle NotBrittle
  Brittle         71         56
  NotBrittle      43        638

               Accuracy : 0.877         
                 95% CI : (0.853, 0.899)
    No Information Rate : 0.859         
    P-Value [Acc > NIR] : 0.0694        
                                        
                  Kappa : 0.517         
                                        
 Mcnemar's Test P-Value : 0.2278        
                                        
            Sensitivity : 0.6228        
            Specificity : 0.9193        
         Pos Pred Value : 0.5591        
         Neg Pred Value : 0.9369        
             Prevalence : 0.1411        
         Detection Rate : 0.0879        
   Detection Prevalence : 0.1572        
      Balanced Accuracy : 0.7711        
                                        
       'Positive' Class : Brittle 
```

**Testing Data Confusion Matrix and Statistics** 

```
            Reference
Prediction   Brittle NotBrittle
  Brittle         28         27
  NotBrittle      18        273

               Accuracy : 0.87         
                 95% CI : (0.83, 0.904)
    No Information Rate : 0.867        
    P-Value [Acc > NIR] : 0.476        
                                       
                  Kappa : 0.479        
                                       
 Mcnemar's Test P-Value : 0.233        
                                       
            Sensitivity : 0.6087       
            Specificity : 0.9100       
         Pos Pred Value : 0.5091       
         Neg Pred Value : 0.9381       
             Prevalence : 0.1329       
         Detection Rate : 0.0809       
   Detection Prevalence : 0.1590       
      Balanced Accuracy : 0.7593       
                                       
       'Positive' Class : Brittle   
```

### Regularized Class Association Rules for Multi-class Problems (RCAR+)   
**Training Data Confusion Matrix and Statistics**
```
Confusion Matrix and Statistics

            Reference
Prediction   Brittle NotBrittle
  Brittle         82         77
  NotBrittle      32        617
                                       
               Accuracy : 0.865        
                 95% CI : (0.84, 0.888)
    No Information Rate : 0.859        
    P-Value [Acc > NIR] : 0.328        
                                       
                  Kappa : 0.522        
                                       
 Mcnemar's Test P-Value : 2.5e-05      
                                       
            Sensitivity : 0.719        
            Specificity : 0.889        
         Pos Pred Value : 0.516        
         Neg Pred Value : 0.951        
             Prevalence : 0.141        
         Detection Rate : 0.101        
   Detection Prevalence : 0.197        
      Balanced Accuracy : 0.804        
                                       
       'Positive' Class : Brittle      
```

**Testing Data Confusion Matrix and Statistics**

```
Reference
Prediction   Brittle NotBrittle
  Brittle         33         39
  NotBrittle      13        261
                                        
               Accuracy : 0.85          
                 95% CI : (0.808, 0.886)
    No Information Rate : 0.867         
    P-Value [Acc > NIR] : 0.848194      
                                        
                  Kappa : 0.474         
                                        
 Mcnemar's Test P-Value : 0.000527      
                                        
            Sensitivity : 0.7174        
            Specificity : 0.8700        
         Pos Pred Value : 0.4583        
         Neg Pred Value : 0.9526        
             Prevalence : 0.1329        
         Detection Rate : 0.0954        
   Detection Prevalence : 0.2081        
      Balanced Accuracy : 0.7937        
                                        
       'Positive' Class : Brittle       
```