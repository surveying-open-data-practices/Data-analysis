
# this function is for the checkbox questions where more than one option can be selected. It plots two variables (e.g. combined with a demographic)
# in the ggplot section, there is a choice between plotting counts or percent stacked barplots (out of 100); the plot of relative frequencies is not yet possible


plotCheckbox2var <- function(questionName, demographic,  data_key, data_all) {
   
   lookUpTableCheckbox <- data_key %>% select(ques_level1, ques_level2, ques_type, question) %>% 
      filter(ques_type == "checkbox")

   questionName <- as.character(unique(lookUpTableCheckbox %>% filter(question == questionName) %>% select(ques_level1)))
   
   # Extract the Question answers and key from data_all and data_key and draw a plot.
   
   # Question Answers
   # =================
   # get the question answers: select all of ques level 2 nos for the ques level 1 identified in question_name
   question_numbers_level2 <- data_key %>% filter(ques_level1 == questionName)
   question_numbers_level2 <- question_numbers_level2$ques_level2
   answers_ch <- data_all %>% select(URN, question_numbers_level2)
   
   # get the question key for the checklist
   question_key_ch <- data_key %>% filter(ques_level1 == questionName) %>%
      select("ques_level2", "question", "choice_options_text", "choice_options_no", "demographicCategory")
   
   # rename the columns of the data according to the options text from the key
   colnames(answers_ch) <- c("URN", question_key_ch$choice_options_text)
   
   # Demographics (or any other multi choice single option question)
   # =================   
   # select for the demographics data
   answers_demographic <- data_all %>% select(URN, demographic)
   
   ## get question key for the demographic and left join onto the answers_demographic
   # question key for the demographic
   question_key_demographic <- data_key %>% filter(demographicCategory == demographic) %>%
      select("choice_options_text", "choice_options_no", "demographicCategory")
   
   # Join the demographic answers with the question_keys
   by_condition <- "choice_options_no" # The column to match in the question_key
   names(by_condition) <- demographic
   qdata_to_plot <- left_join(answers_demographic, question_key_demographic, by = by_condition)
   
   # join the var1 and var2 data sets using URN numbers
   data_total <- left_join(qdata_to_plot, answers_ch, by = "URN")
   
   # plot count data and the fill is the choice_options_text
   
   df_plot <- data_total[, -c(1:2, 4)]
   
   df_plot <- df_plot %>% pivot_longer(
      cols = !choice_options_text,
      names_to = "option",
      values_to = "counts")
   
   # plot with ggplot
   ## counts
   ggplot(df_plot, aes(x=counts, y=option, fill=choice_options_text)) +
      geom_bar(stat = "identity") +
      labs(title = " ", x = "Count ", y = "", fill = " ") +
      theme(legend.position = "bottom", text = element_text(size = 14)) +
      guides(fill = guide_legend(ncol = 3, byrow = TRUE))

   ## to show percent stacked barplot
   #    geom_bar(position="fill", stat = "identity", width=0.7) + 
   #    labs(title = " ", x = " ", y = " ", fill = " ") #+
   
   #coord_flip()
   
}

#plotCheckbox2var("Based on your methods of data collection, what types of data do you generate during your research (select all that apply)?", "Age")

