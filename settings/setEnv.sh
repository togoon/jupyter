#!/bin/bash

# export PS1="\[\e[1;36m\]\u\[\e[1;30m\]@\[\e[0;37m\]\W\[\e[1;32m\]\\$\[\e[0m\]"

curDir=/workspaces/jupyter/settings
cd ${curDir}

# recovery
sudo apt-get update
# rsync -av root@8.219.68.31:/root/tmp/codespaces/jupyter --exclude .git/ /workspaces/
pip install --upgrade pip
python3 -m pip install -r /workspaces/jupyter/settings/requirements.txt  #  settings/requirements.txt
cp /workspaces/jupyter/settings/.vimrc ~/

# mkdir /home/codespace/.vscode-remote/data/User/globalStorage/cweijan.vscode-myssql-client2
# cp /workspaces/jupyter/settings/SQlServerClient_config.json  /home/codespace/.vscode-remote/data/User/globalStorage/cweijan.vscode-myssql-client2/config.json

# ssh id_rsa.pub    # /home/codespace/.ssh/id_rsa
# ssh-keygen
# ssh-copy-id -i /home/codespace/.ssh/id_rsa.pub root@47.241.99.13
# #/root/.shh/authorized_keys (...= codespace@codespaces-db7098)
# ssh -l root 47.241.99.13
# ssh-copy-id -i /home/codespace/.ssh/id_rsa.pub root@8.219.68.31
# ssh -l root 8.219.68.31



