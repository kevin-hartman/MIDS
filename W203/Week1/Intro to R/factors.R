#####################################################################
# Program Name: factors.R
# Analyst     : Paul Laskowski
#
#####################################################################


#####################################################################
# Factors

# R has a special data type that's useful for categorical
# variables: the factor.  A lot of the advanced statistical
# functions we will learn expect factors as input.  By
# coding our categorical variables as factors, we will
# make sure that they're treated correctly and
# displayed correctly.

# There are a few wrinkles to keep in mind when working
# with factors.

# Here is some data from Coye's latest chili cookoff.

chef = c("Coye", "Deirdre", "Judd", "Anno", "Steve")
spiciness = c("Medium", "Mild", "Hot", "Hot", "Medium")

# right now, spiciness is just a character vector.
class(spiciness)

# To make a factor, we can put spiciness into the
# factor constructor function.
(sp = factor(spiciness))

# Our new variable, sp is a factor.

class(sp)

# Factors are stored very compactly.  Under the hood,
# R numbers all the different categories, then stores
# an integer for each observation.

# We can see these integers if we pass the factor into
# as.numeric.

as.numeric(sp)

# The factor also has a vector of levels, which are
# the strings d

levels(sp)

# In this case, we might not like the order of these levels.
# When we display graphs involving this factor, we really
# want mild to come first.

# The factor constructor has a levels argument that we can
# use to specify the levels we want explicitly in the order
# we like.

(sp = factor(sp, levels = c("Mild", "Medium", "Hot")))

# In this case, we put our factor back into the factor
# constructor, but we could have just used our original
# character vector

(sp = factor(spiciness, levels = c("Mild", "Medium", "Hot")))

# Let's say that we want to change the names of these
# levels to match those used by the International 
# Chili Association.  We can do that as follows.

levels(sp) = c("Mild", "Spicy", "Extra Spicy")
sp

# The numerical values are unchanged, they just refer
# to the new vector of levels.

# Sometimes, you'll see the levels changed at the point
# at which the factor is constructed.  This syntax may
# be confusing.  We use the labels argument to store
# the vector of new level names.

(sp = factor(spiciness, levels = c("Mild", "Medium", "Hot"), 
                  labels = c("Mild", "Spicy", "Extra Spicy")))

#####################################################################
# A Common Error with Factors

# Finally, be careful when reading in numerical data that
# might have some text mixed in.  R will often read such
# data in as a factor automatically, and beginners may not
# be able to diagnose the errors that result.

# For example, say we have a rating for each chili, but
# one observation is just a blank space

rating = c(5, 6, 3, 5, " ")

# We will convert this vector to a factor (or R may do
# this automatically at the point at which we read in
# data).

r = factor(rating)

# When we print the value of r, it looks a lot like a
# numerical vector.

r

# But we'll probably get errors if we perform numerical
# operations on r.

mean(r)

# Here's where you need to be careful:  A lot of beginners
# will try to fix this situation by coercing the factor to
# a numerical vector with as.numeric.

mean(as.numeric(r))

# We get an unusually small mean.  To see what's happening,
# examine as.numeric(r)

as.numeric(r)

# But notice that when we do that, the numbers have changed!
# as.numeric takes the integer coding that the factor uses
# and reveals it.

# Unfortunately, there are even times when this type of
# coercion happens automatically, making it even harder to
# notice the error.

# To get the numbers we want, we first have to get the strings
# representing the levels.

levels(r)[r]

# We can then convert these to numbers.

as.numeric(levels(r)[r])

# Notice that the last item, the space, was converted to NA,
# which stands for missing value.  This is the behavior we
# want.  We'll have a lot more to say about missing values
# later.