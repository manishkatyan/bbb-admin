#!/bin/bash

# Number of days of recordings for which participants counts need to be extracted
NUM_DAYS=1

MEETINGS="meeting_file.txt"

find /var/bigbluebutton/recording/raw/ -maxdepth 1 -mtime "$NUM_DAYS" -printf "%f\n" | egrep "^[0-9a-f]{40}-[[:digit:]]{13}$" > "$MEETINGS"

while read meeting; do
  events_xml="/var/bigbluebutton/recording/raw/$meeting/events.xml"
  participant_count=`xmlstarlet sel -t -v '//recording/event[@module="PARTICIPANT"]/name' "$events_xml" | sort --unique | wc -l`
  echo "$meeting $participant_count"
done < "$MEETINGS"

rm "$MEETINGS"
