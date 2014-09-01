Screenbash
==========

Screenshot/file uploader for Bash.

Takes screenshots and uploads them to your own server, and copies the link to your clipboard.

Works with files other than images with the Zenity tool.

Requirements
============

Zenity

A screenshot tool (gnome-screenshot, scrot, etc...)

A web server running PHP.

Installation
============

Upload "upload.php" to a web server of your choice and edit the config values, especially the access key.

Place screenbash.sh in a folder on your local system. Edit the config values inside it to match upload.php, and change the save directory and screenshot program if you wish.

Usage
=====

    screenbash.sh screenshot ## Prompts for a screenshot and then uploads it.

    screenbash.sh file ## Prompts you to select a file and then uploads it.
