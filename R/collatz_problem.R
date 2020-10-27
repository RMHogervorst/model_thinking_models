### Collatz problem hotpo problem (half or three plus one)
#https://en.wikipedia.org/wiki/Collatz_conjecture
#
#The Collatz conjecture is: This process will eventually reach the number 1,
#regardless of which positive integer is chosen initially.
#
#If the conjecture is false, it can only be because there is some starting
#number which gives rise to a sequence that does not contain 1. Such a sequence
#would either enter a repeating cycle that excludes 1, or increase without
#bound. No such sequence has been found.
#
print_co <- TRUE
hotpo <- function(number){
    collector <- number
    while(number != 1){
        if((number %% 2) ==0) {
            #even
            number <- number/2
            collector <- c(collector, number)
            if(print_co) print(number)
        } else {
            number <- (number * 3) +1
            collector <- c(collector, number)
            if(print_co) print(number)
        }
    }
    collector
}

hotpo(20)

# graph how many steps it takes to get to 1. 
sample <- data.frame(
    int = 1:1000,
    steps_to_complete = 0
)
c_hotpo <- function(x){
    length(hotpo(x))
}
sample$steps_to_complete <- sapply(sample$int, c_hotpo)

plot(sample)
