# ---------------------------
# Erasmus Q-Intelligence B.V.
# ---------------------------

## ITERATION

# iteration (loops) -------------------------------------------------------

# vectorized
1:4 + 1
# not vectorized
is.null(list(NULL, NA, 1, -5, 3))

# for loop
series <- list(NULL, NA, 1, -5, 3)
is_null <- vector('logical', 5)
for (i in 1:5) {
    is_null[i] <- is.null(series[[i]])
}

# while loop
series <- c(3)
while (max(series) < 1000) {
    series <- c(series, last(series)^3)
}

# efficiency
get_fibonacci_slow <- function(length) {
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
tictoc::tic()
fib <- get_fibonacci_slow(10000)
tictoc::toc()

get_fibonacci_fast <- function(length) {
    # initialize series
    fib <- vector('numeric', length = length)
    fib[1:2] <- c(0, 1)
    
    # loop from 3 to length
    for (i in 3:length) {
        # add the sum of the last two values to the series
        fib[i] <- fib[i-1] + fib[i-2]
    }
    
    # output
    fib
}

tictoc::tic()
fib <- get_fibonacci_fast(10000)
tictoc::toc()

# purrr
test_list <- list(NA, NULL, 1, -5, 3)
map(test_list, is.null)
map_lgl(test_list, is.null)

# extra arguments
data("mtcars")
map(mtcars, mean, na.rm = TRUE)

# map with own function
get_null <- function(x) {
    if (is.null(x)) {
        'This one is NULL'
    } else {
        'This one is not NULL'
    }
}

map_chr(test_list, get_null)

# map with own anonymous function
map_chr(test_list, function(x) {
    if (is.null(x)) {
        'This one is NULL'
    } else {
        'This one is not NULL'
    }
})

# map_df (return value is a data frame)
test_df <- data.frame(a = 1:5, b = 6:10, c = 11:15)

map_df(test_df, mean)

# map2 (2 lists to iterate over)
test_list1 <- 1:5
test_list2 <- 6:10

map2_dbl(test_list1, test_list2, sum)

# (just as an illustration, `+` is a vectorized function, and thus using
# map2_dbl( ) is a bit inefficient)
test_list1 + test_list2
