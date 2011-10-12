#!/bin/sh
git_host=git.ans-web.co.jp
user=$1
[ ! -z "$user" ] && mkdir -p ~/.ssh/gitolite && ssh-keygen -f ~/.ssh/gitolite/$user && scp ~/.ssh/gitolite/$user.pub $git_host:. && ssh $git_host 'sh -c '"'"'mkdir -p ~/gitolite-admin/keydir/$0/$1 && mv ~/$0.pub ~/gitolite-admin/keydir/$0/$1/$0.pub && cd ~/gitolite-admin && git pull && git add keydir/$0/$1/$0.pub && git commit -m "add $0.$1 key" && git push'"' $user `hostname`"

echo "finished"
echo "append following content to .ssh/config"
echo

echo "Host $user-ans-git"
echo "  User         gitolite"
echo "  HostName     $git_host"
echo "  IdentityFile ~/.ssh/gitolite/$user"
