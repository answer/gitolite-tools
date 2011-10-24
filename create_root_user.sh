#!/bin/bash

[ -f $HOME/.gitolite-tools.rc ] && . $HOME/.gitolite-tools.rc

if [ -z "$gitolite_host" ]; then
	echo "define gitolite_host var in $HOME/.gitolite-tools.rc"
	exit
fi
if [ -z "$gitolite_user" ]; then
	gitolite_user=gitolite
fi
if [ -z "$gitolite_home" ]; then
	gitolite_home=/home/$gitolite_user
fi
if [ -z "$gitolite_keydir" ]; then
	gitolite_keydir=gitolite
fi
if [ -z "$gitolite_admin_user" ]; then
	gitolite_admin_user=root
fi

if [ ! -d ~/.ssh ]; then
	mkdir ~/.ssh
	chmod 700 ~/.ssh
fi

if [ ! -d ~/.ssh/$gitolite_keydir ]; then
	mkdir ~/.ssh/$gitolite_keydir
fi

ssh-keygen -f ~/.ssh/$gitolite_keydir/$gitolite_admin_user && sudo cp ~/.ssh/$gitolite_keydir/$gitolite_admin_user.pub $gitolite_home && sudo -u $gitolite_user sh -c 'cd $3/gitolite-admin && mkdir -p keydir/$0/$2 && cp $3/$1.pub keydir/$0/$2 && rm -f $3/$1.pub && git pull && git add . && git commit -m "add $0.$1 key" && git push' $USER $gitolite_admin_user `hostname` $gitolite_home

echo "finished"
echo "append following content to .ssh/config"
echo
echo "Host $gitolite_admin_user-ans-git"
echo "  User         $gitolite_user"
echo "  HostName     $gitolite_host"
echo "  IdentityFile ~/.ssh/$gitolite_keydir/$gitolite_admin_user"
