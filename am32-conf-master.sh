#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=build-common.sh
source "$SCRIPT_DIR/build-common.sh"

print_proxy_env
printf 'NVM_DIR=%s\n' "$NVM_DIR"
printf 'NODE_VERSION=%s\n' "$NODE_VERSION"
export DATABASE_URL="${DATABASE_URL:-mysql://am32:am32@127.0.0.1:3306/am32}"

repo_dir="/opt/am32-configurator"

clone_or_fetch "https://github.com/am32-firmware/am32-configurator.git" "$repo_dir"
checkout_branch "$repo_dir" "master"

printf '%s\n' \
  'export default defineEventHandler(async () => {' \
  '    return { data: [] };' \
  '});' \
  > "$repo_dir/server/api/sponsors.ts"

load_nvm
nvm use "$NODE_VERSION"

cd "$repo_dir"
command -v corepack >/dev/null || npm install corepack -g
corepack enable
yarn install
yarn prepare

yarn build
