#!/usr/bin/bash

echo $HTTP_PROXY
echo $HTTPS_PROXY
echo $ALL_PROXY
echo $NVM_DIR

if [ ! -d "/opt/esc-configurator" ]; then git clone https://github.com/stylesuxx/esc-configurator.git; fi

cd esc-configurator

git pull

git checkout develop

source $NVM_DIR/nvm.sh
# nvm install $(cat .nvmrc)
# nvm use $(cat .nvmrc)
nvm install 18.16.0
nvm use 18.16.0

npm install yarn -g

yarn install

yarn build

yarn start --host 0.0.0.0

