#!/bin/bash
# =============================================================================
# Kiro IDE Settings + Extensions Setup
# Run after installing Kiro to restore settings and extensions from dotfiles.
#
# Usage:
#   bash setup-kiro.sh                        # settings only
#   bash setup-kiro.sh --copy-ext <host>      # copy extensions from another machine over SSH
#                                             # e.g. bash setup-kiro.sh --copy-ext poppy
# =============================================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
KIRO_SETTINGS="$HOME/.kiro/settings"

echo ""
echo "============================================="
echo "  Kiro IDE Settings Setup"
echo "============================================="
echo ""

if ! command -v kiro &>/dev/null; then
    echo "Kiro does not appear to be installed."
    echo "Install it first, then re-run this script."
    exit 1
fi

# -----------------------------------------------------------------------------
# 1. SETTINGS
# -----------------------------------------------------------------------------
echo ">>> Linking Kiro settings..."
mkdir -p "$KIRO_SETTINGS"

ln -sf "$DOTFILES_DIR/kiro/mcp.json" "$KIRO_SETTINGS/mcp.json"
ln -sf "$DOTFILES_DIR/kiro/permissions.yaml" "$KIRO_SETTINGS/permissions.yaml"
ln -sf "$DOTFILES_DIR/kiro/cli.json" "$KIRO_SETTINGS/cli.json"

echo "    Settings linked."

# -----------------------------------------------------------------------------
# 2. EXTENSIONS
# -----------------------------------------------------------------------------
if [[ "$1" == "--copy-ext" && -n "$2" ]]; then
    SOURCE_HOST="$2"
    echo ">>> Copying extensions from $SOURCE_HOST..."
    mkdir -p "$HOME/.kiro/extensions"
    rsync -az --progress "$SOURCE_HOST:~/.kiro/extensions/" "$HOME/.kiro/extensions/"
    echo "    Extensions copied."
else
    echo ""
    echo "  Skipping extensions copy."
    echo "  To copy extensions from your other machine, run:"
    echo "    bash setup-kiro.sh --copy-ext <hostname>"
    echo "  e.g:"
    echo "    bash setup-kiro.sh --copy-ext poppy"
    echo ""
    echo "  Or copy manually:"
    echo "    rsync -az user@poppy:~/.kiro/extensions/ ~/.kiro/extensions/"
fi

# -----------------------------------------------------------------------------
echo ""
echo "============================================="
echo "  Done! Restart Kiro for changes to take effect."
echo "============================================="
