#!/bin/sh

# Scan for new files and analyze

# check to see if I'm root
if ! [ $(id -u) = 0 ]; then
   echo "Please run as root user"
   exit 1
fi

# source Plex configurations
source /etc/sysconfig/PlexMediaServer

# scan
/usr/lib/plexmediaserver/Plex\ Media\ Scanner -s

# analyze
/usr/lib/plexmediaserver/Plex\ Media\ Scanner -a
