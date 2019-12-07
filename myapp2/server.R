library(shiny)

comp <- complete.cases(airquality)
data <- airquality[comp,]

shinyServer(function(input, output) {
    data$Ozonesp <- ifelse(data$Ozone -60 > 0, data$Ozone, 0)
    model1 <- lm(Temp ~ Ozone, data = data)
    model2 <- lm(Temp ~ Ozonesp + Ozone, data = data)
    
    model1pred <- reactive({
        OzoneInput <- input$sliderOzone
        predict(model1, newdata = data.frame(Ozone = OzoneInput))
    })
    model2pred <- reactive({
        OzoneInput <- input$sliderOzone
        predict(model2, newdata = data.frame(Ozone = OzoneInput,
                                             Ozonesp = ifelse(OzoneInput - 60 > 0, OzoneInput - 60,0)))
    })    
    
    output$plot1 <- renderPlot({
        OzoneInput <- input$sliderOzone
        
        plot(data$Ozone, data$Temp, xlab = "Ozone",
             ylab = "Temperature", bty = "n", pch = 16,
             xlim = c(0,150), ylim = c(50,100))
        if(input$showModel1){
            abline(model1, col = "red", lwd = 2)
        }
        if(input$showModel2){
            model2lines <- predict(model2, newdata = data.frame(
                Ozone = 0:150, Ozonesp = ifelse(0:150 - 60 > 0, 0:150, 0)
            ))
            lines(0:150, model2lines, col = "blue", lwd = 2)
        }
        legend(25,250, c("Model 1 Prediction", "Model 2 Prediction"), pch = 16, 
               col = c("red", "blue"), bty = "n", cex = 1.2)
        points(OzoneInput, model1pred(), col = "red", pch = 16, cex = 2)
        points(OzoneInput, model2pred(), col = "blue", pch = 16, cex = 2)
    })
    output$pred1 <- renderText({
        model1pred()
    })
    output$pred2 <- renderText({
        model2pred()
    })
})
