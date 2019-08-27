#####################################################################
# Program Name: OLS_inference.R
# Analyst     : Paul Laskowski
#
#####################################################################

#####################################################################
# Setup

setwd("~/Desktop/data_w203")
getwd()

library(car)
library(lmtest)
library(sandwich)
library(stargazer)


#####################################################################
# Analysis of wage data.
# The data comes from the 1976 Current Population Survey, 
# and is supplied by Wooldridge.

load("Wage1.rdata")
ls()

# desc includes descriptions of each variable
desc

# data includes the actual observations

summary(data)
str(data)
nrow(data)

# We gain an overview using a scatterplot matrix.
scatterplotMatrix(data[ , c("wage", "educ", "exper")])

# Examine the wage variable
summary(data$wage)
hist(data$wage, breaks = 50, main = "Hourly Wage", xlab = "dollars")
# We note the strong positive skew. There are no missing values.

# Examine education

summary(data$educ)
hist(data$educ, breaks = 0:20-.5, 
     main = "Years of Education", xlab = NULL)

# We notice the spikes at 12 years and 16 years of education.
# Examine years of experience.

summary(data$exper)
hist(data$exper, breaks = 1:52-.5, 
     main = "Years of Potential Experience", xlab = NULL)

# Experience has a positive skew, and the density seems to 
# decrease almost linearly.  We find no missing values, and
# no values that we think should be removed from the dataset.

# fit the linear model

model1 = lm(wage ~ educ + exper, data = data)

# we could use the summary command, but the errors are not
# robust to heteroskedasticity.

summary(model1)

# get the residual vs. fitted value and scale-location plot
plot(model1)


# There are other tools we can use to assess the CLM assumptions.
# For normality of errors, we can examine the residuals directly.
hist(model1$residuals, breaks = 50)

# We might also consider the formal Shapiro-Wilk test of normality.
shapiro.test(model1$residuals)


# We can confirm the presense of heteroskedasticity with
# a Breusch-Pagan test.  Be careful to consider the sample
# size when interpreting this test.
bptest(model1)

#####################################################################
# Responding to violated assumptions.
#
# Recall that we seem to have a violation of zero-conditional mean,
# normality of errors, and homoskedasticity.
#
# Because we have a large sample, we can rely on OLS asymptotics. 
# If we set aside causality and just look for the best fit line,
# exogeneity tells us that our estimates are consistent.
# We also get normality of our sampling distributions from the 
# large sample size.

# To address heteroskedasticity, we use robust standard errors.
coeftest(model1, vcov = vcovHC)
vcovHC(model1)

# Each year of education is associated with $0.64 more hourly
# earnings.

# Even though it's not necessary given the large sample size, 
# researchers usually enter wage into linear models in logarithmic form.
# Here, we examine this alternate specification:

model2 = lm(log(wage) ~ educ + exper, data = data)
plot(model2)

# Note how the residuals are dramatically more normal
# Also notice how the residuals vs fitted values
# and scale-location plots show much less heteroskedasticity.

# Look at the residuals directly
hist(model2$residuals, breaks = 50)
# Notice the reduced skew.

# We continue using robust standard errors, because it's good practice

coeftest(model2, vcov = vcovHC)

# Each year of education is associated with about 9.7% higher
# wages


# Finally, we display both our models in a regression table
# We need the vectors of robust standard errors.
# We can get these from the coeftest output
(se.model1 = coeftest(model1, vcov = vcovHC)[ , "Std. Error"])

# Or directly from the robust covariance matrix.

(se.model1 = sqrt(diag(vcovHC(model1))))

(se.model2 = sqrt(diag(vcovHC(model2))))

# We pass the standard errors into stargazer through 
# the se argument.
stargazer(model1, model2, type = "text", omit.stat = "f",
          se = list(se.model1, se.model2),
          star.cutoffs = c(0.05, 0.01, 0.001))


