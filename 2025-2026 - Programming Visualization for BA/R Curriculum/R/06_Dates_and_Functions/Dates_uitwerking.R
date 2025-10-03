### WERKEN MET DATUMS EN TIJDEN ###
load("flights.RData")

str(flights) # De eerste vier kolommen zijn nu van het type character
mean(flights$sched_arr_time) # kan niet

install.packages('lubridate')
library(lubridate) # Laad de lubridate package
ymd(flights$dep_time) # Kan hier niet, R herkent geen year-month-day format

flights$dep_time <- ymd_hm(flights$dep_time)
flights$sched_dep_time <- ymd_hm(flights$sched_dep_time)
flights$arr_time <- ymd_hm(flights$arr_time)
flights$sched_arr_time <- ymd_hm(flights$sched_arr_time)

# Gebruik regels hieronder als bovenstaande 4 regels niet werken:
#flights$dep_time <- parse_date_time(flights$dep_time, "%Y-%m-%d %H:%M")
#flights$sched_dep_time <- parse_date_time(flights$sched_dep_time, "%Y-%m-%d %H:%M")
#flights$arr_time <- parse_date_time(flights$arr_time, "%Y-%m-%d %H:%M")
#flights$sched_arr_time <- parse_date_time(flights$sched_arr_time, "%Y-%m-%d %H:%M")

str(flights) # De eerste vier kolommen zijn nu van het type POSIXct
mean(flights$sched_arr_time) # kan nu wel

flights$dep_time[1] 
flights$dep_time[1] + 2       # We kunnen seconden optellen bij een datum
flights$dep_time[1] + days(2) # ... of dagen
flights$dep_time[1] * 2       # Niet alle wiskundige operaties zijn mogelijk

flights$arr_time[1] - flights$dep_time[1] # tijdsverschillen berekenen

wday(flights$dep_time)              # achterhaal de weekdag
wday(flights$dep_time, label=TRUE)  # weekdagen zijn nu als tekst gelabeld

flights$air_time <- flights$arr_time - flights$dep_time

mean(flights$air_time) # NA?

sum(is.na(flights$air_time)) 
av_airtime <- mean(flights$air_time, na.rm = TRUE)  # Negeer missende waarden
av_airtime                                          # vluchttijd in minuten
av_airtime/dhours(1)                                # vluchttijd in uren

### OPLOSSING OEFENING 1 ###
flights$arr_delay <- flights$arr_time - flights$sched_arr_time
jfk_delays <- flights$arr_delay[flights$origin == "JFK"]
jfk_delays2 <- flights[flights$origin == "JFK",]$arr_delay
mean(jfk_delays, na.rm = TRUE)/dminutes(1) # vertraging in minuten

library(tidyverse)
load("flights.RData")
flights %>% 
  mutate(arr_time = ymd_hm(arr_time),
         sched_arr_time = ymd_hm(sched_arr_time),
         dep_time = ymd_hm(dep_time),
         sched_dep_time = ymd_hm(sched_dep_time),
         arr_delay = arr_time - sched_arr_time,
         dep_delay = dep_time - sched_dep_time) %>%
  filter(!is.na(arr_delay)) %>%
  group_by(dest) %>%
  summarize(av_arrival_delay = mean(arr_delay)/dminutes(1),
            av_departure_delay = mean(dep_delay)/dminutes(1),
            n_flights = n()) %>%
  arrange(desc(av_arrival_delay))

load("flights.RData")
flights %>% 
  mutate(arr_time = ymd_hm(arr_time),
         sched_arr_time = ymd_hm(sched_arr_time),
         dep_time = ymd_hm(dep_time),
         sched_dep_time = ymd_hm(sched_dep_time),
         arr_delay = arr_time - sched_arr_time,
         dep_delay = dep_time - sched_dep_time) %>%
  filter(!is.na(arr_delay)) %>%
  group_by(dest) %>%
  summarize(av_arrival_delay = mean(arr_delay),
            av_departure_delay = mean(dep_delay),
            n_flights = n()) %>%
  arrange(desc(av_arrival_delay))
