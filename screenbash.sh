#!/bin/bash
# Generate a random file name
FILE="$(date +%s | sha256sum | base64 | head -c 5)"
# Prompt you to select a region
notify-send Screenshot "Select a screenshot region." -t 1000
# Take the screenshot. Click + drag to select the region.
scrot -s $HOME/Pictures/Screenshots/$FILE.png
# Make sure the file exists. This allows you to cancel a screenshot.
if [ -f $HOME/Pictures/Screenshots/$FILE.png ]
then
    # Upload the file to a web folder on your server. This is the part where RSA keys are needed.
    rsync $HOME/Pictures/Screenshots/$FILE.png user@server.com:/directory/for/uploads/$FILE.png
    # Copy the link to your clipboard
    echo "http://your.domain.com/$FILE" | xsel -i -b
    # Tell you the upload is complete
    notify-send Screenshot "http://your.domain.com/$FILE copied to clipboard." -i $HOME/Pictures/Screenshots/$FILE.png -t 1000
fi
