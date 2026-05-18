#!/usr/bin/env bash
set -Eeuo pipefail

clone_or_fetch() {
  local repo_url="$1"
  local repo_dir="$2"

  if [ ! -d "$repo_dir/.git" ]; then
    git clone "$repo_url" "$repo_dir"
  else
    git -C "$repo_dir" remote set-url origin "$repo_url"
    git -C "$repo_dir" fetch --tags --prune --force origin
  fi
}

checkout_tag() {
  local repo_dir="$1"
  local tag="$2"

  git -C "$repo_dir" fetch --tags --prune --force origin
  git -C "$repo_dir" checkout --detach "refs/tags/$tag"
}

checkout_branch() {
  local repo_dir="$1"
  local branch="$2"

  git -C "$repo_dir" fetch --tags --prune --force origin "$branch"
  git -C "$repo_dir" checkout "$branch"
  git -C "$repo_dir" reset --hard "origin/$branch"
}

load_nvm() {
  : "${NVM_DIR:?NVM_DIR is required}"
  # shellcheck source=/dev/null
  source "$NVM_DIR/nvm.sh"
}

use_node_from_nvmrc() {
  local repo_dir="$1"
  local node_version

  node_version="$(cat "$repo_dir/.nvmrc")"
  nvm install "$node_version"
  nvm use "$node_version"
}

print_proxy_env() {
  printf 'HTTP_PROXY=%s\n' "${HTTP_PROXY:-}"
  printf 'HTTPS_PROXY=%s\n' "${HTTPS_PROXY:-}"
  printf 'ALL_PROXY=%s\n' "${ALL_PROXY:-}"
}
