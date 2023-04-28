library(mltools)

library(rpart)
library(rpart.plot)
library(party)
library(randomForest)
library(randomForestExplainer)

library(caret)

# load data
coffee <- read.csv("data/csv/ml_data/br_clean_emp.csv")

# remove unneeded columns
coffee_tr <- subset(coffee, select = -c(country, bear_thous_hect, nonbear_thous_hect,
                                        nonbear_mill_trees,trees_hect_bear, trees_hect_nonbear,
                                        bear_mill_trees, year, subdivision))
# encode type
coffee_encode <- dummyVars(" ~ .", data = coffee_tr)
coffee_encode <- data.frame(predict(coffee_encode, newdata = coffee_tr))

# drop robusta to prevent co-linear
coffee_encode <- subset(coffee_encode, select=-c(typeRobusta))

head(coffee_encode)
write.csv(coffee_encode, "data/csv/ml_data/br_encoded.csv", row.names=FALSE)

y <- subset(coffee_encode, select=c(million_60kgs_bag))
X <- subset(coffee_encode, select=-c(million_60kgs_bag))

# multivariate regression
lm_multivar <- lm(million_60kgs_bag~., coffee_encode)
summary(lm_multivar)
"Residuals:
     Min       1Q   Median       3Q      Max 
-14.7561  -3.1604   0.2132   3.6474  15.9688 

Coefficients:
                Estimate Std. Error t value Pr(>|t|)    
(Intercept)    123.64198   24.66839   5.012 1.08e-05 ***
typeArabica     -7.82627    2.91058  -2.689   0.0103 *  
median_et        0.03409    0.01333   2.558   0.0143 *  
temp_c          -0.83268    0.97179  -0.857   0.3965    
rel_humid       -1.62114    0.19590  -8.275 2.78e-10 ***
wind_speed      -1.37416    1.84541  -0.745   0.4607    
avg_unemp_perc   0.26056    0.37853   0.688   0.4951    
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 5.889 on 41 degrees of freedom
Multiple R-squared:  0.6813,	Adjusted R-squared:  0.6346 
F-statistic: 14.61 on 6 and 41 DF,  p-value: 7.745e-09"

# mse
predictions <- predict(lm_multivar, newdata = coffee_encode)
mse1 <- mse(predictions, y)
mse1
"1421.681"

# reduced model
lm_limited <- lm(million_60kgs_bag~rel_humid+median_et+typeArabica, coffee_encode)
summary(lm_limited)
"Residuals:
     Min       1Q   Median       3Q      Max 
-14.6889  -4.1091   0.1448   3.7081  15.6105 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)    
(Intercept) 107.71869   16.94725   6.356 1.01e-07 ***
rel_humid    -1.59262    0.17868  -8.913 2.05e-11 ***
median_et     0.02090    0.01005   2.079   0.0435 *  
typeArabica  -5.42247    2.60394  -2.082   0.0432 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 5.941 on 44 degrees of freedom
Multiple R-squared:  0.6519,	Adjusted R-squared:  0.6282 
F-statistic: 27.47 on 3 and 44 DF,  p-value: 3.636e-10"

predictions <- predict(lm_limited, newdata = coffee_encode)
mse <- mse(predictions, y)
mse
"1552.753"

# plot limited model interactions 
lm_et <- lm(million_60kgs_bag~median_et, coffee_encode)
summary(lm_et)
"Residuals:
   Min     1Q Median     3Q    Max 
-7.773 -6.286 -4.081  1.125 24.956 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept)  -6.4976    15.4450  -0.421    0.676
median_et     0.0144     0.0147   0.979    0.333

Residual standard error: 9.746 on 46 degrees of freedom
Multiple R-squared:  0.02042,	Adjusted R-squared:  -0.000876 
F-statistic: 0.9589 on 1 and 46 DF,  p-value: 0.3326"

lm_humid <- lm(million_60kgs_bag~rel_humid, coffee_encode)
summary(lm_humid)
"Residuals:
     Min       1Q   Median       3Q      Max 
-14.7036  -4.7478  -0.4794   5.3884  13.6825 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 112.4829    14.3420   7.843 5.05e-10 ***
rel_humid    -1.4207     0.1956  -7.262 3.69e-09 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 6.721 on 46 degrees of freedom
Multiple R-squared:  0.5341,	Adjusted R-squared:  0.524 
F-statistic: 52.74 on 1 and 46 DF,  p-value: 3.686e-09"

lm_temp <- lm(million_60kgs_bag~temp_c, coffee_encode)
summary(lm_temp)
"Residuals:
    Min      1Q  Median      3Q     Max 
-8.2638 -5.7048 -3.8577  0.2254 25.3359 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)
(Intercept) -14.8749    18.3673   -0.81    0.422
temp_c        1.0306     0.8053    1.28    0.207

Residual standard error: 9.677 on 46 degrees of freedom
Multiple R-squared:  0.03438,	Adjusted R-squared:  0.01339 
F-statistic: 1.638 on 1 and 46 DF,  p-value: 0.207"

lm_arabica <- lm(million_60kgs_bag~typeArabica, coffee_encode)
summary(lm_arabica)
"Residuals:
   Min     1Q Median     3Q    Max 
-7.581 -5.944 -4.128  0.150 26.119 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)   
(Intercept)   10.975      3.460   3.172  0.00269 **
typeArabica   -2.894      3.790  -0.764  0.44904   
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 9.785 on 46 degrees of freedom
Multiple R-squared:  0.01252,	Adjusted R-squared:  -0.008952 
F-statistic: 0.583 on 1 and 46 DF,  p-value: 0.449"

lm_unemp <- lm(million_60kgs_bag~avg_unemp_perc, coffee_encode)
summary(lm_unemp)
"Residuals:
   Min     1Q Median     3Q    Max 
-8.337 -5.418 -4.349  3.151 24.414 

Coefficients:
               Estimate Std. Error t value Pr(>|t|)
(Intercept)      3.3668     4.6102   0.730    0.469
avg_unemp_perc   0.6356     0.5372   1.183    0.243

Residual standard error: 9.701 on 46 degrees of freedom
Multiple R-squared:  0.02953,	Adjusted R-squared:  0.008433 
F-statistic:   1.4 on 1 and 46 DF,  p-value: 0.2428"

# geom-jitter for humidity
jpeg(file="images/humid_jitter.png")
ggplot(coffee_encode,aes(rel_humid, million_60kgs_bag, color=typeArabica)) +
  geom_smooth(method='lm') +
  xlab("Humidity") +
  ylab("Million 60 kgs Coffee") +
  geom_jitter()
dev.off()

# geom-jitter for et
jpeg(file="images/et_jitter.png")
ggplot(coffee_encode,aes(median_et, million_60kgs_bag, color=typeArabica)) +
  geom_smooth(method='lm') +
  xlab("ET") +
  ylab("Million 60 kgs Coffee") +
  geom_jitter()
dev.off()

# geom-jitter for temp
jpeg(file="images/temp_jitter.png")
ggplot(coffee_encode,aes(temp_c, million_60kgs_bag, color=typeArabica)) +
  geom_smooth(method='lm') +
  xlab("Temp") +
  ylab("Million 60 kgs Coffee") +
  geom_jitter()
dev.off()

# geom-jitter for wind speed
jpeg(file="images/wind_jitter.png")
ggplot(coffee_encode,aes(wind_speed, million_60kgs_bag, color=typeArabica)) +
  geom_smooth(method='lm') +
  xlab("Wind Speed") +
  ylab("Million 60 kgs Coffee") +
  geom_jitter()
dev.off()

# get data with subdivision
coffee <- read.csv("data/csv/ml_data/br_clean_emp.csv")

# remove unneeded columns
coffee_div <- subset(coffee, select = -c(country, bear_thous_hect, nonbear_thous_hect,
                                        nonbear_mill_trees,trees_hect_bear, trees_hect_nonbear,
                                        bear_mill_trees, year))

# geom-jitter for subdivision for humidity
jpeg(file="images/humid_jitter_div.png")
ggplot(coffee_div,aes(rel_humid, million_60kgs_bag, color=subdivision)) +
  geom_smooth(method='lm') +
  xlab("Humidity") +
  ylab("Million 60 kgs Coffee") +
  geom_jitter()
dev.off()

# geom-jitter for subdivision
jpeg(file="images/et_jitter_div.png")
ggplot(coffee_div,aes(median_et, million_60kgs_bag, color=subdivision)) +
  geom_smooth(method='lm') +
  xlab("Humidity") +
  ylab("Million 60 kgs Coffee") +
  geom_jitter()
dev.off()


# decision tree regressor
tree.coffee <- rpart(million_60kgs_bag~., data=coffee_encode)
summary(tree.coffee)
"          CP nsplit rel error    xerror      xstd
1 0.65740578      0 1.0000000 1.0348679 0.2478058
2 0.09366398      1 0.3425942 0.5269225 0.1866942
3 0.01040603      2 0.2489302 0.4271996 0.1771041
4 0.01000000      3 0.2385242 0.4247152 0.1772285

     rel_humid    typeArabica         temp_c     wind_speed avg_unemp_perc      median_et 
            85             12              1              1              1              1 

Node number 1: 48 observations,    complexity param=0.6574058
  mean=8.563542, MSE=92.92893 
  left son=2 (38 obs) right son=3 (10 obs)
  Primary splits:
      rel_humid      < 69.45164 to the right, improve=0.65740580, (0 missing)
      temp_c         < 21.3905  to the left,  improve=0.20548900, (0 missing)
      wind_speed     < 5.720044 to the left,  improve=0.10358240, (0 missing)
      median_et      < 1039.9   to the left,  improve=0.10093540, (0 missing)
      avg_unemp_perc < 6.2125   to the left,  improve=0.09718308, (0 missing)

Node number 2: 38 observations,    complexity param=0.09366398
  mean=4.553947, MSE=13.554 
  left son=4 (30 obs) right son=5 (8 obs)
  Primary splits:
      typeArabica    < 0.5      to the right, improve=0.8111736, (0 missing)
      temp_c         < 21.68678 to the left,  improve=0.4437660, (0 missing)
      wind_speed     < 6.837006 to the left,  improve=0.3792455, (0 missing)
      median_et      < 1052.7   to the left,  improve=0.3156733, (0 missing)
      avg_unemp_perc < 6.2125   to the left,  improve=0.1445118, (0 missing)

Node number 3: 10 observations
  mean=23.8, MSE=101.312 

Node number 4: 30 observations,    complexity param=0.01040603
  mean=2.841667, MSE=2.302681 
  left son=8 (16 obs) right son=9 (14 obs)
  Primary splits:
      temp_c         < 21.68678 to the left,  improve=0.6719271, (0 missing)
      rel_humid      < 72.6064  to the right, improve=0.5601289, (0 missing)
      avg_unemp_perc < 9.2625   to the left,  improve=0.3132164, (0 missing)
      wind_speed     < 5.605391 to the right, improve=0.1774682, (0 missing)
      median_et      < 998.9    to the right, improve=0.1006927, (0 missing)
  Surrogate splits:
      rel_humid      < 72.6064  to the right, agree=0.800, adj=0.571, (0 split)
      wind_speed     < 6.837006 to the left,  agree=0.800, adj=0.571, (0 split)
      median_et      < 1052.7   to the left,  agree=0.767, adj=0.500, (0 split)
      avg_unemp_perc < 7.0375   to the left,  agree=0.767, adj=0.500, (0 split)

Node number 5: 8 observations
  mean=10.975, MSE=3.521875 

Node number 8: 16 observations
  mean=1.678125, MSE=0.3609277 

Node number 9: 14 observations
  mean=4.171429, MSE=1.206327"

# plot tree

jpeg(file="images/coffee_tree.png")
plot(tree.coffee, uniform=TRUE, main="Regression Tree for Coffee")
text(tree.coffee, use.n=TRUE, all=TRUE, cex=.8)
dev.off()

# mse
predictions <- predict(tree.coffee, newdata = coffee_encode)
mse2 <- mse(predictions, y)
mse2
"1063.958"

# random forest regressor
forest.coffee <- randomForest(million_60kgs_bag~., data=coffee_encode)
importance(forest.coffee)
"IncNodePurity
typeArabica         165.9241
median_et           382.6809
temp_c              653.0411
rel_humid          2023.8485
wind_speed          645.8856
avg_unemp_perc      276.2516"

# plot size of tree
randomForest(formula=million_60kgs_bag~., data=coffee_encode)
jpeg(file="images/forest_coffee.png")
plot(forest.coffee)
dev.off()

# mse
predictions <- predict(forest.coffee, newdata = coffee_encode)
mse4 <- mse(predictions, y)
mse4
"329.6718"

# TODO: ADD MORE DATA FOR STATISTICAL POWER (& TESTING!)

## POST : PCA

principal_components <- princomp(X, cor= TRUE, score = TRUE)
summary(principal_components)
"                       Comp.1    Comp.2    Comp.3     Comp.4     Comp.5     Comp.6
Standard deviation     1.7285299 1.1229939 0.8667981 0.74489206 0.55200026 0.37438172
Proportion of Variance 0.4979693 0.2101859 0.1252232 0.09247736 0.05078405 0.02336028
Cumulative Proportion  0.4979693 0.7081551 0.8333783 0.92585567 0.97663972 1.00000000"

colnames(X)
"typeArabica"
"median_et"      
"temp_c"         
"rel_humid"      
"wind_speed"     
"avg_unemp_perc"

jpeg(file="images/pca_plot.png")
plot(principal_components)
dev.off()

jpeg(file="images/pca_biplot.png")
biplot(principal_components)
dev.off()

