#!/bin/bash

git_host=git.ans-web.co.jp

user=$USER

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
echo "  User         gitolite"
echo "  HostName     $git_host"
echo "  IdentityFile ~/.ssh/gitolite/$user"
