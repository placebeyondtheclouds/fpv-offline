#!/usr/bin/bash

echo $HTTP_PROXY
echo $HTTPS_PROXY
echo $ALL_PROXY
echo $NVM_DIR

if [ ! -d "/opt/ExpressLRS-Configurator" ]; then git clone https://github.com/ExpressLRS/ExpressLRS-Configurator.git; fi

cd ExpressLRS-Configurator


git checkout tags/v1.7.11

git pull

source $NVM_DIR/nvm.sh
nvm install $(cat .nvmrc)
nvm use $(cat .nvmrc)


npm install yarn -g

yarn install


yarn start --host 0.0.0.0



