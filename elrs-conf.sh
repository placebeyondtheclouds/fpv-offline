#!/usr/bin/bash

echo $HTTP_PROXY
echo $HTTPS_PROXY
echo $ALL_PROXY
echo $NVM_DIR

# if [ ! -d "/opt/ExpressLRS-Configurator" ]; then git clone https://github.com/ExpressLRS/ExpressLRS-Configurator.git; fi

# cd ExpressLRS-Configurator


# git checkout tags/v1.7.11

source $NVM_DIR/nvm.sh
# nvm install $(cat .nvmrc)
# nvm use $(cat .nvmrc)

npm install yarn -g
npm install
# npm install -g npm@11.7.0
yarn install --frozen-lockfile
# chown root:root node_modules/electron/dist/chrome-sandbox
# chmod 4755 node_modules/electron/dist/chrome-sandbox




