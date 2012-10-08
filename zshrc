export PATH="/usr/local/bin:/bin:/usr/bin:/usr/sbin"
export EDITOR=vim

export HISTFILE=~/.zsh_history
export HISTSIZE=10000
export SAVEHIST=10000

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

# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line

# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix

autoload -U compinit
compinit

autoload -U promptinit
promptinit
prompt walters
