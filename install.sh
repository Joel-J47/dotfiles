#!/bin/bash
# =============================================================================
# Fedora Dev Environment Setup
# Run once on a fresh Fedora install to get the full dev environment.
# =============================================================================
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "============================================="
echo "  Fedora Dev Environment Setup"
echo "============================================="
echo ""

# -----------------------------------------------------------------------------
# 1. DNF PACKAGES
# -----------------------------------------------------------------------------
echo ">>> Installing dnf packages..."

sudo dnf upgrade -y

sudo dnf install -y \
    zsh \
    git \
    curl \
    wget \
    bat \
    eza \
    fzf \
    jq \
    tree \
    make \
    gcc \
    gcc-c++ \
    aria2 \
    ffmpeg \
    mpv \
    ncat \
    net-tools \
    rclone \
    rsync \
    tailscale \
    postgresql \
    scrcpy \
    android-tools \
    figlet \
    p7zip \
    unzip \
    zip \
    xbindkeys \
    python3 \
    python3-pip \
    python3-venv \
    gh

# -----------------------------------------------------------------------------
# 2. ZSH AS DEFAULT SHELL
# -----------------------------------------------------------------------------
if [[ "$SHELL" != "$(which zsh)" ]]; then
    echo ">>> Setting zsh as default shell..."
    chsh -s "$(which zsh)"
fi

# -----------------------------------------------------------------------------
# 3. GIT-CLONED TOOLS
# -----------------------------------------------------------------------------
echo ">>> Cloning zsh plugins and theme..."

mkdir -p ~/.zsh

[[ ! -d ~/powerlevel10k ]] && \
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k

[[ ! -d ~/.zsh/zsh-autosuggestions ]] && \
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions

[[ ! -d ~/.zsh/zsh-syntax-highlighting ]] && \
    git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting

echo ">>> Installing fzf from git..."
[[ ! -d ~/.fzf ]] && git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all --no-bash --no-fish

# -----------------------------------------------------------------------------
# 4. FLUTTER
# -----------------------------------------------------------------------------
echo ">>> Installing Flutter..."
mkdir -p ~/development
if [[ ! -d ~/development/flutter ]]; then
    git clone https://github.com/flutter/flutter.git -b stable ~/development/flutter
fi
export PATH="$HOME/development/flutter/bin:$PATH"
flutter precache

# -----------------------------------------------------------------------------
# 5. NVM + NODE
# -----------------------------------------------------------------------------
echo ">>> Installing NVM..."
if [[ ! -d ~/.nvm ]]; then
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
fi

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

echo ">>> Installing Node LTS..."
nvm install --lts
nvm use --lts
nvm alias default 'lts/*'

# -----------------------------------------------------------------------------
# 6. DENO
# -----------------------------------------------------------------------------
echo ">>> Installing Deno..."
if ! command -v deno &>/dev/null; then
    curl -fsSL https://deno.land/install.sh | sh
fi

# -----------------------------------------------------------------------------
# 7. KUBECTL
# -----------------------------------------------------------------------------
echo ">>> Installing kubectl..."
if ! command -v kubectl &>/dev/null; then
    KUBECTL_VERSION=$(curl -fsSL https://dl.k8s.io/release/stable.txt)
    sudo curl -fsSLo /usr/local/bin/kubectl \
        "https://dl.k8s.io/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl"
    sudo chmod +x /usr/local/bin/kubectl
fi

# -----------------------------------------------------------------------------
# 8. HELM
# -----------------------------------------------------------------------------
echo ">>> Installing Helm..."
if ! command -v helm &>/dev/null; then
    curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# -----------------------------------------------------------------------------
# 9. YT-DLP
# -----------------------------------------------------------------------------
echo ">>> Installing yt-dlp..."
sudo curl -fsSLo /usr/local/bin/yt-dlp \
    "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp"
sudo chmod +x /usr/local/bin/yt-dlp

# -----------------------------------------------------------------------------
# 10. DOCKER
# -----------------------------------------------------------------------------
echo ">>> Installing Docker CE..."
if ! command -v docker &>/dev/null; then
    sudo dnf -y install dnf-plugins-core
    sudo dnf-3 config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
    sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo systemctl enable --now docker
    sudo usermod -aG docker "$USER"
    echo "    NOTE: Log out and back in for docker group to take effect."
fi

# -----------------------------------------------------------------------------
# 11. MESLO NERD FONT (for Powerlevel10k)
# -----------------------------------------------------------------------------
echo ">>> Installing MesloLGS NF font..."
mkdir -p ~/.local/share/fonts
FONT_DIR="$HOME/.local/share/fonts"
BASE_URL="https://github.com/romkatv/powerlevel10k-media/raw/master"

for font in "MesloLGS NF Regular" "MesloLGS NF Bold" "MesloLGS NF Italic" "MesloLGS NF Bold Italic"; do
    FILE="${font}.ttf"
    ENCODED="${FILE// /%20}"
    [[ ! -f "$FONT_DIR/$FILE" ]] && \
        curl -fsSLo "$FONT_DIR/$FILE" "${BASE_URL}/${ENCODED}"
done
fc-cache -fv

# -----------------------------------------------------------------------------
# 12. DOTFILES SYMLINKS
# -----------------------------------------------------------------------------
echo ">>> Linking dotfiles..."

# Shell
ln -sf "$DOTFILES_DIR/.zshrc" ~/.zshrc
ln -sf "$DOTFILES_DIR/.p10k.zsh" ~/.p10k.zsh

# Git
ln -sf "$DOTFILES_DIR/.gitconfig" ~/.gitconfig

# SSH config (hosts/aliases only — copy your keys manually)
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ln -sf "$DOTFILES_DIR/ssh_config" ~/.ssh/config
chmod 600 "$DOTFILES_DIR/ssh_config"

# Nuxt
ln -sf "$DOTFILES_DIR/.nuxtrc" ~/.nuxtrc

# mpv
mkdir -p ~/.config/mpv/scripts
ln -sf "$DOTFILES_DIR/mpv/mpv.conf" ~/.config/mpv/mpv.conf
ln -sf "$DOTFILES_DIR/mpv/input.conf" ~/.config/mpv/input.conf
ln -sf "$DOTFILES_DIR/mpv/scripts/autoload.lua" ~/.config/mpv/scripts/autoload.lua
ln -sf "$DOTFILES_DIR/mpv/scripts/recent.lua" ~/.config/mpv/scripts/recent.lua
ln -sf "$DOTFILES_DIR/mpv/scripts/simplehistory.lua" ~/.config/mpv/scripts/simplehistory.lua

# -----------------------------------------------------------------------------
# 13. ANDROID STUDIO
# -----------------------------------------------------------------------------
echo ">>> Android Studio — manual install required."
echo "    1. Download the Linux .tar.gz from:"
echo "       https://developer.android.com/studio"
echo "    2. Extract it:"
echo "       sudo tar -xzf android-studio-*.tar.gz -C /opt"
echo "    3. Launch once to complete SDK setup:"
echo "       /opt/android-studio/bin/studio"
echo "    Your zshrc already has the correct paths set:"
echo "       JAVA_HOME=/opt/android-studio/jbr"
echo "       ANDROID_HOME=~/Android/Sdk"

# -----------------------------------------------------------------------------
echo ""
echo "============================================="
echo "  Setup complete!"
echo ""
echo "  Next steps:"
echo "  1. Set your terminal font to: MesloLGS NF"
echo "  2. Log out and back in (for docker group + zsh default)"
echo "  3. Install Android Studio (see instructions above)"
echo "  4. Copy your SSH keys to ~/.ssh/ manually"
echo "  5. Open a new terminal — p10k config will load"
echo "     automatically from the symlinked ~/.p10k.zsh"
echo "============================================="
