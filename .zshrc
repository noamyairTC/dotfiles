## Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

## Set theme
ZSH_THEME="mytheme"

## Use case-sensitive completion.
CASE_SENSITIVE="true"

## Disable auto-update checks.
DISABLE_AUTO_UPDATE="true"

## Display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

## Plugins
plugins=(
  git
  zsh-syntax-highlighting
  zsh-autosuggestions
  command-not-found
)

## Source Oh My Zsh
source $ZSH/oh-my-zsh.sh

## Set LANG
export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

## Set auto suggest color
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan"
source $ZSH/plugins/history-substring-search/history-substring-search.zsh

## Bind incremental search keys
bindkey "^[OA" up-line-or-beginning-search
bindkey "^[OB" down-line-or-beginning-search
bindkey -M vicmd "k" up-line-or-beginning-search
bindkey -M vicmd "j" down-line-or-beginning-search

bindkey -M viins 'jk' vi-cmd-mode
bindkey "^?" backward-delete-char

precmd() {
    export VIMODE=insert
}
zle-keymap-select() {
    if [[ $KEYMAP = vicmd ]]; then
        VIMODE=normal
    else
        VIMODE=insert
    fi

    zle reset-prompt
}
zle -N zle-keymap-select

## Edit command in editor
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
