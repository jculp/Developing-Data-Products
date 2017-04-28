#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that models housing data
shinyUI(fluidPage(
  
    # Application title
    titlePanel("University of California Irvine Housing Data - Predicting Median Home Value"),
    
    h5("The data used here comes from a Boston housing dataset, provided by the UCI Machine Learning Repository online.  The dependent variable is Median Home Value, with 13 accompanying independent variables.  More information can be found at the address at the bottom of this page."),
    h5("The intent of this application, built with Shiny in R, is first to explore the housing data and select a number of independent variables to be included in a linear model."),
    h5("So get a feel for the data and determine what number of variables should be included to best predict our median home values!"),
  
    # Sidebar with a slider input for number of variables
    sidebarLayout(
        sidebarPanel(
            h2("Have a Look at the Data"),
            selectInput("VarToPlot",
                        "Choose an Independent Variable to Plot:",
                        c("CrimeRate" = "CrimeRate", 
                          "LargeLotZoned" = "LargeLotZoned", 
                          "Industrial" = "Industrial",
                          "River" = "River",
                          "NitricOxide" = "NitricOxide",
                          "AvgRooms" = "AvgRooms",
                          "Pre1940" = "Pre1940",
                          "Distance" = "Distance",
                          "RadialHwy" = "RadialHwy",
                          "Tax" = "Tax",
                          "PupilToTeacher" = "PupilToTeacher",
                          "Black" = "Black",
                          "LowStatus" = "LowStatus")),
            h5("A plot of your chosen independent variable is shown to the right, in blue.  Look through these variables and click Submit to get a feel for the data."),
            h2("How many Variables Should We Model?"),
            sliderInput("VarNum",
                        "Choose the Number of Independent Variables to Include in a Linear Model:",
                        min = 1,
                        max = 13,
                        value = 1),
            h5("Median Home Value was modeled by each independent variable on its own, after which those independent variables were ordered based on their p-value.  A selection of N will result in the N most-significant independent variables being included in a linear model, the results of which are shown below and to the right."),
            h5("As you increase the number of variables included, note that some of the most significant variables modeled on their own may no longer be significant."),
            h5("Though the model's squared error (sigma) generally drops with each additional variable, the adjusted R squared does not, suggesting that those additional variables may not be worth the complexity."),
            h5("Finally, is a linear model the best approach with this data?  The diagnostic plots attempt to help answer this."),
            submitButton("Submit Selections")
    ),
  
    # Show modeled output
    mainPanel(
        h2("Plot of Selected Independent Variable (X) vs. Median Home Value (Y)"),
        plotOutput("plotVar"),
        h2("Results of Linear Modeling, Based Slider Selection"),
        h4("Variables Included in Model:"),
        textOutput("modelVars"),
        h4("Variables Actually Significant:"),
        textOutput("modelSigVars"),
        fluidRow(
            splitLayout(cellWidths = c("50%", "50%"),
                        h4("Model's Sigma:"),
                        h4("Model's Adjusted R Squared:"))
        ),
        fluidRow(
            splitLayout(cellWidths = c("50%", "50%"),
                        textOutput("modelSigma"),
                        textOutput("modelAdjR2"))
        ),
        h2("Diagnostic Plots - Does a Linear Model Make Sense for this Housing Data?"),
        fluidRow(
            splitLayout(cellWidths = c("50%", "50%"), 
                        plotOutput("plot1"), 
                        plotOutput("plot2"))
        )
    )
  ),
  h5("Description of data:  https://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.names"),
  h5("Actual raw data:  https://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data")
))
