#!/bin/bash

# This script is used to get the programs that are using the webcam
# You need to have the fuser and jq commands available
# based on script: https://github.com/Alexays/Waybar/issues/2705 

# get programs using the video0 endpoint
ps -eo user,pid,cmd -q "$(fuser /dev/video0 2>/dev/null | xargs)" |\
# omit the column headings and the first line which is wireplumber
sed -n "1!p" |\
# just get the pid and program columns
awk '{print $2 " " $3}' |\
# filter out the program path
awk -F "/" '{print "{\"tooltip\": \"" $1 " " $NF "\"}"}' |\
jq -s 'if length > 0 then {text: "󰄀 ", tooltip: (map(.tooltip) | join("\r"))} else {text: "", tooltip: "No applications are using your webcam!"} end' |\
jq --unbuffered --compact-output