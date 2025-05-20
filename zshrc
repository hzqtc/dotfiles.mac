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

function view() {
  local file="$1"

  if [[ ! -f "$file" ]]; then
    echo "view: file not found: $file"
    return 1
  fi

  case "$file" in
    *.json)
      jless "$file"
      ;;
    *.md|*.markdown)
      glow -p "$file"
      ;;
    *.csv)
      tw "$file"
      ;;
    *)
      local filetype=$(file --brief "$file")
      if [[ "$filetype" == *"text"* ]]; then
        bat "$file"
      else
        hexyl "$file"
      fi
      ;;
  esac
}

eval "$(starship init zsh)"

export LEDGER_FILE="/Users/hzqtc/Documents/hledger/hledger.journal"
export PAGER=moar
export EDITOR=nvim
export HOMEBREW_NO_AUTO_UPDATE=1

