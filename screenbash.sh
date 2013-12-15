#!/bin/bash
# Your upload location. No trailing /
URL="http://your.domain.com"
# Generate a random file name
FILE="$(date +%s | sha256sum | base64 | head -c 7)"
# Final string for URL + file
FINAL="$URL/$FILE"
# Prompt you to select a region
notify-send Screenbash "Select a screenshot region." -t 2000
# Take the screenshot. Click + drag to select the region.
#gnome-screenshot -a -f $HOME/pictures/Screenshots/$FILE.png
scrot -s $HOME/uploads/screenshots/$FILE.png
# Make sure the file exists. This allows you to cancel a screenshot.
if [ -f $HOME/uploads/screenshots/$FILE.png ]
then
    # Upload the file to a web folder on your server. This is the part where RSA keys are needed.
    rsync $HOME/uploads/screenshots/$FILE.png user@server.com:~/path/to/upload/$FILE.png
    # Copy the link to your clipboard
    echo $FINAL | xsel -i -b
    # Tell you the upload is complete
    notify-send Screenbash "$FINAL copied to clipboard." -i $HOME/uploads/screenshots/$FILE.png -t 2000
fi
