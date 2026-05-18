#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=build-common.sh
source "$SCRIPT_DIR/build-common.sh"

: "${BETAFLIGHT_CONF_VERSION:?BETAFLIGHT_CONF_VERSION is required}"

print_proxy_env
printf 'BETAFLIGHT_CONF_VERSION=%s\n' "$BETAFLIGHT_CONF_VERSION"
printf 'NVM_DIR=%s\n' "$NVM_DIR"

repo_dir="/opt/betaflight-configurator"

clone_or_fetch "https://github.com/betaflight/betaflight-configurator.git" "$repo_dir"
checkout_tag "$repo_dir" "$BETAFLIGHT_CONF_VERSION"

load_nvm
use_node_from_nvmrc "$repo_dir"

npm install yarn -g

cd "$repo_dir"
yarn install

yarn build
