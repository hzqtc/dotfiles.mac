#!/bin/bash

copy_to_destination() {
  local file="$1"
  local name="$2"

  echo "$name => $file"
  cp "$name" "$file"

  if [[ "$name" == "Brewfile" ]]; then
    echo -n "Run 'brew bundle' based on $name? [y/N] "
    read ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
      brew bundle
    fi
  fi
}

# Read file on descriptor 3 instead of stdin
# This way `read ans` would not be affected by the content in the file
while IFS= read -r file <&3; do
  file=$(eval echo $file)
  name=${file##*/}
  name=${name#.}

  if [ ! -f "$name" ]; then
    echo "Error: $name doesn't exist"
    continue
  fi

  if [ -f "$file" ]; then
    echo -n "Override $file with $name? [y/N] "
    read ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
      copy_to_destination "$file" "$name"
    fi
  else
    copy_to_destination "$file" "$name"
  fi
done 3< .dotfiles

echo -n "Install uv tools? [y/N] "
read ans
if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
  while IFS= read -r line <&3; do
    if [[ $line =~ ^([a-z-]+)\ v[0-9]+ ]]; then
      uv_tool=${BASH_REMATCH[1]}
      echo "Installing uv tool: $uv_tool"
      uv tool install $uv_tool
    fi
  done 3< uv.tool
fi

