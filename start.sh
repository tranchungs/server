#!/bin/sh
# set -e 
. ~/.nvm/nvm.sh

ROOT_PATH="$PWD"
FOLDER_APPS_PATH="$PWD/.data/server/apps"

sudo apt update && sudo apt upgrade
 
#replace private ip
# sed -i 's/original/new/g' file.txt

#remove php 
sudo apt-get purge 'php*' -y
sudo apt autoremove -y

#install php 8
sudo apt install  ca-certificates apt-transport-https software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt install php8.0 -y
sudo apt install php8.0-dom
sudo apt install php8.0-mbstring -y

#install composer
cd ~
curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php
HASH=`curl -sS https://composer.github.io/installer.sig`
php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
cd $ROOT_PATH

#install git
sudo apt install git
 
#install make
sudo apt install make

#install nvm
# sudo apt install curl
# curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

#install node
# nvm install 16.13.1

#install docker
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu lsb_release -cs test"
sudo apt update
sudo apt install docker-ce
cat ./docker-hub.txt |sudo docker login --username duyhoan1710 --password-stdin

#install docker-compose
sudo apt-get install docker-compose

#run docker-compose
sudo chown $USER /var/run/docker.sock

docker-compose up -d

sudo chmod -R 777 .

rm -rf $FOLDER_APPS_PATH/spreed $FOLDER_APPS_PATH/tasks $FOLDER_APPS_PATH/calendar $FOLDER_APPS_PATH/deck $FOLDER_APPS_PATH/rickdocuments

nvm use 15.14.0

#wait
git clone https://github.com/kma-custom-nextcloud/tasks.git $FOLDER_APPS_PATH/tasks
cd $FOLDER_APPS_PATH/tasks
make

nvm use 14.14.0

#wait
git clone https://github.com/kma-custom-nextcloud/spreed.git $FOLDER_APPS_PATH/spreed
cd $FOLDER_APPS_PATH/spreed
make dev-setup
make build-js

#wait
git clone https://github.com/tranchungs/calendarcloud.git $FOLDER_APPS_PATH/calendar
cd $FOLDER_APPS_PATH/calendar
make dev-setup
make build-js

#wait
git clone https://github.com/kma-custom-nextcloud/deck.git $FOLDER_APPS_PATH/deck
cd $FOLDER_APPS_PATH/deck
make install-deps
make build

#wait
git clone https://github.com/kma-custom-nextcloud/richdocuments.git $FOLDER_APPS_PATH/richdocuments
cd $FOLDER_APPS_PATH/richdocuments
npm ci
npm run dev

#open port
sudo apt install ufw
sudo ufw default allow outgoing
sudo ufw allow 8080/tcp
sudo ufw allow 9980/tcp
sudo ufw allow OpenSSH
sudo ufw allow https
sudo ufw enable