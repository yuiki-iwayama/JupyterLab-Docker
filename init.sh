#!/bin/bash

cp -ip /run/secrets/user_ssh_key ~/.ssh/id_rsa
source /etc/bash_completion
jupyter lab --ip=0.0.0.0 --allow-root --LabApp.token=''