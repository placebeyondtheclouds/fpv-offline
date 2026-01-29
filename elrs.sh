#!/usr/bin/bash

echo $HTTP_PROXY
echo $HTTPS_PROXY
echo $ALL_PROXY
echo $NVM_DIR
echo $ELRS_FLASHER_VER

if [ ! -d "/opt/web-flasher" ]; then git clone https://github.com/ExpressLRS/web-flasher.git; fi

cd web-flasher

git checkout tags/$ELRS_FLASHER_VER

git pull

chmod u+x ./get_artifacts.sh

./get_artifacts.sh

source $NVM_DIR/nvm.sh

npm install

