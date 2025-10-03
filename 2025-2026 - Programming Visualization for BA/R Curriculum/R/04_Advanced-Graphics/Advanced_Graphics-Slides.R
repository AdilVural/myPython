# ---------------------------
# Erasmus Q-Intelligence B.V.
# ---------------------------

## software requirements
library('dplyr')
library("ggplot2")

## data sets
data(storms, package = 'dplyr')
storms_2015 <- filter(storms, year == 2015)
data(economics, package = 'ggplot2')
eredivisie <- readRDS('../../data/eredivisie.Rds')

# --------
# Reminder
# --------

# scatterplot
ggplot(storms_2015, aes(x = wind, y = pressure)) + geom_point()
# density plot
ggplot(storms_2015, aes(x = wind)) + geom_density()
# time series plot
ggplot(economics, aes(x = date, y = unemploy)) + geom_line()

# -------------------
# Finetuning graphics
# -------------------

## colors
## what color names can be used?
colors()

# scatterplot
ggplot(storms_2015, aes(x = wind, y = pressure)) + geom_point(colour = "red")
# density plot
ggplot(storms_2015, aes(x = wind)) + geom_density(color = "red", fill = "grey")
# time series plot
ggplot(economics, aes(x = date, y = unemploy)) + geom_line(color = "red")

## plot symbols and symbol size
# scatterplot: plot symbols 21-25 allow to specify fill color
ggplot(storms_2015, aes(x = wind, y = pressure)) +
  geom_point(color = "black", fill = "red", shape = 21, size = 3)

## line types and line size
# densityplot
ggplot(storms_2015, aes(x = wind)) +
  geom_density(color = "red", fill = "grey", linetype = 5, linewidth = 1)
# time series plot
ggplot(economics, aes(x = date, y = unemploy)) +
  geom_line(color = "red", linetype = "longdash", linewidth = 1)

## color/plot symbol/line type based on variable
# scatterplot: color according to occupation type
ggplot(storms_2015, aes(x = wind, y = pressure, fill = status)) +
  geom_point(shape = 21, color = "black")
# scatterplot: size according to percentage of women
ggplot(economics, aes(x = uempmed, y = unemploy, size = psavert)) +
  geom_point(shape = 21, color = "black", fill = "red")
# density plot: color according to occupation type
# not very readable due to solid fill color
ggplot(storms_2015, aes(x = pressure, color = status)) +
  geom_density(fill = "grey")
# with transparancy
ggplot(storms_2015, aes(x = pressure, color = status)) +
  geom_density(fill = "grey", alpha = 0.35)
# time series point: colored lines for different teams
ggplot(eredivisie, aes(x = Year, y = Points, color = Team)) + geom_line()

## manual scales
# scatterplot: default point symbols
ggplot(storms_2015, aes(x = wind, y = pressure, shape = status)) +
  geom_point()
# scatterplot: custom point symbols via index
ggplot(storms_2015, aes(x = wind, y = pressure, shape = status)) +
  geom_point() + scale_shape_manual(values = 1:6)
# scatterplot: custom point symbols via characters
kleuren <- c("darkblue", "darkgreen", "darkred", "orange", "brown", "purple")
ggplot(storms_2015, aes(x = wind, y = pressure, shape = status, color = status)) +
  geom_point(size = 3) +
  scale_shape_manual(values = c("e", "h", "o", "s", "d", "z")) +
  scale_color_manual(values = kleuren)
# time series plot: default colors
ggplot(eredivisie, aes(x = Year, y = Points, color = Team)) +
  geom_line()
# time series plot: custom colors
ggplot(eredivisie, aes(x = Year, y = Points, color = Team)) +
  geom_line() + scale_color_manual(values = c("black", "red"))

## continuous scales
# scatterplot: default colors
ggplot(economics, aes(x = uempmed, y = unemploy, fill = psavert)) +
  geom_point(shape = 21, color = "black", alpha = 0.5)
# scatterplot: custom colors
ggplot(economics, aes(x = uempmed, y = unemploy, fill = psavert)) +
  geom_point(shape = 21, color = "black", alpha = 0.5) +
  scale_fill_continuous(low = "white", high = "magenta")

## removing legends
# barplot: default with legend
ggplot(storms_2015, aes(x = status, fill = status)) +
  geom_bar()
# barplot: remove legend
ggplot(storms_2015, aes(x = status, fill = status)) +
  geom_bar(show.legend = FALSE)
# conditional boxplot: default with legend
ggplot(storms_2015, aes(x = status, y = wind, fill = status)) +
  geom_boxplot()
# conditional boxplot: remove legend
ggplot(storms_2015, aes(x = status, y = wind, fill = status)) +
  geom_boxplot(show.legend = FALSE)

## flipping coordinates
## barplot
# specify x-axis and flip coordinates
ggplot(storms_2015, aes(x = status, fill = status)) +
  geom_bar(show.legend = FALSE) +
    coord_flip()
    
## conditional boxplot
# specify continuous variable on y-axis and flip coordinates
ggplot(storms_2015, aes(x = status, y = wind, fill = status)) +
  geom_boxplot(show.legend = FALSE) + coord_flip()

## printer friendly theme
# default theme
ggplot(storms_2015, aes(x = pressure, color = status)) +
  geom_density(fill = "grey", alpha = 0.35)
# white background
ggplot(storms_2015, aes(x = pressure, color = status)) +
  geom_density(fill = "grey", alpha = 0.35) + theme_minimal()

## axis limits
# default axis limits
ggplot(eredivisie, aes(x = Year, y = Points, color = Team)) +
  geom_line() + scale_color_manual(values = c("black", "red"))
# custom y-axis limits
ggplot(eredivisie, aes(x = Year, y = Points, color = Team)) +
  geom_line() + scale_color_manual(values = c("black", "red")) +
  ylim(0, 102)

# ---------------
# Adding to plots
# ---------------

## adding scatterplot smoothers
# ggplot2 gets confused about the legend
ggplot(economics, aes(x = uempmed, y = unemploy, fill = psavert)) +
  geom_point(shape = 21, color = "black") +
  scale_fill_continuous(low = 'white', high = 'magenta') +
  geom_smooth(method = "lm")
# suppress legend only for smoother
ggplot(economics, aes(x = uempmed, y = unemploy, size = psavert)) +
  geom_point(shape = 21, color = "black") +
  scale_fill_continuous(low = 'white', high = 'magenta') +
  geom_smooth(color = "black", method = "lm", show.legend = FALSE)

## time series plot: plotting both points and lines
# time series plot: lines only
ggplot(eredivisie, aes(x = Year, y = Points, color = Team)) +
  ylim(0, 102) + geom_line() +
  scale_color_manual(values = c("black", "red"))
# both
ggplot(eredivisie, aes(x = Year, y = Points)) +
  ylim(0, 102) + geom_line(aes(color =)) + geom_point(size = 2) +
  scale_color_manual(values = c("black", "red"))

## adding vertical lines
# without reference line
ggplot(economics, aes(x = date, y = unemploy/pop)) + 
  geom_line(color = '#9aad88')
# with reference line
ggplot(economics, aes(x = date, y = unemploy/pop)) + 
  geom_line(color = '#9aad88') + 
  geom_vline(aes(xintercept = as.Date('1980-01-01')), 
             linetype = 'dashed') + 
  geom_hline(aes(yintercept = 0.04), size = 2)
