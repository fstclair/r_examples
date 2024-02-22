

### day 3 coding class - creating fake beetle data
# Faith St. Clair
# 1.23.2024
# base R

### save code now!

### create dataset

# set a seed for reproducibility
set.seed(123)

# create vector of beetle names
beetle_names <- c("Ladybug", "Stag Beetle", "Firefly Beetle", "Dung Beetle", "Jewel Beetle")

# create a vector of beetle lengths
beetle_lengths <- runif(20, 1, 5) #random lengths between 1 and 5

# create a vector of beetle colors
beetle_colors <- sample(c("Red", "Black", "Green", "Yellow", "Blue"), 20, replace=TRUE)

# create the random beetle dataframe
beetle_df <- data.frame(Name = sample(beetle_names, 20, replace = TRUE), Length = beetle_lengths, Color = beetle_colors)
View(beetle_df)

# save this fake data to data directory - go slow!
write.csv(beetle_df, file = "data/fake_beetle_data.csv")

### make a quick chart

length_chart <- barplot(height = beetle_df$Length, names = beetle_df$Name)
# save chart: export > save as image > name and put in outputs


