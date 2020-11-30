#!/bin/bash

NUM_DAYS=100

COUNTER=1

#List of recordings that are published by BBB
PUBLISHED_FILE='recordings_published_by_BBB.txt'
#Ensure that the file exists and is empty
:> "$PUBLISHED_FILE"

find /var/bigbluebutton/published/presentation/ -maxdepth 1 -mtime -"$NUM_DAYS" -printf "%f\n" | egrep '[a-z0-9]*-[0-9]*' > "$PUBLISHED_FILE"
TOTAL_PUBLISHED_RECRODINGS=$(cat "$PUBLISHED_FILE" | wc -l)

while read meeting_id; do
  #Get metadata.xml of published recording
  metadata_xml="/var/bigbluebutton/published/presentation/$meeting_id/metadata.xml"

  if [[ -f "$metadata_xml" ]];
  then
    MEETING_NAME=`xmlstarlet sel -t -v '//recording/meta/meetingName' "$metadata_xml"`
    
    START_TIME=`xmlstarlet sel -t -v '//recording/start_time' "$metadata_xml" | awk '{printf ("%d", $1/1000)}' | xargs -i date -d "@{}"` 
    
    PLAYBACK_URL=`xmlstarlet sel -t -v '//recording/playback/link' "$metadata_xml"`

    PLAYBACK_SIZE=`xmlstarlet sel -t -v '//recording/playback/size' "$metadata_xml" | awk '{printf ("%.2f", $1/1000000)}'`
    
    PLAYBACK_DURATION=`xmlstarlet sel -t -v '//recording/playback/duration' "$metadata_xml" | awk '{printf ("%.1f", $1/(1000*60))}'`
   

    echo ""
    echo "#$COUNTER $MEETING_NAME"
    echo "Start time: $START_TIME"
    echo "Size: $PLAYBACK_SIZE mb"
    echo "Duration: $PLAYBACK_DURATION min"
    echo "URL: $PLAYBACK_URL"

    COUNTER=$((COUNTER+1))

  else 
    echo "metadata.xml missing"
  fi

done < "$PUBLISHED_FILE"


rm "$PUBLISHED_FILE"
