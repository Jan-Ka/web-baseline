#!/usr/bin/env sh
# This script registers the Claude Code MCP servers github and context7 for
# this project. The registration holds no token. It names `task mcp:headers`
# as the headers helper. Claude Code runs that command on every connection,
# with the project directory as working directory, and the helper reads the
# tokens from .env at that moment (see scripts/mcp-headers.sh).
# Claude Code stores the registration in its project-local config under the
# user profile, not in this repository.
# Task runs this script in its embedded POSIX shell on every OS. Use shell
# builtins and the claude command only.

set -eu

if [ ! -f .env ]; then
  echo "[x] .env not found. Copy .env.example to .env and fill in the values, or run: task setup:secrets"
  exit 1
fi

if ! command -v claude >/dev/null 2>&1; then
  echo "[x] claude is not installed. Run: task check:prereqs"
  exit 1
fi

# Remove an existing registration first. An older registration may still hold
# static headers with a token in them. `claude mcp remove` exits non-zero when
# the server is absent. Ignore that.
claude mcp remove github   >/dev/null 2>&1 || true
claude mcp remove context7 >/dev/null 2>&1 || true

helper="task mcp:headers"

claude mcp add-json github   "{\"type\":\"http\",\"url\":\"https://api.githubcopilot.com/mcp\",\"headersHelper\":\"${helper}\"}"
echo "[+] MCP server github registered"

claude mcp add-json context7 "{\"type\":\"http\",\"url\":\"https://mcp.context7.com/mcp\",\"headersHelper\":\"${helper}\"}"
echo "[+] MCP server context7 registered"

echo ""
echo "MCP servers registered for this project. Tokens stay in .env."
