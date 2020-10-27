#' A function that shows extreme sensitivity to inital
#' conditions
tent_function <- function(x){
    ifelse(x < 1/2, 2*x, 2-(2*x))
}

step_tent <- function(x, steps=100){
    stopifnot(x > 0 && x < 1)
    results <- rep(NA_integer_, steps)
    for (step in seq_len(steps)) {
        if(x %in% c(0, 1, 1/2)) break
        results[step] <- x
        x <- tent_function(x)
    }
    as.vector(na.omit(results))
}
