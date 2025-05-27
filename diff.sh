#!/bin/bash

if [ $# -eq 0 ]; then
  echo "Usage: $0 [filename]"
  exit 1
fi

target="$1"

if [ ! -f "$target" ]; then
  echo "Error: $target not found!"
  exit 1
fi

# Locate the original dot file that corresponds to "$target"
while IFS= read -r file; do
  file=$(eval echo $file)
  if [ -f "$file" ]; then
    name=${file##*/}
    name=${name#.}
    if [[ "$name" == "$target" ]]; then
      nvim -d "$file" "$target"
      exit 0
    fi
  elif [ -d "$file" ]; then
    dir=${file##*/}
    dir=${dir#.}
    for f in $(ls "$file"); do
      if [[ "$dir/$f" == "$target" ]]; then
        nvim -d "$file/$f" "$target"
      exit 0
      fi
    done
  else
    echo "Error: $file does not exist!"
  fi
done < .dotfiles

echo "Error: original of $target not found!"
