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

## [BigBlueButton Tech Support](https://higheredlab.com/bigbluebutton-support/)
### Are you facing difficulties with your BigBlueButton server?
Lean on our expertise to smoothly run your BigBlueButton server. We can: 
1. troubleshoot your BigBlueButton servers to improve audio and video performance,
1. install additional features such as streaming, mp4 recordings and attendance, and
1. provide managed BigBlueButton servers, starting at $12 per month

[Click here to learn more](https://higheredlab.com/bigbluebutton-support/)



## More on BigBlueButton

Check-out the following apps to further extend features of BBB.

### [bbb-jamboard](https://github.com/manishkatyan/bbb-jamboard)

The default whiteboard of BigBlueButton has limited features including no eraser. Many teachers wish to have a more features-rich whiteboard that would help them better in conducting online classes.

With BBB-Jamboard, you can easily integrate Google Jamboard into your BigBlueButton server.

Jamboard is a digital interactive whiteboard developed by Google and can be used in stead of the default BugBlueButton whiteboard. Google Jamboard has the eraser feature that has often been requested by BigBlueButton users.

### [bbb-mp4](https://github.com/manishkatyan/bbb-mp4)
With this app, you can convert a BigBlueButton recording into MP4 video and upload to S3. You can convert multiple MP4 videos in parallel or automate the conversion process.

### [bbb-twilio](https://github.com/manishkatyan/bbb-twilio)

Integrate Twilio into BigBlueButton so that users can join a meeting with a dial-in number. You can get local numbers for almost all the countries.

### [bbb-optimize](https://github.com/manishkatyan/bbb-customize)

Better audio quality, increase recording processing speed, dynamic video profile, pagination, fix 1007/1020 errors and use apply-config.sh to manage your customizations are some key techniques for you to optimize and smoothly run your BigBlueButton servers.

### [bbb-streaming](https://github.com/manishkatyan/bbb-streaming)

Livestream your BigBlueButton classes on Youtube or Facebook to thousands of your users.

### [bbb-recording-server](https://github.com/manishkatyan/bbb-recording-server)

With this app, you can process BigBlueButton recordings on a separate server, called BBB Recording Server. Separation of recordings from BigBlueButton (client) improves performance as all server resources are dedicated towards conducting live classes.

### [100 Most Googled Questions on BigBlueButton](https://higheredlab.com/bigbluebutton-guide/)

Everything you need to know about BigBlueButton including pricing, comparison with Zoom, Moodle integrations, scaling, and dozens of troubleshooting.
