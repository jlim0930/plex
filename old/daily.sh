#!/bin/sh

# Running daily update and cleanup and reboot

# check for root
if ! [ $(id -u) = 0 ]; then
   echo "Please run this as root"
   exit 1
fi

# set vars
BACKUPDIR=/root/bin/dbbackup
DBDIR="/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
DATE=`date +"%Y-%m-%d-%H:%M"`

# Update & Refresh Library then update database
logger "[DEBUG PLEX] Update/Refresh library then update database"
/root/bin/plexupdate.sh && /root/bin/autooptimize.sh

# sleep 5 minutes
sleep 300

# stop plex
logger "[DEBUG PLEX] Stopping Plex Media Server"
systemctl stop plexmediaserver

# create BACKUPDIR if it doesnt exist
mkdir -p $BACKUPDIR

# copy db to backup
logger "[DEBUG PLEX] backing up database ${DATE}"
cp "${DBDIR}"/com.plexapp.plugins.library.db "${BACKUPDIR}"/com.plexapp.plugins.library.db."${DATE}"

# clean up dbbackup of files older than 10 days
logger "[DEBUG PLEX] Cleaning old backups"
find "${BACKUPDIR}"/* -mtime +10 -exec rm {} \;

# system update
logger "[DEBUG PLEX] System update"
yum update -y

# reboot
logger "[DEBUG PLEX] REBOOTING SYSTEM"
shutdown -r
