
# this function is for the checkbox questions where more than one option can be selected. It plots two variables (e.g. combined with a demographic)
# in the ggplot section, there is a choice between plotting counts or percent stacked barplots; I cannot get the plot of relative frequencies to work yet
# the cleaned data files and key files are read in using the script readFilesCleanData.R


### load packages -------

library(tidyverse)

# NOTE: This function plots either the counts, or a percent stacked barplot (out of 100), but I cannot get the plot of frequencies to work yet


plotCheckbox2var <- function(question_name, demographic) {
   
   # Extract the Question answers and key from data_all and data_key and draw a plot.
   
   # Question Answers
   # =================
   # get the question answers: select all of ques level 2 nos for the ques level 1 identified in question_name
   question_numbers_level2 <- data_key %>% filter(ques_level1 == question_name)
   question_numbers_level2 <- question_numbers_level2$ques_level2
   answers_ch <- data_all %>% select(URN, question_numbers_level2)
   
   # get the question key for the checklist
   question_key_ch <- data_key %>% filter(ques_level1 == question_name) %>%
      select("ques_level2", "question", "choice_options_text")
   
   # rename the columns of the data according to the options text from the key
   colnames(answers_ch) <- c("URN", question_key_ch$choice_options_text)
   
   # Demographics (or any other multi choice single option question)
   # =================   
   # select for the demographics data
   answers_demographic <- data_all %>% select(URN, demographic)
   
   ## get question key for the demographic and left join onto the answers_demographic
   # question key for the demographic
   question_key_demographic <- data_key %>% filter(ques_level1 == demographic) %>%
      select("choice_options_text", "choice_options_no")
   
   # Join the demographic answers with the question_keys
   by_condition <- "choice_options_no" # The column to match in the question_key
   names(by_condition) <- demographic
   qdata_to_plot <- left_join(answers_demographic, question_key_demographic, by = by_condition)
   
   # join the var1 and var2 data sets using URN numbers
   data_total <- left_join(qdata_to_plot, answers_ch, by = "URN")
   
   # plot count data and the fill is the choice_options_text
   
   df_plot <- data_total[, -c(1:2)]
   
   df_plot <- df_plot %>% pivot_longer(
      cols = !choice_options_text,
      names_to = "option",
      values_to = "counts")
   
   # plot with ggplot
   ## counts
   ggplot(df_plot, aes(x=counts, y=option, fill=choice_options_text)) +
      geom_bar(stat = "identity") +
      labs(title = " ", x = "Count ", y = "", fill = " ")
   
   ## to show percent stacked barplot
   #    geom_bar(position="fill", stat = "identity", width=0.7) + 
   #    labs(title = " ", x = " ", y = " ", fill = " ") #+
   
   #coord_flip()
   
}

#plotCheckbox2var("Q60", "Q1")


# NOTE: This function plots either the counts, or a percent stacked barplot (out of 100), but I cannot get the plot of frequencies to work yet