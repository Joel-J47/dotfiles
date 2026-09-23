# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# History
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000
setopt notify
setopt autocd

# Completion
zstyle :compinstall filename '$HOME/.zshrc'
autoload -Uz compinit
compinit
# Case-insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# --- OS DETECTION ---
if [[ -n "$TERMUX_VERSION" ]]; then
    # Native Termux
    OS_TYPE="termux"
elif [[ -d "/data/data/com.termux" ]]; then
    # Proot inside Termux
    OS_TYPE="proot"
elif grep -qi "fedora" /etc/os-release 2>/dev/null; then
    OS_TYPE="fedora"
else
    # Default: Debian/Ubuntu
    OS_TYPE="ubuntu"
fi

# OS-specific aliases
case "$OS_TYPE" in
    termux|proot)
        alias cat="bat --paging=never"
        alias update="pkg update && pkg upgrade -y"
        ;;
    fedora)
        alias cat="bat --paging=never"
        alias update="sudo dnf upgrade -y"
        ;;
    ubuntu)
        alias cat="batcat --paging=never"
        alias update="sudo apt update && sudo apt upgrade -y"
        ;;
esac

# --- NAVIGATION ---
alias ..="cd .."
alias ...="cd ../.."
alias h="cd ~"

# --- GIT ---
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline --graph --all"

# --- SYSTEM ---
alias cls="clear"
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'

# --- GLOBAL PIPE ALIASES ---
alias -g G="| grep"
alias -g L="| less"
alias -g H="| head"

# --- GIT SHORTCUTS ---
alias ghkeys='curl -s https://github.com/Joel-J47.keys >> ~/.ssh/authorized_keys'

# --- MISC TOOLS ---
alias gparted='sudo -E gparted'
alias appu='~/bin/update-apps.sh'

# --- YT-DLP ---
alias yt="noglob yt-dlp -f \"bestvideo[height=1080][vcodec^=av01]+bestaudio[acodec=opus]/bestvideo[height=1080][vcodec^=vp9]+bestaudio[acodec=opus]/bestvideo[height=1080]+bestaudio/bestvideo+bestaudio\" --merge-output-format mkv -N 4 -o \"%(title)s.%(ext)s\" --restrict-filenames"

# --- TAILSCALE ---
alias tstart='sudo systemctl start tailscaled && sudo tailscale up'
alias tquit='sudo tailscale down && sudo systemctl stop tailscaled'
alias tstats='tailscale status'
tnet() { sudo tailscale logout && sudo tailscale up --login-server="${1:-https://controlplane.tailscale.com}"; }

# --- TERMINAL CHAT ---
alias msg='ncat -l 1234 --broker --chat & ncat localhost 1234'
alias kmsg='fuser -k 1234/tcp'

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"

# --- ANDROID / JAVA ---
export JAVA_HOME="/opt/android-studio/jbr"
export ANDROID_HOME="$HOME/Android/Sdk"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$PATH"
export CAPACITOR_ANDROID_STUDIO_PATH=/opt/android-studio/bin/studio

# --- FLUTTER ---
export PATH="$HOME/development/flutter/bin:$PATH"

# --- NVM ---
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# --- DENO ---
[ -f "$HOME/.deno/env" ] && . "$HOME/.deno/env"

# --- FZF ---
export FZF_DEFAULT_OPTS="--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# --- ZSH PLUGINS ---
[[ -f ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh ]] && source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]] && source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- POWERLEVEL10K ---
[[ -f ~/powerlevel10k/powerlevel10k.zsh-theme ]] && source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# --- KIRO SHELL INTEGRATION (desktop only) ---
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)" 2>/dev/null
