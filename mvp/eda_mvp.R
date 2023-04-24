library(dplyr)
library(ggplot2)
library(readxl)

# consumption
cons <- read_excel("data/consumption/4b - Disappearance.xlsx")

cons_t <- as.data.frame(t(cons))

cons_t$V41 <- as.numeric(cons_t$V41)

cons_t$V3 <- as.numeric(cons_t$V3)

ggplot(cons_t, aes(x=V3, y=V41)) +
  geom_line()

# production
prod <- read.csv("data/production/coffee-bean-production.csv")

br_prod <- prod %>% filter(Entity=="Brazil")

str(br_prod)

# visualizations
ggplot(br_prod, aes(x=Year, y=Coffee..green...00000656....Production...005510....tonnes)) +
  geom_line()


