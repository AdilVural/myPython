### EIGEN FUNCTIES SCHRIJVEN EN GEBRUIKEN ###


square <- function(x) {
  y <- x^2
  return(y)
}

square(4)             
# Doet het volgende:
# y <- 4^2
# return(y)




# voorbeeld functie voor voorbereiden flights data
prepare_flight_data <- function(flight_data) {  # Hier defini?ren we de functie
  prepared <- flight_data %>%
    mutate(arr_time = parse_date_time(arr_time, "%Y-%m-%d %H:%M"),
           sched_arr_time = parse_date_time(sched_arr_time, "%Y-%m-%d %H:%M"),
           dep_time = parse_date_time(dep_time, "%Y-%m-%d %H:%M"),
           sched_dep_time =  parse_date_time(sched_dep_time, "%Y-%m-%d %H:%M"),
           arr_delay = arr_time - sched_arr_time,
           dep_delay = dep_time - sched_dep_time) %>%
    filter(!is.na(arr_time))
  return(prepared)
}

load("flights.RData")
prepared_flights <- prepare_flight_data(flights)  # Hier roepen we de functie aan

# functie kan ook aangeroepen worden in een pipe
flights %>%
  prepare_flight_data() %>%
  group_by(dest) %>%
  summarize(av_delay = mean(arr_delay))


# Functie met meerdere inputs
# summarize_carrier <- function(flight_data, car)
# flight_data: a dataframe with flights data as used in the flights.RData dataset
summarize_carrier <- function(flight_data, car) {
  carrier_summary <- flight_data %>% 
    prepare_flight_data() %>%   # Hier roepen we onze eerder gemaakte functie aan
    filter(carrier == car) %>%
    summarize(av_arr_delay = mean(arr_delay),
              av_dep_delay = mean(dep_delay),
              n_flights = n())
  return(carrier_summary)
}

summarize_carrier(flights,"UA")
summarize_carrier(flights,"AA")


# Functie met meerdere outputs
summarize_carrier <- function(flight_data, car) {
  carrier_summary <- flight_data %>%
    prepare_flight_data() %>%
    filter(carrier == car)
  
  carrier_summary_short <- carrier_summary %>%
    filter(distance <= 3000) %>%
    summarize(av_arr_delay = mean(arr_delay),
              av_dep_delay = mean(dep_delay),
              n_flights = n())
  
  carrier_summary_long <- carrier_summary %>%
    filter(distance > 3000) %>%
    summarize(av_arr_delay = mean(arr_delay),
              av_dep_delay = mean(dep_delay),
              n_flights = n())
  

  return(list(short_dist_flights = carrier_summary_short,
              long_dist_flights = carrier_summary_long))
}

output <- summarize_carrier(flights, "UA")

flights %>%
  prepare_flight_data() %>%
  filter(origin == "JFK", dest == "MIA") %>%
  summarize(n_flights = n())

n <- flights %>%
  prepare_flight_data() %>%
  filter(origin == "JFK", dest == "MIA") %>%
  summarize(n_flights = n())

