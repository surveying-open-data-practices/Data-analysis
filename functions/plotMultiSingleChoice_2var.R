
# this function is for the multiple choice questions with a single choice option. It plots two variables (e.g. combined with a demographic)
# in the ggplot section, there is a choice between plotting counts or relative frequencies or percent stacked barplots
# the cleaned data files and key files are read in using the script readFilesCleanData.R


### load packages -------

library(tidyverse)


plotMultiSingleChoice_2var <- function(question_name, demographic) {
   
   # Extract the Question answers and key from data_all and data_key and draw a plot.
   
   # get the question answers
   answers_var1 <- data_all %>% select(URN, question_name)
   answers_var2 <- data_all %>% select(URN, demographic)
   
   # get the question key
   question_key_var1 <- data_key %>% filter(ques_level1 == question_name) %>%
      select("choice_options_text", "choice_options_no")
   
   question_key_var2 <- data_key %>% filter(ques_level1 == demographic) %>%
      select("choice_options_text", "choice_options_no")
   
   # Join the answers with the question_keys - var1
   by_condition <- "choice_options_no" # The column to match in the question_key
   names(by_condition) <- question_name
   qdata_to_plot_var1 <- left_join(answers_var1, question_key_var1, by = by_condition)
   
   # Join the answers with the question_keys - var2
   by_condition <- "choice_options_no" # The column to match in the question_key
   names(by_condition) <- demographic
   qdata_to_plot_var2 <- left_join(answers_var2, question_key_var2, by = by_condition)
   
   # join the var1 and var2 data sets using URN numbers
   qdata_to_plot <- left_join(qdata_to_plot_var1, qdata_to_plot_var2, by = "URN")
   
   # plot with ggplot
   ggplot(data = qdata_to_plot, aes(fill=choice_options_text.y, x=choice_options_text.x)) +
      
      # to show counts
      #geom_bar(position="stack", stat = "count", width=0.7) + 
      #labs(title = " ", x = " ", y = "Count", fill = " ") +
      
      # to show percentages
      geom_bar(position="stack", stat = "count", width=0.7, aes(y = (..count..)/sum(..count..))) +
      scale_y_continuous(labels=scales::percent) +
      labs(title = " ", x = " ", y = "Relative frequencies", fill = " ") +
      
      # to show percent stacked barplot
      # geom_bar(position="fill", stat = "count", width=0.7) + 
      # labs(title = " ", x = " ", y = " ", fill = " ") +
      
      coord_flip()
}

#plotMultiSingleChoice_2var("Q1", "Q5")


