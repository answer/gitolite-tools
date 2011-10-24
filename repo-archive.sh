#!/bin/bash

[ -f ~/.gitolite-tools.rc ] && . ~/.gitolite-tools.rc

if [ -z "$gitolite_repo_path" ]; then
	gitolite_repo_path=~/repositories
fi
if [ -z "$gitolite_archive_path" ]; then
	gitolite_archive_path=~/.gitolite.archives
fi
if [ -z "$gitolite_tools_root" ]; then
	gitolite_tools_root=~/gitolite-tools
fi
if [ -z "$gitolite_archive_expire_days" ]; then
	gitolite_archive_expire_days=14
fi

if [ ! -d "$gitolite_archive_path" ]; then
	mkdir -p "$gitolite_archive_path"
fi
if [ ! -d "$gitolite_archive_path" ]; then
	echo "failed create $gitolite_archive_path"
	exit
fi

parent=`dirname "$gitolite_repo_path"`
name=`basename "$gitolite_repo_path"`
cd "$parent"

ext=tar.gz

archive=$gitolite_archive_path/backup-`/bin/date --rfc-3339=date`.$ext
rm -f "$archive" && /bin/tar zcf "$archive" "$name"

/usr/bin/find "$gitolite_archive_path" -mtime "+$gitolite_archive_expire_days" -print0 | xargs -0 rm -f
