source ~/.aliasrc

/opt/homebrew/bin/brew shellenv | source

# Hide greeting message
set fish_greeting
# Use vi key bindings
set -g fish_key_bindings fish_vi_key_bindings

starship init fish | source
