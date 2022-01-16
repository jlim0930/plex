#!/bin/sh

# automatic maintenance of PLEX
# will, optimize the database, Update the library, and empty the trash
# all the commands will work via curl over localhost
# please make sure that jq is installed

# check to see if I'm root
# you can run this script as non root use as long as its ran as the same user that plex runs so that its able to read the Preferences.xml file
#if ! [ $(id -u) = 0 ]; then
#   echo "Please run as root user"
#   exit 1
#fi

# configs
PREF="/opt/plex/Library/Application Support/Plex Media Server/Preferences.xml"

# get token
TOKEN=`cat "${PREF}" | sed -e 's;^.* PlexOnlineToken=";;' | sed -e 's;".*$;;' | tail -1`

# print token for troubleshooting
# uncomment to put your token in the logs if you want to know what it is.
logger "[DEBUG PLEX] TOKEN: $TOKEN"
echo "[DEBUG PLEX] TOKEN: $TOKEN"

# optimize database
logger "[DEBUG PLEX] optimizing library"
echo "[DEBUG PLEX] optimizing library"
## curl -X PUT -H "X-Plex-Token: ${TOKEN}"  http://127.0.0.1:32400/library/optimize\?async=1&X-Plex-Token=${TOKEN}
curl -X PUT http://127.0.0.1:32400/library/optimize\?async=1\&X-Plex-Token=${TOKEN}

# adding 120 sec sleep for things to settle
sleep 120

# run a loop against each library
for i in `curl -s -H "Accept: application/json" -H "X-Plex-Token: ${TOKEN}" http://127.0.0.1:32400/library/sections | jq -M -r '.MediaContainer.Directory[] | "\(.key)"'`
do
  logger "[DEBUG PLEX] Running Update for key: ${i}"
  echo "[DEBUG PLEX] Running Update for key: ${i}"
# OLD way
#  curl -X PUT -H "X-Plex-Token: ${TOKEN}" http://127.0.0.1:32400/library/sections/${i}/refresh\?force=1&X-Plex-Token=${TOKEN}
# NEW way
  curl -X PUT http://127.0.0.1:32400/library/sections/${i}/refresh\?force=1\&X-Plex-Token=${TOKEN}
  # adding 30 sec sleep
  sleep 30
#  curl -X PUT -H "X-Plex-Token: ${TOKEN}" http://127.0.0.1:32400/library/sections/${i}/emptyTrash?X-Plex-Token=${TOKEN}
  logger "[DEBUG PLEX] Emptying Trash for key: ${i}"
  echo "[DEBUG PLEX] Emptying Trash for key: ${i}"
  curl -X PUT http://127.0.0.1:32400/library/sections/${i}/emptyTrash\?X-Plex-Token=${TOKEN}
done

# clean PhotoTranscoder Cache
logger "[DEBUG PLEX] Deleting PhotoTranscoder Cache"
echo "[DEBUG PLEX] Deleting PhotoTranscoder Cache"
CACHEPATH="/opt/plex/Library/Application Support/Plex Media Server/Cache/PhotoTranscoder"
find "${CACHEPATH}" -type f -delete
