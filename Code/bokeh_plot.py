# -*- coding: utf-8 -*-
"""
Created on Sat Dec  1 13:58:47 2018

@author: hongx
"""

import numpy as np
import pandas as pd
from bokeh.layouts import gridplot
from bokeh.plotting import figure, show, output_file

def datetime(x):
    return np.array(x, dtype=np.datetime64)

lyrics_df = pd.read_csv(
    '../Data/lyric_sentiment.csv', encoding = "ISO-8859-1")

lyrics_df = lyrics_df[['artist', 'track_title','year', 'total_week', 'peak', 'sentiment']]



from scipy import stats
#try_df = lyrics_df.groupby(['artist', 'track_title']).agg(lambda x: print(stats.mode(x)[0]))
try_df = lyrics_df.groupby(['artist', 'track_title'])['sentiment'].apply(lambda x: x.value_counts().index[0]).reset_index()

lyrics2_df = lyrics_df.drop_duplicates(subset=['artist', 'track_title','year', 'total_week', 'peak'])
result = pd.merge(
    try_df, lyrics2_df, on=['artist', 'track_title'], how = 'left')

del result['sentiment_y']
result.rename(columns={'sentiment_x':'sentiment'}, inplace=True)

year_emotion = pd.read_csv(
    '../Data/year_emotion.csv', encoding = "ISO-8859-1")

p1 = figure(title="Change of Detailed Sentiments over Years")
p1.grid.grid_line_alpha=0.3
p1.xaxis.axis_label = 'Year'
p1.yaxis.axis_label = 'Sentiment Score'

p1.line(year_emotion[year_emotion["sentiment"] == 'anger']['year'], year_emotion[year_emotion["sentiment"] == 'anger']['sentiment_sum'], color='#FF0000', legend='Anger', line_width=2)
#p1.line(year_emotion[year_emotion["sentiment"] == 'anticipation']['year'], year_emotion[year_emotion["sentiment"] == 'anticipation']['sentiment_sum'], color='#A6CEE3', legend='Anticipatio')
#p1.line(year_emotion[year_emotion["sentiment"] == 'disgust']['year'], year_emotion[year_emotion["sentiment"] == 'disgust']['sentiment_sum'], color='#7FFF00', legend='Disgust')
#p1.line(year_emotion[year_emotion["sentiment"] == 'fear']['year'], year_emotion[year_emotion["sentiment"] == 'fear']['sentiment_sum'], color='#A9A9A9', legend='Fear')
p1.line(year_emotion[year_emotion["sentiment"] == 'joy']['year'], year_emotion[year_emotion["sentiment"] == 'joy']['sentiment_sum'], color='#FFFF00', legend='Joy', line_width=2)
p1.line(year_emotion[year_emotion["sentiment"] == 'sadness']['year'], year_emotion[year_emotion["sentiment"] == 'sadness']['sentiment_sum'], color='#0000FF', legend='Sadness', line_width=2)
#p1.line(year_emotion[year_emotion["sentiment"] == 'surprise']['year'], year_emotion[year_emotion["sentiment"] == 'surprise']['sentiment_sum'], color='#FFA500', legend='Surprise')
p1.line(year_emotion[year_emotion["sentiment"] == 'trust']['year'], year_emotion[year_emotion["sentiment"] == 'trust']['sentiment_sum'], color='#9370DB', legend='Trust', line_width=2)
p1.legend.location = "top_left"

show(gridplot([[p1]], plot_width=800, plot_height=600))  # open a browser

sentiment_list = ['anticipation','joy','surprise','trust'
                  ,'anger','sadness','disgust','fear']
pn_list = ['Positive','Positive','Positive','Positive','Negative','Negative','Negative','Negative',]
graph_sentiment =[]
count_list = []
for sentiment in sentiment_list:
  if sentiment == 'positive' or sentiment == "negative":
    continue
  graph_sentiment.append(sentiment)
  count_list.append(list(lyrics_df.sentiment).count(sentiment))

precent_list = []
for count in count_list:
  precent_list.append(count/sum(count_list))


##Graph2
from bokeh.io import show
from bokeh.models import ColumnDataSource
#from bokeh.palettes import Spectral8
color = ['#ff0000','#ff0000','#ff0000','#ff0000','#084594','#084594','#084594','#084594']
source = ColumnDataSource(
    data=dict(
        Sentiment=graph_sentiment, Count=precent_list, PN = pn_list, color = color))

p = figure(
    x_range=graph_sentiment, y_range=(
        0,0.25), plot_width=800, plot_height=600, title="Bar Chart for the Percentages of Eight Sentiment Counts",
           toolbar_location=None, tools="")

p.vbar(x='Sentiment', top='Count', width=0.9, color='color', legend="PN", source=source)
p.xaxis.axis_label = "Sentiment Categories"
p.yaxis.axis_label = "Sentiment Words Precentage"

show(p)


##Graph3
pn_df = result.copy()

pn_df['sentiment'] = pn_df['sentiment'].map(
    {'anticipation':'positive','joy':'positive','surprise':'positive',
     'trust':'positive','anger':'negative','sadness':'negative',
     'disgust':'negative','fear':'negative','positive':'positive',
     'negative':'negative'})

df = pd.DataFrame(pn_df.groupby(['year','sentiment']).count())
df['year'] = [i[0] for i in list(df.index)]
df['sentiment'] = [i[1] for i in list(df.index)]
  
p1 = figure(title="Change of Sentiments (Positive/Negative) over Years")
p1.grid.grid_line_alpha=0.3
p1.xaxis.axis_label = 'Year'
p1.yaxis.axis_label = 'Sentiment Score'

p1.line(df[df["sentiment"] == 'positive']['year'], df[df["sentiment"] == 'positive']['artist'], color='#FF0000', legend='Positive', line_width=2)
p1.line(df[df["sentiment"] == 'negative']['year'], df[df["sentiment"] == 'negative']['artist'], color='#084594', legend='Negative', line_width=2)

p1.legend.location = "top_left"

show(gridplot([[p1]], plot_width=800, plot_height=600))






