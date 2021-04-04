# SODP Data Analysis - Shiny App
#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
# http://shiny.rstudio.com/
#

# ----- load libraries -----
library(shiny)
library(tidyverse)
library(here)
library(DT)
# library(ggpubr)
library(lemon) # for grid_arrange_shared_legend
library(gridExtra)

# usecairo = T from package Cairo for better quality of figures in shiny app
options(shiny.usecairo=T)

# ----- load data -----
#data_dir <- 'SODPshinyApp/data'
data_all <- read_csv("data/results-for-idrc-surveyin-2021-03-05-0807_edit_allLanguages.csv")
data_key <- read_csv("data/results-for-idrc-surveyin-2020-11-06-1612-key.en_edit.csv")
IAD_framework_key <- read_csv("data/IADframeworkKey.csv")

# ----- data omissions -----
data_all <- data_all %>% drop_na(Q5) %>%
    filter(! Q5 == "9") %>%
    drop_na(Q8) %>%
    filter(! Q8 == "2")

# ----- data omissions -----: exclude code columns from the IAD framework key
IAD_framework_key <- IAD_framework_key %>% select("Question_no", "Question", "IAD_category_1", "IAD_category_2", "IAD_category_3")
    
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

# ----- choices for demographic barplot -----
demographicOptions <- c("Age", "Gender", "Highest_degree", "Discipline_highest_degree", "Country", "Institution", "Position", "Research_project_involvement")

# ----- create lookupTable for question dropdown menu for visualisations panel -----
lookUp <- data_key %>% select(ques_level1, question, ques_type)
lookupTable <- unique(lookUp)
lookupTable <-  slice(lookupTable, -(1:8)) # exclude the demographics questions

# ----- question choices, and question type, for 3rd panel visualisations -----
visualisationQuestions <- lookupTable$question

# ----- load plot functions -----
source('app_functions/plotDemographics.R')
source('app_functions/plotMultiChoiceSingleOption.R')
source('app_functions/plotCheckbox2var.R')
source('app_functions/plotMultiChoiceGrid2var_Q11.R')
source('app_functions/plotMultiChoiceGrid2var_Q17.R')
source('app_functions/plotMultiChoiceGrid2var_Q18.R')
source('app_functions/plotMultiChoiceGrid2var_Q27.R')
source('app_functions/plotMultiChoiceGrid2var_Q53.R')
source('app_functions/plotMultiChoiceGrid2var_Q54.R')
source('app_functions/plotMultiChoiceGrid2var_Q55.R')


#### -----  Define UI for application that draws plot -----
ui <- fluidPage(
    # Application title
    titlePanel("IDRC Surveying Open Data Practices in Africa 2020"),
    p("The Internet and progress in digital technologies are increasingly shifting the logic underlying science and research from closed to open systems. This change is affecting even the way data are managed, used and shared. This project aimed to capture the current landscape of open data practices in research in Africa. We attempted to gather information from eight African countries including Uganda and Ethiopia from East Africa; Burkina Faso and Senegal from West Africa and Botswana, Malawi, Mozambique and Zimbabwe from Southern Africa."),
    tabsetPanel(
# ----- input for first panel (Language distribution) -----
        tabPanel('Language distribution',
            sidebarLayout(
                sidebarPanel(
                    p("Project completed March 2021."),
                    p("The SODP project was funded by the IDRC and hosted by InSIS, Oxford University. For more details please see the ", a("SODP website.", href="https://surveying-open-data-practices.github.io/sopd2020/en/")),
                    p("Open source R code. TO INSERT LINK"),
                    p("See the ", a(href="https://surveying-open-data-practices.github.io/sopd2020/en/blog/", "SODP blog page"), "for more information about the data analysis.")
                    
                    ), # end sidebarPanel
                mainPanel(
                    h4('Distribution of surveys completed in English, French and Portuguese'),
                    plotOutput(outputId = "LangPlot"),
                    #downloadButton('down', 'Download plot'),
                    p(" "),
                    p("To download the plot, right click and select 'Save Image As'."),
                    p("Plots may be used in blog posts, papers, and other media. All plots are under CC-BY 4.0 license. Please cite as follows: Data and plot provided by the Surveying Open Data Practices project funded by IDRC (2020) (https://surveying-open-data-practices.github.io/sopd2020/en/).")
                ) # end mainPanel
            ) # end sidebarLayout
        ), # end tabPanel
# ----- input for second panel (Demographics) -----
        tabPanel('Demographics',
            sidebarLayout(
                sidebarPanel(
                    selectInput(
                        inputId = 'DemographicOption1',
                        label = 'Choose which demographic variable to plot',
                        choices = demographicOptions
                    ), # end selectInput
                    conditionalPanel(condition = "input.DemographicOption2",
                                     # 2nd input for stacking of bargraphs
                                     selectInput(
                                         inputId = 'DemographicOption2',
                                         label = 'Choose by which demographic variable to stack the bars',
                                         choices = demographicOptions
                                     ) # end selectInput
                    ) # end conditionalPanel
                ), # end sidebarPanel
                mainPanel(
                    h4('Demographic information of the respondents'),
                    p(''),
                    plotOutput(outputId = "plotDemographics"),
                    #downloadButton('downloadDemographic', 'Download plot'),
                    p(" "),
                    p("To download the plot, right click and select 'Save Image As'."),
                    p("Plots may be used in blog posts, papers, and other media. All plots are under CC-BY 4.0 license. Please cite as follows: Data and plot provided by the Surveying Open Data Practices project funded by IDRC (2020) (https://surveying-open-data-practices.github.io/sopd2020/en/).")
                ) # end mainPanel
            ) # end sidebarLayout
        ), # end tabPanel

# ----- input for third panel (Visualisations plots) -----
        tabPanel('Visualisation plots',
            sidebarLayout(
                sidebarPanel(
                    selectInput(
                        inputId = 'question',
                        label = 'Select a question for visualisation',
                        choices = visualisationQuestions
                    ), # end selectInput
                    conditionalPanel(condition = "input.DemographicOption3",
                                     # 2nd demographic input for stacking of bargraphs
                                     selectInput(
                                         inputId = 'DemographicOption3',
                                         label = 'Choose by which demographic variable to stack the bars',
                                         choices = demographicOptions
                                     ) # end selectInput
                    ), # end conditionalPanel
                ), # end sidebarPanel
                mainPanel(
                    h4('Visualisation plots for all data'),
                    p('Select a question to see a data visualisation. The IAD Framework classifications are shown in the IAD Framework categories table.'),
                    plotOutput(outputId = "plotVisual"),
                    #downloadButton('downloadVisPlots', 'Download plot'),
                    p(" "),
                    p("To download the plot, right click and select 'Save Image As'."),
                    p("Plots may be used in blog posts, papers, and other media. All plots are under CC-BY 4.0 license. Please cite as follows: Data and plot provided by the Surveying Open Data Practices project funded by IDRC (2020) (https://surveying-open-data-practices.github.io/sopd2020/en/).")
                ) # end mainPanel
            ) # end sidebarLayout
        ), # end tabPanel

# ----- input (table) for fourth panel (IAD Framework table) -----
        tabPanel('IAD Framework categories table',
                 h3("IAD Framework categories table"),
                 DT::dataTableOutput("mytable")
                 )
    ) # end tabsetPanel
) # end fluidpage
    
    
#### -----  Define server logic required to draw a plot -----
server <- function(input, output) {
    
    # ----- output for first panel (Language distribution) -----
    # data selection
    lang_dist <- select(data_all, "language")
    
    # plot with ggplot
    output$LangPlot <- renderPlot({
        ggplot(data = lang_dist, aes(x = language)) +
            geom_bar(stat="count", width=0.7, fill="steelblue") +
            theme(text = element_text(size = 14)) +
            labs(x = " ")
    }) 
    
    # # ----- Download button for download of graphs ----- THIS CODE WORKS, but we have removed the download button for now
    # LangPlot <- reactive({
    #     ggplot(data = lang_dist, aes(x = language)) +
    #         geom_bar(stat="count", width=0.7, fill="steelblue") +
    #         theme(text = element_text(size = 14)) +
    #         labs(x = " ")
    # })
    # output$LangPlot <- renderPlot({
    #     p <- LangPlot()
    #     print(p)
    # })
    # # downloadHandler to download the plot
    # output$down <- downloadHandler(
    #     filename = function() {
    #         paste('SODP survey language distribution ', Sys.Date(),'.png', sep='')
    #     },
    #     content = function(file) {
    #         png(file)
    #         print(LangPlot())
    #         dev.off()
    #     },
    #     contentType = 'image/png'
    # )
           
    # ----- output for second panel (Demographics) -----
    # plot with ggplot
    output$plotDemographics <- renderPlot({
        plotDemographics(input$DemographicOption1, input$DemographicOption2,  data_key, data_all)
    })

    # # ----- Download button for download of graphs ----- THIS CODE WORKS, but we have removed the download button for now
    # demoPlot <- reactive({
    #     plotDemographics(input$DemographicOption1, input$DemographicOption2)
    # })
    # output$downloadDemographic <- renderPlot({
    #     p <- demoPlot()
    #     print(p)
    # })
    # # downloadHandler to download the plot
    # output$downloadDemographic <- downloadHandler(
    #     filename = function() {
    #         paste('SODP survey demographic plot ', Sys.Date(),'.png', sep='')
    #     },
    #     content = function(file) {
    #         png(file)
    #         print(demoPlot())
    #         dev.off()
    #     },
    #     contentType = 'image/png'
    # )
        
    # ----- output for third panel (Visualisations plots) -----
    # plot with ggplot
    output$plotVisual <- renderPlot({
        question_type <- as.character(lookupTable %>% filter(question == input$question) %>% select(ques_type))
        if (question_type == "multichoice_single answer") {
            plotMultiChoiceSingleOption(input$question, input$DemographicOption3, data_key, data_all, lookupTable)
        } else if (question_type == "checkbox") {
            plotCheckbox2var(input$question, input$DemographicOption3,  data_key, data_all)
        } else if (question_type == "multiple choice grid") {
            if (input$question == "Where did you store the data you created while you were conducting your research and after research was completed (select all that apply)") {
                plotMultiChoiceGrid2var_Q11(input$question, input$DemographicOption3,  data_key, data_all, lookupTable)
            } else if (input$question == "At what point do you start sharing different types of data?") {
                plotMultiChoiceGrid2var_Q17(input$question, input$DemographicOption3,  data_key, data_all, lookupTable)
            } else if (input$question == "Who is typically given access to data produced by your research pre- and post-publication?") {
                plotMultiChoiceGrid2var_Q18(input$question, input$DemographicOption3,  data_key, data_all, lookupTable)
            } else if (input$question == "When you share your data, how much do you make open?") {
                plotMultiChoiceGrid2var_Q27(input$question, input$DemographicOption3,  data_key, data_all, lookupTable)
            } else if (input$question == "Who do you think owns the data you have produced in your last research project? Does this differ before publication and after publication?") {
                plotMultiChoiceGrid2var_Q53(input$question, input$DemographicOption3,  data_key, data_all, lookupTable)
            } else if (input$question == "When considering your research activities do you have:") {
                plotMultiChoiceGrid2var_Q54(input$question, input$DemographicOption3,  data_key, data_all, lookupTable)
            } else if (input$question == "Do any other these issues impact on your ability to share your data effectively?") {
                plotMultiChoiceGrid2var_Q55(input$question, input$DemographicOption3,  data_key, data_all, lookupTable)
            } else {
             print("no plot")  
            }
        } # end if statement
    })

# ----- Download button for download of graphs ----- TNB: THIS CODE IS NOT WORKING
#     output$downloadVisPlots <- function(){
#     question_type <- as.character(lookupTable %>% filter(question == input$question) %>% select(ques_type))
#     
#     if (question_type == "multichoice_single answer") {
#         # make the plot
#         visPlot <- reactive({
#             plotMultiChoiceSingleOption(input$question, input$DemographicOption3)
#         })
#         output$downloadVisPlots <- renderPlot({
#             p <- visPlot(
#                 print(p)
#             )
#         })
#         # downloadHandler to download the plot
#         output$downloadVisPlots <- downloadHandler(
#             filename = function() {
#                 paste('SODP survey visualisation plot ', Sys.Date(),'.png', sep='')
#             },
#             content = function(file) {
#                 png(file)
#                 print(visPlot())
#                 dev.off()
#             },
#             contentType = 'image/png'
#         ) 
#     } 
#     else if (question_type == "checkbox") {
#             # make the plot
#             visPlot <- reactive({
#                 plotCheckbox2var(input$question, input$DemographicOption3)
#             })
#             output$downloadVisPlots <- renderPlot({
#                 p <- visPlot(
#                     print(p)
#                 )
#             })
#             # downloadHandler to download the plot
#             output$downloadVisPlots <- downloadHandler(
#                 filename = function() {
#                     paste('SODP survey visualisation plot ', Sys.Date(),'.png', sep='')
#                 },
#                 content = function(file) {
#                     png(file)
#                     print(visPlot())
#                     dev.off()
#                 },
#                 contentType = 'image/png'
#             )
#     }
#     
# } # end function output$downloadVisPlots
        
    # ----- output (table) for fourth panel (IAD framework table) -----
#    output$table <- renderTable(IAD_framework_key)        
    output$mytable = DT::renderDataTable({
            IAD_framework_key
        })
} # end server

# Run the application 
shinyApp(ui = ui, server = server)
