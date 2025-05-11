source ~/.aliasrc

/opt/homebrew/bin/brew shellenv | source

# Hide greeting message
set fish_greeting
# Use vi key bindings
set -g fish_key_bindings fish_vi_key_bindings

# Use xan to view csv files
function cat
  for file in $argv
    if test (string match -r '.*\.csv$' $file)
      xan view -pAR $file
    else
      command bat $file
    end
  end
end

starship init fish | source

set -gx LEDGER_FILE /Users/hzqtc/Documents/hledger/hledger.journal
set -gx EDITOR vim
