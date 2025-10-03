# ---------------------------
# Erasmus Q-Intelligence B.V.
# ---------------------------

## install packages from CRAN: command line
install.packages('ggplot2')
install.packages('dplyr')
?install.packages

## load installed packages
library("ggplot2")
library('dplyr')

## view R help files
# help for the help() function
?help
help("help")
# list all help topics within a package
help(package = "tidyverse")
# run examples from a help file
example("mean")

## load data sets from packages
## example: prestige of Canadian occupations
# load data from a package that is already loaded
data("storms")
?storms
# from a package that is installed, but not loaded
data("storms", package = "dplyr")
# list all data sets of an installed package
data(package = "dplyr")

## view data sets
# type name of the data set
storms
# view first rows of data
head(storms, n = 10)
?head
# view last rows of data
tail(storms)
# summarize data
summary(storms)
