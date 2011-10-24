#!/bin/bash

[ -f ~/.gitolite-tools.rc ] && . ~/.gitolite-tools.rc

if [ -z "$gitolite_repo_path" ]; then
	gitolite_repo_path=~/repositories
fi
if [ -z "$gitolite_tools_root" ]; then
	gitolite_tools_root=~/gitolite-tools
fi

/usr/bin/find "$gitolite_repo_path" -name "*.git" -type d -print0 | xargs -0 "$gitolite_tools_root/repo-push.sh"
