#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=build-common.sh
source "$SCRIPT_DIR/build-common.sh"

print_proxy_env
printf 'NVM_DIR=%s\n' "$NVM_DIR"

repo_dir="/opt/betaflight-configurator"

clone_or_fetch "https://github.com/betaflight/betaflight-configurator.git" "$repo_dir"
checkout_branch "$repo_dir" "master"

load_nvm
use_node_from_nvmrc "$repo_dir"

npm install yarn -g

cd "$repo_dir"
yarn install

yarn build
