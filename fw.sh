#!/usr/bin/bash

echo
echo $HTTP_PROXY
echo $HTTPS_PROXY
echo $ALL_PROXY
echo $BETAFLIGHT_BRANCH
echo $BETAFLIGHT_VERSION
echo $BETAFLIGHT_FW_TARGET
echo $BETAFLIGHT_FW_EXTRA_FLAGS


if [ ! -d "/opt/betaflight" ]; then git clone https://github.com/betaflight/betaflight.git; fi

cd betaflight

git pull

git checkout $BETAFLIGHT_BRANCH

git checkout tags/$BETAFLIGHT_VERSION

make clean

make configs

if ! make arm_sdk_install; then rm -rf /opt/betaflight/downloads && make arm_sdk_install; fi

make $BETAFLIGHT_FW_TARGET EXTRA_FLAGS="-D'RELEASE_NAME=$BETAFLIGHT_VERSION' $BETAFLIGHT_FW_EXTRA_FLAGS" -j

cp -r /opt/betaflight/obj/*.hex /fw