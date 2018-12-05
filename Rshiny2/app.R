# Final Project
# Maria Ren

# The project libraries are listed below

library(shiny)
library(devtools)
library(spotifyr)
library(tidyverse)
library(dplyr)
library(billboard)
library(httr)
library(miscTools)
library(ggplot2)
library(car)
library(ggvis)
library(plotly)

# install.packages("devtools")
# install.packages("spotifyr")
# install.packages("billboard")
# install.packages("httr")
# install.packages("miscTools")
# install.packages("ggplot2")
# install.packages("car")
# install.packages("ggvis")
# install.packages("plotly")

top <- read.csv("Billboard_Top_1.csv")

for (i in 1:nrow(top)) { 
  if (top$year[i] < 1970) {
    top$year[i] <- str_sub("1960-1969") 
    
  }else if (top$year[i] < 1980){
    top$year[i] <- str_sub("1970-1979") 
    
  }else if (top$year[i] < 1990){
    top$year[i] <- str_sub("1980-1989") 
    
  }else if (top$year[i] < 2000){
    top$year[i] <- str_sub("1990-1999")
    
  }else if (top$year[i] < 2010){
    top$year[i] <- str_sub("2000-2009")
    
  }else if (top$year[i] < 2019){
    top$year[i] <- str_sub("2009-2018")
  }
}

danceability <- ggplot(top, aes(top$danceability,top$valence)) +
  geom_point(aes(color = as.factor(year))) +
  geom_smooth(se = FALSE) +
  labs(title = "Danceability vs. Valence")

energy <- ggplot(top, aes(top$energy,top$valence)) +
  geom_point(aes(color = as.factor(year))) +
  geom_smooth(se = FALSE) +
  labs(title = "Energy vs. Valence")

loudness <- ggplot(top, aes(top$loudness,top$valence)) +
  geom_point(aes(color = as.factor(year))) +
  geom_smooth(se = FALSE) +
  labs(title = "Loudness vs. Valence")

speechiness <- ggplot(top, aes(top$speechiness,top$valence)) +
  geom_point(aes(color = as.factor(year))) +
  geom_smooth(se = FALSE) +
  labs(title = "Speechiness vs. Valence")

acousticness <- ggplot(top, aes(top$acousticness,top$valence)) +
  geom_point(aes(color = as.factor(year))) +
  geom_smooth(se = FALSE) +
  labs(title = "Acousticness vs. Valence")

instrumentalness <- ggplot(top, aes(top$instrumentalness,top$valence)) +
  geom_point(aes(color = as.factor(year))) +
  geom_smooth(se = FALSE) +
  labs(title = "Instrumentalness vs. Valence")

liveness <- ggplot(top, aes(top$liveness,top$valence)) +
  geom_point(aes(color = as.factor(year))) +
  geom_smooth(se = FALSE) +
  labs(title = "Liveness vs. Valence")

tempo <- ggplot(top, aes(top$tempo,top$valence)) +
  geom_point(aes(color = as.factor(year))) +
  geom_smooth(se = FALSE) +
  labs(title = "Tempo vs. Valence")

duration <- ggplot(top, aes(top$duration_ms,top$valence)) +
  geom_point(aes(color = as.factor(year))) +
  geom_smooth(se = FALSE) +
  labs(title = "Duration vs. Valence")



top_orig <- read.csv("Billboard_Top_1.csv")

danceability_year <- ggplot(top, aes(fill=top$year, y=top_orig$danceability, x=top_orig$year)) + 
  geom_line(color="purple") +
  geom_point()


energy_year <- ggplot(top, aes(fill=top$year, y=top_orig$energy, x=top_orig$year)) + 
  geom_line(color="purple") +
  geom_point()


loudness_year <- ggplot(top, aes(fill=top$year, y=top_orig$loudness, x=top_orig$year)) + 
  geom_line(color="purple") +
  geom_point()


speechiness_year <- ggplot(top, aes(fill=top$year, y=top_orig$speechiness, x=top_orig$year)) + 
  geom_line(color="purple") +
  geom_point()

acousticness_year <- ggplot(top, aes(fill=top$year, y=top_orig$acousticness, x=top_orig$year)) + 
  geom_line(color="purple") +
  geom_point()


instrumentalness_year <- ggplot(top, aes(fill=top$year, y=top_orig$instrumentalness, x=top_orig$year)) + 
  geom_line(color="purple") +
  geom_point()


liveness_year <- ggplot(top, aes(fill=top$year, y=top_orig$liveness, x=top_orig$year)) + 
  geom_line(color="purple") +
  geom_point()

valence_year <- ggplot(top, aes(fill=top$year, y=top_orig$valence, x=top_orig$year)) + 
  geom_line(color="purple") +
  geom_point()


tempo_year <- ggplot(top, aes(fill=top$year, y=top_orig$tempo, x=top_orig$year)) + 
  geom_line(color="purple") +
  geom_point()

duration_year <- ggplot(top, aes(fill=top$year, y=top_orig$duration_ms, x=top_orig$year)) + 
  geom_line(color="purple") +
  geom_point()



top_reduced <- subset(top_orig,select=c("track_name","artist","year","danceability",
                                   "energy","loudness","speechiness","acousticness",
                                   "instrumentalness","liveness","valence","tempo","duration_ms"))






## app.R ##
library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Music, Happy or Sad"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Introduction",tabName = "intro"),
      menuItem("Dataset Keys",tabName = "key"),
      menuItem("Audio Features vs. Valence", tabName = "secondplot")
      
    )
  ),

  dashboardBody(
    tabItems(
      # Intro
      tabItem(tabName = "intro",
              # Give the page a title
              titlePanel("Music, Emotions - Project Introduction"),
              fluidRow(
                box(
                  width = 40,
                  height = 450,
                  h4(
                  p("We often say, 'I'm in the mood for a happy tune.' But what exactly makes a song happy? Or sad?"), 
                  br(),
                  p("This project uses data extracted from the Spotify API and analyzes the different elements of a 
                    soundtrack that changes human emotions.  The features used include Danceability,  Energy,  Loudness,
                    Speechiness, Acoustics, Instrumentalness, Liveness, Valence, Tempo,  and duration. The musical data
                    consists of musical features and ratings for the number one songs from Billboard Hot 100 Chart? from
                    1960 to 2018.")
                  
                  )
                )
              )
           ),
      # Key
      tabItem(tabName = "key",
              # Give the page a title
              titlePanel("Dataset Introduction"),
              fluidRow(
                box(
                  width = 40,
                  height = 800,
                  h4(
                    p("The Dataset extracts information from Spotify API. The following audio feature data values are 
                      needed for the project analysis.")), 
                    br(),
                   h5(
                     p(strong("Danceability:"), "Describes how a song track is suitable for dancing. Values ranges from 0 to 1,
                      with 0 being the least danceable, and 1 being the most danceable. Danceability is calculated based on music 
                      tempo, rhythm stability, beat strength. "), 
                    br(),
                    p(strong("Energy:"), "Describes level of music intensity and activity. For example, the most energetic music 
                    feels fast and loud (like death metal), while a quiet and peaceful classical music (like Chopin) would score 
                    lower on the energy scale. Calculated from loudness, onset rate, tempo, and dynamic ranges. Values ranges from 0 to 1, 
                    with 0 being least energetic, and 1 being most energetic. "),
                    br(),
                    p(strong("Loudness:"),"Describes the decibel (dB) level of a score. Values ranges from -60 to 0. With -60 being the loudest,
                    and 0 being quietest."),
                    br(),
                    p(strong("Speechiness:"),"Describes the amount of spoken words in a track. Values ranges from 0 to 1, with 0 being music having 
                    no words, and 1 being completely spoken song track. (For example, a talk show would have closer to 1, song with rap with having 
                    values above 0.66, values between 0.33 and 0.66 would be regular songs with lyrics, and values below 0.33 are most likely classical 
                    music that is completely instrumental)."),
                    br(),
                    p(strong("Acousticness:"),"Describes the level of acoustic sound (as opposed to electronic sound) detected from the soundtrack. Values 
                    ranges from 0 to 1, with 0 being entirely electronic sound, and 1 being acoustic sound."),
                    br(),
                    p(strong("Instrumentalness:"), "Describes whether the track contains vocals. ( oh? and ah? sound are treated as instrumental). Values 
                    ranges from 0 to 1, with 0 being the soundtrack having no instrumentation, and 1 being instrumental music. (For example, a rap song would 
                    have score closer to 0, and classical symphonic music would have value closer to 1). "),
                    br(),
                    p(strong("Liveness:"), "Describes whether the song track was recorded live or in a studio. Calculated from detection of audience sound in the sound 
                    track. Values ranges from 0 to 1, with values closer to 0 indicating music which were recorded in a studio setting, and with values 
                    above 0.8 indicating music recorded live. "),
                    br(),
                    p(strong("Valence:"), "Describes the happiness level of a music soundtrack. Values ranges from 0 to 1, with 0 being music tracks that are 
                    negative (sad, depressed, and angry), while 1 being music that are positive (happy, exciting and cheerful). Calculated from audience 
                    reviews and ratings. "),
                    br(),
                    p(strong("Tempo:"), "Describes the tempo of a track in beats per minute (BPM). Values ranges from 0 to around 200. With values around 50 being 
                    very slow, and around 200 being very fast."),
                    br(),
                    p(strong("Duration(Duration_ms):"),"Describes the length of the soundtrack. Calculated in milliseconds.") 
                      
                            
                           
                    
                        )
                      )
                    )
                ),
                
      
      
      # Second tab content
      tabItem(tabName = "secondplot",
              # Give the page a title
              titlePanel("Audio Features vs. Valence"),
              
            fluidPage(
             
            box(plotOutput("plot1", height = 500)),
            br(),
            box(
              selectInput("Features_X1", "*Select different audio features to view plots", 
                          c("danceability"= "danceability",
                            "energy"="energy",
                            "loudness"="loudness",
                            "speechiness"="speechiness",
                            "acousticness"="acousticness",
                            "instrumentalness"="instrumentalness",
                            "liveness"="liveness",
                            "tempo"="tempo",
                            "duration"="duration_ms")),
              hr(),
              helpText("Data from Spotify.")
              ),
            
            box(
             
              h4(
                p("Description:")), 
              br(),
              h5(
                p("Focusing on analysis of valence level. Plots consist of each individual audio feature graphed on the x-axis, 
                and valence graphed on the y-axis."), 
                br(),
                h4(
                  p("Analysis: ")),
                h5(
                  br(),
                  p("When danceability, energy, tempo increases, valence increases. While for loudness, speechiness, 
                    acousticness, and duration of songs, the higher they are on the scale, the lower the valence score."),
                  br(),
                  p("According to the graphs above, songs that are determined as happy? are generally songs that are fast, 
                    upbeat, and not so loud. While songs that fit the ad? or more negative mood are songs that are slower, 
                  longer, and includes more spoken words. ")
                  
                      )
                  )
                )
            )
          )
    )
  )
)


    
  
    
      

  
      
            
         
       
    


















server <- function(input, output) {
  
  # Fill in the spot we created for a plot
  output$featurePlot <- renderPlot({
    
    # Render a plot
    barplot(top[,input$Features_X],
            main = "Features vs. Year",
            xlab = "Year", 
            ylab = "Feature Frequency")
  })
  
  output$basic_stats <- renderPrint({
    summary(top[input$Features_X])
  
  })

  output$plot1 <- renderPlot({
    
    # Render a plot
    if (input$Features_X1 == "danceability") {
      danceability
    } else if (input$Features_X1 == "energy") {
      energy
    } else if (input$Features_X1 == "loudness") {
      loudness
    } else if (input$Features_X1 == "speechiness") {
      speechiness
    } else if (input$Features_X1 == "acousticness") {
      acousticness
    } else if (input$Features_X1 == "instrumentalness") {
      instrumentalness
    } else if (input$Features_X1 == "liveness") {
      liveness
    } else if (input$Features_X1 == "tempo") {
      tempo
    } else if (input$Features_X1 == "duration_ms") {
      duration
    }
  
    })

  output$plot2 <- renderPlot({
    

      # Render a plot
    if (input$Features_X2 == "danceability") {
      danceability_year
    } else if (input$Features_X2 == "energy") {
      energy_year
    } else if (input$Features_X2 == "loudness") {
      loudness_year
    } else if (input$Features_X2 == "speechiness") {
      speechiness_year
    } else if (input$Features_X2 == "acousticness") {
      acousticness_year
    } else if (input$Features_X2 == "instrumentalness") {
      instrumentalness_year
    } else if (input$Features_X2 == "liveness") {
      liveness_year
    } else if (input$Features_X2 == "valence") {
      valence_year
    } else if (input$Features_X2 == "tempo") {
      tempo_year
    } else if (input$Features_X2 == "duration_ms") {
      duration_year
    }
      
    
  })
  
  
  
  
  # The fourth Section
  
    # Define a reactive expression for the document term matrix

  output$plot3 <- renderPlot({
      plot(top[,input$Features_X3],top$valence,
           main = ("Valence Scatter Plot"),
           xlab = "features", 
           ylab = "Valence",
           ylim = input$valence_value)
      
    })
  
  
  
  output$info <- renderPrint({
    nearPoints(top_reduced, 
               input$plot_click, 
               xvar = input$Features_X3, 
               yvar = "valence"
              )
  })
  
  
  # The fifth Plot 
  
  # Set some colors
  plotcolor <- "#F5F1DA"
  papercolor <- "#E3DFC8"
  
  # Plot time series chart 
  output$plot5 <- renderPlotly({
    p <- plot_ly(source = "source") %>% 
      add_lines(data = top_orig, x = top_orig$year, y = top$valence, 
                color = top_orig$year, mode = "lines", line = list(width = 3),
                text = ~paste('</br>Year: ', top_orig$year,
                              '</br>Valence: ', top$valence,
                              '</br></br>Track: ', top$track_name, 
                              '</br>Artist: ', top$artist,
                              '</br>Danceability: ', top$danceability,
                              '</br>Energy: ', top$energy,
                              '</br>Loudness: ', top$loudness,
                              '</br>Speechiness: ', top$speechiness,
                              '</br>Acousticness: ', top$acousticness,
                              '</br>Instrumentalness: ', top$instrumentalness,
                              '</br>Liveness: ', top$liveness,
                              '</br>Tempo: ', top$tempo,
                              '</br>Duration: ', top$duration_ms))
      
   
 p
  
  })
  
 
  
    
    # The Sixth Plot
  
  # Filter data based on selections
    output$table <- DT::renderDataTable(DT::datatable({
      data <- top_reduced
      if (input$year != "All") {
        data <- data[data$year == input$year,]
      }
      if (input$artist != "All") {
        data <- data[data$artist == input$artist,]
      }
      if (input$track != "All") {
        data <- data[data$track_name == input$track,]
      }
      data
    }))
    
  } 
  


      
    
  


shinyApp(ui, server)

