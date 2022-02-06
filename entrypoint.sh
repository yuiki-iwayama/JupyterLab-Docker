#!/bin/bash

chown -R root:root ~/.ssh
chmod -R 0700 ~/.ssh
cp -ip /run/secrets/user_ssh_key ~/.ssh/id_rsa
chmod -R 0600 ~/.ssh
source /etc/bash_completion

exec "$@"