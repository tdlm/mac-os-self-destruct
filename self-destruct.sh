#!/bin/sh

secure_delete_files_for_tag_after_seconds () {

	if [ -z "$1" ]; then
		echo "-Parameter 1 required: Tag"
		return 0
	fi;

	if [ -z "$2" ]; then
		echo "-Parameter 2 required: Seconds"
		return 0
	elif [[ ! $2 =~ ^-?[0-9]+$ ]]; then
		echo "-Parameter 2 must be an integer!"
		return 0
	fi;

    current_stamp=$(date +%s)
    
    mdfind "tag:$1" | while read f; do
        file_modified=$(stat -f %m "$f")
        file_diff=$((current_stamp-file_modified))
    
        if [ $file_diff -ge $2 ]; then
        	if [ -f "$f" -o -L "$f" ]; then
            	srm -f "$f"
            elif [ -d "$f" ]; then
            	srm -rf "$f"
            fi
        fi;
    done
}

if [ "$1" = "-r" -o "$1" = "--run" ]; then

	secure_delete_files_for_tag_after_seconds "1 Minute" 60
	secure_delete_files_for_tag_after_seconds "1 Hour" 3600
	secure_delete_files_for_tag_after_seconds "1 Day" 86400
	secure_delete_files_for_tag_after_seconds "1 Week" 604800
	secure_delete_files_for_tag_after_seconds "1 Month" 2592000
	secure_delete_files_for_tag_after_seconds "1 Year" 31557600

else
	cat <<EOF
Self Destruct v0.9 for Mac OS X

Securely destroys files or directories on a delay based on their OS X "Tag"

Available Tags: 1 Minute, 1 Hour, 1 Day, 1 Week, 1 Month, 1 Year

For example, if a file is tagged with "1 Week" then it will be deleted at
the time exactly one week from the last time the file was modified.

WARNING: If you tag a file that was modified in the past, the time-to-delete
will be in the past and it may be deleted on the next run of Self Destruct.

RUNNING

	chmod +x self-destruct.sh
	./self-destruct.sh --run

HELP

	./self-destruct.sh --help

INSTALLATION

To install Self Destruct, copy this file to a permanent location and put the
following entry in your crontab:

	*/1 * * * * /path/to/self-destruct.sh --run

This will run Self Destruct every minute.

Copyright (c) Scott Weaver <http://scottmw.com/>
EOF
	exit;
fi

