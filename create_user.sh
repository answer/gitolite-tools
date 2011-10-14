#!/bin/bash

[ -f $HOME/.gitolite-tools.rc ] && . $HOME/.gitolite-tools.rc

if [ -z "$gitolite_host" ]; then
	echo "define gitolite_host var in $HOME/.gitolite-tools.rc"
	exit
fi
if [ -z "$gitolite_user" ]; then
	gitolite_user=gitolite
fi

usage(){
	echo 'self.sh <user>'
	exit
}

if [ $# -lt 1 ]; then
	usage
fi
user=$1; shift

if [ ! -d ~/.ssh ]; then
	mkdir ~/.ssh
	chmod 700 ~/.ssh
fi

if [ ! -d ~/.ssh/gitolite ]; then
	mkdir ~/.ssh/gitolite
fi

ssh-keygen -f ~/.ssh/gitolite/$user && sh -c 'mkdir -p ~/gitolite-admin/keydir/$0/$1 && cp ~/.ssh/gitolite/$0.pub ~/gitolite-admin/keydir/$0/$1/$0.pub && cd ~/gitolite-admin && git pull && git add keydir/$0/$1/$0.pub && git commit -m "add $0.$1 key" && git push' $user `hostname`

echo "finished"
echo "append following content to .ssh/config"
echo
echo "Host $user-ans-git"
echo "  User         $gitolite_user"
echo "  HostName     $gitolite_host"
echo "  IdentityFile ~/.ssh/gitolite/$user"
