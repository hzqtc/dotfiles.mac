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

# Use xan to view csv files
function cat() {
  for file in "$@"; do
    if [[ "$file" == *.csv ]]; then
      xan view -pAR "$file"
    else
      command bat "$file"
    fi
  done
}

eval "$(starship init zsh)"

export LEDGER_FILE="/Users/hzqtc/Documents/hledger/hledger.journal"
export EDITOR=vim
