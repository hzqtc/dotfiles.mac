#!/usr/bin/env bash

BREW_DUMP=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --brew-dump)
      BREW_DUMP=true
      ;;
  esac
done

# Read file on descriptor 3 instead of stdin
# This way `read ans` would not be affected by the content in the file
while IFS= read -r remote_file <&3; do
  remote_file=$(eval echo $remote_file)
  if [ -f "$remote_file" ]; then
    if [[ "$remote_file" =~ ".Brewfile" && "$BREW_DUMP" == true ]]; then
      echo "Updating $remote_file"
      brew bundle dump --global --describe --force 2>/dev/null
    fi
    local_file=${remote_file##*/}
    local_file=${local_file#.}
    echo "$remote_file => $local_file"
    cp "$remote_file" "$local_file"
  elif [ -d "$remote_file" ]; then
    dir=${remote_file##*/}
    dir=${dir#.}
    echo "Copying all files in $dir"
    if [ ! -d "$dir" ]; then
      mkdir "$dir"
    fi
    for f in $(ls "$remote_file"); do
      echo "$remote_file/$f => $dir/$f"
      cp "$remote_file/$f" "$dir/$r"
    done
  else
    echo "Error: $remote_file does not exist!"
  fi
done 3< .dotfiles

# Dump python tools installed by UV to a file
echo "Updating uv.tool"
uv tool list > uv.tool 2>/dev/null

