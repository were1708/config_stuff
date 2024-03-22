# Set theme
ZSH_THEME="milktea"

# Path to oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh

# Path to dotfiles
export DOTFILES=$HOME/.dotfiles

# Language environment
export LC_ALL=en_US.utf-8
export LANG="$LC_ALL"

# remember for weird lang bugs do `sudo locale-gen en_US.UTF-8`

# Set editor for local/remote
export EDITOR='nvim'

# Automatically update oh-my-zsh
export UPDATE_ZSH_DAYS=14

# Set zsh directory under zsh directory
ZSH_CUSTOM=zsh

# Source oh-my-zsh
source $ZSH/oh-my-zsh.sh

# Don't autocd.
unsetopt autocd

# Custom keybindings.
bindkey '^F' autosuggest-accept
bindkey ' ' magic-space
bindkey '^L' forward-char
bindkey '^H' backward-char

alias la='ls -A'
alias ll='ls -lA'
alias vi='nvim'
alias vim='nvim'
alias cat='batcat'
alias gs='git status'
alias cmatrix='cmatrix -s'
alias postgres_ucsc='psql -h cse180-db.lt.ucsc.edu -U jtrevill'

# Show TODOs.
if [ -x "$(command -v task)" &> /dev/null ]; then
    task list
fi

[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh
[ -f "$HOME/.cargo/env" ] && source $HOME/.cargo/env
[ -f "$HOME/.ghcup/env" ] && source $HOME/.ghcup/env

# Source plugin manager
export ZPLUG_HOME=$HOME/.zplug
source $ZPLUG_HOME/init.zsh

# Plugins
zplug "wfxr/forgit", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2
zplug "zsh-users/zsh-autosuggestions", defer:2

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Load the plugins last
zplug load

# Make command green and bold
ZSH_HIGHLIGHT_STYLES[arg0]=fg=green,bold


