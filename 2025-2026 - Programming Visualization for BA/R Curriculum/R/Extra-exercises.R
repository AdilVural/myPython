########################
# Erasmus Q-Intelligence
########################

# Extra exercise

# In this exercise we use the dataset 'gapminder' from the 'gapminder'-package.
# It is an excerpt of the Gapminder data on life expectancy, GDP per capita, and 
# population by country.

# Q1 - Introduction
# a) Open this script in R-Studio. Make sure you save this script to a convenient 
# place (not 'Downloads'!). Further, make sure your working directory is the same 
# as where this .R-script is stored.

# b) Install the package 'gapminder' and write the code that is needed down here.


# c) Load the package 'gapminder' to your current R-session, such that functions 
# and datasets from the package can be used.


# d) Get a list of data that is available in the 'gapminder'-package.


# e) Load the dataset 'gapminder' from the 'gapminder'-package.


# f) Take a look at the help file of this dataset to have a first view on your data.


# Q2 - Descriptives
# a) Use the function head(), tail() and summary() to get a second view on your data.
# Change the number of rows shown in head() and tail().


# b) Use a function to get the number of rows and columns in the dataset.


# c) Show in a table how many observations there are by continent. Next, show in 
# a two-way table how many observations there are by continent, by year. Check the 
# help-file of table() if needed.


# d) Get a view on the distribution of life expectancy by showing the following set
# of quantiles: c(0, 0.01, 0.05, 0.1, 0.25, 0.5, 0.75, 0.9, 0.95, 0.99, 1). What does it tell you?


# e) Get the correlation matrix of the numeric variables in the dataset. Since not
# in the material yet, use the following code to select the variables of interest:
gapminder_num <- dplyr::select(gapminder, lifeExp, pop, gdpPercap)
# Elaborate on the correlation between lifeExp and gdpPercap


# A flaw in the above investigations is that we have observations over the years, 
# and now take them all together. It would be interesting to see differences over 
# the years: something for the next exercises of visualization and of a later topic 
# in the course (05_Data-Wrangling).

# Q3 - Graphics
# a) Get a third view of the data by using the function plot() on the dataset. Use
# the Zoom-button to see that it is still not very informative.


# b) Load the ggplot2-package that make your own visualizations


# c) Visualize the relation between GDP per capita and life expectancy in a scatter 
# plot using ggplot2.


# d) Visualize the distribution of life expectancy using a boxplot and differentiate 
# over year.

# You probably got a warning message, since geom_boxplot() expects a non-continuous
# variable for the x-axis. Use as.character(year) instead.

# Interpret the visualization.

# e) Visualize the distribution of GDP per capita using a histogram. Play with the 
# number of bins.

# The distribution of GDP per capita is very skewed. Visualize a log()-transformation
# instead to find a clearer view, not only on the extreme outliers.


# Q4 - Advanced Graphics
# a) We continue with the visualization from 3c). Visualize the relation between 
# GDP per capita and life expectancy in a scatter plot using ggplot2. Given what 
# we found in 3e), use log(gdpPercap) instead of gdpPercap. Change the shape of 
# the points to 21, the filling of the dots to red, choose an other-than-default
# transparency,change the x-label to 'logarithm of GDP per capita (in US dollars)'
# and the y-label to 'life expectancy (in years)'. 


# b) We continue with the visualization from 4a). Make the filling of the
# dots dependent on continent and use your own manual colors (not the default).
# Play with transparency to clearify your plot. Make color to be 'white'. Use a 
# different pre-set theme.


# c) We continue with the visualization from 3d). Visualize the distribution of 
# life expectancy using a boxplot and differentiate over as.character(year). Make 
# the color of the box dependent on year. Is the legend informative? If not, drop 
# the legend. Add a title to the plot and update the x- and y-labels if necessary. 
# Use a minimal theme.


# d) We continue with the visualization from 4c). We want to use our own colors over
# year. Since year is a continuous variable, scale_color_manual() does not work. 
# Instead, we can use scale_color_gradient(). Check the help-file and add your own 
# color scheme to the plot. Next, update the y-axis, having breaks 30-40-50-...-80
# using scale_y_continuous() - see again the help-file.


# e) EXTRA Instead of a boxplot, where a lot of information is lost, we can create
# a dotplot. Look for the helpfile of geom_dotplot().
# Visualize life expectancy over as.character(year), using only 1957, 1982 and 2007
# (otherwise, the final visualization will be too full). Using the following code:
gapminder_filtered <- filter(gapminder, year %in% c(1957, 1982, 2007))
# Use as arguments in geom_dotplot(): 
# - binaxis = 'y' (which directions should the bins have)
# - stackdir = 'center' (such that we have a 'violin shape')
# what do you see from this visualization?

# Make the filling of the dots dependent on continent (do not using the default 
# colors), color 'white' and play with dotsize. Add 'position = position_dodge(0.8)' 
# as argument, such that the dots of different continents are not placed over each other.
# Use a minimal theme again.

# What can you conclude from the visualization?


# Q5 - Data Wrangling
# Use Pipes (%>%) where possible
# a) Using the original gapminder dataset. Filter only the observations for continent
# Europe, drop the column lifeExp and create a new column which represents GDP (not
# bein GDP per capita)


# b) Only for Netherlands, create a column which shows the five-yearly increase or 
# decrease in gdpPercap. You migth want to use the function ?lag() for this question. 
# Make sure your data is ordered by year before using this lag-function! Visualise 
# the newly created column in a simple time series.


# c) Get, for all countries, the increase in lifeExp from the beginning till the 
# end of the dataset. Which country increased most? Get a subset of countries which
# had a decrease in lifeExp.


# d) Get, only for 2007, for each continent, the country with the highest and the 
# country with the lowest life expectancy.


# Q6-8 - Functions, Iteration and Conditions
# a) Write a function get_vis(data, nation, var) which creates and saves to a .png-file (?ggsave())
# the time series of 'var' for a given 'nation'. Use an if-statement to:
# - print an informative warning if the given 'nation' is not in 'data'
# - print an informative warning if 'var' is not a numeric column in 'data'
# if nation and var are OK, the plot should be made (and if not OK, the plot should not be made!)
# if both 'nation' and 'var' are incorrect, 2 messages should be printed.
# save the plot to a convenient name. Add 'nation' and 'var' to this name using ?str_c() from the stringr-package
# do you need an output value?
# HINT: as we needed to use {{}} in dplyr-functions, you now need the similar !!sym(var) in ggplot2


# b) Iterate the function from a) over a set of 5 countries (chosen by you) for var = lifeExp


# c) Write a function get_avg_lifeExp(data, countries) which calculates the average 
# lifeExp by year of the countries given in the vector 'countries'. The function 
# should return the averages by year of the countries known in the data and print 
# a warning message containing those countries in the given vector which are not 
# in the data. If none of the given countries is available, this should give a warning 
# as well (and no averages).
# HINT: you probably might want to use dplyr-functions in this question.


# d) Execute get_avg_lifeExp() on a set of 5 countries (chosen by you)


# e) BONUS: Get a list countries_by_alphabet from A-Z with all countries in list-element A, B, C ...
# based on the first letter of the country name


# f) BONUS: Iterate get_avg_lifeExp() over the list countries_by_alphabet. From the 
# resulting list of data.frames, get (again by iterating) the average lifeExp in 2007 
#and store those in a vector. What is striking?
