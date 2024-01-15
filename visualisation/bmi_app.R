#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

#Please make sure you have installed the following packages already
#Load package 
library(shiny)
library(dplyr)
library(plotly)
library(mfp)


#Read data
survey_data <- read.csv("clean/clean_dt.csv")


#Define the user interface, user can enter their poverty income ratio
#Limit INDFMPIR to a maximum of 5, all enter greater than 5 will be treated as 5
#as is defined for INDFPIR
survey_data$INDFMPIR <- pmin(survey_data$INDFMPIR, 5) 


#Define the user interface
#Let user be able to choose their potato chips consumption groups and their poverty ratio
ui <- fluidPage(
  #Add title
  titlePanel("3D Relationship of BMXBMI, Poverty Income Ratio, and Frequency of Eating Potato Chips"),
  sidebarLayout(
    #Define a sidebar panel for user to choose
    sidebarPanel(
      #Add a table to describe the frequency of eating potato chips in each groups
      h4("Frequency of Eating Potato Chips:"),
      tags$table(class = "table table-striped",
                 tags$thead(
                   tags$tr(tags$th("Group"), tags$th("Potato Chips Consumption Frequency"))
                 ),
                 tags$tbody(
                   tags$tr(tags$td("1"), tags$td("Never")),
                   tags$tr(tags$td("2"), tags$td("1-6 times per year")),
                   tags$tr(tags$td("3"), tags$td("7-11 times per year")),
                   tags$tr(tags$td("4"), tags$td("1 time per month")),
                   tags$tr(tags$td("5"), tags$td("2-3 time per month")),
                   tags$tr(tags$td("6"), tags$td("1 time per week")),
                   tags$tr(tags$td("7"), tags$td("2 time per week")),
                   tags$tr(tags$td("8"), tags$td("3-4 time per week")),
                   tags$tr(tags$td("9"), tags$td("5-6 time per week")),
                   tags$tr(tags$td("10"), tags$td("1 time per day")),
                   tags$tr(tags$td("11"), tags$td("2 or more times per day"))
                 )
      ),
      #Define input for potato chips consumption frequency groups and poverty income ratio 
      numericInput("inputFrequency", "Please select your frequency of eating potato chips:", min = 1, max = 11, value = 1),
      numericInput("inputPIR", "Please enter your Poverty Income Ratio:", min = 0, max = 5, value = 0),
      #Add a button, when user click button, app will predict the bmi based on their choice
      actionButton("predict", "Predict")
    ),
    #Main panel to display outcomes: 3D plot and predicted BMI output
    mainPanel(
      plotlyOutput("Plot3D"),
      textOutput("predictedBMI")
    )
  )
)

#Define server logic
server <- function(input, output) {
  
    #Reactive data, so that data can load and process automatically
    survey_data <- reactive({
      data <- read.csv("clean/clean_dt.csv")
      data$INDFMPIR <- pmin(data$INDFMPIR, 5)  
      data
    })
    
    #Reactive model fitting, so model will fit automatically
    #The model here is a fractional polynomial between BMI and potato chips cosumption groups
    #Poverty income ratio is added in model as a cofounder
    fit <- reactive({
      mfp(BMXBMI ~ fp(FFQ0102, df=2) + INDFMPIR, data = survey_data(), family = gaussian)
    })
    
    #Generate 3D plot for our output
    output$Plot3D <- renderPlotly({
      plot_data <- survey_data() %>% 
        select(FFQ0102, INDFMPIR, BMXBMI)
      
      #Create a 3D scatter plot for our model
      p <- plot_ly(plot_data, x = ~FFQ0102, y = ~INDFMPIR, z = ~BMXBMI, type = 'scatter3d', mode = 'markers',
                   marker = list(color = 'blue', size = 1), name = 'Population Data') %>%
        layout(title = "3D Relationship of BMXBMI, PIR, and Frequency of Eating Chips",
               scene = list(xaxis = list(title = 'Frequency of Eating Chips'),
                            yaxis = list(title = 'Poverty Income Ratio (Capped at 5)'),
                            zaxis = list(title = 'BMXBMI')),
               legend = list(x = 0.9, y = 0.1, orientation = 'h'))
      #return p
      p
    })
    
    #Predict the BMI based on user's input and label the predicted point on the plot
    observeEvent(input$predict, {
      #Create new data for prediction based on user input
      new_data <- data.frame(FFQ0102 = input$inputFrequency, INDFMPIR = pmin(input$inputPIR, 5))
      #Predict data with our model
      predicted_value <- predict(fit(), newdata = new_data, type = "response")
      
      #Display the predicted BMI in the UI
      output$predictedBMI <- renderText({
        paste("Predicted BMI for Potato Chips Consumption Group:", input$inputFrequency, "and Poverty Income Ratio:", input$inputPIR, "is:", predicted_value)
      })
      
      #Update the plot with the predicted point
      output$Plot3D <- renderPlotly({
        plot_data <- survey_data() %>% 
          select(FFQ0102, INDFMPIR, BMXBMI)
        
        #Add the predicted point to the existing plot
        #The red point is predicted point based on user's input
        #The blue points are real data from our collection
        p <- plot_ly(plot_data, x = ~FFQ0102, y = ~INDFMPIR, z = ~BMXBMI, type = 'scatter3d', mode = 'markers',
                     marker = list(color = 'blue', size = 1), name = 'Population Data') %>%
          add_trace(x = c(input$inputFrequency), y = c(input$inputPIR), z = c(predicted_value),
                    type = 'scatter3d', mode = 'markers',
                    marker = list(color = 'red', size = 3), name = 'Predicted Data') %>%
          layout(title = "3D Relationship of BMXBMI, PIR, and Frequency of Eating Chips",
                 scene = list(xaxis = list(title = 'Frequency of Eating Chips'),
                              yaxis = list(title = 'Poverty Income Ratio (Capped at 5)'),
                              zaxis = list(title = 'BMXBMI')),
                 #Put the legend at the bottom right
                 legend = list(x = 0.9, y = 0.1, orientation = 'h'))
        #return p
        p
      })
    })
  }
#Run app 
shinyApp(ui = ui, server = server)