#######
#Coding challenge - Faith St. Clair
#merging my work with the hints provided

# Randy's comments -----

# You do not have code to read in the input data so I cannot rerun or be sure this works.  I cannot find the data in your directory.  Please fix.



#load libraries
library(tidyverse)
#install.packages("janitor")
library(janitor)

###
#pivot longer rcm data frame

rcm <- ref_con_modified %>% 
  pivot_longer(!Model_Code, names_to = "refLabel", values_to = "refPercent") %>%
  unite(model_label, c("Model_Code", "refLabel"), remove = FALSE) %>%
  left_join(bps_model_number_name)

###
# need bps model numbers
aoi_bps_models <- bps_aoi_attributes$BPS_MODEL

#subset ref_con to aoi, keeping all BpSs in the AOI for now
aoi_ref_con <- subset(rcm, Model_Code %in% aoi_bps_models)

###

## wrangle current & make calculations

#bring in s-class labels
combine <- left_join(combine_raw, 
                     scls_aoi_attributes %>%
                       dplyr::select(2, 4),  
                     by = c("Var2" = "VALUE"))

#bring in bps labels
combine <- left_join(combine, 
                     LF16_BPS_200 %>%
                       dplyr::select(1:4),
                     by = c("Var1" = "VALUE"))

# calculate current sclass percents
current <- combine %>%
  group_by(Var1, BPS_MODEL) %>%
  mutate(total_count = sum(Freq)) %>%
  mutate(currentPercent = as.integer((Freq/total_count)*100)) %>%
  unite(model_label, c("BPS_MODEL", "LABEL"))

#percents for one group should be around 100

#may be missing sclass labels

#merge everything together

aoi_ref_cur <- left_join(aoi_ref_con, #combining dataset created with the current data calculated
                         current) %>%
  drop_na(refPercent) %>% #delete any na values
  mutate(currentPercent = as.numeric(currentPercent), #mutate column & make into a numeric data type
         currentPercent = ifelse(is.na(currentPercent), 0,  currentPercent)) %>% 
  mutate(total_count = as.numeric(total_count),
         total_count = ifelse(is.na(total_count), 0, total_count)) %>% #checking the na's with ifelse and is.na
  select(-c(BPS_CODE, ZONE)) %>% 
  select(c(Freq, #selecting just the columns i need
           Var1,
           Var2,
           BpS_Name,
           Model_Code,
           refLabel,
           model_label,
           refPercent,
           currentPercent,
           total_count)) %>%
  rename(count = Freq, #renaming for consistency
         bps_value = Var1,
         scl_value = Var2,
         bps_name = BpS_Name) %>%
  clean_names() #clean messy column names


###

#now set up the data for the chart
bps_scls_top <- aoi_ref_cur %>%
  group_by(model_code) %>% #grouping by model code between current and past that was merged
  mutate(total_count = ifelse(total_count == 0, max(total_count), total_count)) %>%
  arrange(desc(total_count))  %>%
  ungroup() %>%
  dplyr::filter(dense_rank(desc(total_count)) < 4) %>%
  dplyr::select(c("bps_name", "ref_label",  "current_percent", "ref_percent")) %>%
  pivot_longer(
    cols = c(`ref_percent`, `current_percent`), 
    names_to = "ref_cur", 
    values_to = "percent"
  )

#mutate for total counts at 0
#arrange total count in descending order and ungroup
#filter for values less than 4
#select the columns needed and tidy by pivot longer with past and current

# order classes for chart
bps_scls_top$ref_label <- factor(bps_scls_top$ref_label, 
                                 levels = c(
                                   "Developed",
                                   "Agriculture",
                                   "E",
                                   "D",
                                   "C",
                                   "B",
                                   "A"))

#make the plot!

plot <-
  ggplot(bps_scls_top, aes(fill = factor(ref_cur), y = percent, x = ref_label)) + 
  geom_col(width = 0.8, position = position_dodge()) +
  coord_flip() +
  facet_grid(. ~BpS) +
  scale_x_discrete(limits = (levels(bps_scls_top$ref_label))) +
  labs(
    title = "Succession Classes past and present",
    subtitle = "Top BpSs selected for illustration. Not all succession classes present in all BpSs",
    caption = "Data from landfire.gov.",
    x = "",
    y = "Percent") +
  theme_minimal(base_size = 12) +
  theme(plot.caption = element_text(hjust = 0, face = "italic"), #default is hjust=1
        plot.title.position = "plot", #NEW parameter. apply for subtitle too.
        plot.caption.position =  "plot") +
  scale_fill_manual(values = c("#3d4740", "#32a852" ), # present (grey), historical (green)
                    name = " ", 
                    labels = c("Present",
                               "Past")) +
  facet_wrap(~bps_name, nrow(3),labeller = labeller(bps_name = label_wrap_gen())) +
  theme(panel.spacing = unit(.05, "lines"),
        panel.border = element_rect(color = "black", fill = NA, size = 1), 
        strip.background = element_rect(color = "black", size = 1))

plot


#########

###Reflection
#I learned that I struggle to understand datasets that I'm not exactly used to seeing. I need to ground myself with messy data and work to wrap my head around the data.
#I also need to learn how to better put things together/merge things in the data. I hit a stopping point where I wasn't sure where to go, so learning how to successfully Google and use my resources will be helpful in the future.
#I learned how to somewhat sort messy data and combining multiple tasks in one line of code. I usually split things up, but learned to combine and be more efficient with my code.
#I think I did well with the chart and mocking up a fake graph originally. I also think I did well with the general workflow and planning out what I needed to do, but executing my plan is where I struggled.
#Overall, I definitely struggled with this challenge, but appreciated a real-world example and learning how to use my resources to solve the challenge.



