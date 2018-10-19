#!/bin/sh

# automatic maintenance of PLEX
# run this via cron every 6 hours
# will Update the library, empty the trash, optmize the library
# all the commands will work via curl over localhost
# please make sure that jq is installed


# configs
PREF="/data/plex/Library/Application Support/Plex Media Server/Preferences.xml"

# check to see if I'm root
# you can run this script as non root use as long as its ran as the same user that plex runs so that its able to read the Preferences.xml file

if ! [ $(id -u) = 0 ]; then
   echo "Please run as root user"
   exit 1
fi

# get token
TOKEN=`cat "${PREF}" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1`

# print token for troubleshooting
# uncomment to put your token in the logs if you want to know what it is.
# logger "[DEBUG PLEX] TOKEN: $TOKEN"


# run a loop against each library
for i in `curl -s -H "Accept: application/json" -H "X-Plex-Token: ${TOKEN}" http://127.0.0.1:32400/library/sections | jq -M -r '.MediaContainer.Directory[] | "\(.key)"'`
do
  logger "[DEBUG PLEX] Running Update and emptyTrash for key: ${i}"
  echo "[DEBUG PLEX] Running Update and emptyTrash for key: ${i}"
  curl -X PUT -H "X-Plex-Token: ${TOKEN}" http://127.0.0.1:32400/library/sections/${i}/refresh\?force=1
  # adding 30 sec sleep
  sleep 30
  curl -X PUT -H "X-Plex-Token: ${TOKEN}" http://127.0.0.1:32400/library/sections/${i}/emptyTrash 
done

# adding another 30 sec sleep for things to settle
sleep 30

# optimize library 
logger "[DEBUG PLEX] optimizing library"
echo "[DEBUG PLEX] optimizing library"
curl -X PUT -H "X-Plex-Token: ${TOKEN}"  http://127.0.0.1:32400/library/optimize\?async=1
