#####################################################################
# Program Name: dataframes.R
# Analyst     : Paul Laskowski
#
#####################################################################



#####################################################################
# Working with dataframes in R

# The data frame is R's basic representation for a
# table of data.  It's our usual way of packaging multiple
# variables together for the same units of observation.

# For very small data frames, we can just type
# the data into R manually.

# Here is more data from Coye's chili cookoff.

chef = c("Coye", "Deirdre", "Judd", "Anno", "Steve")
spiciness = c("Medium", "Mild", "Hot", "Hot", "Medium")
score = c(5, 6, 3, 5, 5)

# We can manually place these into the data.frame constructor
Chili = data.frame(chef, spiciness, score)

# This data frame is so small that we can just print it.

Chili

# We often use the summary command to get an overview of a
# new data frame.

summary(Chili)

# summary is what we call a generic function in R.  It checks
# to see what kind of object we pass into it, and it tailors
# the output to that type of object.  You'll end up using this
# command a lot to get an overview of objects that you create.

# To get individual variables out of a data frame, we use a $.

Chili$score

# We could have also used our constructor to rename variables

Chili = data.frame(cook = chef, spiciness, score)
summary(Chili)

# After the data frame is made, we use the names function to
# access the variable names.

names(Chili)
names(Chili)[3]
names(Chili)[3] = "score1"
summary(Chili)

# We can also use a $ to add new variables to a data frame.

Chili$score2 = c(4,3,3,4,5)
Chili


#####################################################################
# Reading Data from Files

# For all but the tiniest datasets, we can't type the
# data in manually.  A lot of the time in this class, we 
# will access data from a data file.

# Before we can read in a data file, we have to make sure
# R knows where to look for it.  We will set the working
# directory to the same location we placed the file.

setwd("~/Desktop/data_w203")
getwd()

# If you're lucky, you can get your data in an RData
# file.  This format is made for R and the interpreter
# can read it very efficiently.  Here, we use load to get the
# data in the file Chili.RData.

load("Chili.RData")

# After we use this command, we would typically call
# objects() to see what objects we've added.

objects()

# The new object Chili2 has appeared, and we can examine
# it to see what we have

summary(Chili2)

# Most of the time, you'll need to at least start with
# a file that isn't an RData file.  For example, the
# file Chili.csv contains a larger set of data taken from 
# Coye's chili cookoff.  It is in a common structured format 
# called a comma separated value (csv) file.  You should 
# open the file and examine this format.

# A csv file is easily read using the read.csv command.

Chili = read.csv("Chili.csv")

# Typically, after we do this, we examine the first few
# rows of data to see if the read was successful.
head(Chili)

summary(Chili)

# There is one problem here: score 1 is appearing as
# a factor.  We will fix this shortly.

# First, we demonstrate another command we can use to read
# files, read.table.  This command is quite flexible, but
# requires a bit more work in this case.

Chili = read.table("Chili.csv", sep=",")
head(Chili)

# Notice that the header row is incorrectly lumped in
# with the data.  We can fix this with the header argument.

Chili = read.table("Chili.csv", sep=",", header = TRUE)
summary(Chili)

# The problem with score1 seems to be the value "na"

levels(Chili$score1)

# We can manually fix this as before.

(score1.fixed = as.numeric(levels(Chili$score1)[Chili$score1]))
Chili$score1 = score1.fixed
summary(Chili)

# We could have also fixed this in the read.table command,
# which has a lot of options to read data in just the way
# you want.

Chili = read.table("Chili.csv", sep=",", header = TRUE, na.strings = "na")
summary(Chili)


# Let's do some more manipulation.
# Here's how we would compute a mean score.

Chili$mean_score = (Chili$score1 + Chili$score2) / 2
Chili

# Notice that we get a missing value for the last mean score.
# This is probably the behavior that we want, since the two
# scores may not be comparable to each other.  Most of the time,
# R does sensible things with missing values, but sometimes
# you have to override the default behavior.

# Suppose we want to know the overall mean score

mean(Chili$mean_score)

# This gives an NA, since one of the values is missing.
# In this case, we don't want the default behavior.  We
# can override it with the na.rm argument.

(grand_mean = mean(Chili$mean_score, na.rm = TRUE))

# We may also want the sample variance and sample standard deviation.
# These are easy to get in R.

var(Chili$mean_score)
sd(Chili$mean_score)

# We may want to plot the sample on a histogram

hist(Chili$mean_score)

# It's important to fix the titles so that it's easy to understand.

hist(Chili$mean_score, main = "Histogram of Mean Scores in Chili Cookoff",
     xlab = "mean score")

# Let's see whether score1 and score2 seem related to
# each other.  We'll use a scatterplot
plot(Chili$score1, Chili$score2)

# This is not a full exploratory analysis, it's just
# a demonstration of some simple tools for describing
# data.

# Suppose we want to know which chilis are above average.
# We can create a logical vector to represent this condition

Chili$above_av = Chili$mean_score >= grand_mean
Chili


#####################################################################
# Indexing Data Frames

# We can use indexing to pull values that we want out
# of a data frame.  We do this with square brackets,
# as we did for vectors, but now we have to specify both
# the rows that we want, and the columns that we want.
# The rows go first, followed by a comma, followed
# by the columns.

Chili[2,1] # row 2, column 1
Chili[1, "cook"]  # row 1, column named cook.
Chili[2:5, c(3,4)]  # rows 2-5, 3rd and 4th column

# If we omit the rows, we get all rows.
# If we omit the columns, we get all columns.
Chili[1,]  # First row
Chili[, c("spiciness", "mean_score")] # spiciness and mean_score columns

# Some more useful examples:
Chili[Chili$above_av == TRUE, c("cook", "mean_score")]
Chili[Chili$spiciness %in% c("Medium", "Hot"),]
Chili[Chili$score1 > Chili$score2, ]



#####################################################################
# A note on attach

# Some users will use the attach command to help them
# access the variables in a data frame.

attach(Chili)

# This adds convenience, because now we can refer to the
# variables without writing Chili$.

score1 + score2

# I don't usually do this, because it can lead to errors.
# attach actually makes a copy of the data frame, so
# changes you make to the variables will be lost.  Also,
# if the original data frame changes, you won't see the
# changes in the variables created by attach.

# Instead of using attach, consider choosing nice and short
# names for your data frames.  This also lets you save
# different versions of your data as you proceed, so you
# can easily go back when needed.

detach(Chili)
