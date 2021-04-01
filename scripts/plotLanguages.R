
### load packages -------

library(tidyverse)
library(here)

### Read files in ------
data_dir <- '~/Documents/Talarify/SODP/SODP_Rproject/data/edit'
data_all <- read_csv(here(data_dir, "results-for-idrc-surveyin-2021-03-05-0807_edit_allLanguages.csv"))
data_key <- read_csv(here(data_dir, "results-for-idrc-surveyin-2020-11-06-1612-key.en_edit.csv"))

### DATA OMMISSIONS
data_all <- data_all %>% drop_na(Q5) %>%  #Q5 (country): omit data where respondents did not answer (i.e. na)
   filter(! Q5 == "9") %>%  #Q5: omit data if answered 'none of the above' (option 9)
   drop_na(Q8) %>% #Q8 (involvement in research): omit data if not answered (i.e. = na)
   filter(! Q8 == "2") #Q8: omit data if answered 'no' (option 2)

### simple plot -- language distribution

# data selection
lang_dist <- select(data_all, "language")

# plot with ggplot
ggplot(data = lang_dist, aes(x = language)) +
   geom_bar(stat="count", width=0.7, fill="steelblue")
