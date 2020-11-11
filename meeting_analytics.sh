#!/bin/bash

MEETING_ID=$1

echo "**"
echo "Meeting Analytics"

if [[ -n $(find /var/bigbluebutton/recording/raw/ -maxdepth 1 -printf "%f\n" | grep -w "$MEETING_ID") ]]
then
  echo "Raw recording found: $MEETING_ID"

  #Get events.xml of raw recording
  events_xml="/var/bigbluebutton/recording/raw/$MEETING_ID/events.xml"

  if [[ -f "$events_xml" ]];
  then
    #Read events.xml and look for RecordStatusEvent as true, which means the meeting was recorded
    result=`xmlstarlet sel -t -v '//recording/event[@eventname="RecordStatusEvent"]/status' "$events_xml"`

    if [ -n "$result" ];
    then
      echo "recorded: yes"
    else 
      echo "recorded: no"
    fi

    BBB_CONTEXT=`xmlstarlet sel -t -v '//recording/metadata/@bbb-context' "$events_xml"`
    BBB_ORIGIN_SERVER_NAME=`xmlstarlet sel -t -v '//recording/metadata/@bbb-origin-server-name' "$events_xml"`
    MEETING_NAME=`xmlstarlet sel -t -v '//recording/metadata/@meetingName' "$events_xml"`

    PARTICIPANTS=`xmlstarlet sel -t -m '//recording/event[@eventname="ParticipantJoinEvent"]' -v "name" -o "," -v "role" -o "," -v "date" -n "$events_xml"`
    
    PARTICIPANTS_COUNT=`xmlstarlet sel -t -v '//recording/event[@eventname="ParticipantJoinEvent"]/name' "$events_xml" | sort | uniq | wc -l`
    
    START_TIME=`xmlstarlet sel -t -v '//recording/event[@eventname="ParticipantJoinEvent"][1]/date' "$events_xml"`
    
    END_TIME=`xmlstarlet sel -t -v '//recording/event[@eventname="EndAndKickAllEvent"]/date' "$events_xml"`
 
    echo "bbb-context: $BBB_CONTEXT"
    echo "bbb-server-name: $BBB_ORIGIN_SERVER_NAME"
    echo "meeting name: $MEETING_NAME"
    echo "participant count: $PARTICIPANTS_COUNT"
    echo "start time: $START_TIME"
    echo "end time: $END_TIME"

    echo "Participants:"
    echo "$PARTICIPANTS"
  
  else 
    echo "events.xml not found"
  fi

else 
  echo "Raw recording not found: $MEETING_ID"
fi
