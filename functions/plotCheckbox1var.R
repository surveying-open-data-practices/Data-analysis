

# this function is for the checkbox questions where more than one option can be selected. It plots one variable as a percentage.
# the cleaned data files and key files are read in using the script readFilesCleanData.R


### load packages -------

library(tidyverse)
library(kableExtra)
library(data.table)


plotCheckbox1var <- function(question_name) {
   
   # Extract the Question answers and key from data_all and data_key and draw a plot.
   
   # get the question answers: select all of ques level 2 nos for the ques level 1 identified in question_name
   question_numbers_level2 <- data_key %>% filter(ques_level1 == question_name)
   question_numbers_level2 <- question_numbers_level2$ques_level2
   answers_ch <- data_all %>% select(URN, question_numbers_level2)
   
   # get the question key
   question_key_ch <- data_key %>% filter(ques_level1 == question_name) %>%
      select("ques_level2", "question", "choice_options_text")
   
   # rename the columns of the data according to the options text from the key
   colnames(answers_ch) <- c("URN", question_key_ch$choice_options_text)
   
   # calculate share of respondents
   df <- data.frame(Frequency = colSums(answers_ch[2:ncol(answers_ch)]), Share_of_respondents = (colSums(answers_ch[2:ncol(answers_ch)])/sum(answers_ch[2:ncol(answers_ch)])) * 100, Share_of_cases = ((colSums(answers_ch[2:ncol(answers_ch)]))/nrow(answers_ch[2:ncol(answers_ch)])) * 100)
   
   # format the data into the required form
   setDT(df, keep.rownames = TRUE)
   colnames(df)[1] <- "Option"
   df %>% kableExtra::kbl(align = "c") %>% kable_paper("hover", full_width = F)
   
   ## plot with ggplot
   ggplot(data = df, aes(x = Option, y = Share_of_cases, fill = Option)) + 
      geom_bar(stat = "identity") + 
      theme(legend.position = "none") +
      geom_text(aes(label = paste0(round(Share_of_cases), "%")), position = position_stack(vjust = 0.5)) +
      labs(x = NULL, y = NULL, fill = NULL, title = " ") + 
      coord_flip()
   
}

#plotCheckbox1var("Q9")

