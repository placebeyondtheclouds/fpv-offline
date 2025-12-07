#!/usr/bin/bash

echo $HTTP_PROXY
echo $HTTPS_PROXY
echo $ALL_PROXY
echo $NVM_DIR

if [ ! -d "/opt/esc-configurator" ]; then git clone https://github.com/stylesuxx/esc-configurator.git; fi

cd esc-configurator

git checkout develop

git pull

source $NVM_DIR/nvm.sh

npm install yarn -g

yarn install

yarn build

