#!/bin/bash

[ -f ~/.gitolite-tools.rc ] && . ~/.gitolite-tools.rc

if [ -z "$gitolite_repo_path" ]; then
	gitolite_repo_path=~/repositories
fi
if [ -z "$gitolite_archive_path" ]; then
	gitolite_archive_path=~/.gitolite.archives
fi
if [ -z "$gitolite_archive_logrotate_path" ]; then
	gitolite_archive_logrotate_path=~/gitolite-tools/logrotate.d
fi

if [ ! -d "$gitolite_archive_path" ]; then
	mkdir -p "$gitolite_archive_path"
fi
if [ ! -d "$gitolite_archive_path" ]; then
	echo "failed create $gitolite_archive_path"
	exit
fi

archive=$gitolite_archive_path/backup.tar.gz
conf=$gitolite_archive_path/logrotate.conf

echo -n $archive >> $conf
cat $gitolite_archive_logrotate_path/archive >> $conf

rm -f "$archive" && /bin/tar zcf "$archive" "$gitolite_repo_path" && /usr/sbin/logrotate $conf
