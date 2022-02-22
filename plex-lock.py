#!/usr/bin/python3

'''
To lock metadata for movies
'''

from plexapi.server import PlexServer
baseurl = 'https://plex.sullung.com'
token = 'gauPQh9PYsCU4azQbyoj'
plex = PlexServer(baseurl, token)

list = ['title', 'originalTitle', 'summary', 'studio', 'originallyAvailableAt', 'titleSort', 'tagline', 'contentRating', 'year', 'decade', 'duration', 'genre', 'director', 'writer', 'producer', 'actor', 'country']
for field in list:
  plex.library.section('Movies - Korean').lockAllField(field, libtype='movie')
'''
to unlock
for field in list:
  plex.library.section('Movies - Korean').unlockAllField(field, libtype='movie')
'''

'''
List all fields for libtype: movie, show, season, episode, artist, album, track, photoalbum, photo
blah = plex.library.section('Movies - Korean')
for field in blah.listFields(libtype='movie'):
  print(field)
'''

'''
Get a list of Unwatched movies in a library
movies = plex.library.section('Movies - Korean')
for video in movies.search(unwatched=True):
  print(video.title)
'''
