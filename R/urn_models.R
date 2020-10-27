### URN models

cumulative_sum <- function(vec){
    N_vec <- length(vec)
    results <- data.frame(
        steps = seq_len(N_vec),
        stringsAsFactors = FALSE
    )
    for (color in unique(vec)) {
        results[[color]] <- rep(0, N_vec)
        for (step in results$steps) {
            results[step, color] <- sum(vec[1:step] == color)
        }
    }
    results
}

urn_plot <- function(df){
    df %>% 
        pivot_longer(-steps,names_to="marble") %>% 
        ggplot(aes(steps, value, color = marble))+
        geom_point()+
        geom_line(alpha = 1/2)+
        labs(
            x = "step number",
            y = "Cumulative number drawn",
            caption = "simulation of urn models"
        )
}

#' Run urn model several times and return distribution
#' 
#' 
prob_distr_urn <- function(fun, iterations_per_model = 100, repeats=10){
    props <- rep(NA_real_, repeats)
    for (it in seq_len(repeats)) {
        result = fun(iterations = iterations_per_model)
        props[it] <- sum(result == "red")/length(result)
    }
    props
}

vis_prop_distr <- function(props){
    ggplot(data.frame(prop=props), aes(prop))+
        geom_histogram(bins = 50)
}

#' Bernoulli process
#' 
#' Urn model, we pick a ball from an urn.
#' We look at it's color and return it to the urn.
#' 
urn_bernoulli <- function(iterations = 100, ball_colors=c("red","blue")){
    urn <- ball_colors
    sample(urn, iterations, replace = TRUE)
}

#' Polya process
#' 
#' Urn model, we pick a ball from an urn.
#' We look at it's color and return it to the urn.
#' However, we add a ball of that color to the pot
urn_polya <- function(iterations = 100, ball_colors = c('red',"blue")){
    urn <- ball_colors
    results <- rep(NA_character_, iterations)
    for (iteration in seq_len(iterations)) {
        results[iteration] <- sample(urn, size = 1)
        urn <- c(urn, results[[iteration]])
    }
    results
}

#' balancing urn model
#' 
#' Urn model, we pick a ball from an urn.
#' We look at it's color and return it to the urn.
#' However, we add a ball of opposite color to the pot
urn_balancing <- function(iterations = 100, ball_colors = c('red',"blue")){
    urn <- ball_colors
    results <- rep(NA_character_, iterations)
    for (iteration in seq_len(iterations)) {
        results[iteration] <- sample(urn, size = 1)
        urn <- c(urn, ball_colors[ball_colors != results[[iteration]] ])
    }
    results
}

safe_iterator <- function(vec, iteration){
    if(iteration < 1){NULL}
    else{
        vec[iteration]
    }
}

#' sway process
#' 
#' Urn model, we pick a ball from an urn.
#' We look at it's color and return it to the urn.
#' We add a ball of opposite color to the pot
#' We add 1 balls of color step back
#' We add 2 balls of color 2 steps back
#' We add 4 balls of color 3 steps back, 
#' etc.
#' 
#' The decisions of the past weigh more and more heavily. 
urn_sway <- function(iterations = 100, ball_colors = c("red","blue")){
    urn <- ball_colors
    results <- rep(NA_character_, iterations)
    for (iteration in seq_len(iterations)) {
        results[iteration] <- sample(urn, size = 1)
        urn <- c(urn, results[[iteration]])
        for (i in iteration) {
            urn <- c(urn, rep(safe_iterator(urn, iteration - i),2^(i-1)))
        }
    }
    results
}


#' very different model
urn_symbiots <- function(iterations=100){
    ball_colors = c("red","blue","yellow","green")
    urn <- ball_colors
    results <- rep(NA_character_, iterations)
    for (iteration in seq_len(iterations)) {
        pick <- sample(urn, size = 1)
        results[iteration] <- pick
        additional_ball <- switch (pick,
            "red" = "green",
            "green" = "red",
            "blue" = "yellow",
            "yellow" = "blue"
        )
        urn <- c(urn,additional_ball)
    }
    results
}
