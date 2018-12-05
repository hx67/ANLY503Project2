library(tidyverse) 
library(data.table) 
library(countrycode) #Matching country names
library(plotly) #Interactive plots
library(viridis) #Color scales
library(tm) #Textmining for wordclouds
library(wordcloud) #Generation of wordclouds
library(leaflet) #Interactive maps
library(maps) #Maps generating

df = read.csv('./data/lyrics_sentiment.csv')

descriptions <- df$lyrics[df$lyrics != ""] #Filters all filled descriptions

descriptions <- iconv(descriptions,"WINDOWS-1252","UTF-8")

words <- descriptions %>% as.character() %>%
  removePunctuation() %>% #Removes punctuation
  tolower() %>% #Converts all characters to lower case
  removeWords(stopwords()) %>% #Remove english stop words
  str_split(pattern = " ") %>% #Splits all lines into lists of words
  unlist() #converts all lists into a single concatenated vector

word_freq <- words %>% as.tibble() %>% #Converts into tibble
  filter(value != "", !str_detect(value, "^\\d*$")) %>% #Removes enpty and number-only words
  count(value)

wordcloud(word_freq$value, word_freq$n, max.words = 75, colors = c("gold", "chocolate", "darkorange",  "firebrick3"), random.order = FALSE)
