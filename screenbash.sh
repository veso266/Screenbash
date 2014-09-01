#!/bin/bash

## Configuration - modify these
# Your upload location. No trailing /
URL="http://example.com"
# Name of the PHP script on the remote end
SCRIPT="upload.php"
# Key for the PHP script. See upload.php
KEY="secret"

## The following only affects screenshots
# File extension for images
EXT="png"
# The command to use for screenshots. The filename will be appended to this.
# ex. "scrot -s"
SCREENSHOT="gnome-screenshot -a -f"
# Path to save screenshots to locally. No trailing /
# Saves to /tmp by default, which is cleared on reboot.
# Change this to keep a local copy of the files you upload.
LOCALPATH="/tmp"
## Configuration end

# Takes a screenshot, then uploads it.
screenshot() {
    # Generate a random file name.
    FILE="$LOCALPATH/$(date +%s | sha256sum | head -c 9).$EXT"
    # Prompt you to select a region.
    notify-send Screenbash "Select a screenshot region." -t 2000
    # Take the screenshot. Click + drag to select the region.
    $SCREENSHOT "$FILE"
    upload_file 
}

# Uploads other files. Please make sure the file you are uploading is allowed in upload.php
file() {
    # Prompt the user with a Zenity file selection.
    FILE=$(zenity --file-selection --title="Select a file")
    upload_file
}

upload_file() {
    if [ -f $FILE ]
    then
        FINAL=$(curl -F "file=@$FILE" -F "key=$KEY" "$URL/$SCRIPT")
        # Copy the link to your clipboard
        echo $FINAL | xsel -i -b
        # Tell you the upload is complete
        notify-send Screenbash "$FINAL copied to clipboard." -i "$FILE" -t 2000
    fi
}

usage() {
    echo "Usage:"
    echo "'screenbash.sh screenshot' - Takes and uploads a screenshot"
    echo "'screenbash.sh file' - Uploads a file - Requires Zenity"
}

case $1 in
    screenshot)
        screenshot
        ;;
    file)
        file
        ;;
    *)
        usage
        ;;
esac
