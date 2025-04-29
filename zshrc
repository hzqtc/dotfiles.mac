source ~/.aliasrc

eval "$(/opt/homebrew/bin/brew shellenv)"

bindkey -v

# Up and Down keys would search command history starting with the current prompt
autoload -U history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^[[A" history-beginning-search-backward-end
bindkey "^[[B" history-beginning-search-forward-end

autoload zmv

eval "$(starship init zsh)"

