#####################################################################
# Program Name: t-distribution.R
# Analyst     : Paul Laskowski
#
#####################################################################

#####################################################################
# Setup

setwd("~/Desktop/data_w203")
getwd()

#####################################################################
# T-distributions in R

# R makes it quite easy to work with T-distributions.  The following
# command brings up information on the relevant functions.
?TDist

# Notice that these functions are analogous to those for the normal
# distribution and the uniform distribution.  Also notice that the
# second parameter for each function is the number of degrees of 
# freedom.

# For example, if we wanted to know the area under a T-distribution 
# with 10 degrees of freedom, between -1 and 1, we could get that as
# follows.

pt(1, 10) - pt(-1, 10)

# We can also use the quantile function, qt, to construct confidence
# intervals based on the t-distribution.

# For this example, we'll look at data on the number of minutes of 
# sleep a set of workers gets in a night.

# This data is provided by Wooldridge and comes from the following paper.
# J.E. Biddle and D.S. Hamermesh (1990), “Sleep and the Allocation of 
# Time,” Journal of Political Economy 98, 922-943.
# To highlight the distinction between a t-test and z-test, we will only
# use a subsample of 50 measurements.

load("sleep.Rdata")
sleep$min

# Is a t-distribution appropriate for this data?  Note that the number
# of observations is greater than 30, which indicates that we can generally
# apply the Cnetral Limit Theorem.  This means that both the z-distribution and
# the t-distribution would be valid (and they would be nearly equivalent).

# If we had less than 30 observations, we would need to examine our variable
# to see if it had an approximately normal distribution.  Even if we have more
# than 30 observations, it is always good practice to examine the variable
# to understand the data we're dealing with and to identify any extreme 
# distributions that might cause us to question whether n=30 is enough
# to invoke the CLT.

hist(sleep$min, breaks = 50, main = "Histogram of Sleep Time", xlab = "minutes")

# In this case, the data looks fairly reasonable, bearing in mind that the
# confidence intervals based on the t-distribution are considered fairly
# robust to deviations from normality.  In this case, we would be checking 
# for substantial deviations from normality, such as a strong skew.

# We could also pull up a qq-plot to see how normal this variable looks.
# Remember that a perfectly normal variable would show up as a nice diagonal
# line on the qq-lot.

qqnorm(sleep$min, main = "Normal Q-Q plot for Sleep Time")

# Since we believe a t-distribution is valid, we will proceed to build
# our confidence interval.  
# First, we observe that the mean number of minutes is 3250.2

xbar = mean(sleep$min)

# We also need the sample standard deviation, which is our estimate for
# the population standard deviation.

s = sd(sleep$min)

# since we have 50 observations, we will be using a t-distribution
# with 49 degrees of freedom.  The critical value we want for a 95%
# confidence interval is the following.

qt( .975, 49)

# We can calculate our 95% confidence interval as follows:

c(xbar - qt( .975, 49) * s / sqrt(50), xbar + qt( .975, 49) * s / sqrt(50))

# As an alternative, we can use the t.test function.  Note that we
# haven't described what a t-test is at this point in the course, so
# we will need to ignore most of the output of this command.  However,
# notice that part of the output includes a 95% confidence interval for
# the mean.

t.test(sleep$min)

# We can pull out just the confidence interval as follows.

t.test(sleep$min)$conf.int

# We can also choose different confidence levels by changing the
# conf.level argument.

t.test(sleep$min, conf.level = .99)$conf.int

# Notice that the 99% confidence interval is wider than the 95%
# confidence interval.  This is the price we pay to have more
# confidence in our interval estimator.