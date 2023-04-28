coffee <- read.csv("data/csv/ml_data/br_clean_noemp.csv")

# remove unneeded columns
coffee_tr <- subset(coffee, select = -c(country, bear_thous_hect, nonbear_thous_hect,
                                        nonbear_mill_trees,trees_hect_bear, trees_hect_nonbear,
                                        bear_mill_trees, year))

# scale million_kgs_bags, since regiosn produce a different scale of bags
#coffee_tr$million_60kgs_bag <- scale(coffee_tr$million_60kgs_bag)    

# only consider arabica bean
coffee_tr <- coffee_tr %>% filter(type=="Arabica")

coffee_tr <- subset(coffee_tr, select = -c(type))

write.csv(coffee_tr, "data/csv/ml_data/br_nocat.csv", row.names=FALSE)
