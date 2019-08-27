#####################################################################
# Program Name: Bivariate_OLS_estimation.R
# Analyst     : Paul Laskowski
#
#####################################################################

#####################################################################
# Setup

setwd("~/Desktop/data_w203")
getwd()

# Setting the seed will ensure different users generate the
# same random numbers 

set.seed(898)

#####################################################################
# Part 1: Simulation

# We will first demonstrate how simulation can be used
# in the context of a bivariate linear regression model.

# The true population model will be y = 1 + 0.5 * x + u,
# where we assume u has a normal distribution with mean 0
# and standard deviation 1.

# The CLM assumptions impose almost no restriction on how
# our x variable is distributed.  For simplicity, we'll assume 
# that the marginal distribution of x is also normal,
# with mean 10 and standard deviation 5.

# generate x values
x = rnorm(100, 10, 5)

# generate errors
u = rnorm(100, 0, 1)

# generate y values
y = 1 + 0.5 * x + u

# Let's visualize the data we generated

plot(x,y, main = "Simulated Data from Linear Population Model")

# Next, we will switch roles and try to estimate the paramters
# of the model.

# Use lm to fit a linear model.

(simmodel1 = lm(y ~ x))

# We can superimpose our fitted model over the data
abline(simmodel1)

# Our estimator for the slope coefficient is 0.519 (the true value is 0.5)
# Our estimator for the intercet is 0.775 (the true value is 1.0)

# Observe that our estimators don't equal the true parameters exactly.
# The ols coefficients are random variables.

# In the coming units, we will learn to quantify the variation in these
# coefficients, for example, with standard errors.  For now, we're
# just trying to develop intuition for what they mean.

# To get R-squared, we can use the summary command.  However,
# we won't use this command very often because the standard
# errors and p-values it provides are not robust to a condition
# we call heteroskedasticity. We will explain this in detail
# when we discuss OLS inference.

summary(simmodel1)$r.square

# Notice that the R-squared for our regression is .835.  The interpretation
# is that 83.5% of the variation in our y is explained by our x variable.
# The rest of the variation comes from our error.

# Let's examine our residuals

u_hat = simmodel1$residuals
head(cbind(u, u_hat))

# Notice that the residuals are similar to the errors, but they are
# not the same.  Our residuals are our estimates of the errors.

# We can plot the residual for each data point as a function of x.
# This is something called a residual versus predictor plot.

plot(x,u_hat, main = "Residual versus Predictor for Simulated Data")

# Notice that the residuals seem balanced around 0 as we look from
# the left to the right of the plot.  There's no obvious place where the
# band seems above zero or below zero.  This is because of our
# zero-conditional mean condition.  We constructed our errors so
# E(u|x) = 0 and our residuals estimate the errors.

#####################################################################
# Part 2: Analysis of GPA data

#Load the data
load("GPA1.rdata")

# see what the variables are
ls()
# alternately call:  objects()

# read the description of variables
desc

# examine a few rows of data
head(data)

#####################################################################
# Fit a univariate linear model
# An interesting question is what relationship ACT score has with 
# college GPA. Here, we will fit a model that predicts college 
# GPA from ACT score.

# Our model looks like
# colGPA = beta_0 + beta_1 ACT + u

# Note right away that this model will not have a causal interpretation.
# We're going to measure the association between ACT and GPA in the
# population, but that doesn't mean that if we manipulate ACT score for 
# one individual, that individual's GPA will go up by beta_1.  This is
# because students that have a higher ACT score are different in many
# ways compared to students with a lower ACT score.  We'll have a lot
# more to say about causality later in the course.

# examine the ACT variable

summary(data$ACT)
hist(data$ACT, breaks = 16:36 - 0.5, 
     main = "Histogram of ACT Scores", xlab = NULL)

# notice that there are no missing values, the histogram shows no
# unusual spikes, and all values are within the expected range of
# 1-36

# examine the colGPA variable

summary(data$colGPA)
hist(data$colGPA, breaks = 20, main = "Histogram of College GPA", xlab = NULL)

# Notice again that we have no missing values, and no unusual spikes
# in the histogram, and all values are within the expected range
# of 0-4

# let's visualize the relationship
plot(data$ACT, data$colGPA, xlab = "ACT score", 
     ylab = "College GPA", main = "College GPA versus ACT score")

# fit the linear model
(model1 = lm(colGPA ~ ACT, data = data))
abline(model1)

# notice that the coefficient of ACT is .027.
# Interpretation: each additional point on the ACT is associated with
# .027 more GPA points.
# A student that scores 4 points higher would be expected to have a GPA
# just over 0.1 points higher.

summary(model1)$r.square

# The R-square is 0.04275.  The interpretation is that just 4.3% of the
# variation in GPA can be explained by ACT score.  This seems pretty low
# but remember that we're usually more interested in the slope coefficient
# as a measure of effect size.  Here, our objective isn't to predict
# GPA, but rather to understand the relationship between these two variables.

# This is only the beginning of a regression analysis.  The next step 
# will be to test the assumptions of our linear regression
# model.  We will do this using diagnostic plots, background knowledge,
# and statistical tests.  We also want to quantify the
# uncertainty in our estimates.  For now, however, we just want to focus
# on how to interpret our estimates.