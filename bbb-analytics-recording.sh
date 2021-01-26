#!/bin/bash
MEETING_ID=$1

PUBLISHED_DIR="/mnt/scalelite-recordings/var/bigbluebutton/published/presentation/"
CLIENT_MOODLE_SERVER="mahamyakywuntha.com"

if [[ -n $(find "$PUBLISHED_DIR" -maxdepth 1 -printf "%f\n" | grep -w "$MEETING_ID") ]]
then
  #Get metadata.xml of published recording
  metadata_xml="$PUBLISHED_DIR/$MEETING_ID/metadata.xml"

  BBB_ORIGIN_SERVER_NAME=`xmlstarlet sel -t -v '//recording/meta/bbb-origin-server-name' "$metadata_xml"`
  BBB_ORIGIN=`xmlstarlet sel -t -v '//recording/meta/bbb-origin' "$metadata_xml"`
  MEETING_ID=`xmlstarlet sel -t -v '//recording/id' "$metadata_xml"`

  if [ "$BBB_ORIGIN_SERVER_NAME" == "$CLIENT_MOODLE_SERVER" ]; then
    echo "$MEETING_ID"
    SIZE=`du -sh "$PUBLISHED_DIR$MEETING_ID" | awk '{print $1}'`
    echo "$SIZE"
  fi	  


else
  echo "Published recording not found: $MEETING_ID"
fi

