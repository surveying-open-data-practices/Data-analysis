
NB: THIS IS NOT IN A FUNCTION YET


# this script is for the multiple choice grid (table) questions where more than one option can be selected.
# it plots relative frequencies for more than one condition of the data (e.g. options selected for 'during research' and options selected for 'after research'). The plots are arranged to show in one plotting window

# the cleaned data files and key files are read in using the script readFilesCleanData.R


### load packages -------

library(tidyverse)
library(kableExtra)
library(data.table)
library(ggpubr)


#plotMultichoiceGrid1var <- function(questionName) {

# Extract the Question answers and key from data_all and data_key and draw a plot

# get the question answers: select all of ques level 2 nos for the ques level 1 identified in question_name
question_numbers_level2 <- data_key %>% filter(ques_level1 == "Q11") # for function: replace "Q11" with questionName
question_numbers_level2 <- question_numbers_level2$ques_level2
answers_mcg <- data_all %>% select(URN, question_numbers_level2)

# get the question key
question_key_mcg <- data_key %>% filter(ques_level1 == "Q11") %>%
   select("ques_level2", "question", "multiple_choice_grid_options", "choice_options_text")

# split answers_mcg by the letter in the column names (e.g. a, b, etc)
mcg_answers_a <- answers_mcg %>% select("URN", contains("a"))
mcg_answers_b <- answers_mcg %>% select("URN", contains("b"))

# split the question_key using group_split on the multiple_choice_grid_options - this allows a tibble for one of the ques level 2 options to be extracted (e.g. before research, after research)
mcg_key <- question_key_mcg %>% 
   group_split(multiple_choice_grid_options)

#mcg_key[[1]]
#mcg_key[[2]]

# get the names of the tibbles for the multiple choice options for the plots
name_one <- mcg_key[[1]][1,3]
name_two <- mcg_key[[2]][1,3]

# rename the column headings containing ques nos in answers_mcg with the choice options text
colnames(mcg_answers_a) <- c("URN", mcg_key[[1]]$choice_options_text)
colnames(mcg_answers_b) <- c("URN", mcg_key[[2]]$choice_options_text)

# calculate share of respondents: a
dfa <- data.frame(Frequency = colSums(mcg_answers_a[2:ncol(mcg_answers_a)]), Share_of_respondents = (colSums(mcg_answers_a[2:ncol(mcg_answers_a)])/sum(mcg_answers_a[2:ncol(mcg_answers_a)])) * 100, Share_of_cases = ((colSums(mcg_answers_a[2:ncol(mcg_answers_a)]))/nrow(mcg_answers_a[2:ncol(mcg_answers_a)])) * 100)

# calculate share of respondents: b
dfb <- data.frame(Frequency = colSums(mcg_answers_b[2:ncol(mcg_answers_b)]), Share_of_respondents = (colSums(mcg_answers_b[2:ncol(mcg_answers_b)])/sum(mcg_answers_b[2:ncol(mcg_answers_b)])) * 100, Share_of_cases = ((colSums(mcg_answers_b[2:ncol(mcg_answers_b)]))/nrow(mcg_answers_b[2:ncol(mcg_answers_b)])) * 100)

# format the data into the required form: a
setDT(dfa, keep.rownames = TRUE)
colnames(dfa)[1] <- "Option"
dfa %>% kableExtra::kbl(align = "c") %>% kable_paper("hover", full_width = F)

# format the data into the required form: b
setDT(dfb, keep.rownames = TRUE)
colnames(dfb)[1] <- "Option"
dfb %>% kableExtra::kbl(align = "c") %>% kable_paper("hover", full_width = F)

## plot with ggplot: a
p1 <-  ggplot(data = dfa, aes(x = Option, y = Share_of_cases, fill = Option)) + 
   geom_bar(stat = "identity") + 
   theme(legend.position = "none") +
   geom_text(aes(label = paste0(round(Share_of_cases), "%")), position = position_stack(vjust = 0.5)) + 
   labs(x = NULL, y = NULL, fill = NULL, title = name_two) + 
   coord_flip()

## plot with ggplot: b
p2<-  ggplot(data = dfb, aes(x = Option, y = Share_of_cases, fill = Option)) + 
   geom_bar(stat = "identity") + 
   theme(legend.position = "none") +
   geom_text(aes(label = paste0(round(Share_of_cases), "%")), position = position_stack(vjust = 0.5)) + 
   labs(x = NULL, y = NULL, fill = NULL, title = name_one) + 
   coord_flip()

figure <- ggarrange(p1, p2,
                    ncol = 1, nrow = 2)
figure

#}

#plotMultichoiceGrid1var("Q ")


