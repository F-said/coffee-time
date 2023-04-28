library(mltools)
library(rpart)
library(randomForest)
library(caret)

# load and remove unemployed since it is not significant
coffee_tr <- read.csv("data/csv/ml_data/br_nocat.csv")

# drop subdiv
coffee_tr <- subset(coffee_tr, select = -c(subdivision))

head(coffee_tr)

y <- subset(coffee_tr, select=c(million_60kgs_bag))
X <- subset(coffee_tr, select=-c(million_60kgs_bag))

# multivariate regression
lm_multivar <- lm(million_60kgs_bag~., coffee_tr)
summary(lm_multivar)
"Residuals:
    Min      1Q  Median      3Q     Max 
-15.222  -4.269  -1.772   4.936  19.939 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 76.40106   19.55237   3.908 0.000222 ***
median_et    0.04381    0.01258   3.484 0.000883 ***
temp_c      -0.22756    0.80184  -0.284 0.777451    
rel_humid   -1.06230    0.18435  -5.763 2.37e-07 ***
wind_speed  -4.67752    1.61956  -2.888 0.005236 ** 
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 7.208 on 66 degrees of freedom
Multiple R-squared:  0.4941,	Adjusted R-squared:  0.4634 
F-statistic: 16.12 on 4 and 66 DF,  p-value: 2.966e-09"

# mse
predictions <- predict(lm_multivar, newdata = coffee_tr)
mse1 <- mse(predictions, y)
mse1
"3428.688"

# reduced model
lm_limited <- lm(million_60kgs_bag~rel_humid+median_et+wind_speed, coffee_tr)
summary(lm_limited)
"Residuals:
    Min      1Q  Median      3Q     Max 
-15.374  -3.952  -1.865   4.980  19.953 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept) 72.85877   14.94645   4.875 7.01e-06 ***
rel_humid   -1.04746    0.17555  -5.967 1.01e-07 ***
median_et    0.04275    0.01192   3.585 0.000635 ***
wind_speed  -4.92856    1.34731  -3.658 0.000501 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 7.158 on 67 degrees of freedom
Multiple R-squared:  0.4935,	Adjusted R-squared:  0.4708 
F-statistic: 21.76 on 3 and 67 DF,  p-value: 5.977e-10"

predictions <- predict(lm_limited, newdata = coffee_tr)
mse <- mse(predictions, y)
mse
"3432.872"

# model interactions 
lm_et <- lm(million_60kgs_bag~median_et, coffee_tr)
summary(lm_et)
"Residuals:
   Min     1Q Median     3Q    Max 
-7.959 -6.351 -4.999 -1.270 25.476 

Coefficients:
             Estimate Std. Error t value Pr(>|t|)
(Intercept)  2.421254  12.212168   0.198    0.843
median_et    0.005764   0.011913   0.484    0.630

Residual standard error: 9.894 on 69 degrees of freedom
Multiple R-squared:  0.003381,	Adjusted R-squared:  -0.01106 
F-statistic: 0.2341 on 1 and 69 DF,  p-value: 0.6301"

lm_humid <- lm(million_60kgs_bag~rel_humid, coffee_tr)
summary(lm_humid)
"Residuals:
    Min      1Q  Median      3Q     Max 
-13.873  -5.143  -1.447   2.685  23.882 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)  96.3264    13.6883   7.037 1.14e-09 ***
rel_humid    -1.1870     0.1842  -6.446 1.32e-08 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 7.83 on 69 degrees of freedom
Multiple R-squared:  0.3758,	Adjusted R-squared:  0.3668 
F-statistic: 41.54 on 1 and 69 DF,  p-value: 1.325e-08"

lm_temp <- lm(million_60kgs_bag~wind_speed, coffee_tr)
summary(lm_temp)
"Residuals:
    Min      1Q  Median      3Q     Max 
-10.846  -6.459  -3.647   1.277  25.021 

Coefficients:
            Estimate Std. Error t value Pr(>|t|)    
(Intercept)   28.573      7.798   3.664 0.000483 ***
wind_speed    -3.276      1.247  -2.627 0.010614 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

Residual standard error: 9.45 on 69 degrees of freedom
Multiple R-squared:  0.0909,	Adjusted R-squared:  0.07773 
F-statistic:   6.9 on 1 and 69 DF,  p-value: 0.01061"

# get data with subdivision
coffee_tr_div <- read.csv("data/csv/ml_data/br_nocat.csv")

# geom-jitter for subdivision for humidity
jpeg(file="images/humid_jitter_div_noemp.png")
ggplot(coffee_tr_div,aes(rel_humid, million_60kgs_bag, color=subdivision)) +
  geom_smooth(method='lm') +
  xlab("Humidity") +
  ylab("Million 60 kgs coffee_tr") +
  geom_jitter()
dev.off()

# geom-jitter for subdivision for et
jpeg(file="images/et_jitter_div_noemp.png")
ggplot(coffee_tr_div,aes(median_et, million_60kgs_bag, color=subdivision)) +
  geom_smooth(method='lm') +
  xlab("ET") +
  ylab("Million 60 kgs coffee_tr") +
  geom_jitter()
dev.off()

# geom-jitter for subdivision for windspeed
jpeg(file="images/wind_jitter_div_noemp.png")
ggplot(coffee_tr_div,aes(wind_speed, million_60kgs_bag, color=subdivision)) +
  geom_smooth(method='lm') +
  xlab("Wind Speed (Knots)") +
  ylab("Million 60 kgs coffee_tr") +
  geom_jitter()
dev.off()

# geom-jitter for subdivision for temp
jpeg(file="images/temp_jitter_div_noemp.png")
ggplot(coffee_tr_div,aes(temp_c, million_60kgs_bag, color=subdivision)) +
  geom_smooth(method='lm') +
  xlab("Celsius") +
  ylab("Million 60 kgs coffee_tr") +
  geom_jitter()
dev.off()

# decision tree regressor
tree.coffee_tr <- rpart(million_60kgs_bag~., data=coffee_tr)
summary(tree.coffee_tr)
" CP nsplit rel error    xerror      xstd
1 0.58031356      0 1.0000000 1.0550412 0.1887793
2 0.06112985      1 0.4196864 0.5485482 0.1591103
3 0.01000000      3 0.2974267 0.5832763 0.1711398

Variable importance
 rel_humid  median_et wind_speed     temp_c 
        76         12          9          3 

Node number 1: 71 observations,    complexity param=0.5803136
  mean=8.302113, MSE=95.45771 
  left son=2 (58 obs) right son=3 (13 obs)
  Primary splits:
      rel_humid  < 69.45164 to the right, improve=0.58031360, (0 missing)
      wind_speed < 6.355014 to the right, improve=0.18459640, (0 missing)
      temp_c     < 23.57443 to the right, improve=0.09540694, (0 missing)
      median_et  < 943.8    to the left,  improve=0.06151321, (0 missing)

Node number 2: 58 observations,    complexity param=0.06112985
  mean=4.778448, MSE=31.15449 
  left son=4 (34 obs) right son=5 (24 obs)
  Primary splits:
      wind_speed < 5.738478 to the right, improve=0.21667000, (0 missing)
      temp_c     < 20.64254 to the left,  improve=0.05082922, (0 missing)
      median_et  < 1074.35  to the right, improve=0.04178479, (0 missing)
      rel_humid  < 72.2317  to the right, improve=0.02866142, (0 missing)
  Surrogate splits:
      median_et < 986      to the right, agree=0.810, adj=0.542, (0 split)
      rel_humid < 72.72577 to the right, agree=0.724, adj=0.333, (0 split)
      temp_c    < 23.43495 to the right, agree=0.707, adj=0.292, (0 split)

Node number 3: 13 observations
  mean=24.02308, MSE=79.80485 

Node number 4: 34 observations
  mean=2.595588, MSE=1.225054 

Node number 5: 24 observations,    complexity param=0.06112985
  mean=7.870833, MSE=57.24144 
  left son=10 (17 obs) right son=11 (7 obs)
  Primary splits:
      median_et  < 977.45   to the left,  improve=0.31817030, (0 missing)
      wind_speed < 5.451871 to the left,  improve=0.12405880, (0 missing)
      temp_c     < 21.82213 to the right, improve=0.07612314, (0 missing)
      rel_humid  < 75.95853 to the left,  improve=0.06446246, (0 missing)
  Surrogate splits:
      rel_humid  < 80.67344 to the left,  agree=0.792, adj=0.286, (0 split)
      wind_speed < 5.531307 to the left,  agree=0.792, adj=0.286, (0 split)
      temp_c     < 22.2149  to the left,  agree=0.750, adj=0.143, (0 split)

Node number 10: 17 observations
  mean=5.132353, MSE=18.60028 

Node number 11: 7 observations
  mean=14.52143, MSE=88.64133 "

# plot tree

jpeg(file="images/coffee_tr_tree_noemp.png")
plot(tree.coffee_tr, uniform=TRUE, main="Regression Tree for coffee_tr")
text(tree.coffee_tr, use.n=TRUE, all=TRUE, cex=.8)
dev.off()

# mse
predictions <- predict(tree.coffee_tr, newdata = coffee_tr)
mse2 <- mse(predictions, y)
mse2
"2015.809"

# random forest regressor
forest.coffee_tr <- randomForest(million_60kgs_bag~., data=coffee_tr)
summary(forest.coffee_tr)
"Length Class  Mode     
call              3    -none- call     
type              1    -none- character
predicted        71    -none- numeric  
mse             500    -none- numeric  
rsq             500    -none- numeric  
oob.times        71    -none- numeric  
importance        4    -none- numeric  
importanceSD      0    -none- NULL     
localImportance   0    -none- NULL     
proximity         0    -none- NULL     
ntree             1    -none- numeric  
mtry              1    -none- numeric  
forest           11    -none- list     
coefs             0    -none- NULL     
y                71    -none- numeric  
test              0    -none- NULL     
inbag             0    -none- NULL     
terms             3    terms  call    "

# plot tree
randomForest(formula=million_60kgs_bag~., data=coffee_tr)
jpeg(file="images/forest_coffee_tr_noemp.png")
plot(forest.coffee_tr)
dev.off()

# mse
predictions <- predict(forest.coffee_tr, newdata = coffee_tr)
mse4 <- mse(predictions, y)
mse4
"613.061"

# TODO: ADD MORE DATA FOR STATISTICAL POWER

## POST : PCA

principal_components <- princomp(X, cor= TRUE, score = TRUE)
summary(principal_components)
"                       Comp.1    Comp.2     Comp.3     Comp.4
Standard deviation     1.5519780 1.0078185 0.59216087 0.47435394
Proportion of Variance 0.6021589 0.2539246 0.08766362 0.05625291
Cumulative Proportion  0.6021589 0.8560835 0.94374709 1.00000000"

colnames(X)
"median_et"      
"temp_c"         
"rel_humid"      
"wind_speed"     

jpeg(file="images/pca_plot_noemp.png")
plot(principal_components)
dev.off()

jpeg(file="images/pca_biplot_noemp.png")
biplot(principal_components)
dev.off()
