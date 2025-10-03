
#################### NORMAL BUBBLE PLOT  #######################

library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(plotly)
library(viridis)
library(hrbrthemes)
library(htmlwidgets)
library(ggthemes)

load('flights.RData')
factor(flights$carrier)
 

flights %>%
  mutate(arr_time = ymd_hm(arr_time),
         sched_arr_time = ymd_hm(sched_arr_time),
         dep_time = ymd_hm(dep_time),
         sched_dep_time = ymd_hm(sched_dep_time),
         arr_delay = arr_time - sched_arr_time,
         dep_delay = dep_time - sched_dep_time,
         flights_delayed = arr_delay > 0) %>%
  filter(!is.na(arr_delay)) %>%
  group_by(carrier) %>%
  summarize(av_arrival_delay = mean(arr_delay)/dminutes(1),
            perc_flights_delayed = (sum(flights_delayed)/n()*100),
            n_flights=n()) %>%
  ggplot() + geom_point(aes(x=av_arrival_delay, y=perc_flights_delayed, colour = carrier, size = n_flights, alpha=0.9)) + 
  scale_size(range = c(3, 12), name="Number of flights") +
  geom_text_repel(aes(x=av_arrival_delay, y=perc_flights_delayed, label = carrier)) +
  scale_x_continuous(expand = c(0, 0), limits=c(-10,24), breaks=seq(-10,25,2), name = "Average arrival delay (min)") + 
  scale_y_continuous(expand = c(0, 0), limits=c(25,65), breaks=seq(20,70,10), name = "% flights delayed on arrival") +
  ggtitle('Carrier performance') + 
  theme_economist() + theme(legend.position="right") + guides(col = guide_legend(ncol = 2))

#################### INTERACTIVE PLOT  #######################

library(tidyverse)
library(lubridate)
library(ggplot2)
library(ggrepel)
library(dplyr)
library(plotly)
library(viridis)
library(hrbrthemes)
library(htmlwidgets)

load('flights.RData')
factor(flights$carrier)

p <- flights %>%
  mutate(arr_time = ymd_hm(arr_time),
         sched_arr_time = ymd_hm(sched_arr_time),
         dep_time = ymd_hm(dep_time),
         sched_dep_time = ymd_hm(sched_dep_time),
         arr_delay = arr_time - sched_arr_time,
         dep_delay = dep_time - sched_dep_time,
         flights_delayed = arr_delay > 0) %>%
  filter(!is.na(arr_delay)) %>%
  group_by(carrier) %>%
  summarize(av_arrival_delay = mean(arr_delay)/dminutes(1),
            perc_flights_delayed = (sum(flights_delayed)/n()*100),
            n_flights=n()) %>%
  ggplot() + 
  geom_point(aes(colour = carrier, x=av_arrival_delay, y=perc_flights_delayed, size = n_flights, alpha = 0.95, text = paste("Carrier: ", carrier, "\nTotal flights: ", n_flights, "\nDelayed flights (%): ", perc_flights_delayed, "\nArrival delay (min): ", av_arrival_delay))) + 
  scale_size(range = c(3, 12), name="Number of flights") +
  scale_x_continuous(expand = c(0, 0), limits=c(-10,24), breaks=seq(-10,25,2), name = "Average arrival delay (min)") + 
  scale_y_continuous(expand = c(0, 0), limits=c(25,65), breaks=seq(20,70,10), name = "% flights delayed on arrival") +
  ggtitle('Carrier performance') + 
  theme_economist() + theme(legend.position="right") + guides(col = guide_legend(ncol = 2))
p

pp <- ggplotly(p, tooltip = 'text')
pp
