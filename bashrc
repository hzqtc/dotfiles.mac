source ~/.aliasrc

eval "$(/opt/homebrew/bin/brew shellenv)"

view() {
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
      filetype=$(echo "$filetype" | tr '[:upper:]' '[:lower:]')
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

nvo() {
  nvr --remote "$@"
  open -a Neovide
}

copylast() {
  history | tail -n 2 | head -n 1 | sed 's/^[ ]*[0-9]*[ ]*//' | pbcopy
}

eval "$(zoxide init bash)"
eval "$(starship init bash)"
eval "$(fzf --bash)"
eval "$(nf-list --init bash)"

export LEDGER_FILE="/Users/hzqtc/Documents/hledger/hledger.journal"
export PAGER=moar
export EDITOR=nvim
export HOMEBREW_NO_AUTO_UPDATE=1
