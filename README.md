# bbb-admin
A collection of scripts that help us run our BigBlueButton servers

## Meeting Summary

```sh
# pass the most recent 10 meetings to get their summary
ls -ltr /var/bigbluebutton/recording/raw/ | tail -n 2 | awk '{print $9}' | xargs  -l ./meeting_summary.sh

# pass individual meeting to get its summary
./meeting_summary.sh <meeting-id>

# get the summary of meetings conducted on 2 Nov
find /var/bigbluebutton/recording/raw/ -maxdepth 1 -newerct "2 Nov" ! -newerct "3 Nov" -printf "%f\n" | xargs  -l ./meeting_summary.sh 
```

## Extract Users' IPs

```sh
# Show result in the form: IP datetime name
./extract_IP_user_name.sh
```
