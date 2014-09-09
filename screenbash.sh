#!/bin/bash

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.

##################################
## Configuration - modify these ##
##################################

# Your upload location. No trailing /
URL="http://example.com"

# Name of the PHP script on the remote end
SCRIPT="upload.php"

# Key for the PHP script. See upload.php
KEY="secret"

# Length of file names from generated URLs
URLLENGTH=5

## The following only affects screenshots
# File extension for images
EXT="png"

# The command to use for screenshots. The filename will be appended to this.
# ex. "scrot -s"
# Leave empty to autodetect.
SCREENSHOT=""

# Path to save screenshots to locally. No trailing /
# Saves to /tmp by default, which is cleared on reboot.
# Change this to keep a local copy of the files you upload.
LOCALPATH="/tmp"

#######################
## Configuration end ##
#######################

# Autodetect screenshot program.
if [ $SCREENSHOT == "" ]; then
    if (which gnome-screenshot &>/dev/null); then
        SCREENSHOT="gnome-screenshot -a -f"
    elif (which kbackgroundsnapshot &>/dev/null); then
        SCREENSHOT="kbackgroundsnapshot --region"
        KDE_SCREENSHOT=true
    elif (which scrot &>/dev/null); then
        SCREENSHOT="scrot -s"
    else
        echo "Can't find a suitable screenshot application."
        echo "Please install gnome-screenshot, ksnapshot or scrot."
        exit 1
    fi
fi

# Takes a screenshot, then uploads it.
screenshot() {
    # Prompt you to select a region.
    notify-send Screenbash "Select a screenshot region." -t 2000

    if $KDE_SCREENSHOT; then
        # KDE needs to take the screenshot first, and then it gives you a name.
        if $SCREENSHOT; then
            # Grab the filename from the Desktop dir.
            FILE="$(ls -d -1 ~/Desktop/snapshot*.png --sort=time | head -1)"
        fi
    else
        # Generate a random filename.
        FILE="$LOCALPATH/$(date +%s | sha256sum | head -c 9).$EXT"
        # Take the screenshot. Click + drag to select the region.
        $SCREENSHOT "$FILE"
    fi

    upload_file
}

# Uploads other files.
file() {
    # Prompt the user with a Zenity file selection.
    FILE=$(zenity --file-selection --title="Select a file")
    upload_file
}

upload_file() {
    if [ -n "$FILE" ]; then
        if [ -f "$FILE" ]; then
            FINAL=$(curl -F "file=@$FILE" -F "key=$KEY" -F "length=$URLLENGTH" "$URL/$SCRIPT")
            # Copy the link to your clipboard
            echo $FINAL | xsel -i -b
            # Tell you the upload is complete
            notify-send Screenbash "$FINAL copied to clipboard." -i "$FILE" -t 2000
        fi
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
