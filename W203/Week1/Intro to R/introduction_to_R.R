#####################################################################
# Program Name: introduction_to_R.R
# Analyst     : Paul Laskowski
#
#####################################################################


#####################################################################
# This is a first look at R for students that are just starting out.
# Note that these commands will be entered into the console
# window.

#####################################################################
# The console window, arithmetic, getting help

# First note the console window.
# It allows us to interact with the R interpreter in a 
# conversational manner.

5 + 5

# arithmetic operations are exactly what you'd expect

# exponentiation is either ^ or **.
3^2
3**2

# Order of operations is standard.

# There are a lot of functions built into base R.
log(100)

# Say you want to know how to change the base of the logarithm.
# You can get help by putting a ? before the name of a function
?log

log(100, 10)
log(100, base = 10)
log10(100)

args(log)

# R has variables, like any general-purpose programming language.

x = 5
x

y <- 5
6 -> y
y

6

# The variables that you create exist in a region of memory called
# the workspace.  You can always check to see what's in the workspace
# by calling the objects function.

objects()

#####################################################################
# Vectors and Vectorized Operations

# The most basic data type in R is a vector.  In fact,
# numbers in R are just vectors of length 1.
# This is one of the ways that R is specialized for data analysis

# We can create a vector using the concatenate function.
c(2, 5, 2, 3)


# The sequence operator is often handy for making vectors
1:4

4:1

-1:2

# The sequence function is more flexible
seq(2, 8, by=2)
seq(0,1, by=.1)
seq(0, 1, length = 11)

# Of course, we can store vectors in variables
x = c(3, 4, 5, 6)
x
x/2

# To get some useful information about a vector,
# try the summary command.

summary(x)

# This is a numerical vector, so we get some useful
# numerical summaries.

# Most mathematical operations are vectorized.  That means that
# if we add x and y, we take the first element of x, add it to the
# first element of y.  Then we take the second element of x, add it
# to the second element of y, and so on.

y = c(1,2,3,4)


x + y

x * y

# One interesting detail is that you can do vectorized operations,
# even if the vectors aren't the same length.

z = c(1, 2)
x + z

# What happened, is that the interpreter runs out of values in
# z, so it went back to the beginning of the vector and started
# over.

# This even works if the length of the longer vector is
# not a multiple of the length of the shorter one.

x + c(1,2,3)

# We do get a warning because R is worried that we did
# something wrong, but it lets us get away with it.


#####################################################################
# Character and Logical Vectors

# The vectors we've seen so far have all been numerical vectors.
# There are other types of vectors in R, I'll show you two more
# now.

# First, a character vector contains strings.
names = c("Paul", "Coye", "Steve", "Andy")
names

# R has a lot of machinery to help you work with
# character vectors.  For example, we can use the paste
# command to glue each string together

paste(names, collapse = "**")

# R also has logical vectors, that are very important
# for manipulating data.
# each element is True of False.

v = c(TRUE, TRUE, FALSE, TRUE)
v= c(T,T,F,T)

# We often get a logical vector, when we apply comparisons
# to numerical vectors.

x
x > 4
x %% 3 == 0 # mod operator

# we can perform operations on logical vectors
# The exclamation mark means NOT.
!v

# when we do numeric operations, TRUE is interpreted as 1,
# FALSE is interpreted as 0.
sum(v)
sum(!v)

# Note that a vector is all one type.  You should be careful
# when creating vectors.  If you put in different values, some
# may be coerced to other types.
c(x, "a")


#####################################################################
# Indexing Vectors

x
x[1]
x[2]
x[length(x)]

# We can put in an entire vector of indices
x[c(1,2)]
x[c(2,2,1)]

# here's an easy way to reverse a vector
x[4:1]

# negative indices mean that we want to omit elements.
x[-1]
x[-c(2,3)]


# We can also index using a logical vector.
x[c(T,T,F,F)]

# This is really useful when we're doing comparisons.
x > 3
x[x > 3]
x[x >= 3]

x[x == 4]
x[x != 4]

# We sometimes use the and operator & to make more complicated
# expressions.
x[x > 4 & x %% 3 == 0]

# | is the or operator.
x[x> 4 | x%% 3 == 0]

# Warning: don't confuse these with && and ||
# these only compare the first element of vectors.
# we don't usually need these, but they have uses in flow control


#####################################################################
# Defining Functions

# Note, this is a good time to open an editor window with
# a blank R script.
#
# Comments are made with the # sign.

# There are times when you need to define your own functions
# in R.

add1 = function(x) x + 1
x
add1(x)

# More complicated functions can be written on
# more than one line.

rescale = function(x) {
  upper = max(x)
  lower = min(x)
  (x - lower) / (upper - lower)
}
rescale(x)

# functions you define are also stored in the workspace.

objects()


# Finally, to quit R, you can use the quit() command
quit()