#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=build-common.sh
source "$SCRIPT_DIR/build-common.sh"

: "${BB_VER:?BB_VER is required}"

print_proxy_env
printf 'BETAFLIGHT_VERSION=%s\n' "${BETAFLIGHT_VERSION:-}"
printf 'NVM_DIR=%s\n' "$NVM_DIR"
printf 'BB_VER=%s\n' "$BB_VER"

repo_dir="/opt/blackbox-log-viewer"

clone_or_fetch "https://github.com/betaflight/blackbox-log-viewer.git" "$repo_dir"
checkout_tag "$repo_dir" "$BB_VER"

load_nvm
use_node_from_nvmrc "$repo_dir"

npm install yarn -g

cd "$repo_dir"
yarn install

yarn build
