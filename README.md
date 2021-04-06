# About

This repository contains data and scripts for cleaning and visualisation for the Surveying Open Data Practices 2020 project. More information is available at the website: https://surveying-open-data-practices.github.io/sopd2020/en/


# Data 

The survey was set up in JISC's Online Survey Tool (https://www.onlinesurveys.ac.uk/).

The survey was offered in three languages: English, French and Portuguese. Data was downloaded from the JISC Online survey tool in CSV format. The key files were used to merge responses from the three different surveys.

Due to differences between the three surveys, several iterations of manual cleaning were run to allow the merging of the data across languages. See [data/README.md](data/README.md) for information on the data files and the data cleaning conducted.

After cleaning, a total of 64 responses were obtained:
- English: 58
- French: 4
- Portuguese: 2

The following question types exist in the survey:
- multiple choice (radio buttons - a single response is allowed)
- multiple choice (checkboxes - more than one answer could be selected)
- gridded questions (more than one condition was provided where more than one answer could be selected)

# Scripts

Due to the specific format of the data and manual data manipulation that needed to take place to correct small errors in the data, these scripts and functions are probably not directly transferrable to future versions of this survey. However, we hope that the scripts will provide help for others wanting to do similar analyses and visualisations.

The [scripts/readFilesCleanData.R](scripts/readFilesCleanData.R) file contain R instructions for cleaning the data and manipulating the data format to facilitate plotting.

Functions for data manipulation and plotting is available from the [functions/](functions/) directory.

# Interactive visualisation

An interactive web app for visualising the results from the survey is available at https://sodp2020.shinyapps.io/SODP-DataVisualisation/. The code for this Shiny app is available from the [SODPshinyApp](SODPshinyApp) directory.

All code is available under an open license to facilitate reuse.
