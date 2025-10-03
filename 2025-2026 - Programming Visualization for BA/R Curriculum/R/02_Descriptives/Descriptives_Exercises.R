# ----------------------------
# Erasmus Q-Intelligence B.V.
# ----------------------------

# -------------
# Exercise 1.1
# -------------

# a
forsale <- readRDS("../../data/forsale.Rds")

# b
View(forsale)
colnames(forsale)

# c 
nrow(forsale)
ncol(forsale)
dim(forsale)

# d 
summary(forsale)

# -------------
# Exercise 1.2
# -------------

# a
mean(forsale$asking_price)

# b 
median(forsale$asking_price) ## skew to the right (median < mean)

# c
min(forsale$asking_price)
max(forsale$asking_price)
range(forsale$asking_price)

# d 
max(forsale$asking_price) - min(forsale$asking_price)
sd(forsale$asking_price)

# e
table(forsale$city)
table(forsale$available_now)
table(forsale$type_build)
table(forsale$bedrooms)

# f
table(forsale$jacuzzi, forsale$sauna)
