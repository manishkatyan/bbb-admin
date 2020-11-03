#!/bin/bash

cat /var/log/nginx/bigbluebutton.access.log | grep join | grep fullName | awk '{split($7, a, "=");} {split(a[2],b,"&");} {print $1, $4, $5, b[1]}'
