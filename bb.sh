#!/usr/bin/bash

echo $HTTP_PROXY
echo $HTTPS_PROXY
echo $ALL_PROXY
echo $BETAFLIGHT_BRANCH
echo $BETAFLIGHT_VERSION
echo $NVM_DIR
echo $BB_VER

if [ ! -d "/opt/blackbox-log-viewer" ]; then git clone https://github.com/betaflight/blackbox-log-viewer.git; fi

cd blackbox-log-viewer

git checkout tags/$BB_VER

git pull

source $NVM_DIR/nvm.sh
nvm install $(cat .nvmrc)
nvm use $(cat .nvmrc)

npm install yarn -g

yarn install

yarn build