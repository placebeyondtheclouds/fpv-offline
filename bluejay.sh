#!/bin/sh


URL="https://github.com/bird-sanctuary/bluejay/releases/download/v0.21.1-RC1/$(echo "$BLUEJAY_TARGET" | tr '-' '_')_${BLUEJAY_PWM}_v0.21.1-RC1.hex"
curl -L -O "$URL"

cp -r *.hex /fw