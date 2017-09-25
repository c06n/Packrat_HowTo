# Initializing Packrat
packrat::init()

# tidyverse
library(dplyr)
library(ggplot2)

demo <- mtcars %>%
  mutate(type = row.names(.)) %>%
  select(type, everything()) %>%
  filter(mpg > 16) %>%
  glimpse

ggplot(demo, aes(as.factor(cyl), mpg)) + geom_boxplot()
ggplot(demo, aes(wt, mpg)) + geom_smooth()

# data.table
library(data.table)
demo_dt <- as.data.table(demo)
demo_dt[, cyl := cyl + 1]

# Export the whole thing into a single tar archive
packrat::bundle(file = '~/projects/R_pkg_dev/Packrat_HowTo/export.tar.gz', overwrite = TRUE)
