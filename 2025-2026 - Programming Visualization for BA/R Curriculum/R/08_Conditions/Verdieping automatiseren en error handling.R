### EFFICIENT AUTOMATISEREN ###
load("flights.RData")
prepared_flights <- prepare_flight_data(flights)
prepared_flights 

# Trage loop
start_time <- Sys.time()

delay_levels <- c()

for (i in 1:nrow(prepared_flights)) {
  delay_mins <- prepared_flights$arr_delay[i]/dminutes(1)
  if (delay_mins <= 0) {
    delay_levels <- c(delay_levels,"no delay")
  } else if (delay_mins <= 30) {
    delay_levels <- c(delay_levels,"short delay")
  } else if (delay_mins <= 180) {
    delay_levels <- c(delay_levels,"long delay")
  } else {
    delay_levels <- c(delay_levels,"extreme delay")
  }
}

end_time <- Sys.time()
end_time - start_time

# Snellere loop
start_time <- Sys.time()

delay_levels <- c()
delay_mins <- prepared_flights$arr_delay/dminutes(1)

for (i in 1:nrow(prepared_flights)) {
  if (delay_mins[i] <= 0) {
    delay_levels <- c(delay_levels,"no delay")
  } else if (delay_mins[i] <= 30) {
    delay_levels <- c(delay_levels,"short delay")
  } else if (delay_mins[i] <= 180) {
    delay_levels <- c(delay_levels,"long delay")
  } else {
    delay_levels <- c(delay_levels,"extreme delay")
  }
}

end_time <- Sys.time()
end_time - start_time


# Nog snellere loop
start_time <- Sys.time()

delay_levels <- vector(mode="character",length=nrow(prepared_flights))
delay_mins <- prepared_flights$arr_delay/dminutes(1)

for (i in 1:nrow(prepared_flights)) {
  if (delay_mins[i] <= 0) {
    delay_levels[i] <- "no delay"
  } else if (delay_mins[i] <= 30) {
    delay_levels[i] <- "short delay"
  } else if (delay_mins[i] <= 180) {
    delay_levels[i] <- "long delay"
  } else {
    delay_levels[i] <- "extreme delay"
  }
}

end_time <- Sys.time()
end_time - start_time

# Gebruik logical indexing!
start_time <- Sys.time()

delay_levels <- vector(mode="character",length=nrow(prepared_flights))
delay_mins <- prepared_flights$arr_delay/dminutes(1)

delay_levels[delay_mins <= 0] <- "no delay"
delay_levels[delay_mins > 0 & delay_mins <= 30] <- "short delay"
delay_levels[delay_mins > 30 & delay_mins <= 180] <- "long delay"
delay_levels[delay_mins > 180] <- "extreme delay"

end_time <- Sys.time()
end_time - start_time

# Alternatieve, iets langzamere oplossing
start_time <- Sys.time()
prepared_flights <- prepared_flights %>%
  mutate(delay_levels = if_else(delay_mins <= 0, "no delay", 
                                if_else(delay_mins <= 30, "short delay",
                                        if_else(delay_mins <= 180, "long delay","extreme delay"))))
end_time <- Sys.time()
end_time - start_time

prepared_flights$delay_levels <- factor(delay_levels, levels = c("no delay", "short delay", "long delay", "extreme delay"),
                                        ordered=TRUE)

delay_table <- table(prepared_flights$carrier, prepared_flights$delay_levels)
delay_table

### OMGAAN MET ERRORS ###
price_1 <- 2
price_2 <- 4
av_price <- mean(price_1, price_2)
quantity <- 10
revenue <- quantity * av_price
print(revenue)

mileages <- c(10,20,15,18,12)
av_mileage <- average(mileages)
costs_per_mile <- 3
av_costs <- av_mileage * costs_per_mile
print(av_costs)

average(5,7)
delay_table[18,]
1,5 * 3,7
for i in 1:10 { print(i) }

load("BenAndJerry.csv")

# Error in een functie
count_flights <- function(flight_data, org, dst) {
  prep <- flight_data %>%
    prepare_flight_data() 
  
  out <- prep %>%
    filter(origin == org, dest == dst) 
  
  out1 <- nrow(out)
  out2 <- mean(out$arr_delay/dminutes(1)>30)
  
  return(list(n_flights = out1, perc_delayed = out2))
}
count_flights("JFK","ANC")


# De browser functie gebruiken
count_flights(flights, JFK, MIA)

count_flights <- function(flight_data, org, dst) {
  browser() # We voegen de browser() command hier toe
  prep <- flight_data %>%
    prepare_flight_data() 
  
  out <- prep %>%
    filter(origin == org, dest == dst) 
  
  out1 <- nrow(out)
  out2 <- mean(out$arr_delay/dminutes(1)>30)
  
  return(list(n_flights = out1, perc_delayed = out2))
}

count_flights(flights, JFK, MIA)

### OEFENING: WAAR ZITTEN DE FOUTEN?
count_flights <- function(flight_data, org, dst) {
  prep <- flight_data %>%
    prepare_flight_data() 
  
  out <- prep %>%
    filter(origin = org, dest = dst) 
  
  out1 <- nrow(out)
  out2 <- mean(out$arr_delay/dminutes>30)
  
  return(list(n_flights = out1), perc_delayed = out2)
}

load("flights.RData")
count_flights(flights, "JFK", "MIA")

count_flights <- function(flight_data, org, dst) {
  prep <- flight_data %>%
    prepare_flight_data() 
  
  out <- prep %>%
    filter(origin == org, dest == dst) 
  
  out1 <- nrow(out)
  out2 <- mean(out$arr_delay/dminutes(1)>30)
  
  return(list(n_flights = out1), perc_delayed = out2)
}

load("flights.RData")
count_flights(flights, "JFK", "MIA")


