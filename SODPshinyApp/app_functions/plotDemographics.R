
# this function is for plotting two demographics
# in the ggplot section, there is a choice between plotting counts or relative frequencies or percent stacked barplots (out of 100)


### plotting function -------
plotDemographics <- function(demographicOne, demographicTwo) {
   
   # Extract the Question answers and key from data_all and data_key and draw a plot
   
   # get the question answers
   answers_var1 <- data_all %>% select(URN, demographicOne)
   answers_var2 <- data_all %>% select(URN, demographicTwo)
   
   # get the question key
   question_key_var1 <- data_key %>% filter(demographicCategory == demographicOne) %>%
      select("choice_options_text", "choice_options_no", "demographicCategory")
   
   question_key_var2 <- data_key %>% filter(demographicCategory == demographicTwo) %>%
      select("choice_options_text", "choice_options_no", "demographicCategory")
   
   # Join the answers with the question_keys - var1
   by_condition <- "choice_options_no" # The column to match in the question_key
   names(by_condition) <- demographicOne
   qdata_to_plot_var1 <- left_join(answers_var1, question_key_var1, by = by_condition)
   
   # Join the answers with the question_keys - var2
   by_condition <- "choice_options_no" # The column to match in the question_key
   names(by_condition) <- demographicTwo
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
      theme(legend.position = "bottom", text = element_text(size = 14)) +
      guides(fill = guide_legend(ncol = 3, byrow = TRUE)) +

      # to show percent stacked barplot
      # geom_bar(position="fill", stat = "count", width=0.7) + 
      # labs(title = " ", x = " ", y = " ", fill = " ") +
      
      coord_flip()
}

#plotDemographics("Age", "Discipline_highest_degree")


