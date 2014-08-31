#!/bin/bash

## VARS
# Your upload location. No trailing /
URL="http://example.com"
# Name of the PHP script on the remote end
SCRIPT="upload.php"
# Key for the PHP script. See upload.php
KEY="secret"
# File extension for the image
EXT="png"
# Path to save files to locally. No trailing /
LOCALPATH="$HOME/uploads/screenshots"

# Generate a random file name
FILE="$(date +%s | sha256sum | head -c 9).$EXT"
# Prompt you to select a region
notify-send Screenbash "Select a screenshot region." -t 2000
# Take the screenshot. Click + drag to select the region.
gnome-screenshot -a -f $LOCALPATH/$FILE
#scrot -s $HOME/uploads/screenshots/$FILE.png
# Make sure the file exists. This allows you to cancel a screenshot.
if [ -f $LOCALPATH/$FILE ]
then
    FINAL=$(curl -F "file=@$LOCALPATH/$FILE" -F "key=$KEY" "$URL/$SCRIPT")
    # Copy the link to your clipboard
    echo $FINAL | xsel -i -b
    # Tell you the upload is complete
    notify-send Screenbash "$FINAL copied to clipboard." -i $LOCALPATH/$FILE -t 2000
fi
