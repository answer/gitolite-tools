#!/bin/bash

[ -f ~/.gitolite-tools.rc ] && . ~/.gitolite-tools.rc

if [ -z "$gitolite_backup_ssh" ]; then
	echo "define gitolite_backup_ssh var in ~/.gitolite-tools.rc"
	exit
fi

while [ $# -gt 0 ]; do
	repository_path=$1; shift

	if [ -z "$gitolite_repo_path" ]; then
		gitolite_repo_path=~/repositories
	fi
	if [ -z "$gitolite_backup_path" ]; then
		gitolite_backup_path=~/.gitolite.backup
	fi
	if [ -z "$gitolite_backup_prefix" ]; then
		gitolite_backup_prefix=gitolite-backup
	fi

	if [ ! -d "$gitolite_backup_path" ]; then
		mkdir -p "$gitolite_backup_path"
	fi
	if [ ! -d "$gitolite_backup_path" ]; then
		echo "failed create $gitolite_backup_path"
		exit
	fi

	deploy_path=$repository_path
	deploy_path=${deploy_path#$gitolite_repo_path}
	deploy_path=${deploy_path%.git}

	backup_path=$gitolite_backup_path$deploy_path

	if [ ! -d $backup_path ]; then
		parent_path=`dirname $backup_path`
		mkdir -p $parent_path
		cd $parent_path
		git clone "$repository_path"
	fi

	cd "$backup_path"
	git push "$gitolite_backup_ssh:$gitolite_backup_prefix/$deploy_path" refs/remotes/origin/*:refs/heads/*
done
