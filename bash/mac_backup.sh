#!/bin/sh

currPath=$(pwd)
srcPath="/Users/$(whoami)/";
descPath="$currPath/mac_backup/$(whoami)/"
excludeFile="$currPath/mac_backup_ignore.conf"
logFile="$currPath/mac_backup.log"
otherPath="$currPath/mac_backup/$(whoami)/other"

mkdir -p "$descPath"
/bin/rm -f "$logFile"

echo "$srcPath => $descPath"

#sudo rsync -avzeu --log-file="$logFile" --delete --progress --exclude-from="$excludeFile" "$srcPath" "$descPath"

sudo time rsync -arlp --delete --log-file="$logFile" --exclude-from="$excludeFile" "$srcPath" "$descPath"

/bin/rm -rf "$otherPath"
mkdir -p "$otherPath"

cp -R "/usr/local/etc/nginx/servers" "$otherPath/usr_local_etc_nginx_servers"
cp "/etc/hosts" "$otherPath/etc_hosts"
cp ~/Library/Application\ Support/Google/Chrome/*/Bookmarks "$otherPath/Chrome_Bookmarks"
cp "/etc/ansible/hosts" "$otherPath/ansible_hosts"
cp "/etc/ansible/ansible.cfg" "$otherPath/ansible.cfg"
cp -a "/usr/local/Homebrew" "$otherPath/Homebrew"
cp -a "/Users/$(whoami)/Library/Application Support/Sublime Text 3" "$otherPath/Sublime Text 3"

cp -a "/etc/pf.conf" "$otherPath/etc_pf.conf"
cp -a "/etc/pf.anchors" "$otherPath/pf.anchors"

cp -a "/Users/$(whoami)/Library/DBeaverData/workspace6/General/Scripts" "$otherPath/DBeaverScripts"
cp -R "/Library/Services/" "$otherPath/library_services"


