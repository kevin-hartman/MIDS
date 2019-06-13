#####################################################################
# Program Name: central_limit_theorem.R
# Analyst     : Paul Laskowski
#
#####################################################################

#####################################################################
# Setup

# setting the seed will ensure different users generate the
# same random draws.
set.seed(898)

#####################################################################
# Sampling distributions in R

# For this demonstration, we will use the faithful dataset that's 
# included in R.  This includes observations of the famous Old
# Faithful geyser in Yellowstone National Park.
?faithful

# The eruptions variable measures the duration of each eruption in
# minutes.

# Although this is a sample, for this demonstration, we'll pretend 
# that this is actually the entire population of eruption times

eruptions = faithful$eruptions
str(eruptions) # Note that there are 272 observations.

# From the histogram, notice the bimodal distribution

hist(eruptions, breaks = 50, xlim=c(1,6))

# The mean is 3.49.

mean(eruptions)

# What's important is that this distribution is very non-normal.
# This will help us highlight the way the Central Limit Theorem
# works.

# Again, remembering that we're treating this dataset as if it
# were an entire population, let's see how we'd take a sample.
# We'll start with a very small sample size, n1 = 3.

n1 <- 3
samp1 <- sample(eruptions, n1, replace=T)
samp1

# Note that we set the replace argument to True, meaning that
# we put each value back after we draw it so there's a chance it's
# drawn again.  This means that we have a random sample, since 
# each draw is idependent and identically distributed.

# We could alternately set the replace argument to False, so
# that each value can only get drawn once.  This is a natural
# choice if we're simulating a typical survey.  One issue is that
# because we have a finite population, our observations are not
# fully independent and we don't have a random sample.

# As long as our sample size is much smaller than the
# population size, the two types of sampling behave very similarly.
# For this demo, we will use sampling with replacement, mainly
# because it has nice mathematical properties.  The results would
# be substantially similar if we sampled without replacement.

# Now that we have a sample, we can compute statistics from it.
# Here, we'll compute the mean.

mean(samp1)

# Notice that we only get one value for the mean.  If this were a
# real study, that's really all we'd ever get.  Most of the time,
# it's too expensive to repeat a study again to see what mean
# we'd get the next time around.  Even though we know the 
# mean is a random variable with some sample distribution, we
# only get a single draw from that distribution.

# Since we have the full population, we can actually see what would
# happen if we repeated our study over and over.
# To do this, we use the replicate command.  We will replicate our
# procedure 1000 times, computing a sample mean each time.

draws1 <- replicate(1000,mean(sample(eruptions, n1, replace=T)))

# Since we have a large number of draws, our histogram will approximate
# the shape of the sampling distribution of the mean.

hist(draws1, breaks = 50, xlim=c(1,6),
     main = "Simulated Sample Means from Repeated Sampling",
     xlab = "sample mean")

# Things to notice:
#
# 1. The sampling distribution looks different than the population 
# distribution.  this is very important:  The sampling distribution 
# of a statistic is not the same as the population distribution 
# of the variable.
#
# 2. The sampling distribution of the mean still doesn't look normal.  
# We don't have a large sample since n is much smaller than 30, so 
# the Central Limit Theorem doesn't apply.
#
# 3. The sampling distribution is less dispersed than
# the population distribution.  Since we're averaging 3 draws, our 
# standard deviation is decreased by sqrt(3).


# To see the Central Limit Theorem in action, we need to increase our 
# sample size.

# First, let's see what happens with a sample size of 10.

n2 = 10
draws2 <- replicate(1000,mean(sample(eruptions, n2, replace=T)))
hist(draws2, breaks = 50, xlim=c(1,6))

# Notice that the variance has decreased even more.
# Furthermore, the distribution looks more normal, but it still
# deviates noticable from normality.

# Next, let's try a sample size of 30.

n3 = 30
draws3 <- replicate(1000,mean(sample(eruptions, n3, replace=T)))
hist(draws3, breaks = 50, xlim=c(1,6))

# Things to notice:
#
# 1. The standard deviation continues to decrease.  In particular,
# it decreases with the square root of n.
#
# 2. The distribution seems to be concentrating around the true
# population mean, 3.49.  This is dictated by the Law of Large
# Numbers.
# 
# 3. The distribution is quite normal in shape at this point.  To see
# this more clearly, we can allow the x-axis to resize in our histogram.

hist(draws3, breaks = 50)

# We have a sample size of 30, which generally means that it's safe to
# rely on the Central Limit Theorem.

# Remember n=30 is only a rule of thumb and there are some unusual 
# distributions for which we may need n = 100 or even more to invoke 
# the CLT.  In the vast majority of cases, n=30 is sufficient, but 
# it is worth the time to examine your variable to check for an
# unusually large skew.



