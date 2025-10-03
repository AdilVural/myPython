# ---------------------------
# Erasmus Q-Intelligence B.V.
# ---------------------------

# 1. Functions
# a)
# get product of input arguments
get_product <- function(a, b = 3) {
    # calculate product
    d <- 1
    c <- a * b * d
    
    # output
    return(c)
}
get_product(3, 4)
# b)
get_product(3)
# get product of input arguments
get_product <- function(a) {
    # calculate product
    c <- a * b
    
    # output
    return(c)
}
get_product(3) # error
b <- 3
get_product(3) # no error if b is available in parent environment
# c)
a <- 1
b <- 2
c <- 3
get_... <- function(b, d = 4) {
    c <- 5
    e <- a + d * c ^ b
    str_c('e equals', e, sep = ' ')
}
get_...(b)
get_...(1)
get_...(d = 2)
get_...(a = 2)
get_...(b, d = 3)
get_...(3, d = 1)
f <- get_...(b)

# 2. Functions
# a)
max_input <- function(a, b) {
    max(a, b)
}
max_input(3, 4)
# b)
b <- 4
max_input2 <- function(a) {
    max(a, b)
}
max_input2(3)
rm(b)
max_input2(3)
# c)
max <- function(a, b) {
    max(a, b)
}
max(3, 4)
# solution
max <- function(a, b) {
    base::max(a, b)
}
max(3, 4)

# 3. Reusability
# a)
mtcars %>% group_by(cyl) %>% summarize(group_count =  n())
mtcars %>% group_by(carb) %>% summarize(group_count =  n())
starwars %>% group_by(homeworld) %>% summarize(group_count =  n())
starwars %>% group_by(species) %>% summarize(group_count =  n())
storms %>% group_by(year) %>% summarize(group_count =  n())

# step 1: mtcars %>% group_by(cyl) %>% summarize(group_count =  n())

# step 2: 
# get_group_count <- function() {
# mtcars %>% group_by(cyl) %>% summarize(group_count =  n())
# }

# step 3 and step 4:

get_group_count <- function(data, var) {
data %>% group_by({{var}}) %>% summarize(group_count =  n())
}

get_group_count(mtcars, 'cyl')
get_group_count(starwars, 'homeworld')
get_group_count(storms, 'year')

# 4. Reusability
data <- read.csv("animal_species.csv")
# c)
get_summary_by <- function(group, var, data) {
    data %>%
        group_by({{group}}) %>%
        summarise(mean = mean({{var}}, na.rm = TRUE),
                  sd = sd({{var}}, na.rm = TRUE),
                  iqr_low = quantile({{var}}, 0.25, na.rm = TRUE),
                  iqr_high = quantile({{var}}, 0.75, na.rm = TRUE),
                  observations = sum(!is.na({{var}})))
}
# d)
get_summary_by(year, weight, data) %>%
    filter(year == 1989) %>%
    select(mean)
get_summary_by(taxa, hindfoot_length, data) %>%
    filter(taxa == 'Rodent') %>%
    pull(sd)
get_summary_by(genus, weight, data) %>%
    filter(genus == 'Onychomys') %>%
    pull(observations)
