# transform modis into yearly and join on growth for comparison

br_growth <- read.csv("data/csv/growth/coffee_growth_br.csv")
br_mod <- read.csv("data/csv/et/brmod16_stats.csv")

# get yearly average
br_mod$Year <- format(as.Date(br_mod$Date, format="%Y-%m-%d"),"%Y")

# calc 8-day mean avg for each year (YEAR-ROUND)
yearly_et_br <- aggregate(br_mod$Mean, list(br_mod$Year), FUN=mean) 

# rename cols
colnames(yearly_et_br)[2] ="mean_et"

# join growth on et
df_year <- merge(x = yearly_et_br, y = yearly_et_br, by = "CustomerId", all = TRUE)