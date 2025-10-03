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

