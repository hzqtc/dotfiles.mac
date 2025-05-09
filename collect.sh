#!/bin/bash

dotfiles=(\
~/.vimrc \
~/.zshrc \
~/.aliasrc \
~/.gitconfig \
~/.gitignore \
~/.config/fish/config.fish \
~/.tmux.conf \
~/.sysinfo.sh \
~/.Brewfile \
"$HOME/Library/Application Support/organize/config.yaml")

for file in "${dotfiles[@]}"
do
  if [ -f "$file" ]; then
    if [[ "$file" =~ ".Brewfile" ]]; then
      echo "Updating $file"
      brew bundle dump --global --describe --force 2>/dev/null
    fi
    name=${file##*/}
    name=${name#.}
    echo "$file => $name"
    cp "$file" "$name"
  else
    echo "Error: $file does not exist!"
  fi
done

# Dump python tools installed by UV to a file
echo "Updating uv.tool"
uv tool list > uv.tool 2>/dev/null

