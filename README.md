Screenbash
==========

Screenshot/file uploader for Bash.

Takes screenshots and uploads them to your own server, and copies the link to your clipboard.

Works with files other than images with the Zenity tool.

Requirements
============

Zenity (for file selection dialog, not required for screenshot mode).

A screenshot tool capable of running and taking a screenshot from the command line (gnome-screenshot, scrot, etc...).

notify-send for notifications.

xsel for copying links to the clipboard.

A web server running PHP. If you don't like PHP, you can probably use a language of your choice, provided you're willing to rewrite the server-side portion of this script.

Installation
============

Upload "upload.php" to a web server of your choice and edit the config values, especially the access key.

Place screenbash.sh in a folder on your local system. Edit the config values inside it to match upload.php, and change the save directory and screenshot program if you wish.

Usage
=====

    ## Takes a screenshot and then uploads it.
    
    $ screenbash.sh screenshot

    ## Prompts you to select a file and then uploads it.
    
    $ screenbash.sh file

Licensing
=========

The two components of this program fall under two different licenses.

screenbash.sh is licensed under the GPLv3

upload.php is licensed under the WTFPL (http://www.wtfpl.net/) and is written by GunfighterJ (http://gunfighterj.com)
