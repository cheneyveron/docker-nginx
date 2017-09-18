#!/bin/bash
# today
NOW=$(date +"%Y%m%d")

cd /var/www/html

# New backup
git checkout master
git add -A
git commit -m "backup "$NOW

# Clean backups earlier than 180 days
git log | grep "^commit" | tail -n +180 | head -n 1 | sed 's/commit //g' | xargs /usr/bin/git-clean

# Push
git push -u origin master -f