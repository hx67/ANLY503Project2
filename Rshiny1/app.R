library(shiny)
library(dplyr)
library(ggplot2)
library(tidyr)
require(data.table)
library(tidyverse)
library(DT)

top20_df <- fread('../Part1/data/top20.csv')
setnames(top20_df, c('Artist', 'Count', "Median peak", "Mean total weeks", 'Overall sentiment score'))

top20_df <- top20_df[1:(nrow(top20_df)-1),] # remove last row of dataframe loaded

# preprocess data
top20_df$`Median peak` = sapply(top20_df$`Median peak`, function(x){floor(x)})
top20_df$`Mean total weeks` = sapply(top20_df$`Mean total weeks`, function(x){floor(x)})

top20_df$`Overall sentiment score` = sapply(top20_df$`Overall sentiment score`, function(x){round(x, 2)})

# Define UI for application that plots features of movies
ui <- fluidPage(
  titlePanel("Artists' performance on Billboard"),
  br(),
  # Sidebar layout with a input and output definitions
  sidebarLayout(
    
    # Inputs
    sidebarPanel(
      
      # Select variable for y-axis
      selectInput(inputId = "y",
                  label = "Y-axis:",
                  choices = c("Count" , 
                              "Median peak" , 
                              "Mean total weeks", 
                              "Overall sentiment score" ),
                  selected = "Count"),
      
      # Select variable for x-axis
      selectInput(inputId = "x",
                  label = "X-axis:",
                  choices = c("Artist"),
                  selected =  "Artist")
    ),
    
    # Outputs
    mainPanel(
      plotOutput(outputId = "histogram")
    )
  )
)

# Define server function required to create the scatterplot
server <- function(input, output) {
  
  # Create scatterplot
  output$histogram <- renderPlot({
    ggplot(data = top20_df, aes_string(x = input$x, y = as.name(input$y))) +
      geom_bar(position = "dodge", stat = "identity", aes(fill = input$x)) + coord_flip() + ggtitle("Histogram showing top 20 Billboard artists' performance")
  })
  
}

# Create the Shiny app object
shinyApp(ui, server)