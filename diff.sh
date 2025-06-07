#!/usr/bin/env bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 [filename]"
  exit 1
fi

target="$1"

if [ ! -f "$target" ]; then
  echo "Error: $target not found!"
  exit 1
fi

if command -v difft >/dev/null 2>&1; then
  diff_tool=(difft --display side-by-side-show-both)
elif command -v nvim >/dev/null 2>&1; then
  diff_tool=(nvim -d)
else
  diff_tool=(vim -d)
fi

while IFS= read -r file; do
  file="${file/#\~/$HOME}"
  if [ -f "$file" ]; then
    name="${file##*/}"
    name="${name#.}"
    if [[ "$name" == "$target" ]]; then
      "${diff_tool[@]}" "$file" "$target"
      exit 0
    fi
  elif [ -d "$file" ]; then
    dir="${file##*/}"
    dir="${dir#.}"
    for f in "$file"/*; do
      f_name=$(basename "$f")
      if [[ "$dir/$f_name" == "$target" ]]; then
        "${diff_tool[@]}" "$f" "$target"
        exit 0
      fi
    done
  else
    echo "Error: $file does not exist!"
  fi
done < .dotfiles

echo "Error: original of $target not found!"
