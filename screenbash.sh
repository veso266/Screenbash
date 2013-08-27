#!/bin/bash
# Generate a random file name.
FILE="$(date +%s | sha256sum | base64 | head -c 5)"
# Prompt you to select a region.
notify-send Screenbash "Select a screenshot region." -t 1000
# Take the screenshot. Click + drag to select the region.
scrot -s $HOME/Pictures/Screenshots/$FILE.png
# Make sure the file exists. This allows you to cancel a screenshot.
if [ -f $HOME/Pictures/Screenshots/$FILE.png ]
then
    # Upload the file to a web folder on your server. This is the part where RSA keys are needed.
    rsync $HOME/Pictures/Screenshots/$FILE.png rev@revthefox.co.uk:~/httpdocs/img/$FILE.png
    # Copy the link to your clipboard.
    echo "http://i.revthefox.co.uk/$FILE" | xsel -i -b
    # Tell you the upload is complete.
    notify-send Screenbash "http://i.revthefox.co.uk/$FILE copied to clipboard." -i $HOME/Pictures/Screenshots/$FILE.png -t 1000
fi
