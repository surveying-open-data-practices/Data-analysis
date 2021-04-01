
### load packages -------

library(tidyverse)
library(here)

### Read files in ------

data_dir <- '~/Documents/Talarify/SODP/SODP_Rproject/data/edit'
data_all <- read_csv(here(data_dir, "results-for-idrc-surveyin-2021-03-05-0807_edit_allLanguages.csv"))
data_key <- read_csv(here(data_dir, "results-for-idrc-surveyin-2020-11-06-1612-key.en_edit.csv"))

### Data omissions ------

data_all <- data_all %>% drop_na(Q5) %>%  #Q5 (country): omit data where respondents did not answer (i.e. na)
   filter(! Q5 == "9") %>%  #Q5: omit data if answered 'none of the above' (option 9)
   drop_na(Q8) %>% #Q8 (involvement in research): omit data if not answered (i.e. = na)
   filter(! Q8 == "2") #Q8: omit data if answered 'no' (option 2)


# ----- rename question numbers for demographic options -----
# data_all (answers): rename demographic questions (Q1-Q8) to text for shiny choice options
data_all <- rename(data_all, Age = Q1, 
                   Gender = Q2,
                   Highest_degree = Q3,
                   Discipline_highest_degree = Q4,
                   Country = Q5,
                   Institution = Q6,
                   Position = Q7,
                   Research_project_involvement = Q8
)

# data_key (question key): rename demographic questions (Q1-Q8) to text for shiny choice options
data_key$demographicCategory <- case_when(data_key$ques_level1 == "Q1" ~ "Age",
                                          data_key$ques_level1 == "Q2" ~ "Gender",
                                          data_key$ques_level1 == "Q3" ~ "Highest_degree",
                                          data_key$ques_level1 == "Q4" ~ "Discipline_highest_degree",
                                          data_key$ques_level1 == "Q5" ~ "Country",
                                          data_key$ques_level1 == "Q6" ~ "Institution",
                                          data_key$ques_level1 == "Q7" ~ "Position",
                                          data_key$ques_level1 == "Q8" ~ "Research_project_involvement"
)


lookUp <- data_key %>% select(ques_level1, question)
lookupTable <- unique(lookUp)   


