Sys.setenv(SPOTIFY_CLIENT_ID = id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = secret)

devtools::install_github('JosiahParry/genius')
devtools::install_github('charlie86/spotifyr')

library(spotifyr)
library(plyr)
library(tidyverse)
library(ggthemes)
library(ggridges)
library(knitr)
library(kableExtra)
library(lubridate)

access_token <- get_spotify_authorization_code(scope = c('user-top-read','playlist-read-private','user-read-recently-played'))

get_my_recently_played(limit = 5, authorization = access_token) %>% 
  mutate(artist.name = map_chr(track.artists, function(x) x$name[1]),
         played_at = as_datetime(played_at)) %>% 
  select(track.name, artist.name, track.album.name, played_at)

get_my_top_artists_or_tracks(type = 'tracks', time_range = 'medium_term', limit = 10, authorization = access_token) %>% 
  mutate(artist.name = map_chr(artists, function(x) x$name[1])) %>% 
  select(name, artist.name, album.name)

#analyzing song data of linkin park
lp <- get_artist_audio_features('linkin park')
nrow(lp)

lp <- lp %>% 
  select(track_name, album_name, valence, danceability,energy,loudness,speechiness,liveness,tempo,album_release_year,track_number) %>% 
  arrange(album_release_year) %>%
  unite(album,album_name,album_release_year,sep=' - ',remove=FALSE)
lp$album_name <- as.factor(lp$album_name)
lp$album_release_year <- as.factor(lp$album_release_year)
