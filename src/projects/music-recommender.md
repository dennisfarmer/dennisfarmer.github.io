---
layout: layouts/base.njk
title: Music Recommender System
image: /images/pca_plot.png
date: 2025-03-01
featured: true
---

## Music Recommender

[https://northstarsound.streamlit.app/](https://northstarsound.streamlit.app/)

I am building a music recommender from scratch, utilizing Principal Component Analysis to cluster and recommend tracks based on a user-submitted top-10 mixtape. All audio features used are computed from audio files scraped from YouTube, based on a scraped dataset of Spotify user playlists.


![PCA plots of the tracks](/images/pca_plot.png)

[View GitHub Repository](https://github.com/dennisfarmer/northstarsound)

![Another PCA plots of the entire track dataset, colored by various interpretable audio feature metrics](/images/old_pca_plot.png)
