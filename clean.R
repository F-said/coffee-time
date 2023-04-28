# load data
coffee <- read.csv("data/csv/ml_data/br_final.csv")

# remove null rows 
na_rows <- is.na(coffee$wind_speed)
coffee_tr <- coffee[!na_rows, ]

na_rows <- is.na(coffee_tr$temp_c)
coffee_tr <- coffee_tr[!na_rows, ]

na_rows <- is.na(coffee_tr$rel_humid)
coffee_tr <- coffee_tr[!na_rows, ]

na_rows <- is.na(coffee_tr$median_et)
coffee_tr <- coffee_tr[!na_rows, ]

na_rows <- is.na(coffee_tr$nonbear_mill_trees)
coffee_tr <- coffee_tr[!na_rows, ]

# remove max and mean et
coffee_tr<- subset(coffee_tr, select = -c(max_et, mean_et))
# remove avg unemp
coffee_noemp <- subset(coffee_tr, select = -c(avg_unemp_perc))

# remove outliers

dim(coffee_noemp)

write.csv(coffee_noemp, "data/csv/ml_data/br_clean_noemp.csv", row.names=FALSE)

na_rows <- is.na(coffee_tr$avg_unemp_perc)
coffee_emp <- coffee_tr[!na_rows, ]

dim(coffee_emp)

write.csv(coffee_emp, "data/csv/ml_data/br_clean_emp.csv", row.names=FALSE)

