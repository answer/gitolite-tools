#!/bin/bash

[ -f $HOME/.gitolite-tools.rc ] && . $HOME/.gitolite-tools.rc

if [ -z "$gitolite_host" ]; then
	echo "define gitolite_host var in $HOME/.gitolite-tools.rc"
	exit
fi
if [ -z "$gitolite_user" ]; then
	gitolite_user=gitolite
fi
if [ -z "$gitolite_keydir" ]; then
	gitolite_keydir=gitolite
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

if [ ! -d ~/.ssh/$gitolite_keydir ]; then
	mkdir ~/.ssh/$gitolite_keydir
fi

ssh-keygen -f ~/.ssh/$gitolite_keydir/$user && scp ~/.ssh/$gitolite_keydir/$user.pub $gitolite_host:. && ssh $gitolite_host 'sh -c '"'"'mkdir -p ~/gitolite-admin/keydir/$0/$2 && mv ~/$1.pub ~/gitolite-admin/keydir/$0/$2 && cd ~/gitolite-admin && git pull && git add . && git commit -m "add $0.$1 key" && git push'"' $USER $user `hostname`"

echo "finished"
echo "append following content to .ssh/config"
echo
echo "Host $user-ans-git"
echo "  User         $gitolite_user"
echo "  HostName     $gitolite_host"
echo "  IdentityFile ~/.ssh/$gitolite_keydir/$user"
