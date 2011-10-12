#!/bin/bash

git_host=git.ans-web.co.jp

if [ ! -d ~/.ssh ]; then
	mkdir ~/.ssh
	chmod 700 ~/.ssh
fi

if [ ! -d ~/.ssh/gitolite ]; then
	mkdir ~/.ssh/gitolite
fi

ssh-keygen -f ~/.ssh/gitolite/root && sudo cp .ssh/gitolite/root.pub /home/gitolite && sudo -u gitolite sh -c 'cd /home/gitolite/gitolite-admin && mkdir -p keydir/$0/$1 && cp /home/gitolite/root.pub keydir/$0/$1 && rm -f /home/gitolite/root.pub && git pull && git add "keydir/$0/$1/root.pub" && git commit -m "add $USER.root key" && git push' root `hostname`

echo "finished"
echo "append following content to .ssh/config"
echo
echo "Host root-ans-git"
echo "  User         gitolite"
echo "  HostName     $git_host"
echo "  IdentityFile ~/.ssh/gitolite/root"
