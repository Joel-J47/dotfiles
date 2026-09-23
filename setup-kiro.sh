#!/bin/bash
# =============================================================================
# Kiro IDE Settings Setup
# Run after installing Kiro to restore settings from dotfiles.
# Usage: bash setup-kiro.sh
# =============================================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIRO_SETTINGS="$HOME/.kiro/settings"

echo ""
echo "============================================="
echo "  Kiro IDE Settings Setup"
echo "============================================="
echo ""

if ! command -v kiro &>/dev/null && [[ ! -f "$HOME/.local/bin/kiro-cli" ]]; then
    echo "Kiro does not appear to be installed."
    echo "Install it first, then re-run this script."
    exit 1
fi

echo ">>> Creating Kiro settings directory..."
mkdir -p "$KIRO_SETTINGS"

echo ">>> Linking Kiro settings..."
ln -sf "$DOTFILES_DIR/kiro/mcp.json" "$KIRO_SETTINGS/mcp.json"
ln -sf "$DOTFILES_DIR/kiro/permissions.yaml" "$KIRO_SETTINGS/permissions.yaml"
ln -sf "$DOTFILES_DIR/kiro/cli.json" "$KIRO_SETTINGS/cli.json"

echo ""
echo "============================================="
echo "  Done! Settings linked:"
echo "  - mcp.json        (MCP servers: dhis2-docs)"
echo "  - permissions.yaml (web_fetch, web_search)"
echo "  - cli.json         (notifications)"
echo ""
echo "  Restart Kiro for changes to take effect."
echo "============================================="
