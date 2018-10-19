# PLEX

## plexdo.sh

A script to place into cron to run once or twice a day to update/scan the library and empty trash.




# ALL of the following were moved to OLD


The following are my scripts for my linux based PLEX server for daily cleanup and updates.

## autooptimize.sh
  finds the token from Preferences.xml and use curl to optmize plex database

## daily.sh
  calls various scripts and runs system updates and reboots the system
  this is configured with daily cronjob to execute

## dbbackup
  this is the directory where the database backups are stored

## manualoptimize.sh
  I always had problems with sqlite3 on CentOS with PLEX db file. it does work in windows

## plexupdate.sh
  script run scan for new files then analyze on the whole library
