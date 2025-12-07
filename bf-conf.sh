#!/usr/bin/bash

echo $HTTP_PROXY
echo $HTTPS_PROXY
echo $ALL_PROXY
echo $BETAFLIGHT_BRANCH
echo $BETAFLIGHT_VERSION
echo $NVM_DIR

if [ ! -d "/opt/betaflight-configurator" ]; then git clone https://github.com/betaflight/betaflight-configurator.git; fi

cd betaflight-configurator

git checkout tags/${BETAFLIGHT_VERSION}

git pull

source $NVM_DIR/nvm.sh
nvm install $(cat .nvmrc)
nvm use $(cat .nvmrc)

npm install yarn -g

yarn install

yarn build