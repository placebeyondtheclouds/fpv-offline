#!/usr/bin/env bash
set -Eeuo pipefail

export DISPLAY="${DISPLAY:-:0}"
export HOME="${HOME:-/home/elrs}"
export VNC_PORT="${VNC_PORT:-5900}"
export SCREEN_WIDTH="${SCREEN_WIDTH:-1600}"
export SCREEN_HEIGHT="${SCREEN_HEIGHT:-900}"
export SCREEN_DEPTH="${SCREEN_DEPTH:-24}"
export VNC_PASSWORD="${VNC_PASSWORD:-change-me-now}"

DISPLAY_NUMBER="${DISPLAY#:}"
X_LOCK="/tmp/.X${DISPLAY_NUMBER}-lock"
X_SOCKET="/tmp/.X11-unix/X${DISPLAY_NUMBER}"

XVFB_PID=""
OPENBOX_PID=""
VNC_PID=""
APP_PID=""

mkdir -p \
  "$HOME/.vnc" \
  "$HOME/.config/openbox" \
  /tmp/.X11-unix

chmod 1777 /tmp/.X11-unix

x11vnc \
  -storepasswd "$VNC_PASSWORD" "$HOME/.vnc/passwd" \
  >/dev/null

chmod 600 "$HOME/.vnc/passwd"

cleanup() {
  local exit_code=$?

  trap - EXIT INT TERM

  for pid in "$APP_PID" "$VNC_PID" "$OPENBOX_PID" "$XVFB_PID"; do
    if [[ -n "$pid" ]] && kill -0 "$pid" 2>/dev/null; then
      kill "$pid" 2>/dev/null || true
    fi
  done

  wait 2>/dev/null || true

  rm -f "$X_LOCK" "$X_SOCKET"

  exit "$exit_code"
}

trap cleanup EXIT INT TERM

# A normal Docker restart preserves files in the container writable layer.
# Remove the X lock/socket only when no live process owns the display.
if [[ -f "$X_LOCK" ]]; then
  existing_pid="$(tr -d '[:space:]' < "$X_LOCK" 2>/dev/null || true)"

  if [[ -n "$existing_pid" ]] && kill -0 "$existing_pid" 2>/dev/null; then
    echo "ERROR: display $DISPLAY is already owned by PID $existing_pid" >&2
    exit 1
  fi

  echo "Removing stale X lock $X_LOCK"
  rm -f "$X_LOCK" "$X_SOCKET"
elif [[ -e "$X_SOCKET" ]]; then
  echo "Removing stale X socket $X_SOCKET"
  rm -f "$X_SOCKET"
fi

echo "Starting Xvfb on $DISPLAY"

Xvfb "$DISPLAY" \
  -screen 0 "${SCREEN_WIDTH}x${SCREEN_HEIGHT}x${SCREEN_DEPTH}" \
  -nolisten tcp \
  -ac \
  +extension GLX \
  +render \
  -noreset &

XVFB_PID=$!

display_ready=false

for _ in $(seq 1 100); do
  if xdpyinfo -display "$DISPLAY" >/dev/null 2>&1; then
    display_ready=true
    break
  fi

  if ! kill -0 "$XVFB_PID" 2>/dev/null; then
    echo "ERROR: Xvfb exited before $DISPLAY became available" >&2
    wait "$XVFB_PID"
    exit 1
  fi

  sleep 0.1
done

if [[ "$display_ready" != true ]]; then
  echo "ERROR: timed out waiting for X display $DISPLAY" >&2
  exit 1
fi

echo "Starting Openbox"

dbus-run-session -- openbox-session &
OPENBOX_PID=$!

echo "Starting x11vnc on port $VNC_PORT"

x11vnc \
  -display "$DISPLAY" \
  -rfbport "$VNC_PORT" \
  -rfbauth "$HOME/.vnc/passwd" \
  -forever \
  -shared \
  -noxdamage \
  -repeat \
  -xkb &

VNC_PID=$!

if [[ ! -d /opt/elrs ]]; then
  echo "ERROR: /opt/elrs does not exist" >&2
  exit 1
fi

if [[ ! -f /opt/elrs/package.json ]]; then
  echo "ERROR: /opt/elrs/package.json does not exist" >&2
  echo "Contents of /opt/elrs:" >&2
  ls -la /opt/elrs >&2 || true
  echo >&2
  echo "Mounted filesystems:" >&2
  mount >&2 || true
  exit 1
fi

cd /opt/elrs

echo "Starting ELRS Configurator"

yarn start &
APP_PID=$!

wait "$APP_PID"

