#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=build-common.sh
source "$SCRIPT_DIR/build-common.sh"

: "${ELRS_FLASHER_VER:?ELRS_FLASHER_VER is required}"

print_proxy_env
printf 'NVM_DIR=%s\n' "$NVM_DIR"
printf 'ELRS_FLASHER_VER=%s\n' "$ELRS_FLASHER_VER"

repo_dir="/opt/web-flasher"

clone_or_fetch "https://github.com/ExpressLRS/web-flasher.git" "$repo_dir"
checkout_tag "$repo_dir" "$ELRS_FLASHER_VER"

chmod u+x "$repo_dir/get_artifacts.sh"

cd "$repo_dir"
./get_artifacts.sh

load_nvm

npm install
