#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=build-common.sh
source "$SCRIPT_DIR/build-common.sh"

: "${ESC_CONF_VER:?ESC_CONF_VER is required}"

print_proxy_env
printf 'NVM_DIR=%s\n' "$NVM_DIR"
printf 'ESC_CONF_VER=%s\n' "$ESC_CONF_VER"

repo_dir="/opt/esc-configurator"

clone_or_fetch "https://github.com/stylesuxx/esc-configurator.git" "$repo_dir"
checkout_tag "$repo_dir" "$ESC_CONF_VER"

load_nvm

npm install yarn -g

cd "$repo_dir"
yarn install

yarn build
