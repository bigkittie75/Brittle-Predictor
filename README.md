# Brittle-Predictor
Training and testing classification-based association rule mining for predicting brittle paper in library collections.

## Accuracy of CBA Models
### Classification Based on Assocation Rules Algorithm (CBA)
**Testing on Training Data**  
Confusion Matrix and Statistics
|Prediction|Brittle|Not Brittle|
|:---|---:|---:|
|**Brittle**|71|56|
|**Not Brittle**|43|638|

```
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