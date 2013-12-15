#!/bin/bash
# Your upload location. No trailing /
URL="http://your.domain.com"
# Generate a random file name
FILE="$(date +%s | sha256sum | base64 | head -c 6)"
# Final string for URL + file
FINAL="$URL/$FILE"
# Write the contents of the clipboard to a file.
xsel --clipboard > $HOME/uploads/text/$FILE.txt
# Make sure the file exists. This allows you to cancel an upload.
if [ -f $HOME/uploads/text/$FILE.txt ]
then
    # Upload the file to a web folder on your server. This is the part where RSA keys are needed.
    rsync $HOME/uploads/text/$FILE.txt user@server.com:~/path/to/uploads/$FILE.txt
    # Copy the link to your clipboard
    echo $FINAL | xsel -i -b
    # Tell you the upload is complete
    notify-send Clipbash "$FINAL copied to clipboard." -t 2000
fi
