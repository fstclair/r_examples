

#making box and whisker plot for first rep of sf and bw wash attachment assays
# - 'number of rosettes', 'number of partially damaged rosettes', and 'number of fully damaged rosettes' after 4 consecutive washes for SF and BW exine pollen media
# - starts with images pre-exine wash


#import the data sfbw_w_aa_ir.csv

df <- sfbw_w_aa_ir #set data name

library(tidyr)
library(dplyr)
library(ggplot2)
DF <- df %>% pivot_longer(everything(), names_to = "var",values_to = "values") #use 'pivot_longer' function from 'tidyr' package to transform data into two columns with the first one being the name of the condition and the second one contains values and set to DF:


col <- c("coral", "goldenrod1", "coral1", "goldenrod2", "coral2", "goldenrod3", "coral3", "goldenrod4", "coral4", "saddlebrown" ) #set colors for boxes


# grouped boxplot
ggplot(data, aes(x=variety, y=note, fill=treatment)) + 
  geom_boxplot()



g <-
  ggplot(DF, aes(x = var, y = values, fill = var)) + #using DF, x are the variables and y are the values
  labs(x = "Wash Number", y = "Number of individual rosettes") + #set x and y labels
  scale_fill_manual(values = col) + #manually fill the boxes with preset colors
  theme_classic()


#create the boxplot
g + geom_boxplot()

#want to figure out how to group by SF and BW and re-label axes

