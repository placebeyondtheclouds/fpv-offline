#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=build-common.sh
source "$SCRIPT_DIR/build-common.sh"

print_proxy_env
printf 'BUCKSAW_REF=%s\n' "${BUCKSAW_REF:-}"

repo_dir="/opt/bucksaw"

clone_or_fetch "https://github.com/KoffeinFlummi/bucksaw.git" "$repo_dir"

if [ -n "${BUCKSAW_REF:-}" ]; then
  git -C "$repo_dir" fetch --tags --prune --force origin
  git -C "$repo_dir" checkout "$BUCKSAW_REF"
fi

cd "$repo_dir"
trunk build --release
