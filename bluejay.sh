#!/bin/sh
set -eu

: "${BLUEJAY_VERSION:?BLUEJAY_VERSION is required}"
: "${BLUEJAY_TARGET:?BLUEJAY_TARGET is required}"
: "${BLUEJAY_PWM:?BLUEJAY_PWM is required}"

printf 'BLUEJAY_VERSION=%s\n' "$BLUEJAY_VERSION"
printf 'BLUEJAY_TARGET=%s\n' "$BLUEJAY_TARGET"
printf 'BLUEJAY_PWM=%s\n' "$BLUEJAY_PWM"

target_name="$(printf '%s' "$BLUEJAY_TARGET" | tr '-' '_')"
file_name="${target_name}_${BLUEJAY_PWM}_${BLUEJAY_VERSION}.hex"
url="https://github.com/bird-sanctuary/bluejay/releases/download/${BLUEJAY_VERSION}/${file_name}"

printf 'URL=%s\n' "$url"
curl -fL --output "$file_name" "$url"

cp "$file_name" /fw/
