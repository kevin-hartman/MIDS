#####################################################################
# Directory   : 
# Program Name: OLS_specification.R
# Analyst     : Paul Laskowski
# Last Updated: 4/3/2015
#
# Purpose:
# OLS Specification
#####################################################################

#####################################################################
# Setup

setwd("~/Desktop/data_w203")
getwd()


#####################################################################
# Load Libraries

library(car)
library(lmtest)
library(sandwich)


#####################################################################
# Analysis of baseball data.
# We look at the wage dataset to demonstrate heteroskedasticity

load("mlb1.rdata")
ls()

# desc includes descriptions of each variable
desc

# data contains the data itself.
summary(data)

# Examine the salary variable
summary(data$salary)
hist(data$salary, breaks= 200)
# This is a highly skewed distribution with a notable spike at the
# minimum value.  Check out a few of the smallest values of salary
head(sort(data$salary), 50)

# It turns out that the minimum mlb salary, set by negotions
# with the MLB players association was $109,000 in 1993.  This
# corresponds to the minimum value we see.

# we can also examine the log of salary
hist(log10(data$salary), breaks= 100)
# Interestingly, the distribution is not very normal and looks
# almost uniform.  It could be that the minimum salary is set high
# enough to distort the usual salary distribution that we expect
# to find.

# Examine years and games per year variables
summary(data$years)
hist(data$years, breaks = 20)
summary(data$gamesyr)
hist(data$gamesyr, breaks = 100)
# both have no missing values and distributions look reasonable.

# Examine batting average
hist(data$bavg, breaks=100)
# According to baseball-almanac.com, the record for highest season 
# batting average was set by Hugh Duffy at .440.
# We may be suspicious of the two outlying values.
data[data$bavg > 400,]

# Notice that these players have very few at bats, 7 and 8.  The mean
# number of at bats is 2,169.  
summary(data$atbats)
head(sort(data$atbats), 50)

# It seems that these players got lucky due to how few chances 
# they had at bat.  The values are meaningful, though we expect
# a lot of extra variation in our x-variable.
# Notive that there are similar outliers in the negative direction as well
data[data$bavg < 150,]

# We could fit a much more complicated model to account for this
# effect, but that's beyond the scope of this course.
# A simpler idea is to mitigate the problem by removing players who
# have few chances to bat.
# To be eligible for the MLB batting title, players must
# have at least 3.1 at bats per team game originally scheduled, or
# approximately 500 at bats.
# Our dataset has 73 players with less than 500 at bats
sum(data$atbats<500)

# We proceed without these players.
mlb = data[data$atbats>=500,]
summary(mlb)
nrow(mlb)
# We are left with 280 players

# Examine home runs per year and runs batted per year
summary(mlb$hrunsyr, breaks=100)
hist(mlb$hrunsyr, breaks=100)
summary(mlb$rbisyr, breaks = 100)
hist(mlb$rbisyr, breaks = 100)
# Both of these have no missing values and the distributions
# have no suspicious artifacts.

# Our full model predicts salary based on years, games per year,
# and then three performance metrics: batting average, runs batted per
# year, and home runs per year.
model1 = lm(log(salary)~ years + gamesyr + bavg + hrunsyr + rbisyr, data = mlb)
plot(model1)
# Note the evidence of heteroskedasticity in the residuals vs. fitted
# values plot and in the scale-location plot.

# We now examine the coefficients.
coeftest(model1, vcov = vcovHC)

# Out of our three performance metrics, only batting average has a significant
# effect.

# We could recreate the output in Wooldridge by putting in the full data
# including players with few at bats
model_wooldridge = lm(log(salary)~ years + gamesyr + bavg + hrunsyr + rbisyr, data = data)
plot(model_wooldridge)
# notice the outlying points in the residuals vs leverage plot with high
# leverage. These have small residuals, however, meaning that they don't
# affect our coefficients very much.  In particular, a general rule is
# that a cook's distance of 1 represents a worrysome amount of influence,
# and none of our datapoints are close.
coeftest(model_wooldridge, vcov = vcovHC)
# Here, the extra variation in bavg is acting like measurement error.
# Thus, it is little surprise that we lose statistical significance,
# even though we're adding more data.

##### Joint Hypothesis Testing
# We want to test whether the three performance indicators are jointly
# significant.  That is, whether the coefficients for bavg, hrunsyr, and
# rbisyr are all zero.

# Our restricted model is formed by removign the performance indivators
model_rest = lm(log(salary)~ years + gamesyr, data = mlb)
coeftest(model_rest, vcov = vcovHC)

# To test whether the difference in fit is significant, we use the wald test,
# which generalizes the usual F-test of overall significance,
# but allows for a heteroskedasticity-robust covariance matrix
waldtest(model1, model_rest, vcov = vcovHC)

# Another useful command is linearHypothesis, which allows us
# to write the hypothesis we're testing clearly in string form.
linearHypothesis(model1, c("bavg = 0", "hrunsyr = 0", "rbisyr = 0"), vcov = vcovHC)

# In this case, the three performance indicators are jointly significant.
# There is probably a great deal of multicollinearity, which explains
# why in Wooldridge's specification, none of their coefficients is
# individually significant.

#### Testing whether coefficients are different
# One question is whether a hit and a walk affect salary by 
# the same amount.  We write an alternate specification as follows:
model2 = lm(log(salary)~ years + gamesyr + hits + bb, data = mlb)
coeftest(model2, vcov = vcovHC)

# Our hypothesis is that the coefficients for hits and bb (walks)
# are the same.
# We can test this manually by creating a new variable to equal the total
# hits_plus_walks.
mlb$hits_plus_walks = mlb$hits + mlb$bb

# We then put this variable into our model along with hits (how many
# of the total are hits). The coefficient for hits will then measure
# the difference between the effects of hits and walks.
model3 = lm(log(salary)~ years + gamesyr + hits + hits_plus_walks, data = mlb)
coeftest(model3, vcov = vcovHC)
# The coefficient is insignificant - we did not find evidence
# that hits and walks affect salary differently.

# We could also use linearHypothesis to do the same thing, in an
# even clearer way
linearHypothesis(model2, "hits = bb", vcov = vcovHC)
# Notice that we get the same p-value as before.
