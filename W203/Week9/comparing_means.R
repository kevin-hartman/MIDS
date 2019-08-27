#####################################################################
# Program Name: comparing_means.R
# Analyst     : Paul Laskowski
#
#####################################################################

#####################################################################
# Setup

# setting the seed will ensure different users generate the
# same random draws.
set.seed(898)

setwd("~/Desktop/data_w203")
getwd()

# effsize gives us a convenient function for computing Cohen's d
library(effsize)

#####################################################################
# Comparing means in R
#
# The data we are using is provided by Wooldridge and comes from
# the Michigan Department of Education.  It was analyzed by
# Leslie Papke in the following paper.
# “The Effects of Spending on Test Pass Rates: Evidence from 
# Michigan” (2005), Journal of Public Economics 89, 821-839.
#
# Here, we will use the data to practice comparing population
# means.  We are interested in two questions:
#
# 1. Do schools with a high benefits-to-salary ratio have higher
# percentages of students that pass the 4th grade math test, 
# compared to those with a low benefits-to-salary ratio?
#
# 2. Do schools have a higher percentage of students that pass
# the 4th grade math test or the 4th grade reading test?

# Two caveats to bear in mind:
#
# 1. We are modeling associations and our findings will
# not have a causal interpretation.  In general, schools that
# offer a lot of benefits may differ in many ways from
# schools that offer few benefits.  Our analysis does not
# address the important question of what would happen if
# a specific school invested more in benefits.
#
# 2. The data is not a random sample because schools
# are not truly independent of each other.  For example, the
# data includes a district variable and we may expect certain
# factors to be correlated across schools in a given district.
# A more accurate analysis would account for this effect
# by employing clustered standard errors.  For simplicity, we
# will not address this limitation here.

load("elem94_95.RData")
head(Schools)

# desc contains descriptions of each variable.

desc

# The bs variable represents the benefits-to-salary ratio.

summary(Schools$bs)
hist(Schools$bs, breaks = 50, main = "Histogram of Benefits-to-Salary Ratio",
     xlab = NULL)

# The histogram of bs shows a reasonably smooth distribution, 
# but there are some outliers, especially in the positive direction.

# Let's look at the data points with unusually high bs ratios.
order(Schools$bs, decreasing = T)
head(Schools[ order(Schools$bs, decreasing = T), ])

# Note the unusually low average salary for the most outlying point
# To investigate further, we can try ordering the data by salary.

head(Schools[ order(Schools$avgsal), ])

# The point in question has the lowest average salary, but it's not
# too far from second and third place.

# Although some of these outlying points are suspicious, we decide to
# leave them in the dataset.  Because we are planning to bin our bs
# variable, the effect on our results should be minimal.

# We create a binary variable to represent schools with a high
# benefits-to-salary ratio.
ifelse(Schools$bs > mean(Schools$bs), 
       "high benefits", "low benefits")
Schools$ben = factor(ifelse(Schools$bs > mean(Schools$bs), 
                            "high benefits", "low benefits"))
summary(Schools$ben)

# Next, examine the math4 variable

summary(Schools$math4)
hist(Schools$math4, breaks= 50, 
     main = "Percentage of Students Passing Math Exam",
     xlab = NULL)

# Note that we have a skewed distribution, though it is not an
# extreme skew.
#
# Additionally, there is a spike at 100 percent.  We can think
# of this as an attenuated scale.  It is as though some schools
# are doing such a good job that they would appear to the right 
# of 100% on the histogram, but the scale cuts off at 100%.  
# There are advanced statistical techniques that let us model 
# this type of outcome variable (e.g. Tobit models), but we won't
# use them here, noting that the feature is reasonably small.

# We want to know if high-bs-ratio schools pass more
# students than low-bs-ratio schools.  We don't have a normal
# distribution, but we do have a large sample size, so we
# should be safe to use a parametric t-test.  Additionally,
# there is no natural pairing for our data (note that the number
# of schools in the two groups are not even equal), so we will
# need an independent-samples t-test.

t.test(math4 ~ ben, data = Schools)

# The first argument to t.test may be confusing at first.  It
# is a formula expressing our model.  In this case, our outcome
# variable is math4, and we want to approximate it with one 
# value when ben is "high benefits" and another value when ben 
# is "low benefits".  We therefore place our grouping variable to the 
# right of the '~' so that R finds a different mean for each
# group.
#
# This notation will make more sense when we learn to work in a 
# regression framework.  Note that the t.test command can also
# accept two vectors holding the values for each group, which may
# be more intuitive at this stage.

# Here, we create a separate vector to hold the values for each
# group.

(high_bs_scores = Schools$math4[Schools$ben == "high benefits"])
(low_bs_scores = Schools$math4[Schools$ben == "low benefits"])

# the t.test yields the same result.

t.test(high_bs_scores, low_bs_scores)

# Our t-test is highly statistically significant.
# The effect seems to be practically significant as well, with
# the high bs ratio schools passing 58% of students on 
# the average, while the low bs ratio schools pass 64% on the
# average.

# The direction of the effect may seem surprising.  There are
# many confounding variables that could account for this.  For
# example, it's possible that the high bs schools have a high
# ratio simply because they pay teachers a low salary.

# A quick glance at the means confirms that this is true.

by(Schools$avgsal, Schools$ben, mean)

# In this case, the difference in means is probably the best
# measure of effect size, but there are times when we might
# want a standardized measure.  Cohen's d is essentially
# a measure of how many population standard deviations 
# separate the means.

cohen.d(math4 ~ ben, data = Schools)

# In this case, this is telling us that our means are about .28
# standard deviations apart.

# We could also calculate the effect size correlation.  This effect
# size measure has a very elegant interpretation.  Since we have
# highben as a grouping variable, the effect size correlation is
# simply the correlation between math4 and our grouping variable.
summary(as.numeric(Schools$ben))
cor(Schools$math4, as.numeric(Schools$ben))

# The correlation of -0.14 is a fairly small correlation.


#####################################################################
# Smaller Samples
#
# Since we had a large sample, we were able to apply a parametric test.
# What if we had a small sample instead?  For example, here, we take 
# a subsample with only 25 schools.

small_samp = Schools[sample(nrow(Schools), 25), ]
summary(small_samp)

# As before, we can see some evidence of a non-normal distribution.

hist(small_samp$math4, breaks = 20, main = "Math Passing Rate in Small Sample",
     xlab = NULL)

# This can be confirmed by looking at the qq plot

qqnorm(small_samp$math4, 
       main = "Normal Q-Q Plot for Math Exam Passing Rate")

# The skew is not extreme, and the t-test is fairly robust to deviations
# from normality, so we might argue that a t-test is still valid in this
# case.  Because the assumptions are harder to justify, we will instead
# perform a Wilcoxon rank-sum test.

wilcox.test(math4 ~ ben, data = Schools)

# In this case, our test is statistically significant, supporting the
# alternate hypothesis that low bs ratio schools tend to have more students
# pass than high bs ratio schools.


#####################################################################
# Math versus Reading

# Our second question is whether schools have a higher percentage
# of students that pass the math test versus the reading test.

# In many ways, it would be more intuitive to weight bigger schools
# more heavily.  We could simply ask whether students are more 
# likely to pass the the math test or the reading test.  
# For the sake of this demonstration, however, we'll keep our 
# focus on the percentages at the school level.

# In this case, there is a very natural pairing between our 
# observations.  Each school corresponds to a specific
# math value and a specific reading value.  Furthermore, it
# is probably to our advantage to conduct a paired test.
# There could be schools that are high performers in general
# and therefore score well on both math and reading.  This
# could drive a lot of overall variation, but the two scores
# for a given school are likely to move up and down together.
# This suggests that there could be less variation in the 
# difference in scores.

# First, we'll examine the means directly
c(mean(Schools$math4), mean(Schools$story4))

# Notice that the average for math is 61% while the average
# for reading is 70%, which seems like a practically 
# significant difference.

# Since we are focusing on the difference in values,
# we examine a histogram of the difference.

hist(Schools$story4 - Schools$math4, breaks= 50, 
     main = "Difference between Passing Rates for Reading and Math",
     xlab = "reading passing rate minus math passing rate")

# Note the spikes, which likely correspond to the upper limit
# of 100% for each underlying variable.  Nonetheless, the
# distribution seems fairly close to normal.

# Additionally, we have a large sample, so we can perform
# a parametric test.

# The command is as follows.

t.test(Schools$math4, Schools$story4, paired = T)

# Our t-statistic is highly statistically significant.

# Just to confirm our intuition, note that if we performed an
# unpaired test, the result would still be significant, but
# out t-statistic would be considerably reduced, from -34 to
# -16.

t.test(Schools$math4, Schools$story4, paired = F)

# In many other cases, switching to an unpaired t-test could
# result in the loss of statistical significance.
