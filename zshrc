export PATH="/usr/local/bin:/bin:/usr/bin:/sbin:/usr/sbin:/usr/local/share/npm/bin"
export EDITOR=vim

export HISTFILE=~/.zsh_history
export HISTSIZE=1000
export SAVEHIST=1000

setopt AUTO_LIST
setopt AUTO_MENU
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS

source ~/.aliasrc

bindkey -v

bindkey "\e[1~" beginning-of-line
bindkey "\e[2~" insert-last-word
bindkey "\e[3~" delete-char
bindkey "\e[4~" end-of-line
bindkey "\e[5~" backward-word
bindkey "\e[6~" forward-word
bindkey "\e[A"	up-line-or-search
bindkey "\e[B"	down-line-or-search
bindkey "\e[C"	forward-char
bindkey "\e[D"	backward-char

bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

autoload -U compinit
compinit

autoload -U promptinit
promptinit

autoload -U colors
colors

autoload zmv

PROMPT="%{$fg[yellow]%}%n%{$reset_color%} %# "
RPROMPT="%{$fg[green]%}%~%{$reset_color%} [%{$fg[red]%}%?%{$reset_color%}]"
RPROMPT2=""
