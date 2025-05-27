source ~/.aliasrc

/opt/homebrew/bin/brew shellenv | source

# Hide greeting message
set fish_greeting
# Use vi key bindings
set -g fish_key_bindings fish_vi_key_bindings

function view
  set file $argv[1]

  if not test -f "$file"
    echo "view: file not found: $file"
    return 1
  end

  switch "$file"
    case '*.json'
      jless "$file"
    case '*.md' '*.markdown'
      glow -p "$file"
    case '*.csv'
      tw --theme catppuccin "$file"
    case '*'
      set filetype (file --brief "$file")
      if string match -q '*text*' "$filetype"
        bat "$file"
      else
        hexyl "$file"
      end
  end
end

starship init fish | source

set -gx LEDGER_FILE /Users/hzqtc/Documents/hledger/hledger.journal
set -gx PAGER moar
set -gx EDITOR nvim
set -gx HOMEBREW_NO_AUTO_UPDATE 1

