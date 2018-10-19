#!/bin/sh

# DO NOT USE AS SQLITE3 on CentOS is a bit broken
exit 1

# check for root
if ! [ $(id -u) = 0 ]; then
   echo "Please run this as root"
   exit 1
fi

# set vars
BACKUPDIR=/root/bin/dbbackup
DBDIR="/var/lib/plexmediaserver/Library/Application Support/Plex Media Server/Plug-in Support/Databases"
DATE=`date +"%Y-%m-%d-%H:%M"`

# stop plex
systemctl stop plexmediaserver

# create BACKUPDIR if it doesnt exist
mkdir -p $BACKUPDIR

# copy db to backup
mv "${DBDIR}"/com.plexapp.plugins.library.db $BACKUPDIR/com.plexapp.plugins.library.db."${DATE}"
rm -rf "${DBDIR}"/com.plexapp.plugins.library.db-???

# dump and import
sqlite3 "${BACKUPDIR}"/com.plexapp.plugins.library.db."${DATE}" > /tmp/dbdump.sql
sqlite3 "${DBDIR}"/com.plexapp.plugins.library.db < /tmp/dbdump.sql
chown plex:plex "${DBDIR}"/com.plexapp.plugins.library.db
rm -rf /tmp/dbdump.sql

# clean up dbbackup of files older than 3 months
find "${BACKUPDIR}"/* -mtime +90 -exec rm {} \;

# start plex
systemctl start plexmediaserver
