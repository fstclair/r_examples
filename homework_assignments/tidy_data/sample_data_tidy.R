install.packages("tidyverse")
install.packages("dplyr")


#import dataset single_wash_sfbw.csv

#set names of columns
colnames(single_wash_sfbw) <- c('SF intact rosettes', 'SF partially damaged rosettes', 'BW intact rosettes', 'BW partially damaged rosettes')

#remove last row because its total counts
single_wash_sfbw[-26,]
