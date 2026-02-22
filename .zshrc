# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000000
SAVEHIST=1000
setopt notify
setopt autocd
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/joel/.zshrc'

autoload -Uz compinit
compinit
# Case-insensitive tab completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# --- OS DETECTION ---
if [[ -d "/data/data/com.termux" ]]; then
    # Settings for NATIVE Termux
    alias cat="bat --paging=never"
    alias update="pkg update && pkg upgrade"
    # P10k full path in Termux
    P10K_THEME="$HOME/powerlevel10k/powerlevel10k.zsh
else
    # Settings for Pop!_OS or Proot Ubuntu
    alias cat="batcat --paging=never"
    alias update="sudo apt update && sudo apt upgrade -y"
    P10K_THEME="$HOME/powerlevel10k/powerlevel10k.zsh-theme"
fi    
    
# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias h="cd ~"

# Git (Essential for dev work)
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gl="git log --oneline --graph --all"
#alias cat="batcat --paging=never"

# System Maintenance
#alias update="sudo apt update && sudo apt upgrade -y"
alias cls="clear"
#alias ls="ls --color=auto --group-directories-first"
#alias ll="ls -lah"
alias ls='eza --icons --group-directories-first'
alias ll='eza -lah --icons --group-directories-first'
#Global
alias -g G="| grep"
alias -g L="| less"
alias -g H="| head"

#Scripts
alias adl='/mnt/win_ssd/Users/JOEL/Downloads/Video/animepahe-dl-master/animepahe-dl.sh -o jpn -t 40'

# End of lines added by compinstall
source ~/powerlevel10k/powerlevel10k.zsh-theme
source ~/powerlevel10k/powerlevel10k.zsh-theme

# Plugins
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
#source <(fzf --zsh)
export FZF_DEFAULT_OPTS="--preview 'batcat --color=always --style=numbers --line-range=:500 {}'"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh