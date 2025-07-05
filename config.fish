source ~/.aliasrc

/opt/homebrew/bin/brew shellenv | source

# Hide greeting message
set fish_greeting
# Use vi key bindings
set -g fish_key_bindings fish_vi_key_bindings

function view
  set file $argv[1]

  if test -z "$file"
    echo "view: no file specified"
    return 1
  end
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
      tw "$file"
    case '*'
      set filetype (file --brief "$file")
      set filetype (string lower "$filetype")
      switch "$filetype"
        case '*json*'
          jless "$file"
        case '*csv*'
          tw "$file"
        case '*text*'
          bat "$file"
        case '*'
          # Fall back to binary format
          hexyl "$file"
      end
  end
end

function nvo
  nvr --remote $argv
  open -a Neovide
end

function copylast
    history --max=1 | pbcopy
end

zoxide init fish | source
starship init fish | source

set -gx LEDGER_FILE /Users/hzqtc/Documents/hledger/hledger.journal
set -gx PAGER moar
set -gx EDITOR nvim
set -gx HOMEBREW_NO_AUTO_UPDATE 1

