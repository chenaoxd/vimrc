#!/usr/bin/env bash
set -euo pipefail

DATA_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim"
BLINK_DIR="${BLINK_DIR:-$DATA_DIR/lazy/blink.cmp}"
TARGET_DIR="$BLINK_DIR/target/release"

case "$(uname -s)" in
  Darwin)
    LIB_NAME="libblink_cmp_fuzzy.dylib"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    LIB_NAME="libblink_cmp_fuzzy.dll"
    ;;
  *)
    LIB_NAME="libblink_cmp_fuzzy.so"
    ;;
esac

DEFAULT_URL=""
if [ "$(uname -s)" = "Linux" ] && [ "$(uname -m)" = "x86_64" ]; then
  DEFAULT_URL="https://console.s3.chenaoxd.com/public/assets/x86_64-unknown-linux-gnu.so"
fi

DOWNLOAD_URL="${BLINK_DOWNLOAD_URL:-$DEFAULT_URL}"

if [ -z "$DOWNLOAD_URL" ]; then
  echo "No download URL configured for this platform."
  echo "Set BLINK_DOWNLOAD_URL to the libblink_cmp_fuzzy binary URL and rerun."
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  echo "curl not found"
  exit 1
fi

if [ ! -d "$BLINK_DIR" ]; then
  echo "blink.cmp is not installed at: $BLINK_DIR"
  echo "Run Neovim once or :Lazy sync first."
  exit 1
fi

TMP_DIR="$(mktemp -d "${TMPDIR:-/tmp}/blink-fuzzy.XXXXXX")"
TMP_LIB="$TMP_DIR/$LIB_NAME"

cleanup() {
  rm -rf "$TMP_DIR"
}

trap cleanup EXIT

mkdir -p "$TARGET_DIR"

echo "Downloading $LIB_NAME"
echo "Source: $DOWNLOAD_URL"

curl --fail --location --silent --show-error --retry 3 --retry-all-errors \
  --connect-timeout 10 --max-time 120 \
  --output "$TMP_LIB" \
  "$DOWNLOAD_URL"

install -m755 "$TMP_LIB" "$TARGET_DIR/$LIB_NAME"

# When no version file is present, blink.cmp treats the library as a manual install
# and uses it directly without trying to update it during startup.
rm -f "$TARGET_DIR/version" "$TARGET_DIR/$LIB_NAME.sha256"

echo "Installed: $TARGET_DIR/$LIB_NAME"
