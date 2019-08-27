#####################################################################
# Program Name: t-test.R
# Analyst     : Paul Laskowski
#
#####################################################################

#####################################################################
# Setup

setwd("~/Desktop/data_w203")
getwd()

#####################################################################
# T-tests in R

# Recall that we previously used a dataset on sleep times to practice
# generating confidence intervals for the mean in R.

load("sleep.Rdata")
sleep$min

# Remember that we have over 30 observations, so we know that the
# t-distribution is generally valid because of the Central Limit Theorem.

# The easiest way to generate a confidence interval is with the t.test
# command.  We are now in a position to understand all of the output of
# that command.

t.test(sleep$min)

# 1. First note that a t-test is conducted in relation to a specific 
# null hypothesis, and the alternate hypothesis can be one-tailed or
# two tailed.  The second line tells us that the null is that the
# mean is 0, which is the default for t.test.  It also tells us that 
# we are running a two-tailed test.
#
# 2. The first line gives us the t-statistic, in this case 62.68, which
# is very high.  We are over 60 estimated standard deviations away from
# zero.
#
# 3. The first line tells us that the number of degrees of freedom is 49,
# which is what we expect since we have 50 observations.
#
# 4. We are given a p-value, which is extremely small in this case.  This
# represents the probability of getting a statistic this high, assuming 
# the true population mean is zero.  Because the p-value is less than .05,
# we would reject the null hypothesis in this case.
#
# 5. As before, we are given a 95% confidence interval.  Notice that the
# confidence interval does not include zero.  This is another way of
# seeing that we should reject the null nypothesis.
#
# 6. We are also given the sample mean.

# Suppose we wanted to test whether the true mean was 3150 minutes.
# We can set the null hypothesis mean with the mu argument.

t.test(sleep$min, mu = 3150)

# Notice that the test is marginally statistically significant (p < .10)
# but we cannot reject the null hypothesis.

# Suppose that we wanted to run a one-tailed t-test instead.
# We can do this with the alternative argument.

t.test(sleep$min, mu = 3150, alternative = "greater")

# Notice that our p-value has decreased below .05, so we would be able
# to reject the null hypothesis.
# A researcher might be tempted to switch to this test after the fact
# in order to claim a positive result, but this is clearly cheating.
# Because of this possibility, two-tailed tests are far more common,
# unless you have a very strong justification for why you would only
# be interested in rejecting the null in one direction.

