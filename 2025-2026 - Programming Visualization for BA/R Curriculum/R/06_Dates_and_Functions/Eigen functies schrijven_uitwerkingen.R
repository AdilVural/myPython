#Oefeningen zelf functies schrijven

# Oefening 1
# Deel 1
mijn_functie <- function(a) {
  y <- sqrt(a+10)
  return(y)
}

mijn_functie(3)      

# Deel 2
library(ggplot2)
library(ggthemes)

mijn_functie2 <- function(p) {
  p <- p + theme_economist() 
  return(p)
}

pp <- ggplot(economics, aes(x = date, y = unemploy)) + geom_line()
pp <- pp + ggtitle("U.S. unemployment over time") + xlab("Date") + ylab("Unemployment (x 1,000)")
pp

pp <- mijn_functie2(pp)
pp



# Oefening 2
load("flights.RData")

summarize_carrier_min_dist <- function(flight_data, car, min_dist) {
  carrier_summary <- flight_data %>% 
    prepare_flight_data() %>%   # Hier roepen we onze eerder gemaakte functie aan
    filter(carrier == car, distance >= min_dist) %>%
    summarize(av_arr_delay = mean(arr_delay),
              av_dep_delay = mean(dep_delay),
              n_flights = n())
  return(carrier_summary)
}

summarize_carrier_min_dist(flights,"UA",5000)



# Oefening 3
count_flights <- function(flight_data, org, destination)
{
  n <- flight_data %>%
    prepare_flight_data() %>%
    filter(origin == org, dest == destination) %>%
    summarize(n_flights = n())
  return(n$n_flights)
}

count_flights(flights,"JFK", "MIA")

# Oefening 3 bonus
count_flights <- function(flight_data, org, destination)
{
  n <- flight_data %>%
    prepare_flight_data() %>%
    filter(origin == org, dest == destination) %>%
    summarize(n_flights = n())
  
  n_long_delay <- flight_data %>%
    prepare_flight_data() %>%
    filter(origin == org, dest == destination, arr_delay >= 30*dminutes(1)) %>%
    summarize(n_flights = n())
  return(list(n_total = n$n_flights, proportion_long_delay = n_long_delay$n_flights/n$n_flights))
}

count_flights(flights,"JFK", "MIA")
