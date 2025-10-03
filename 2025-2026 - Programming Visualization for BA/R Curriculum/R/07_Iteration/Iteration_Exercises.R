# ---------------------------
# Erasmus Q-Intelligence B.V.
# ---------------------------

## ITERATION
## EXERCISES

## 1. for and while
# a)
for (i in 10:20) {
  print(i*2)
}
my_function <- function(start_value, increment){
  value <- start_value
  while (value > 0){
    print(value)
    value <- value - increment
    increment <- increment + 1
  }
}
my_function(100,10)

## 2. Fibonacci
# a)
get_fibonacci_by_length <- function(length) {
    # initialize series
    fib <- c(0, 1)
    
    # loop from 3 to length
    for (i in 3:length) {
        # add the sum of the last two values to the series
        fib <- c(fib, fib[i-1] + fib[i-2])
    }
    
    # output
    fib
}
get_fibonacci_by_length(10)
# the next number depends on the previous ones, so vectorization would not work.

# b)
get_fibonacci_by_max <- function(max_value) {
    # initialize series
    fib <- c(0, 1)
    
    # next number
    next_fib <- sum(fib)
    
    # as long as next_fib smaller than max_value, go on
    while (next_fib < max_value) {
        # add the sum of the last two values to the series
        fib <- c(fib, next_fib)
        
        # calculate the next value, needed for the condition in the while
        next_fib <- fib[length(fib)] + fib[length(fib)-1]
    }
    
    # output
    fib
}
get_fibonacci_by_max(500)


## 3. ITERATION: PURRR
# a)
vector <- 1:10
# b)
# get mean over x random numbers
get_rmean <- function(x) {
    mean(rnorm(x))
}
# c)
set.seed(13031989)
map_dbl(vector, get_rmean)

1:1000 %>%
    map_dbl(get_rmean)

## 4)
# a)
data("mtcars")
map_df(mtcars, mean)
# b)
mtcars %>% summarize(across(everything(), .fns = mean))
# c)
# You can work with groups of your data in dplyr (group_by())
# It is easier with dplyr to select the columns you want to execute your function on

## 5)
# data
data("starwars")
# transformed data
starwars_list <- starwars %>% 
    transpose() %>% 
    setNames(starwars$name)
# get movies for characters from transformed data
get_movies <- function(starwars_list, characters){
    # over all characters
    # apply the function which gets all movies
    # set the names to the newly created list
    characters %>% map(function(name){
        starwars_list[[name]]$films
        }) %>% 
        setNames(characters)
}
characters <- c('Luke Skywalker', 'R2-D2', 'Leia Organa')
q5 <- get_movies(starwars_list, characters)

## 6)
# get movies for characters from the original data in a tidy way
get_tidy_movies <- function(starwars, characters){
    # from starwars filter all where name in character
    # select columns
    # create a tibble for all characters, by character
    starwars %>% 
        filter(name %in% characters) %>% 
        select(name, films) %>%  
        pmap_df(function(name, films){
            tibble(name, films)
            })
}
q6 <- get_tidy_movies(starwars, characters)
