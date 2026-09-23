#!/bin/bash
# =============================================================================
# Kiro IDE Settings + Extensions Setup
# Run after installing Kiro to restore settings and extensions from dotfiles.
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

# -----------------------------------------------------------------------------
# 2. EXTENSIONS
# -----------------------------------------------------------------------------
echo ">>> Installing extensions..."

EXTENSIONS=(
    charliermarsh.ruff
    coenraads.bracket-pair-colorizer-2
    dart-code.dart-code
    dart-code.flutter
    eamodio.gitlens
    esbenp.prettier-vscode
    github.vscode-github-actions
    github.vscode-pull-request-github
    jeanp413.open-remote-ssh
    jeroen-meijer.pubspec-assist
    mechatroner.rainbow-csv
    ms-python.debugpy
    ms-python.python
    ms-python.vscode-python-envs
    nash.awesome-flutter-snippets
    ritwickdey.liveserver
    usernamehw.errorlens
)

for ext in "${EXTENSIONS[@]}"; do
    echo "  Installing $ext..."
    kiro --install-extension "$ext" 2>/dev/null && echo "  ✓ $ext" || echo "  ✗ $ext (skipped or already installed)"
done

# -----------------------------------------------------------------------------
echo ""
echo "============================================="
echo "  Done!"
echo "  - Settings linked (mcp, permissions, cli)"
echo "  - ${#EXTENSIONS[@]} extensions installed"
echo ""
echo "  Restart Kiro for changes to take effect."
echo "============================================="
