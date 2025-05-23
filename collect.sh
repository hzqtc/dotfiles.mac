#!/bin/bash

# Read file on descriptor 3 instead of stdin
# This way `read ans` would not be affected by the content in the file
while IFS= read -r file <&3; do
  file=$(eval echo $file)
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
done 3< .dotfiles

# Dump python tools installed by UV to a file
echo "Updating uv.tool"
uv tool list > uv.tool 2>/dev/null

