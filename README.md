# bbb-admin
A collection of scripts for BigBlueButton admins including extracting IP of users joining, participants attendance and poll answers.
## Meeting Analytics

```sh
# pass the most recent 10 meetings to get their summary
ls -1tr /var/bigbluebutton/recording/raw/ | tail -n 10 | xargs  -l ./meeting_analytics.sh

# pass individual meeting to get its summary
./meeting_analytics.sh <meeting-id>

# get the summary of meetings conducted on 2 Nov
find /var/bigbluebutton/recording/raw/ -maxdepth 1 -newerct "2 Nov" ! -newerct "3 Nov" -printf "%f\n" | xargs  -l ./meeting_analytics.sh
```

Sample Meeting Analytics:
* Id of meeting
* Whether recorded or not
* bbb-context and bbb-server-name
* Meeting name
* Unique participant count
* Meeting start time
* Meeting end time
* List of participants with their name, role (Viewer | Moderator) and join time

## Meeting Polls
```sh
ruby meeting_poll.rb sample_events_poll.xml
```
`meeting_poll.rb` will extract polls answers from the given `events.xml`. The output is in JSON format that you can export and use are per your requirements. 

First you should find out `<internal-meeting-id>` of the meeting for which you want to extract poll analytics. 

Next, find out corresponding `events.xml` for the given `<internal-meeting-id>` from the following location `/var/bigbluebutton/recording/raw/<internal-meeting-id>/events.xml`.

Lastly, run the script as shown above `ruby meeting_poll.rb events.xml`.

For reference, I have included a sample `events.xml` which is having some poll data. Upon executing, you will see users' data with their polls responses in JSON format.

## Extract Users' IPs

```sh
# Show result in the form: IP datetime name
./extract_IP_user_name.sh
```

## Get Recording Playback 
```sh
./meeting_playback.sh
```

Sample result:
* Meeting name and count
* Start time
* Size in MB
* Duration in minute
* Playback url

## Get Recording Size
```sh
ls -ltr /mnt/scalelite-recordings/var/bigbluebutton/published/presentation/ | awk '{print $9}' | xargs  -l ./bbb-analytics-recording.sh
```
Sampple result:
* Meeting Id
* Size in MB/KB

You can set `CLIENT_MOODLE_SERVER` to the domain of the Moodle (or any other) server from where the BBB Meetings are created. You can find this value from metadata.xml > meta > bbb-origin-server-name of any recording.  

## 🚀 <a href="https://higheredlab.com/bigbluebutton" target="_blank">Stress-free BigBlueButton hosting! Start free Trial</a>

**Save big with our affordable BigBlueButton hosting.**

- Bare metal servers for HD video
- 40% lower hosting costs
- Top-rated tech support, 100% uptime
- Upgrade / cancel anytime
- 2 weeks free trial; No credit card needed

<a href="https://higheredlab.com/bigbluebutton" target="_blank"><strong>Start Free Trial</strong></a>
