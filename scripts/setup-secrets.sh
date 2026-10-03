#!/usr/bin/env sh
# This script writes .env from .env.1password. The 1Password CLI resolves every
# op:// value. Literal values pass through unchanged.
#
# 1Password is optional. When .env.1password does not exist and .env does, the
# script keeps .env and exits with success. When neither exists, it explains
# both ways to create .env.
#
# Task runs this script in its embedded POSIX shell on every OS. Use shell
# builtins and the op command only.
#
# Set SETUP_VERBOSE=1 to see the raw 1Password error when a lookup fails. The
# default output hides it, because the error repeats the vault and item name.

set -eu

# Only the current user may read .env and the partial file. umask is not a
# builtin in the embedded shell of Task, so the call may fail there. chmod then
# does the same job on Unix. On Windows the user profile protects the file.
umask 077 2>/dev/null || true
restrict() {
  command -v chmod >/dev/null 2>&1 && chmod 600 "$1" 2>/dev/null || true
}

if [ ! -f .env.1password ]; then
  if [ -f .env ]; then
    restrict .env
    echo "[+] .env found. 1Password is not used."
    exit 0
  fi
  echo "[x] Neither .env nor .env.1password exists. Create one of them:"
  echo "    - By hand: copy .env.example to .env. Fill in the values."
  echo "    - With 1Password: copy .env.example to .env.1password. Replace each empty"
  echo "      value with an op://<vault>/<item>/<field> reference. Run this task again."
  echo "    .gitignore covers both files."
  exit 1
fi

if ! command -v op >/dev/null 2>&1; then
  echo "[x] .env.1password exists, but the 1Password CLI (op) is not installed."
  echo "    Install it (task check:prereqs shows how), or write .env by hand from"
  echo "    .env.example and delete .env.1password."
  exit 1
fi

# This checks that the 1Password CLI has an account. It does not check for an
# active session on purpose. With the desktop app integration `op whoami`
# reports "not signed in" while `op read` still works, because the app
# authorizes each read. A read failure below prints the sign-in hint.
if ! op account list >/dev/null 2>&1; then
  echo "[x] The 1Password CLI has no account on this device. Run: op signin"
  exit 1
fi

TMPENV=".env.partial"
rm -f "$TMPENV"
trap 'rm -f "$TMPENV"' EXIT
: > "$TMPENV"
restrict "$TMPENV"

CR=$(printf '\r')

while IFS= read -r line || [ -n "$line" ]; do
  line="${line%"$CR"}"
  case "$line" in
    ""|\#*) continue ;;
  esac
  KEY="${line%%=*}"
  VALUE="${line#*=}"
  VALUE="${VALUE%\"}"
  VALUE="${VALUE#\"}"

  case "$VALUE" in
    op://*)
      if [ "${SETUP_VERBOSE:-0}" = "1" ]; then
        RESOLVED=$(op read "$VALUE") || RESOLVED=""
      else
        RESOLVED=$(op read "$VALUE" 2>/dev/null) || RESOLVED=""
      fi
      if [ -z "$RESOLVED" ]; then
        echo "[x] Failed to resolve $KEY."
        echo "    Check that the op:// reference in .env.1password points to an existing"
        echo "    item, and that you are signed in to the right 1Password account."
        echo "    Without the desktop app integration, run: op signin"
        echo "    Run with SETUP_VERBOSE=1 to see the 1Password error."
        exit 1
      fi
      printf '%s=%s\n' "$KEY" "$RESOLVED" >> "$TMPENV"
      echo "[+] $KEY (resolved from 1Password)"
      ;;
    *)
      printf '%s=%s\n' "$KEY" "$VALUE" >> "$TMPENV"
      echo "[+] $KEY (literal)"
      ;;
  esac
done < .env.1password

mv "$TMPENV" .env
echo ""
echo "Secrets written to .env"
