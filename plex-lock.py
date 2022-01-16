#!/usr/bin/python3

'''
To lock metadata for movies
'''

from plexapi.server import PlexServer
baseurl = 'https://plex.url:32400'
token = 'xxxxxxxx'
plex = PlexServer(baseurl, token)

list = ['title', 'studio', 'contentRating', 'year', 'decade', 'duration', 'genre', 'director', 'writer', 'producer', 'actor', 'country']
for field in list:
  plex.library.section('Movies - Korean').lockAllField(field, libtype='movie')
  
'''
to unlock
for field in list:
  plex.library.section('Movies - Korean').unlockAllField(field, libtype='movie')
'''
