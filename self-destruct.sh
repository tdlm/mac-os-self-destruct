#!/bin/sh

SELF_DESTRUCT_VERSION="0.92"

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
        file_modified=$(stat -f %c "$f")
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

load_configuration () {
	script_dir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
	script_install_path="/usr/local/bin/self-destruct"
	plist_name="com.github.tdlm.os-x-self-destruct"
	plist_path="$script_dir/$plist_name.plist"
	plist_install_path="$HOME/Library/LaunchAgents/$plist_name.plist"
	is_plist_loaded=$(launchctl list | grep -c "$plist_name")
}

install () {
	load_configuration

	echo "Copying self to $script_install_path"
	cp -f $0 $script_install_path
	chmod +x $script_install_path

	local user=`whoami`

	if [ $is_plist_loaded -gt 0 ]; then
		echo "Plist found. Unloading before install..."
		launchctl unload $plist_install_path
	else
		echo "Plist not found. Loading fresh..."
	fi

	echo "Generating plist for user and installing: $plist_install_path"
	cat $plist_path | sed -e "s#{SCRIPT_INSTALL_PATH}#'$script_install_path'#g" > $plist_install_path
	launchctl load -w -F $plist_install_path

	echo "Installation complete!"
}

uninstall () {
	load_configuration

	local is_plist_loaded=$(launchctl list | grep -c "$plist_name")

	if [ -f $script_install_path ]; then
		echo "Removing script..."
		srm -f $script_install_path
	fi

	if [ $is_plist_loaded -gt 0 ]; then
		echo "Unloading plist"
		launchctl unload $plist_install_path
	fi

	if [ -f $plist_install_path ]; then
		echo "Removing $plist_install_path..."
		srm -f $plist_install_path
	fi

	echo "Uninstall complete!"
}

show_usage() {

	cat <<EOF
Self Destruct v${SELF_DESTRUCT_VERSION} for Mac OS X

Securely destroys files or directories on a delay based on their OS X "Tag"

Available Tags: 1 Minute, 1 Hour, 1 Day, 1 Week, 1 Month, 1 Year

For example, if a file is tagged with "1 Week" then it will be deleted at
the time exactly one week from the last time the file was modified.

WARNING:  This script uses srm (Secure Remove), which will not only erase
the file(s), but will use a multi-pass erase which render the files
un-recoverable and un-traceable.

RUNNING MANUALLY

	self-destruct.sh --run

HELP

	self-destruct.sh --help

INSTALLATION FROM REPOSITORY

	git clone git@github.com:tdlm/os-x-self-destruct.git
	cd os-x-self-destruct && ./self-destruct.sh --install

UNINSTALL

	self-destruct.sh --uninstall

Copyright (c) Scott Weaver <http://scottmw.com/>
EOF
exit 2

}

if [ "$1" = "-r" -o "$1" = "--run" ]; then

	secure_delete_files_for_tag_after_seconds "1 Minute" 60
	secure_delete_files_for_tag_after_seconds "1 Hour" 3600
	secure_delete_files_for_tag_after_seconds "1 Day" 86400
	secure_delete_files_for_tag_after_seconds "1 Week" 604800
	secure_delete_files_for_tag_after_seconds "1 Month" 2592000
	secure_delete_files_for_tag_after_seconds "1 Year" 31557600

elif [ "$1" = "-i" -o "$1" = "--install" ]; then

	install

elif [ "$1" = "-u" -o "$1" = "--uninstall" ]; then

	uninstall

else
	show_usage
fi

