library(dplyr)
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


df <- coffee

## univariate analysis ## 

# explore distributions

# coffee production
jpeg(file="images/coffee_prod_hist.png")
hist(df$million_60kgs_bag)
dev.off()

jpeg(file="images/coffee_prod_qq.png")
qqnorm(df$million_60kgs_bag, pch = 1, frame = FALSE)
qqline(df$million_60kgs_bag, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$million_60kgs_bag)
"data:  df$million_60kgs_bag
W = 0.77519, p-value = 5.551e-12"

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
"data:  df$bear_mill_trees
W = 0.81675, p-value = 2.245e-10"

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
"data:  df$nonbear_mill_trees
W = 0.94276, p-value = 0.0001357"

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
"data:  df$bear_thous_hect
W = 0.9422, p-value = 0.0001246"

# coffee growth (non-bearing hectares)
jpeg(file="images/coffee_nonbearinghect_hist.png")
hist(df$nonbear_thous_hect)
dev.off()

jpeg(file="images/coffee_nonbearingtrees_qq.png")
qqnorm(df$nonbear_thous_hect, pch = 1, frame = FALSE)
qqline(df$nonbear_thous_hect, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$trees_hect_nonbear)
"data:  df$trees_hect_nonbear
W = 0.91189, p-value = 2.081e-06"

# coffee growth (non-bearing trees/hectares)
jpeg(file="images/coffee_nonbearingtreeshect_hist.png")
hist(df$trees_hect_nonbear)
dev.off()

jpeg(file="images/coffee_nonbearingtrees_qq.png")
qqnorm(df$trees_hect_nonbear, pch = 1, frame = FALSE)
qqline(df$trees_hect_nonbear, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$trees_hect_nonbear)
"data:  df$trees_hect_nonbear
W = 0.91189, p-value = 2.081e-06"

# coffee growth (nbearing trees/hectares)
jpeg(file="images/coffee_bearingtreeshect_hist.png")
hist(df$trees_hect_bear)
dev.off()

jpeg(file="images/coffee_nonbearingtrees_qq.png")
qqnorm(df$trees_hect_bear, pch = 1, frame = FALSE)
qqline(df$trees_hect_bear, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$trees_hect_bear)
"data:  df$trees_hect_bear
W = 0.91545, p-value = 3.225e-06"

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
"data:  df$median_et
W = 0.98428, p-value = 0.315

ET APPEARS TO BE NORMAL!"

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
"data:  df$temp_c
W = 0.90484, p-value = 1.616e-06"

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
"data:  df$rel_humid
W = 0.9446, p-value = 0.0002771"

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
"data:  df$wind_speed
W = 0.92612, p-value = 2.13e-05"

# avg unemployment (thousand)
jpeg(file="images/unemp_hist.png")
hist(df$avg_unemp_perc)
dev.off()

jpeg(file="images/unemp_qq.png")
qqnorm(df$avg_unemp_perc, pch = 1, frame = FALSE)
qqline(df$avg_unemp_perc, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(df$avg_unemp_perc)
"data:  df$avg_unemp_perc
W = 0.93091, p-value = 0.001095"

# explore summary statistics

summary(df$avg_unemp_perc)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  4.125   6.800   7.925   8.881  11.425  14.100      48 "

summary(df$median_et)
" Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  815.6   979.7  1054.5  1049.6  1118.9  1277.0      20 "

summary(df$wind_speed)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  4.752   5.611   6.008   6.400   7.363   8.345      11"

summary(df$rel_humid)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  62.45   71.17   75.82   74.37   78.02   83.24      11"

summary(df$nonbear_mill_trees)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
    466     679    1052     995    1185    1510       5"

summary(df$bear_mill_trees)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
   4465    5640    5738    5648    5810    6200       5"

summary(df$nonbear_thous_hect)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
  148.0   205.0   307.0   298.1   347.0   495.0       5"

summary(df$bear_thous_hect)
"Min. 1st Qu.  Median    Mean 3rd Qu.    Max.    NA's 
   2010    2070    2135    2146    2223    2360       5 "

# explore box-plots (by region)
# non-bearing (TODO)
jpeg(file="images/boxplot.png")
boxplot(df$million_60kgs_bag~df$subdivision)
dev.off()

## bivariate analysis ## 

ndf <- df[order(df$year),] 
# get only arabica, since thats the majority of beans
ndf <- ndf %>% filter(type=="Arabica")

# plot line plot of interesting features
# standardize coffee --> million bags to thousand bags

# line plots
# arabica
jpeg(file="images/arabica_lineplot.png")
ggplot(data = ndf, aes(x=year, y=million_60kgs_bag)) + geom_line(aes(color = subdivision)) 
dev.off()

#et
jpeg(file="images/et_lineplot.png")
ggplot(data = ndf, aes(x=year, y=median_et)) + geom_line(aes(color = subdivision)) 
dev.off()

# plot avg et over years
jpeg(file="images/avg_et_lineplot.png")
et_avg <- aggregate( median_et ~ year , ndf , mean )
ggplot(data = et_avg, aes(x=year, y=median_et)) + geom_line() 
dev.off()

# unemployment
jpeg(file="images/umemp_lineplot.png")
ggplot(data = ndf, aes(x=year, y=avg_unemp_perc)) + geom_line(aes(color = subdivision)) 
dev.off()

# humidity
jpeg(file="images/humid_lineplot.png")
ggplot(data = ndf, aes(x=year, y=rel_humid)) + geom_line(aes(color = subdivision)) 
dev.off()

# plot avg humidity over years
jpeg(file="images/avg_humid_lineplot.png")
humid_avg <- aggregate( rel_humid ~ year , ndf , mean )
ggplot(data = humid_avg, aes(x=year, y=rel_humid)) + geom_line() 
dev.off()

# temp
jpeg(file="images/temp_lineplot.png")
ggplot(data = ndf, aes(x=year, y=temp_c)) + geom_line(aes(color = subdivision)) 
dev.off()

# plot avg temp across years
jpeg(file="images/avg_temp_lineplot.png")
et_avg <- aggregate( temp_c ~ year , ndf , mean )
ggplot(data = et_avg, aes(x=year, y=temp_c)) + geom_line() 
dev.off()

# bar plots
jpeg(file="images/arabica_barplot.png")
ggplot(ndf, aes(fill=subdivision, x=year, y=million_60kgs_bag)) +
  geom_bar(position="stack", stat="identity") 
dev.off()

jpeg(file="images/unemp_barplot.png")
ggplot(ndf, aes(fill=subdivision, x=year, y=avg_unemp_perc)) +
  geom_bar(position="dodge", stat="identity") 
dev.off()

# plot avg production over years
jpeg(file="images/avg_prod_lineplot.png")
prod_avg <- aggregate( million_60kgs_bag ~ year , ndf , mean )
ggplot(data = prod_avg, aes(x=year, y=million_60kgs_bag)) + geom_line() 
dev.off()

# plot avg growth over years
jpeg(file="images/avg_growth_lineplot.png")
growth_avg <- aggregate( trees_hect_bear ~ year , ndf , mean )
ggplot(data = growth_avg, aes(x=year, y=trees_hect_bear)) + geom_line() 
dev.off()

# plot avg non-growth over years
jpeg(file="images/avg_nongrowth_lineplot.png")
growth_avg <- aggregate( trees_hect_nonbear ~ year , ndf , mean )
ggplot(data = growth_avg, aes(x=year, y=trees_hect_nonbear)) + geom_line() 
dev.off()


# explore scatter plots for et 
et <- df
etdf <- et[order(et$year),] 
# get only arabica
etdf <- etdf %>% filter(type=="Arabica")

mget <- etdf %>% filter(subdivision == "Minas Gerais")
saet <- etdf %>% filter(subdivision == "Sao Paulo")
eset <- etdf %>% filter(subdivision == "Espirito Santo")
paet <- etdf %>% filter(subdivision == "Parana")

# median et (kg/m^2 sum)
jpeg(file="images/etARABICA_hist.png")
hist(etdf$median_et)
dev.off()

jpeg(file="images/etARABICA_qq.png")
qqnorm(etdf$median_et, pch = 1, frame = FALSE)
qqline(etdf$median_et, col = "steelblue", lwd = 2)
dev.off()

# check shapiro-wilkes test
shapiro.test(etdf$median_et)
"data:  etdf$median_et
W = 0.98489, p-value = 0.5047"

# total 
# weather vs prod
jpeg(file="images/et_prod.png")
ggplot(et, aes(x=median_et, y=million_60kgs_bag)) + geom_point(aes(color = subdivision))
dev.off()

jpeg(file="images/humid_prod.png")
ggplot(et, aes(x=rel_humid, y=million_60kgs_bag)) + geom_point(aes(color = subdivision))
dev.off()

jpeg(file="images/temp_prod.png")
ggplot(et, aes(x=temp_c, y=million_60kgs_bag)) + geom_point(aes(color = subdivision))
dev.off()

# weather vs weather
jpeg(file="images/et_temp.png")
ggplot(et, aes(x=temp_c, y=median_et)) + geom_point(aes(color = subdivision))
dev.off()

jpeg(file="images/et_humid.png")
ggplot(et, aes(x=rel_humid, y=median_et)) + geom_point(aes(color = subdivision))
dev.off()

jpeg(file="images/et_wind.png")
ggplot(et, aes(x=wind_speed, y=median_et)) + geom_point(aes(color = subdivision))
dev.off()

jpeg(file="images/humid_wind.png")
ggplot(et, aes(x=rel_humid, y=wind_speed)) + geom_point(aes(color = subdivision))
dev.off()

jpeg(file="images/temp_wind.png")
ggplot(et, aes(x=temp_c, y=wind_speed)) + geom_point(aes(color = subdivision))
dev.off()

jpeg(file="images/temp_humid.png")
ggplot(et, aes(x=temp_c, y=rel_humid)) + geom_point(aes(color = subdivision))
dev.off()

# weather vs growth
# et and bearing
jpeg(file="images/et_trees.png")
ggplot(et, aes(x=median_et, y=bear_mill_trees)) + geom_point()
dev.off()

jpeg(file="images/et_hect.png")
ggplot(et, aes(x=median_et, y=bear_thous_hect)) + geom_point()
dev.off()

jpeg(file="images/et_treeshect.png")
ggplot(et, aes(x=median_et, y=trees_hect_bear)) + geom_point()
dev.off()

# et and non-bearing
jpeg(file="images/et_nontrees.png")
ggplot(et, aes(x=median_et, y=nonbear_mill_trees)) + geom_point()
dev.off()

jpeg(file="images/et_nonhect.png")
ggplot(et, aes(x=median_et, y=nonbear_thous_hect)) + geom_point()
dev.off()

jpeg(file="images/et_nontreeshect.png")
ggplot(et, aes(x=median_et, y=trees_hect_nonbear)) + geom_point()
dev.off()

jpeg(file="images/humid_trees.png")
ggplot(et, aes(x=rel_humid, y=bear_mill_trees)) + geom_point()
dev.off()

jpeg(file="images/humid_hect.png")
ggplot(et, aes(x=rel_humid, y=bear_thous_hect)) + geom_point()
dev.off()

jpeg(file="images/humid_treeshect.png")
ggplot(et, aes(x=rel_humid, y=trees_hect_bear)) + geom_point()
dev.off()

jpeg(file="images/temp_trees.png")
ggplot(et, aes(x=temp_c, y=bear_mill_trees)) + geom_point()
dev.off()

jpeg(file="images/temp_hect.png")
ggplot(et, aes(x=temp_c, y=bear_thous_hect)) + geom_point()
dev.off()

jpeg(file="images/temp_treeshect.png")
ggplot(et, aes(x=temp_c, y=trees_hect_bear)) + geom_point()
dev.off()

# make heat plot
# use clean data for heat map
clean <- read.csv("data/csv/ml_data/br_clean_emp.csv")
corr_cols <- subset(clean, select = c(million_60kgs_bag, bear_mill_trees, bear_thous_hect, temp_c, rel_humid, median_et, avg_unemp_perc)) 
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
jpeg(file="images/minais_etkg.png")
ggplot(mget, aes(x=median_et, y=bear_thous_hect)) + geom_point()
dev.off()

# es
jpeg(file="images/espirito_etkg.png")
ggplot(eset, aes(x=median_et, y=bear_thous_hect)) + geom_point()
dev.off()

# pa
jpeg(file="images/parana_etkg.png")
ggplot(paet, aes(x=median_et, y=bear_thous_hect)) + geom_point()
dev.off()

# pa
jpeg(file="images/sao_etkg.png")
ggplot(saet, aes(x=median_et, y=bear_thous_hect)) + geom_point()
dev.off()

# scatter
jpeg(file="images/scatter.png")
ndf_numeric <- subset(ndf, select = c(million_60kgs_bag, median_et, temp_c, wind_speed))
pairs(ndf_numeric , upper.panel = NULL)
dev.off()


