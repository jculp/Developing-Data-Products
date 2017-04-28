#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define server logic required to draw a histogram
shinyServer(function(input, output) {
    
    data <- read.table("https://archive.ics.uci.edu/ml/machine-learning-databases/housing/housing.data", na.strings = "?")
    header <- c("CrimeRate", "LargeLotZoned", "Industrial", "River", "NitricOxide", "AvgRooms", "Pre1940", "Distance", "RadialHwy", "Tax", "PupilToTeacher", "Black", "LowStatus", "MedianValue")
    names(data) <- header
    target <- data$MedianValue
    data$MedianValue <- NULL

    pvals <- as.numeric()
    for (i in names(data)) {
        fit      <- lm(target ~ data[[i]])
        sum      <- summary(fit)
        pvals[i] <- sum$coefficients[2, 4]
    }
    pvals <- sort(pvals)
    
    modelSum <- reactive({
        
        num <- input$VarNum

        dataSub        <- data.frame(data[, names(pvals)[1:num]])
        names(dataSub) <- names(pvals)[1:num]
        fitMulti       <- lm(target ~ ., data = dataSub)
        sumMulti       <- summary(fitMulti)
    })
    
    modelPvals <- reactive({
        
        num <- input$VarNum
        
        dataSub        <- data.frame(data[, names(pvals)[1:num]])
        names(dataSub) <- names(pvals)[1:num]
        fitMulti       <- lm(target ~ ., data = dataSub)
        sumMulti       <- summary(fitMulti)
        pvalsMulti     <- sumMulti$coefficients
    })

    
    plot1 <- reactive({
        
        num            <- input$VarNum
        dataSub        <- data.frame(data[, names(pvals)[1:num]])
        names(dataSub) <- names(pvals)[1:num]
        fitMulti       <- lm(target ~ ., data = dataSub)
        plot(fitMulti, which = 1, pch = 21, col = rgb(0,0,0, alpha = 75, maxColorValue=255))
        
    })
    
    plot2 <- reactive({
        
        num            <- input$VarNum
        dataSub        <- data.frame(data[, names(pvals)[1:num]])
        names(dataSub) <- names(pvals)[1:num]
        fitMulti       <- lm(target ~ ., data = dataSub)
        plot(fitMulti, which = 2, pch = 21, col = rgb(0,0,0, alpha = 75, maxColorValue=255))
        
    })
    
    # plot3 <- reactive({
    #     
    #     num            <- input$VarNum
    #     dataSub        <- data.frame(data[, names(pvals)[1:num]])
    #     names(dataSub) <- names(pvals)[1:num]
    #     fitMulti       <- lm(target ~ ., data = dataSub)
    #     plot(fitMulti, which = 3)
    #     
    # })
    # 
    # plot4 <- reactive({
    #     
    #     num            <- input$VarNum
    #     dataSub        <- data.frame(data[, names(pvals)[1:num]])
    #     names(dataSub) <- names(pvals)[1:num]
    #     fitMulti       <- lm(target ~ ., data = dataSub)
    #     plot(fitMulti, which = 4)
    #     
    # })
        output$modelVars <- renderText(paste0(gsub("\\(", "", gsub("\\)", "", rownames(modelPvals()))), "; "))
    
        output$modelSigVars <- renderText(paste0(gsub("\\(", "", gsub("\\)", "", rownames(modelPvals())))[modelPvals()[, 4] < 0.05],
                                                " (",
                                                format(round(modelPvals()[modelPvals()[, 4] < 0.05, 4], 4),  nsmall = 4),
                                                ");"))
        
        output$modelSigma   <- renderText(format(round(modelSum()$sigma, 4), nsmall = 4))
        output$modelAdjR2   <- renderText(format(round(modelSum()$adj.r.squared, 4), nsmall = 4))
        
        output$plot1        <- renderPlot({
            plot1()
            })
        
        output$plot2        <- renderPlot({
            plot2()
        })
        
        # output$plot3        <- renderPlot({
        #     plot3()
        # })
        # 
        # output$plot4        <- renderPlot({
        #     plot4()
        # })
        
        output$plotVar      <- renderPlot({
            
            plotVar         <- input$VarToPlot
            plot(x = data[[plotVar]], y = target, 
                 xlab = paste(plotVar, "(User-Selected)"),
                 ylab = "MedianValue (Home)",
                 pch = 21, col = rgb(0,0,255, alpha = 75, maxColorValue = 255))
        })
})
