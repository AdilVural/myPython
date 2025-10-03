# ----------------------
# Erasmus Q-Intelligence
# ----------------------

## load installed packages
library("ggplot2")
library("dplyr")

# data
data(storms, package = "dplyr")
?storms

## the usual suspect
# scatterplot matrix for data frame
plot(storms)

## scatterplot
ggplot(storms, aes(x = wind, y = pressure))
ggplot(storms, aes(x = wind, y = pressure)) + geom_point()

## histogram
ggplot(storms, aes(x = wind)) + geom_histogram()
ggplot(storms, aes(x = wind)) + geom_histogram(bins = 15)

## density plot
ggplot(storms, aes(x = wind)) + geom_density()

## normal quantile-quantile plot
ggplot(storms, aes(sample = wind)) + geom_qq()

## boxplot
# doesn't work: boxplot always requires to specify x-axis
ggplot(storms, aes(y = wind)) + geom_boxplot()
# works: empty label on x-axis
ggplot(storms, aes(x = "", y = wind)) + geom_boxplot()

## conditional boxplot
ggplot(storms, aes(x = status, y = wind)) + geom_boxplot()

## barplot
ggplot(storms, aes(x = status)) + geom_bar()

## example: economics dataset
data(economics, package = 'ggplot2')
?economics

## plot univariate time series
ggplot(economics, aes(x = date, y = unemploy)) + geom_line()