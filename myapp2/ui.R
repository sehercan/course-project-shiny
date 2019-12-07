library(shiny)

shinyUI(fluidPage(
    titlePanel("Predict Temperature from Ozone"),
    sidebarLayout(
        sidebarPanel(
            sliderInput("sliderOzone","Select the Ozone level in New York City:", min = 0, max = 150, value = 60),
            checkboxInput("showModel1", "show/hide model 1", value = TRUE),
            checkboxInput("showModel2", "show/hide model 2", value = TRUE),
            # submitButton("Submit")
        ),
        mainPanel(
            plotOutput("plot1"),
            h3("Predicted Temperature from Model1:"),
            textOutput("pred1"),
            h3("Predicted Temperature from Model2:"),
            textOutput("pred2")
        )
    )
))
