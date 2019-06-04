#####################################################################
# Program Name: joint_distributions.R
# Analyst     : Paul Laskowski
#
#####################################################################

#####################################################################
# Setup

# We will use the mvrnorm function in the MASS package
library(MASS)

# setting the seed will ensure different users generate the
# same random draws.
set.seed(898)

#####################################################################
# Using joint distributions in R
# 
# Suppose we want to simulate draws from two random variables, X and Y,
# with some joint distribution.  It is often easiest to begin with the
# marginal distribution of X to generate the X-values, then use the 
# conditional distribution of Y to generate the Y values.

# For example, suppose know the marginal distribution of adult swallow 
# wingspans.  Furthermore, we may understand the relationship between
# wingspan and airspeed velocity so that given a wingspan, we know the
# conditional distribution of velocity.

# Here, we assume that the marginal distribution of wingspan is normal, with
# mean 10 inches and standard deviation 4 inches.  We first generate 100 
# draws from this distribution.

wingspan = rnorm(100, mean = 10, sd = 4)

# Next, we'll assume that given a particular wingspan, the airspeed velocity
# has a normal distribution with mean 0.5 * wingspan and standard deviation 1.

velocity = 0.5 * wingspan + rnorm(100)

# Let's visualize the simulated sample we created
plot(wingspan, velocity, main = "Simulated Data on Swallow Flight Characteristics")


#####################################################################
# Multivariate Normal Distributions

# The joint distribution we created to represent swallows belongs to a
# special class of distributions called bivariate normal.  This class
# of distributions has a lot of nice properties that make it a popular
# choice for many statistical procedures.

# One interesting point is that we could have performed our swallow
# simulation the other way around: we could have started by drawing the 
# velocity values from a normal distribution, then modeled the wingspan
# values as a linear function of the velocity values plus a draw from 
# a normal distribution.

# More generally, if you imagine taking a "slice" through the bivariate 
# normal distribution in any direction (along the x-axis, along the y-axis,
# or along a diagonal), you'll get a normal curve.  There's nothing too
# special about these axes: if you stretch a bivariate normal distribution
# in any direction, you'll get a bivariate normal distribution.

# It turns out that any bivariate normal distribution can be completely
# described by just five values: the mean of X, the mean of Y, the variance
# of X, the variance of Y, and the covariance between X and Y.

# Some of the time, it might be easier for use to draw the X and Y values
# from a bivariate normal distribution at the same times.  We can do this 
# with the mvrnorm function in the MASS package.
?mvrnorm

# First, we need a vector of the means.  We chose 10 as the mean
# of wingspan and we can compute the mean of velocity to be 5.
mu = c(10, 5)

# Next, we need a variance-covariate matrix to represent the dispersion
# in our variables.  We already know the variance of wingspan is 16.
# With a little manipulation, we can compute the variance of velocity 
# to be 5.  We can also compute the covariance between the two to be
# 8.  We put these values into a variance-covariance matrix as follows:

Sigma = matrix(c(16,8,8,5),2,2)

# Notice that the variances appear on the main diagonal.  The covariance
# appears in both the upper right and lower left corner.

# Putting these together, we can simulate draws as follows:
data = mvrnorm(100, mu, Sigma)
colnames(data) = c("wingspan", "velocity")
head(data)

plot(data, main = "Simulated Data on Swallow Flight Characteristics")

# Note that the sample is different than the one we computed before,
# even though the joint distribution is the same, since we're using
# new randomness.

# Just for fun, let's see what would happen if we set the covariance between
# our two variables to be zero:
Sigma2 = matrix(c(16,0,0,5),2,2)
data2 = mvrnorm(100, mu, Sigma2)
colnames(data2) = c("wingspan", "velocity")

plot(data2, main = "Simulated Data with Zero Covariance")

# Notice that there is no noticable relationship between the variables.
# This is because we've constructed them to be independent.