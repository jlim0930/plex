#!/bin/sh

# automatic optimization of the database

# check to see if I'm root
if ! [ $(id -u) = 0 ]; then
   echo "Please run as root user"
   exit 1
fi

# get token
TOKEN=`cat "/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Preferences.xml" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1`

# print token for troubleshooting
# echo "[DEBUG] TOKEN: $TOKEN"

# perform optmize
curl --request PUT http://127.0.0.1:32400/library/optimize\?async=1\&X-Plex-Token=$TOKEN

# make it sleep for 5 minutes
sleep 300
