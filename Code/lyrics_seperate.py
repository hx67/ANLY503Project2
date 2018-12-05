# -*- coding: utf-8 -*-
"""
Created on Fri Nov 30 22:06:49 2018

@author: hongx
"""

import pandas as pd

lyrics_df = pd.read_csv(
    '../Data/lyrics_sentiment.csv', encoding = "ISO-8859-1")

sample = lyrics_df.lyrics[0].split('\n')

sample = [item.replace('\r', '') for item in sample]
sample = list(filter(None, sample))

title_list = []
artist_list = []
year_list = []
total_week_list = []
peak_list = []
lyric_list = []

for idx, lyric in enumerate(lyrics_df.lyrics):
  sep_list = lyric.split('\n')
  sep_list = [item.replace('\r', '') for item in sep_list]
  sep_list = list(filter(None, sep_list))
  for line in sep_list:
    title_list.append(lyrics_df.title[idx])
    artist_list.append(lyrics_df.artists[idx])
    year_list.append(lyrics_df.date[idx].split('/')[-1])
    total_week_list.append(lyrics_df.total_weeks[idx])
    peak_list.append(lyrics_df.peak[idx])
    lyric_list.append(line)
    
result_df = pd.DataFrame({"artist":artist_list, "track_title":title_list,
                          "year": year_list, "lyric":lyric_list, 
                          "total_week":total_week_list, "peak": peak_list})
  
result_df.to_csv("../Data/all_singers.csv")
  