#!/usr/bin/env bash
set -Eeuo pipefail

: "${BETAFLIGHT_BRANCH:?BETAFLIGHT_BRANCH is required}"
: "${BETAFLIGHT_VERSION:?BETAFLIGHT_VERSION is required}"
: "${BETAFLIGHT_FW_TARGET:?BETAFLIGHT_FW_TARGET is required}"

repo_dir="/opt/betaflight"

if [ ! -d "$repo_dir/.git" ]; then
  git clone https://github.com/betaflight/betaflight.git "$repo_dir"
else
  git -C "$repo_dir" remote set-url origin https://github.com/betaflight/betaflight.git
  git -C "$repo_dir" fetch --tags --prune --force origin
fi

git -C "$repo_dir" fetch --tags --prune --force origin "$BETAFLIGHT_BRANCH"
git -C "$repo_dir" checkout --detach "refs/tags/$BETAFLIGHT_VERSION"

cd "$repo_dir"

make clean

make configs

if ! make arm_sdk_install; then
  rm -rf "$repo_dir/downloads"
  make arm_sdk_install
fi

make "$BETAFLIGHT_FW_TARGET" EXTRA_FLAGS="-D'RELEASE_NAME=$BETAFLIGHT_VERSION' ${BETAFLIGHT_FW_EXTRA_FLAGS:-}" -j

cp "$repo_dir"/obj/*.hex /fw/

echo
printf 'HTTP_PROXY=%s\n' "${HTTP_PROXY:-}"
printf 'HTTPS_PROXY=%s\n' "${HTTPS_PROXY:-}"
printf 'ALL_PROXY=%s\n' "${ALL_PROXY:-}"
printf 'BETAFLIGHT_BRANCH=%s\n' "$BETAFLIGHT_BRANCH"
printf 'BETAFLIGHT_VERSION=%s\n' "$BETAFLIGHT_VERSION"
printf 'BETAFLIGHT_FW_TARGET=%s\n' "$BETAFLIGHT_FW_TARGET"
printf 'BETAFLIGHT_FW_EXTRA_FLAGS=%s\n' "${BETAFLIGHT_FW_EXTRA_FLAGS:-}"
