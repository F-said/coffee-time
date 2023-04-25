library(dplyr)
library(readxl)
library(tidyr)
library(class)

library(ggplot2)
library(reshape2)

# load data
coffee <- read.csv("data/csv/ml_data/br_final.csv")

str(coffee)
head(coffee)
dim(coffee)

rowSums(is.na(coffee))

# remove null rows 
na_rows <- is.na(coffee$avg_unemp_thou)
coffee_tr <- coffee[!na_rows, ]

na_rows <- is.na(coffee_tr$wind_speed)
coffee_tr <- coffee_tr[!na_rows, ]

na_rows <- is.na(coffee_tr$temp_c)
coffee_tr <- coffee_tr[!na_rows, ]

na_rows <- is.na(coffee_tr$rel_humid)
coffee_tr <- coffee_tr[!na_rows, ]

na_rows <- is.na(coffee_tr$median_et)
coffee_tr <- coffee_tr[!na_rows, ]

# this results in sao paulo being completely removed!

# remove max and mean et
coffee_tr <- subset(coffee_tr, select = -c(max_et, mean_et))

dim(coffee_tr)

write.csv(coffee_tr, "data/csv/ml_data/br_transformed.csv")

df <- coffee_tr

## univariate analysis ## 

# explore distributions

# coffee production
jpeg(file="images/coffee_prod_hist.png")
hist(df$million_60kgs_bag, breaks = 30)
dev.off()

jpeg(file="images/coffee_prod_qq.png")
qqnorm(df$million_60kgs_bag, pch = 1, frame = FALSE)
qqline(df$million_60kgs_bag, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$million_60kgs_bag)
"
data:  df$million_60kgs_bag
W = 0.79039, p-value = 2.128e-05
"

# coffee growth (bearing trees)
jpeg(file="images/coffee_bearingtrees_hist.png")
hist(df$bear_mill_trees)
dev.off()

jpeg(file="images/coffee_brearingtrees_qq.png")
qqnorm(df$bear_mill_trees, pch = 1, frame = FALSE)
qqline(df$bear_mill_trees, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$bear_mill_trees)
"
data:  df$bear_mill_trees
W = 0.90187, p-value = 0.00596
"

# coffee growth (non-bearing trees)
jpeg(file="images/coffee_nonbearingtrees_hist.png")
hist(df$nonbear_mill_trees)
dev.off()

jpeg(file="images/coffee_nonbearingtrees_qq.png")
qqnorm(df$nonbear_mill_trees, pch = 1, frame = FALSE)
qqline(df$nonbear_mill_trees, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$nonbear_mill_trees)
"
data:  df$nonbear_mill_trees
W = 0.91613, p-value = 0.01434
"

# coffee growth (bearing hectares)
jpeg(file="images/coffee_bearinghect_hist.png")
hist(df$bear_thous_hect)
dev.off()

jpeg(file="images/coffee_bearingtrees_qq.png")
qqnorm(df$bear_thous_hect, pch = 1, frame = FALSE)
qqline(df$bear_thous_hect, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$bear_thous_hect)
"
data:  df$bear_thous_hect
W = 0.90127, p-value = 0.005747
"

# coffee growth (non-bearing hectares)
jpeg(file="images/coffee_nonbearinghect_hist.png")
hist(df$nonbear_thous_hect)
dev.off()

jpeg(file="images/coffee_nonbearingtrees_qq.png")
qqnorm(df$nonbear_thous_hect, pch = 1, frame = FALSE)
qqline(df$nonbear_thous_hect, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$nonbear_thous_hect)
"
data:  df$nonbear_thous_hect
W = 0.91952, p-value = 0.01776
"

# median et (kg/m^2 sum)
jpeg(file="images/et_hist.png")
hist(df$median_et)
dev.off()

jpeg(file="images/et_qq.png")
qqnorm(df$median_et, pch = 1, frame = FALSE)
qqline(df$median_et, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$median_et)
"
data:  df$median_et
W = 0.90661, p-value = 0.007943
"

# avg temp celsius
jpeg(file="images/temp_hist.png")
hist(df$temp_c)
dev.off()

jpeg(file="images/temp_qq.png")
qqnorm(df$temp_c, pch = 1, frame = FALSE)
qqline(df$temp_c, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$temp_c)
"
data:  df$temp_c
W = 0.83697, p-value = 0.0001782
"

# avg humidity
jpeg(file="images/humid_hist.png")
hist(df$rel_humid)
dev.off()

jpeg(file="images/humid_qq.png")
qqnorm(df$rel_humid, pch = 1, frame = FALSE)
qqline(df$rel_humid, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$rel_humid)
# most likely normal! 
"
data:  df$rel_humid
W = 0.94134, p-value = 0.07433
"

# avg wind speed (knots)
jpeg(file="images/wind_hist.png")
hist(df$wind_speed)
dev.off()

jpeg(file="images/wind_qq.png")
qqnorm(df$wind_speed, pch = 1, frame = FALSE)
qqline(df$wind_speed, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$wind_speed)
"
data:  df$wind_speed
W = 0.9341, p-value = 0.04586
"

# avg unemployment (thousand)
jpeg(file="images/unemp_hist.png")
hist(df$avg_unemp_thou)
dev.off()

jpeg(file="images/unemp_qq.png")
qqnorm(df$avg_unemp_thou, pch = 1, frame = FALSE)
qqline(df$avg_unemp_thou, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$avg_unemp_thou)
"
data:  df$avg_unemp_thou
W = 0.79842, p-value = 3.011e-05
"

# explore summary statistics

summary(df$avg_unemp_thou)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  121.5   153.2   252.5   420.6   540.0  1356.5"

summary(df$wind_speed)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  5.916   6.241   6.934   6.953   7.532   8.202 "

summary(df$rel_humid)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  63.84   71.17   74.77   73.44   77.37   82.22"

summary(df$nonbear_mill_trees)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
    835    1055    1125    1087    1150    1300"

summary(df$bear_mill_trees)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   5640    5735    5760    5764    5810    5860"

summary(df$nonbear_thous_hect)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
  260.0   307.0   335.0   320.8   340.0   380.0"

summary(df$bear_thous_hect)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
   2020    2070    2090    2096    2135    2150"

# explore box-plots

boxplot(df$bear_thous_hect, df$nonbear_thous_hect, names=c("bearing hectars (thousand)", "non-bearing hectars (thousand)"))

boxplot(df$bear_mill_trees, df$nonbear_mill_trees, names=c("bearing trees (mill)", "non-bearing trees (mill)"))

## bivariate analysis ## 
ndf <- df[order(df$year),] 
# get only arabica
ndf <- ndf %>% filter(type=="Arabica")

# plot line plot of interesting features
# standardize coffee --> million bags to thousand bags

mg <- ndf %>% filter(subdivision == "Minas Gerais")
es <- ndf %>% filter(subdivision == "Espirito Santo")
pa <- ndf %>% filter(subdivision == "Parana")

# line plots
jpeg(file="images/arabica_lineplot.png")
ggplot(data = ndf, aes(x=year, y=million_60kgs_bag)) + geom_line(aes(color = subdivision)) 
dev.off()

jpeg(file="images/trees_barplot.png")
ggplot(ndf, aes(fill=subdivision, x=year, y=bear_mill_trees)) +
  geom_bar(position="stack", stat="identity") 
dev.off()

jpeg(file="images/et_lineplot.png")
ggplot(data = ndf, aes(x=year, y=median_et)) + geom_line(aes(color = subdivision)) 
dev.off()

jpeg(file="images/umemp_lineplot.png")
ggplot(data = ndf, aes(x=year, y=avg_unemp_thou)) + geom_line(aes(color = subdivision)) 
dev.off()

# bar plots
jpeg(file="images/arabica_barplot.png")
ggplot(ndf, aes(fill=subdivision, x=year, y=million_60kgs_bag)) +
  geom_bar(position="stack", stat="identity") 
dev.off()

jpeg(file="images/unemp_barplot.png")
ggplot(ndf, aes(fill=subdivision, x=year, y=avg_unemp_thou)) +
  geom_bar(position="stack", stat="identity") 
dev.off()


# explore scatter plots for et 
et <- read.csv("data/csv/ml_data/br_final_onlyet.csv")
etdf <- et[order(et$year),] 
# get only arabica
etdf <- etdf %>% filter(type=="Arabica")

mget <- etdf %>% filter(subdivision == "Minas Gerais")
eset <- etdf %>% filter(subdivision == "Espirito Santo")
paet <- etdf %>% filter(subdivision == "Parana")

# median et (kg/m^2 sum)
jpeg(file="images/etALL_hist.png")
hist(etdf$median_et)
dev.off()

jpeg(file="images/etALL_qq.png")
qqnorm(etdf$median_et, pch = 1, frame = FALSE)
qqline(etdf$median_et, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(etdf$median_et)
"data:  etdf$median_et
W = 0.96167, p-value = 0.1503"

# total 
jpeg(file="images/et_prod.png")
ggplot(et, aes(x=median_et, y=million_60kgs_bag)) + geom_point()
dev.off()

jpeg(file="images/et_temp.png")
ggplot(et, aes(x=median_et, y=temp_c)) + geom_point()
dev.off()

jpeg(file="images/et_humid.png")
ggplot(et, aes(x=median_et, y=rel_humid)) + geom_point()
dev.off()

jpeg(file="images/et_wind.png")
ggplot(et, aes(x=median_et, y=wind_speed)) + geom_point()
dev.off()

jpeg(file="images/et_trees.png")
ggplot(et, aes(x=median_et, y=bear_mill_trees)) + geom_point()
dev.off()

jpeg(file="images/et_hect.png")
ggplot(et, aes(x=median_et, y=bear_thous_hect)) + geom_point()
dev.off()

# make heat plot
corr_cols <- subset(df, select = c(million_60kgs_bag, bear_mill_trees, bear_thous_hect, temp_c, rel_humid, median_et, avg_unemp_thou)) 
cormat <- round(cor(corr_cols),2)
melted_cormat <- melt(cormat)

jpeg(file="images/heatmap.png")
ggplot(data = melted_cormat, aes(x=Var1, y=Var2, fill=value)) + 
  geom_tile() + 
  scale_fill_gradient2(low = "#075AFF",
                       mid = "#FFFFCC",
                       high = "#FF0000") + 
  geom_text(aes(Var2, Var1, label = value),
                          color = "black", size = 4)
dev.off()

# mg 
jpeg(file="images/et_hectares_mg.png")
ggplot(mget, aes(x=median_et, y=bear_thous_hect)) + geom_point()
dev.off()

# es
jpeg(file="images/et_hectares_es.png")
ggplot(eset, aes(x=median_et, y=bear_thous_hect)) + geom_point()
dev.off()

# pa
jpeg(file="images/et_hectares_pa.png")
ggplot(paet, aes(x=median_et, y=bear_thous_hect)) + geom_point()
dev.off()
