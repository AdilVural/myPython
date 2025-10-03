# ---------------------------
# Erasmus Q-Intelligence B.V.
# ---------------------------

library("dplyr")
library("ggplot2")

# -----------------
# Customizing plots
# -----------------

### first exercise: patents data
patents <- readRDS("../../data/patents.Rds")

## densityplot of transformed total number of patents
ggplot(patents, aes(x = logtotal, color = densitycat)) + geom_density()

## black fill color with transparancy
ggplot(patents, aes(x = logtotal, color = densitycat)) +
  geom_density(fill = "black", alpha = 0.1)

## scatterplots of transformed total number of patents vs logarithm of
## population density
ggplot(patents, aes(x = logdensity, y = logtotal, fill = governor)) +
  geom_point(shape = 21, size = 3)

## same plot with different plot symbol
ggplot(patents, aes(x = logdensity, y = logtotal, color = governor)) +
  geom_point(shape = 16, size = 3)

## conditional boxplots with colored boxes
# legend does not add new information
ggplot(patents, aes(x = densitycat, y = logtotal, fill = densitycat)) +
  geom_boxplot()
# there's a fix for this
ggplot(patents, aes(x = densitycat, y = logtotal, fill = densitycat)) +
  geom_boxplot(show.legend = FALSE)

## variable width
ggplot(patents, aes(x = densitycat, y = logtotal, fill = densitycat)) +
  geom_boxplot(varwidth = TRUE)

### second exercise: msleep data
data(msleep, package = 'ggplot2')

## scatterplot of sleep_total vs sleep_rem with default color scale
p <- ggplot(msleep, aes(x = sleep_total, y = sleep_rem, color = vore)) + 
  geom_point(shape = 15, size = 2)
p

## manual color scale
colors <- c('darkred', 'darkgreen', 'black', 'lightblue')
p + scale_color_manual(values = colors)
# there's a fix for this
p + scale_color_manual(values = colors, na.value = "snow3")

## printer-friendly
p + theme_minimal()

## categorize eduction
range(msleep$sleep_total)
breaks <- seq(0, 20, by = 5)
msleep <- msleep %>% mutate(sleep_cut = cut(sleep_total, breaks))

## stacked barplot of education category by occupation type
p <- ggplot(msleep, aes(x = vore, fill = sleep_cut)) + geom_bar() + coord_flip()
p

## nicer labels
# note that axis labels need to be defined as if the coordinates were not
# flipped
p + labs(x = "Type", y = "Frequency") + 
  scale_fill_manual(values = stringr::str_c('lightskyblue', 1:4)) +
    scale_x_discrete(na.translate = FALSE)

## bars next to each other and horizontal
p <- ggplot(msleep, aes(x = vore, fill = sleep_cut)) +
  geom_bar(position = "dodge") + coord_flip()
p

### third exercise: patents data
patents <- readRDS('../../data/patents.Rds')

## boxplot of logdensity
ggplot(patents, aes(x = "", y = logdensity)) + geom_boxplot() +
  labs(x = NULL, y = "Logarithm of population density")

## scatterplot of logtotal vs logdensity
# determine cut-off values
quartiles <- quantile(patents$logdensity, probs = c(0.25, 0.75))
cutoff <- quartiles + c(-1, 1) * 1.5 * diff(quartiles)
# produce scatterplot with reference lines
p <- ggplot() +
  geom_vline(aes(xintercept = cutoff), color = "grey") +
  geom_point(aes(x = logdensity, y = logtotal),
             data = patents, size = 3)
p

## change axis limits and labels
xlimits <- range(patents$logdensity) + c(-0.5, 0.5)
ylimits <- range(patents$logtotal) + c(-0.5, 0.5)
p + xlim(xlimits) + ylim(ylimits) +
  labs(x = "Logarithm of population density",
       y = "Logarithm of total number of patents")

## scatterplot without outliers
ggplot(patents, aes(x = logdensity, y = logtotal)) +
  geom_point(size = 3) + geom_smooth(method = "lm")

## different color for the scatterplot smoother
ggplot(patents, aes(x = logdensity, y = logtotal)) +
  geom_point(size = 3) + geom_smooth(method = "lm", color = "magenta")

# fourth exercise: vwgolf
# a
# load data
vwgolf <- readRDS("../../data/vwgolf.Rds")

# b
# basis scatterplot
ggplot(vwgolf, aes(x = PriceNew, y = AskingPrice)) + geom_point()

# c
# color depending on mileage and size depending on top speed
p <- ggplot(vwgolf, aes(x = PriceNew, y = AskingPrice,
                        fill = Mileage, size = TopSpeed)) +
  geom_point(shape = 21)
p

# d
# change color range
p <- p + scale_fill_continuous(low = "white", high = "red")
p

# e/f
# add annotation
p <- p + labs(title = "Asking Price versus New Price",
              subtitle = "56 second-hand VW Golfs from Marktplaats.nl",
              x = "New Price (euro)", y = "Asking Price (euro)")
p
