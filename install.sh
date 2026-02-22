#!/bin/bash

echo "Starting Dotfiles Installation..."

# 1. Detect Environment
if [[ -d "/data/data/com.termux" && -z "$PREFIX" ]]; then
    # This logic handles Proot (where /data/... exists but we aren't in native termux shell)
    echo "Detected Proot Linux"
    apt update && apt install git zsh bat eza fzf -y
elif [[ -n "$TERMUX_VERSION" || -d "/data/data/com.termux" ]]; then
    echo "Detected Native Termux"
    pkg update && pkg upgrade -y
    pkg install git zsh bat eza fzf -y
else
    echo "Detected Pop!_OS / Desktop Linux"
    sudo apt update && sudo apt install git zsh bat eza fzf -y
fi

# 2. Setup Plugins (Same as before)
mkdir -p ~/.zsh
[[ ! -d ~/powerlevel10k ]] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
[[ ! -d ~/.zsh/zsh-autosuggestions ]] && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
[[ ! -d ~/.zsh/zsh-syntax-highlighting ]] && git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

# 3. Links
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

echo "Done! Restarting shell..."