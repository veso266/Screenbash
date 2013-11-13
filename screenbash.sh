#!/bin/bash
# Generate a random file name.
FILE="$(date +%s | sha256sum | base64 | head -c 5)"
# Prompt you to select a region.
notify-send Screenbash "Select a screenshot region." -t 1000
# Take the screenshot. Click + drag to select the region.
# You have two choices here. Scrot or Gnome Screenshot. Scrot is buggier, but works on everything. Uncomment as needed.
# gnome-screenshot -a -f $HOME/uploads/screenshots/$FILE.png
# scrot -s $HOME/uploads/screenshots/$FILE.png
# Make sure the file exists. This allows you to cancel a screenshot.
if [ -f $HOME/uploads/screenshots/$FILE.png ]
then
    # Upload the file to a web folder on your server. This is the part where RSA keys are needed.
    rsync $HOME/uploads/screenshots/$FILE.png user@server.com:/path/to/upload/folder/$FILE.png
    # Copy the link to your clipboard.
    echo "http://your.domain.com/$FILE" | xsel -i -b
    # Tell you the upload is complete.
    notify-send Screenbash "http://your.domain.com/$FILE copied to clipboard." -i $HOME/Pictures/Screenshots/$FILE.png -t 1000
fi
