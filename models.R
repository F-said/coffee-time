library(mltools)
library(tree)
library(randomForest)

# load data
coffee <- read.csv("data/csv/ml_data/br_transformed.csv")

# remove unneeded columns
coffee_tr <- subset(coffee, select = -c(X, country, million_60kgs_bag, nonbear_mill_trees,
                                        bear_mill_trees, year, subdivision, type,
                                        nonbear_thous_hect ))
# encode type (TODO)
#head(coffee_encode)
#write.csv(coffee_encode, "data/csv/ml_data/br_encoded.csv")

target <- subset(coffee_tr, select=c(bear_thous_hect))
train <- subset(coffee_tr, select=-c(bear_thous_hect))

# multivariate regression (humidity & ecoffee_trvapotransporation)
lm_multivar <- lm(bear_thous_hect~., coffee_tr)
summary(lm_multivar)
"Residuals:
    Min      1Q  Median      3Q     Max 
-61.219 -13.578  -2.637  15.306  48.472 

Coefficients:
                 Estimate Std. Error t value Pr(>|t|)    
(Intercept)    2935.26906  139.37742  21.060  < 2e-16 ***
median_et         0.11161    0.10560   1.057    0.300    
temp_c           -5.22790    4.29213  -1.218    0.234    
rel_humid        -9.54016    1.62586  -5.868 3.00e-06 ***
wind_speed      -10.47307   13.29204  -0.788    0.438    
avg_unemp_thou   -0.15827    0.02713  -5.834 3.28e-06 ***
---"

# mse
predictions <- predict(lm_multivar, newdata = coffee_tr)
mse1 <- mse(predictions, target)
mse1
"18485.02"

# decision tree regressor
tree.coffee <- tree(bear_thous_hect~., data=coffee_tr)
summary(tree.coffee)
"Number of terminal nodes:  5 
Residual mean deviance:  686.4 = 19220 / 28 
Distribution of residuals:
    Min.  1st Qu.   Median     Mean  3rd Qu.     Max. 
-51.8800 -20.0000  -0.7143   0.0000  23.1200  38.1200"

# plot tree
tree(formula=bear_thous_hect~., data=coffee_tr)
jpeg(file="images/coffee_tree.png")
plot(tree.coffee)
text(tree.coffee, pretty=0)
dev.off()

# mse
predictions <- predict(tree.coffee, newdata = coffee_tr)
mse2 <- mse(predictions, target)
mse2
"19218.3"

# random forest regressor
forest.coffee <- randomForest(bear_thous_hect~., data=coffee_tr)
summary(forest.coffee)
"type              1    -none- character
predicted        33    -none- numeric  
mse             500    -none- numeric  
rsq             500    -none- numeric  
oob.times        33    -none- numeric  
importance        5    -none- numeric  
importanceSD      0    -none- NULL     
localImportance   0    -none- NULL     
proximity         0    -none- NULL     
ntree             1    -none- numeric  
mtry              1    -none- numeric  
forest           11    -none- list     
coefs             0    -none- NULL     
y                33    -none- numeric  
test              0    -none- NULL     
inbag             0    -none- NULL     
terms             3    terms  call   "

# plot tree
randomForest(formula=bear_thous_hect~., data=coffee_tr)
jpeg(file="images/forest_coffee.png")
plot(forest.coffee)
text(forest.coffee, pretty=0)
dev.off()

# mse
predictions <- predict(forest.coffee, newdata = coffee_tr)
mse3 <- mse(predictions, target)
mse3
"8424.347"

# TODO: Panel Regression

## POST : PCA

principal_components <- princomp(train, cor= TRUE, score = TRUE)
summary(principal_components)
"                       Comp.1    Comp.2    Comp.3     Comp.4     Comp.5
Standard deviation     1.760234 0.9302948 0.8636498 0.39814817 0.36292409
Proportion of Variance 0.619685 0.1730897 0.1491782 0.03170439 0.02634278
Cumulative Proportion  0.619685 0.7927746 0.9419528 0.97365722 1.00000000"

jpeg(file="images/pca_plot.png")
plot(principal_components)
dev.off()

jpeg(file="images/pca_biplot.png")
biplot(principal_components)
dev.off()


# PCA components prediction (TODO)
lm_multivar <- lm(principal_components~., coffee_tr)
summary(lm_multivar)
