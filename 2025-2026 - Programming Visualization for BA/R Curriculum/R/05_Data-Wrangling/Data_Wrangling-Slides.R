# ---------------------------
# Erasmus Q-Intelligence B.V.
# ---------------------------

install.packages("nycflights13")

## software requirements
library("nycflights13")
library("tidyverse")

## data sets
data("flights", package = 'nycflights13')
data(package = 'nycflights13')
?flights
head(flights, n = 5)

# ------
# filter
# ------

## filter rows based on content
flights_mar13 <- filter(flights, month == 3 & day == 13)

head(flights_mar13, n = 5)

flights_q4 <- filter(flights, month == 10 | month == 11 | month == 12)
flights_q4 <- filter(flights, month %in% c(10:12))

flights_no_dep_time <- filter(flights, is.na(dep_time))

# -------
# arrange
# -------

## arrange rows
flights_arranged <- arrange(flights, dep_delay)
xxx <- arrange(flights, carrier)
head(flights_arranged, n = 5)

flights_arranged <- arrange(flights, desc(dep_delay))

# ------
# select
# ------

## select columns based on names
flights_selection <- select(flights, carrier, origin, dest, 
                            dep_delay, arr_delay)
head(flights_selection, n = 5)

flights_selection <- select(flights, carrier:dest)

flights_selection <- select(flights, -(year:day))

flights_reordered <- select(flights, flight, tailnum, carrier, 
                            origin, dest, everything())

?dplyr_tidy_select

flights_time <- select(flights, contains('time'))
head(flights_time, n = 2)

# ------
# mutate
# ------

# (preparation)
flights_selection <- select(flights, 
                            year:day, ends_with('delay'), 
                            air_time)

## mutate or add new columns
flights_gain <- mutate(flights_selection, 
                       gain = dep_delay - arr_delay, 
                       gain_per_minute = gain/air_time)
head(flights_gain, n = 3)

flights_gain <- mutate(flights_gain, 
                       gain_per_hour = gain_per_minute*60, 
                       cum_gain = cummean(gain_per_hour))

flights_gained <- filter(flights_gain, gain > 0)

# ---------
# summarise
# ---------

## make a summary of the data
flights_summary <- summarise(flights, 
                             delay = mean(dep_delay, 
                                          na.rm = TRUE))
flights_summary

## make a summary by group
flights_grouped <- group_by(flights, month, day)
flights_summary <- summarise(flights_grouped, 
                             delay = mean(dep_delay, 
                                          na.rm = TRUE))
head(flights_summary, n = 5)

flights_summary <- summarise(flights_grouped, 
                             delay = mean(dep_delay, 
                                          na.rm = TRUE),
                             first_delay = first(dep_delay),
                             nr_fligths = n())
head(flights_summary, n = 5)

# filter by group
flights_by_day <- group_by(flights, month, day)
flights_most_delay <- filter(flights_by_day, 
                             rank(desc(arr_delay)) < 10)

# mutate by group
flights_by_dest <- group_by(flights, dest)
flights_delays <- filter(flights_by_dest, arr_delay > 0)
flights_prop_delay <- mutate(flights_delays, 
                             prop_delay = arr_delay / 
                                 sum(arr_delay, na.rm = TRUE))
# not by group:
flight_prop_delay2 <- mutate(flights,
                             prop_delay = arr_delay /
                                 sum(arr_delay, na.rm = TRUE))

# -----
# pipes
# -----

# convenient way of data wrangling, without intermediate savings
flights_summary <- flights %>% 
    group_by(month, day) %>% 
    summarise(delay = mean(dep_delay, na.rm = TRUE),
              first_delay = first(dep_delay),
              nr_fligths = n())

flights_gains <- flights %>%
    filter(month == 3 & day == 13) %>%
    select(carrier, origin, dest, dep_delay, arr_delay) %>%
    mutate(gain = dep_delay - arr_delay) %>%
    group_by(dest) %>%
    summarise(mean_gain = mean(gain, na.rm = TRUE),
              max_gain = max(gain, na.rm = TRUE),
              nr_flights = n())
flights_gains

# ------
# across
# ------

# not using across
flights_grouped <- group_by(flights, month, day)
flights_no_across <- summarise(flights_grouped, 
                               dep_delay = mean(dep_delay, na.rm = TRUE),
                               arr_delay = mean(arr_delay, na.rm = TRUE),
                               air_time = mean(air_time, na.rm = TRUE))

# using across, same result
flights_across <- summarise(flights_grouped, 
                            across(c(dep_delay, arr_delay, air_time), 
                                   ~mean(.x, na.rm = TRUE)))

# using across with logical statement
flights_across <- summarise(flights, 
                            across(where(is.character), n_distinct))

# using across with a list of functions
mean_median <- list(mean = ~mean(.x, na.rm = TRUE),
                    median = ~median(.x, na.rm = TRUE))
flights_across <- flights %>%
    group_by(month, day) %>%
    summarise(across(c(dep_delay, arr_delay, air_time), 
                     mean_median))

# -----
# joins
# -----

# (preparation)
data("planes")

flights_select <- flights %>%
    select(year, month, day, tailnum, flight, carrier, origin, 
           dest, dep_time, arr_time)
head(flights_select, n = 5)
head(planes, n = 5)

## joining multiple data.frames, matching them using matching columns
flights_planes <- flights_select %>% 
    left_join(planes, by = c('tailnum' = 'tailnum'))
head(flights_planes, n = 3)
data(package = 'nycflights13')

# -----
# tidyr
# -----

# tidy and untidy tables
print(table1, n = 6)
print(table2, n = 6)
print(table3, n = 6)

# gather with pivot_longer()
print(table4a)
table_gathered <- table4a %>% 
    pivot_longer(cols = c(`1999`, `2000`), 
                 names_to = 'year', 
                 values_to = 'cases')
print(table_gathered)

# spread with pivot_wider()
print(table2, n = 6)
table_spread <- table2 %>% 
    pivot_wider(names_from = 'type', 
                values_from = 'count')
print(table_spread)