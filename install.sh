#!/bin/bash

echo "Starting Dotfiles Installation..."

# 1. Detect Environment and Install Packages
if [[ -d "/data/data/com.termux" ]]; then
    echo "Detected Termux Environment"
    pkg update && pkg upgrade -y
    pkg install git zsh bat eza fzf -y
else
    echo "Detected Linux (Pop!_OS / Ubuntu / Proot)"
    sudo apt update
    sudo apt install git zsh bat eza fzf -y
fi

# 2. Setup Plugin Directories
mkdir -p ~/.zsh

# 3. Clone Powerlevel10k and Plugins if they don't exist
[[ ! -d ~/powerlevel10k ]] && git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
[[ ! -d ~/.zsh/zsh-autosuggestions ]] && git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
[[ ! -d ~/.zsh/zsh-syntax-highlighting ]] && git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

# 4. Create Symbolic Links (Points ~/.zshrc to our git folder)
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh

echo "Installation Complete! Type 'zsh' to enter your new shell."
