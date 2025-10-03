# ----------------------
# Erasmus Q-Intelligence
# ----------------------

# data
data('iris')
?iris
forsale <- readRDS('../../data/forsale.Rds')

## software requirements
library(dplyr)
library(ggplot2)

# -------------------------
# First data interpretation
# -------------------------

## overview
head(iris, n = 10)
tail(iris, n = 10)
summary(iris)

## data dimensions
dim(iris)
nrow(iris)
ncol(iris)

## names
colnames(iris)
rownames(iris)

## frequency
table(iris$Species)

# ----------------------
# Descriptive statistics
# ----------------------

## minimum and maximum
# separately
min(iris$Sepal.Length)
max(iris$Sepal.Length)
# together
range(iris$Sepal.Length)

## quantiles
quantile(iris$Sepal.Length)
quantile(iris$Sepal.Length, probs = c(0.05, 0.25, 0.5, 0.75, 0.95))

## mean and median
mean(iris$Sepal.Length)
median(iris$Sepal.Length)

## dispersion
sd(iris$Sepal.Length)
var(iris$Sepal.Length)

# keep only numeric variables in data set
iris_num <- select(iris, where(is.numeric))

# covariance
cov(iris_num)
# correlation
cor(iris_num)

# distribution
summary(forsale$living_area)
summary(log(forsale$living_area))

ggplot(forsale, aes(x = living_area)) + geom_histogram(bins = 30)
ggplot(forsale, aes(x = log(living_area))) + geom_histogram(bins = 30)