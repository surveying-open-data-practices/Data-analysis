# About

This data directory includes the raw and cleaned data for the Surveying Open Data Practices 2020 project. More information is available at the website: https://surveying-open-data-practices.github.io/sopd2020/en/.

Plots may be used in blog posts, papers, and other media. All plots are under CC-BY 4.0 license. Please cite as follows: Data and plot provided by the Surveying Open Data Practices project funded by IDRC (2020) (https://surveying-open-data-practices.github.io/sopd2020/en/).


# Data

This data directory includes the raw survey response data and key files for all languages downloaded from the JISC Online survey tool on the 05 March 2021 and the 06 November 2020 respectively.

Within the data directory, there is a directory called [edit/](edit/), which contains the cleaned and edited data files for:
- The survey responses for all languages combined ([edit/results-for-idrc-surveyin-2021-03-05-0807_edit_allLanguages.csv](edit/results-for-idrc-surveyin-2021-03-05-0807_edit_allLanguages.csv))
- A key file (in English) ([edit/results-for-idrc-surveyin-2020-11-06-1612-key.en_edit.csv](edit/results-for-idrc-surveyin-2020-11-06-1612-key.en_edit.csv))
- An IAD Framework Key file showing the IAD categories of the survey questions ([edit/IADframeworkKey.csv](edit/IADframeworkKey.csv))


# Data cleaning

## Results files
The ordering, type and options of some of the survey questions differed between the three languages. Edits were made to the downloaded response csv data files to enable merging into one data file to use for analysis:
- A column was added for language and populated with the language of the survey (English, French or Portuguese).
- The French survey was missing option 12 for Question 19. Therefore this question was eliminated from all surveys.
- The question types for Questions 37, 46 and 59 differed between the three language surveys. These questions were therefore eliminated from all surveys.
- Questions 53, 54 and 55: in the English survey, the format of the headers differed between these questions and others of the same question type, i.e. Q53_1_a instead of Q53_1_a_1. The headers were edited for consistency. 
- Questions 53, 54 and 55: the format of the results for the English survey differed to all other results, where only 1’s were shown and no 0's. This was dealt with in the Shiny App R code, where NAs were replaced with 0's to enable correct result interpretation for plotting.
- Questions 2 and 3 had been switched around in the Portuguese survey. This was corrected, and all three language surveys were compared to ensure consistent question numbering.
- All three language survey files were merged into one for analysis.

### Data ommissions (dealt with in the Shiny app R code)
- Question 5 (What country do you currently work in?): data excluded if this question was not answered, or if answered 'none of the above'.
- Question 8 (Are you currently involved in a research project, or have been in the last 5 years?): data excluded if answered 'no' or if not answered.
- Question 6 (What kind of institution do you currently work in?): One of the prerequisites was that respondents had to be working in an institution conducting research. However, we did not exclude respondents who answered Question 6 'I do not work in an institution conducting research', as Question 8 (i.e. 'Are you currently involved in a research project, or have been in the last 5 years?') implies that respondents do not have to CURRENTLY be working in an institution conducting research.


## Key file
The key file in the downloaded format was not very user friendly. For example, the question number formats are not the same as those given in the respondents results files. Also, there is more than one data type in column two, i.e. both questions and options in the same column.

To clean the key file to ready it for use in the data analysis and visualisation, the following edits were made to the downloaded file:
- An extra column was added for the question numbers. The column 'ques_level1' contains the overall question number (e.g. Q1); 'ques_level2' contains the next question number level (e.g. Q10_1, Q11_1_b_1, etc) to correspond to the numbering given in the results data files.
- A column was added giving the question type (e.g. multiple choice, checkbox or multiple choice grid).
- In the original key file, both questions and options were listed in the same column. These were split and the questions were placed in their own column, a column was added for the multiple choice grid options (e.g. During research, After research, etc). The text for the options was placed in another column (e.g. for Q1: 18-24, 25-34, etc), and the numbers for these options that correspond to the numbering given in the results file (1,2,3, etc) were put into a separate column.
- The choice options text column was edited to reduce the legend text size for the plots.
