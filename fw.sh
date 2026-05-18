#!/usr/bin/env bash
set -Eeuo pipefail

: "${BETAFLIGHT_BRANCH:?BETAFLIGHT_BRANCH is required}"
: "${BETAFLIGHT_FW_TARGET:?BETAFLIGHT_FW_TARGET is required}"

repo_dir="/opt/betaflight"
release_name="${BETAFLIGHT_VERSION:-master}"
source_ref="branch:$BETAFLIGHT_BRANCH"

if [ ! -d "$repo_dir/.git" ]; then
  git clone https://github.com/betaflight/betaflight.git "$repo_dir"
else
  git -C "$repo_dir" remote set-url origin https://github.com/betaflight/betaflight.git
  git -C "$repo_dir" fetch --tags --prune --force origin
fi

if [ "$BETAFLIGHT_BRANCH" = "master" ]; then
  git -C "$repo_dir" fetch --prune --force origin master
  git -C "$repo_dir" checkout -B master origin/master
  release_name="master"
else
  : "${BETAFLIGHT_VERSION:?BETAFLIGHT_VERSION is required unless BETAFLIGHT_BRANCH=master}"
  git -C "$repo_dir" fetch --tags --prune --force origin "$BETAFLIGHT_BRANCH"
  git -C "$repo_dir" checkout --detach "refs/tags/$BETAFLIGHT_VERSION"
  release_name="$BETAFLIGHT_VERSION"
  source_ref="tag:$BETAFLIGHT_VERSION"
fi

cd "$repo_dir"

make clean

make configs

if ! make arm_sdk_install; then
  rm -rf "$repo_dir/downloads"
  make arm_sdk_install
fi

make "$BETAFLIGHT_FW_TARGET" EXTRA_FLAGS="-D'RELEASE_NAME=$release_name' ${BETAFLIGHT_FW_EXTRA_FLAGS:-}" -j

cp "$repo_dir"/obj/*.hex /fw/

echo
printf 'HTTP_PROXY=%s\n' "${HTTP_PROXY:-}"
printf 'HTTPS_PROXY=%s\n' "${HTTPS_PROXY:-}"
printf 'ALL_PROXY=%s\n' "${ALL_PROXY:-}"
printf 'BETAFLIGHT_BRANCH=%s\n' "$BETAFLIGHT_BRANCH"
printf 'BETAFLIGHT_SOURCE=%s\n' "$source_ref"
printf 'BETAFLIGHT_VERSION=%s\n' "${BETAFLIGHT_VERSION:-ignored}"
printf 'RELEASE_NAME=%s\n' "$release_name"
printf 'BETAFLIGHT_FW_TARGET=%s\n' "$BETAFLIGHT_FW_TARGET"
printf 'BETAFLIGHT_FW_EXTRA_FLAGS=%s\n' "${BETAFLIGHT_FW_EXTRA_FLAGS:-}"
