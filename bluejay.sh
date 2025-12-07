#!/bin/sh

echo $BLUEJAY_VERSION
echo $BLUEJAY_TARGET
echo $BLUEJAY_PWM

URL="https://github.com/bird-sanctuary/bluejay/releases/download/${BLUEJAY_VERSION}/$(echo "$BLUEJAY_TARGET" | tr '-' '_')_${BLUEJAY_PWM}_${BLUEJAY_VERSION}.hex"

echo $URL
curl -L -O "$URL"

cp -r *.hex /fw