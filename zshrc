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

  if [[ -z "$file" ]]; then
    echo "view: no file specified"
    return 1
  fi

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
      filetype=${filetype:l}
      case "$filetype" in
        *json*)
          jless "$file"
          ;;
        *csv*)
          tw "$file"
          ;;
        *text*)
          bat "$file"
          ;;
        *)
          hexyl "$file"
          ;;
      esac
      ;;
  esac
}

function nvo() {
  nvr --remote "$@"
  open -a Neovide
}

function copylast() {
  fc -ln -1 | pbcopy
}

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
source <(fzf --zsh)
source <(nf-list --init zsh)

export LEDGER_FILE="/Users/hzqtc/Code/hledger/hledger.journal"
export PAGER=moar
export EDITOR=nvim
export HOMEBREW_NO_AUTO_UPDATE=1

