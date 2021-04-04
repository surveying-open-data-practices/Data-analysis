

# this function is for plotting the multiple choice grid (table) question Q55 combined with a demographic.
# it plots counts for more than one condition of the data (e.g. options selected by respondents for 'during research' and options selected for 'after research'). The plots are arranged to show in one plotting window

#questionName <- "Do any other these issues impact on your ability to share your data effectively?"
#demographic <- "Age"

plotMultiChoiceGrid2var_Q55 <- function(questionName, demographic, data_key, data_all, lookupTable) {

   questionName <- as.character(lookupTable %>% filter(question == questionName) %>% select(ques_level1))
   
   # Extract the Question answers and key from data_all and data_key and draw a plot: there are FOUR levels

   ## Question answers ====== ##
   # ==================

   # get the question answers: select all of ques level 2 nos for the ques level 1 identified in questionName
   question_numbers_level2 <- data_key %>% filter(ques_level1 == questionName)
   question_numbers_level2 <- question_numbers_level2$ques_level2
   answers_mcg <- data_all %>% select(URN, question_numbers_level2)
   answers_mcg[is.na(answers_mcg)] <- 0  # replace NAs with 0

   # get the question key
   question_key_mcg <- data_key %>% filter(ques_level1 == questionName) %>%
   select("ques_level2", "question", "multiple_choice_grid_options", "choice_options_text")

   # split answers_mcg by the letter in the column names (e.g. a, b, etc)
   mcg_answers_a <- answers_mcg %>% select("URN", contains("a")) # strongly agree
   mcg_answers_b <- answers_mcg %>% select("URN", contains("b")) # agree
   mcg_answers_c <- answers_mcg %>% select("URN", contains("c")) # disagree
   mcg_answers_d <- answers_mcg %>% select("URN", contains("d")) # strongly disagree

   # split the question_key using group_split on the multiple_choice_grid_options - this allows a tibble for one of the ques level 2 options to be extracted (e.g. before research, after research)
   mcg_key <- question_key_mcg %>% 
   group_split(multiple_choice_grid_options)
   #mcg_key[[1]]
   #mcg_key[[2]]
   #mcg_key[[3]]
   #mcg_key[[4]]

   # get the names of the tibbles for the multiple choice options
   name_one <- mcg_key[[1]][1,3]    # 'b' - agree
   name_two <- mcg_key[[2]][1,3]    # 'c' - disagree
   name_three <- mcg_key[[3]][1,3]  # 'a' - strongly agree
   name_four <- mcg_key[[4]][1,3]   # 'd' - strongly disagree
   
   # rename the column headings containing ques nos in answers with the choice options text
   colnames(mcg_answers_a) <- c("URN", mcg_key[[3]]$choice_options_text)
   colnames(mcg_answers_b) <- c("URN", mcg_key[[1]]$choice_options_text)
   colnames(mcg_answers_c) <- c("URN", mcg_key[[2]]$choice_options_text)
   colnames(mcg_answers_d) <- c("URN", mcg_key[[4]]$choice_options_text)
   

   ## Demographics (or any other multi choice single option question) ====== ##
   # ==================
   # select for the demographics data
   answers_demographic <- data_all %>% select(URN, demographic)

   ## get question key for the demographic and left join onto the answers_demographic ====== ##
   # ==================   
   # question key for the demographic
   question_key_demographic <- data_key %>% filter(demographicCategory == demographic) %>%
   select("choice_options_text", "choice_options_no")

   # Join the demographic answers with the question_keys
   by_condition <- "choice_options_no" # The column to match in the question_key
   names(by_condition) <- demographic
   qdata_to_plot <- left_join(answers_demographic, question_key_demographic, by = by_condition)

   # join the key/choice options text to answers files a, b, c, d using URN numbers ====== ##
   # ==================
   data_total_a <- left_join(qdata_to_plot, mcg_answers_a, by = "URN")
   data_total_b <- left_join(qdata_to_plot, mcg_answers_b, by = "URN")
   data_total_c <- left_join(qdata_to_plot, mcg_answers_c, by = "URN")
   data_total_d <- left_join(qdata_to_plot, mcg_answers_d, by = "URN")
   

   # plot count data and the fill is the choice_options_text ====== ##
   # ==================
   df_plot_a <- data_total_a[, -c(1:2)]
   df_plot_b <- data_total_b[, -c(1:2)]
   df_plot_c <- data_total_c[, -c(1:2)]
   df_plot_d <- data_total_d[, -c(1:2)]

   df_plot_a <- df_plot_a %>% pivot_longer(
      cols = !choice_options_text,
      names_to = "option",
      values_to = "counts")

   df_plot_b <- df_plot_b %>% pivot_longer(
      cols = !choice_options_text,
      names_to = "option",
      values_to = "counts")

   df_plot_c <- df_plot_c %>% pivot_longer(
      cols = !choice_options_text,
      names_to = "option",
      values_to = "counts")

   df_plot_d <- df_plot_d %>% pivot_longer(
      cols = !choice_options_text,
      names_to = "option",
      values_to = "counts")
     
   # plot with ggplot ====== ##
   # ==================
   ## counts
   p1 <- ggplot(df_plot_a, aes(x=counts, y=option, fill=choice_options_text)) +
         geom_bar(stat = "identity") +
         labs(title = name_three, x = " ", y = "", fill = " ") +
         theme(text = element_text(size = 11), plot.title = element_text(size = 12)) +
         guides(fill = guide_legend(ncol = 3, byrow = TRUE)) +
         coord_cartesian(xlim =c(0, 30))

   p2 <- ggplot(df_plot_b, aes(x=counts, y=option, fill=choice_options_text)) +
         geom_bar(stat = "identity") +
         labs(title = name_one, x = " ", y = "", fill = " ") +
         theme(text = element_text(size = 11), plot.title = element_text(size = 12)) +
         guides(fill = guide_legend(ncol = 3, byrow = TRUE)) +
         coord_cartesian(xlim =c(0, 30))
   
   p3 <- ggplot(df_plot_c, aes(x=counts, y=option, fill=choice_options_text)) +
         geom_bar(stat = "identity") +
         labs(title = name_two, x = " ", y = "", fill = " ") +
         theme(text = element_text(size = 11), plot.title = element_text(size = 12)) +
         guides(fill = guide_legend(ncol = 3, byrow = TRUE)) +
         coord_cartesian(xlim =c(0, 30))
   
   p4 <- ggplot(df_plot_d, aes(x=counts, y=option, fill=choice_options_text)) +
         geom_bar(stat = "identity") +
         labs(title = name_four, x = "Count ", y = "", fill = " ") +
         theme(text = element_text(size = 11), plot.title = element_text(size = 12)) +
         guides(fill = guide_legend(ncol = 3, byrow = TRUE)) +
         coord_cartesian(xlim =c(0, 30))
     
   grid_arrange_shared_legend(p1, p2, p3, p4, ncol = 1, nrow = 4)  # shares the legend
     
   }

#plotMultiChoiceGrid2var_Q55("Do any other these issues impact on your ability to share your data effectively?", "Age")
