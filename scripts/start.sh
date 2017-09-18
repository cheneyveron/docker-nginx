#!/bin/bash

ls -la /var/www/html

#Config git
git config --global user.email "${GIT_EMAIL}"
git config --global user.name "${GIT_USER}"
#Clone repository
git clone https://${GIT_USER}:${GIT_TOKEN}@${GIT_REPO} /var/www/html

crond

exec /usr/sbin/nginx -g "daemon off;"