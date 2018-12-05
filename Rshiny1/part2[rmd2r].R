#' ---	
#' title: "project part 2"	
#' author: "Tianjing Cai"	
#' date: "12/1/2018"	
#' output: html_document	
#' ---	
#' 	
#' 	
library(shiny)	
library(dplyr)	
library(ggplot2)	
library(tidyr)	
require(data.table)	
library(tidyverse)	
library(DT)	
rsconnect::setAccountInfo(name='tianjingcai95',	
			  token='886DF70418F9AA110765C3D4A9B2A06D',	
			  secret='YULeS4CRLriMmMfpT/F3f8cL04S7iOWs0A+fM/uA')	
#' 	
#' 	
#' ## R Markdown	
#' 	
#' This is an R Markdown document. Markdown is a simple formatting syntax for authoring HTML, PDF, and MS Word documents. For more details on using R Markdown see <http://rmarkdown.rstudio.com>.	
#' 	
#' When you click the **Knit** button a document will be generated that includes both content as well as the output of any embedded R code chunks within the document. You can embed an R code chunk like this:	
#' 	
#' 	
top20_df <- fread('../Part1/data/top20.csv')	
setnames(top20_df, c('Artist', 'Count', "Median peak", "Mean total weeks", 'Overall sentiment score'))	
	
top20_df <- top20_df[1:(nrow(top20_df)-1),] # remove last row of dataframe loaded	
	
# preprocess data	
top20_df$`Median peak` = sapply(top20_df$`Median peak`, function(x){floor(x)})	
top20_df$`Mean total weeks` = sapply(top20_df$`Mean total weeks`, function(x){floor(x)})	
	
top20_df$`Overall sentiment score` = sapply(top20_df$`Overall sentiment score`, function(x){round(x, 2)})	
#' 	
#' 	
#' ## Including Plots	
#' 	
#' You can also embed plots, for example:	
#' 	
#' 	
	
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
shinyApp(ui = ui, server = server)	
#' 	
#' 	
#' Note that the `echo = FALSE` parameter was added to the code chunk to prevent printing of the R code that generated the plot.	
#' 	
#' 	
#' 	
# Define UI for application that plots features of movies	
ui <- fluidPage(	
  	
  br(),	
  titlePanel("Artists' performance on Billboard"),	
  # Sidebar layout with a input and output definitions	
  sidebarLayout(	
    # Inputs	
    	
    sidebarPanel(	
	
      # Select variable for y-axis	
      selectInput(inputId = "metric",	
                  label = "Metric:",	
                  choices = c("Count" , 	
                              "Median peak" , 	
                              "Mean total weeks", 	
                              "Overall sentiment score" ),	
                  selected = "Count"),	
	
      # Select variable for x-axis	
      selectInput(inputId = "artist",	
                  label = "Choose artist(s):",	
                  choices = top20_df$Artist,	
                  actionLink("selectall", "Select All"),	
                  multiple = TRUE)	
    ),	
	
    	
    # Output:	
    mainPanel(	
      	
      htmlOutput(outputId = "describe"),	
      # Show scatterplot	
      br(),	
      plotOutput(outputId = "scatterplot", hover = "plot_hover"),	
      # Show data table	
      dataTableOutput(outputId = "singertable"),	
      br()	
    )	
  )	
)	
	
# Define server function required to create the scatterplot	
server <- function(input, output) {	
  top20_df_filter <- reactive({top20_df %>% filter(Artist %in% input$artist)})	
  # Create scatterplot object the plotOutput function is expecting	
  output$scatterplot <- renderPlot({	
    top20 <- top20_df_filter()	
    ggplot(data = top20, aes(x = Artist)) +	
      geom_point(aes_string(y = as.name(input$metric)), colour = "red", size = 3) + coord_flip() + ggtitle('Scatterplot for artists name versus their performance ')	
  })	
  	
  # Print data table	
  output$singertable <- DT::renderDataTable({	
    top20 <- top20_df_filter()	
    nearPoints(top20, coordinfo = input$plot_hover) 	
  })	
  	
  output$describe <- renderUI({	
    HTML(	
      paste("The plot below shows selected artists' performance on Billboard evaluated using different metrics.")	
    )	
  }	
    	
  )	
  	
}	
	
# Create a Shiny app object	
shinyApp(ui = ui, server = server)	
#' 	
