#####################################################################
# Program Name: random_variables.R
# Analyst     : Paul Laskowski
#
#####################################################################

#####################################################################
# Setup

# setting the seed will ensure different users generate the
# same random draws.
set.seed(898)

#####################################################################
# Using distributions in R
# 
# R makes it easy to work with common types of random variables.
# For each common distribution, including the normal, uniform, etc,
# there is a set of functions for computing probabilities and also
# for taking draws.  Once you learn the functions for one 
# distribution, the other ones will be very intuitive.


#####################################################################
# The Normal Distribution
# The normal distribution is the most important one to know.  The 
# following command will bring up documentation about it.
?Normal

# Notice that there are four functions listed: dnorm, pnorm, qnorm, rnorm

# let's generate a set of x-value to help us visualize these functions.
x = seq(-3,3, by = .01)
head(x)

# The density function
dnorm(0)

# for non-standard normal curves, we can specify the mean and sd.
dnorm(0, 1, 1)
dnorm(0, mean = 1, sd = 1)

# We can use the function to visualize the normal curve
plot(x, dnorm(x), type="l")

# The cumulative probability function gives the total area under a normal
# distribution from negative infinity to a given point.
pnorm(0)

# An important point on the normal curve to remember
pnorm(1.96)

# Visualize the cumulative probability function.
plot(x, pnorm(x), type="l")

# Suppose you want the area under the normal curve from one standard
# deviation below the mean, to one standard deviation above the mean
# We can get this by subtracting the cumulative probabilities
pnorm(1) - pnorm(-1)



# the quantile function
# Think of this as the inverse of the cumulative probability function.
# You put in a probabiltiy and you get back the point on the x-axis
# for which the normal curve has that cumulative probability.
qnorm(.5)
# Important values to remember:
qnorm(.975)
qnorm(.025)

# Say you want to know what point on the x-axis leaves 10% of the
# area under the standard normal curve on the right tail.  This means
# we want the point that gives a cumulative probability of 90%
qnorm(.9)

# Taking draws from a normal random variable.
# This is done with the rnorm function.
rnorm(1)
# The first argument is the number of draws.  rnorm returns a vector.
rnorm(100)

# We can visualize the draws we get with a histogram
# notice that the histogram shape starts to approximate the normal
# distribution.
hist(rnorm(100), breaks = 50, 
     main = "Draws from a Standard Normal Distribution", xlab = NULL)


#####################################################################
# The Uniform Distribution
# The uniform distribution is usually more artificial than the normal,
# but we sometimes use it because it is so mathematically tractable.
?Uniform

# Notice how similar the function names are.
# The density function
dunif(0.5)
dunif(1.5)

# Notice that if we expand the interval, the density decreases.
dunif(0.5, min = 0, max = 2)

# The cumulative probability
punif(0.5)
plot(x, punif(x), type = "l")

# The quantile function
qunif(0.5)

# Random draws from a uniform distribution
runif(100)
hist(runif(100), breaks = 20, 
     main = "Draws from a Uniform Distribution", xlab = NULL)
