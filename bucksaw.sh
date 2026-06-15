#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=build-common.sh
source "$SCRIPT_DIR/build-common.sh"

print_proxy_env
printf 'BUCKSAW_REF=%s\n' "${BUCKSAW_REF:-}"

repo_dir="/opt/bucksaw"
patched_blackbox_log_dir="/opt/blackbox-log-0.4.2-patched"

clone_or_fetch "https://github.com/KoffeinFlummi/bucksaw.git" "$repo_dir"

if [ -n "${BUCKSAW_REF:-}" ]; then
  git -C "$repo_dir" fetch --tags --prune --force origin
  git -C "$repo_dir" checkout "$BUCKSAW_REF"
fi

cd "$repo_dir"

cargo fetch --locked

if ! grep -q 'blackbox-log = { path = "../blackbox-log-0.4.2-patched" }' Cargo.toml; then
  blackbox_log_src="$(find "${CARGO_HOME:-/root/.cargo}/registry/src" -type d -path '*/blackbox-log-0.4.2' | head -n 1)"
  if [ -z "$blackbox_log_src" ]; then
    echo "blackbox-log 0.4.2 source not found after cargo fetch" >&2
    exit 1
  fi

  rm -rf "$patched_blackbox_log_dir"
  cp -a "$blackbox_log_src" "$patched_blackbox_log_dir"
  patch -d "$patched_blackbox_log_dir" -p1 < "$SCRIPT_DIR/bucksaw-blackbox-log-2026.patch"

  cat >> Cargo.toml <<'EOF'

[patch.crates-io]
blackbox-log = { path = "../blackbox-log-0.4.2-patched" }
EOF
fi

disable_service_worker() {
  rm -f dist/sw.js

  if [ -f dist/index.html ]; then
    sed -i "s|navigator.serviceWorker.register('sw.js');|navigator.serviceWorker.getRegistrations().then((registrations) => registrations.forEach((registration) => registration.unregister()));|" dist/index.html
  fi
}

for attempt in 1 2 3; do
  if trunk build --release; then
    disable_service_worker
    exit 0
  fi

  echo "trunk build failed on attempt $attempt" >&2
  sleep $((attempt * 5))
done

exit 1
