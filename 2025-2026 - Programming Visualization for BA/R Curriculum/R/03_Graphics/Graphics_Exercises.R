# ----------------------
# Erasmus Q-Intelligence
# ----------------------

library("ggplot2")

# --------
# Graphics
# --------

### patents data
patents <- readRDS("../../data/patents.Rds")

## scatterplots
ggplot(patents, aes(x = density, y = total)) + geom_point()
ggplot(patents, aes(x = logdensity, y = logtotal)) + geom_point()

## histograms
ggplot(patents, aes(x = total)) + geom_histogram(bins = 15)
ggplot(patents, aes(x = logtotal)) + geom_histogram(bins = 15)

## density plots
ggplot(patents, aes(x = total)) + geom_density()
ggplot(patents, aes(x = logtotal)) + geom_density()

# boxplot of logdensity
ggplot(patents, aes(x = "", y = logdensity)) + geom_boxplot()

## conditional boxplots
ggplot(patents, aes(x = densitycat, y = total)) + geom_boxplot()
ggplot(patents, aes(x = densitycat, y = logtotal)) + geom_boxplot()

## barplots
# governor
ggplot(patents, aes(x = governor)) + geom_bar()
# area category
ggplot(patents, aes(x = areacat)) + geom_bar()
