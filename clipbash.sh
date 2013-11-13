#!/bin/bash
# Generate a random file name
FILE="$(date +%s | sha256sum | base64 | head -c 5)"
# Write the contents of the clipboard to a file.
xsel --clipboard > $HOME/uploads/text/$FILE.txt
# Make sure the file exists. This allows you to cancel an upload.
if [ -f $HOME/uploads/text/$FILE.txt ]
then
    # Upload the file to a web folder on your server. This is the part where RSA keys are needed.
    rsync $HOME/uploads/text/$FILE.txt user@server.com:/path/to/upload/folder/$FILE.txt
    # Copy the link to your clipboard
    echo "http://i.revthefox.co.uk/$FILE" | xsel -i -b
    # Tell you the upload is complete
    notify-send Clipbash "http://i.revthefox.co.uk/$FILE copied to clipboard." -i $HOME/Pictures/Screenshots/$FILE.png -t 2000
fi
