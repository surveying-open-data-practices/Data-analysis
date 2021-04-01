

# this function is for the multiple choice questions with a single choice option. It plots one variable.
# in the ggplot section, there is a choice between plotting counts or percentages
# the cleaned data files and key files are read in using the script readFilesCleanData.R


### load packages -------

library(tidyverse)


plotMultiSingleChoice_1var <- function(question_name) {
   
   # Extract the Question answers and key from data_all and data_key and draw a plot.
   
   # get the question answers
   answers <- data_all %>% select(question_name)
   
   # get the question key
   question_key <- data_key %>% filter(ques_level1 == question_name) %>%
      select("choice_options_text", "choice_options_no")
   
   # Join the answers with the question_keys
   by_condition <- "choice_options_no" # The column to match in the question_key
   names(by_condition) <- question_name
   qdata_to_plot <- left_join(answers, question_key, by = by_condition)
   
   # plot with ggplot
   ggplot(data = qdata_to_plot, aes(x = choice_options_text)) +
      
      # to show counts
      geom_bar(stat="count", width=0.7, fill="steelblue") + 
      labs(title = " ", x = " ", y = "Count") +
      
      # to show percentages
      # geom_bar(position="stack", stat = "count", width=0.7, fill="steelblue", aes(y = (..count..)/sum(..count..))) +
      #scale_y_continuous(labels=scales::percent) +
      #labs(title = " ", x = " ", y = "Relative frequencies") +
      
      coord_flip()
   
}

#plotMultiSingleChoice_1var("Q1")


