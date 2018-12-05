# -*- coding: utf-8 -*-
"""
Created on Tue Dec  4 23:01:04 2018

@author: hejia
"""

import plotly

import plotly.plotly as py
import plotly.graph_objs as go

import numpy as np
import pandas as pd
data = pd.read_csv("tweetlyricsscores.csv")
x = list(data["tweet_s"])
y = list(data["lyric_s"])
z = list(data["heat"])
trace1 = go.Scatter3d(
    x=x,
    y=y,
    z=z,
    mode='markers',
    marker=dict(
        size=12,
        color=z,                # set color to an array/list of desired values
        colorscale='Viridis',   # choose a colorscale
        opacity=0.8
    )
)

data = [trace1]
layout = go.Layout(title = "3D Graph for Sentimenal Scores",
                   scene = dict(
                    xaxis = dict(
                   title = "Tweets Sentimental Scores"),
                    yaxis = dict(
                   title = "Lyrics Sentimental Scores"),
                    zaxis = dict(
                   title = "Weeks the Song Stays on Board"),),
                    width=700,
                    margin=dict(
                    r=20, b=10,
                    l=10, t=60
))
fig = go.Figure(data=data, layout=layout)

py.iplot(fig, filename='3d-axis-titles')