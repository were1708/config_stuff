# Set theme
ZSH_THEME="milktea"

# Path to oh-my-zsh installation
export ZSH=$HOME/.oh-my-zsh
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

alias la='exa -a'
alias ll='exa -l'
alias ls='exa'
alias lt='exa --tree'
alias vi='nvim'
alias vim='nvim'
alias gs='git status'
alias cat='batcat'
alias viconfig='vi ~/.config/nvim/init.lua'
alias edit='nvim $(fzf --preview="cat {}")'
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

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux attach || tmux new
fi

# Fuzzy find history
source <(fzf --zsh)
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

fortune | cowsay

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
