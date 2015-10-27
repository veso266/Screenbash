#!/bin/bash

#  This program is free software: you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation, either version 3 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program.  If not, see <http://www.gnu.org/licenses/>.

##################################
## Configuration - modify these ##
##################################
# Your upload location.
url="http://example.com/upload.php"

# Key for the PHP script. See upload.php
key="secret"

# Length of file names from generated urls
urllength=5

## The following only affects screenshots
# File extension for images
ext="png"

# The command to use for screenshots. The filename will be appended to this.
# ex. "scrot -s"
# Leave empty to autodetect.
screenshot=""

# Path to save screenshots to locally. No trailing /
# Saves to $XDG_RUNTIME_DIR by default, which is cleared on reboot.
# Change this to keep a local copy of the files you upload.
localpath="$XDG_RUNTIME_DIR"

#######################
## Configuration end ##
#######################

# Autodetect screenshot program.
if [[ $screenshot == "" ]]; then
	if $(which gnome-screenshot &>/dev/null); then
		screenshot="gnome-screenshot -a -f"
	elif $(which kbackgroundsnapshot &>/dev/null); then
		screenshot="kbackgroundsnapshot --region"
		kde_screenshot="true"
	elif $(which import &>/dev/null); then
		screenshot="import"
	elif $(which scrot &>/dev/null); then
		screenshot="scrot -s"
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

	if [[ "$kde_screenshot" == "true" ]]; then
		# kde needs to take the screenshot first, and then it gives you a name.
		if $screenshot; then
			# Grab the filename from the Desktop dir.
			file="$(ls -d -1 ~/Desktop/snapshot*.png --sort=time | head -1)"
		fi
	else
		# Generate a random filename.
		file="$localpath/$(date +%s | sha256sum | head -c 9).$ext"
		# Take the screenshot. Click + drag to select the region.
		#echo "$file"
		$screenshot "$file"
	fi

	upload_file
}

# Uploads other files.
file() {
	# Prompt the user with a Zenity file selection.
	if [[ -z $1 ]]; then
		file=$(zenity --file-selection --title="Select a file")
	else
		file="$1"
	fi
	upload_file
}

upload_file() {
	if [[ -n "$file" ]]; then
		if [[ -f "$file" ]]; then
			final=$(curl -F "file=@$file" -F "key=$key" -F "length=$urllength" "$url")
			notify="notify-send Screenbash \"$final uploaded.\" -t 2000"

			# Copy the link to your clipboard
			echo $final | xsel -i -b

			if $(which convert &>/dev/null); then
				# Convert to a thumbnail to prevent certain notification daemons taking over the screen
				small_file="$file.small.$ext"
				convert "$file" -resize 128x128\! "$small_file"

				notify="$notify -i $small_file"
				eval $notify
				rm $small_file
			else
				notify="$notify -i $file"
				eval $notify
			fi
		fi
	fi
}

usage() {
	echo "Usage:"
	echo "$(basename $0) screenshot - Takes and uploads a screenshot"
	echo "$(basename $0) file [file] - Uploads a file - If no file is specified, requires Zenity"
}

case $1 in
	screenshot)
		screenshot
		;;
	file*)
		file $2
		;;
	*)
		usage
		;;
esac
