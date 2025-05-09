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

confirm_and_copy() {
  local question="$1"
  local file="$2"
  local name="$3"

  echo -n "$question [y/N] "
  read ans
  if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
    echo "$name => $file"
    cp "$name" "$file"

    if [[ "$name" == "Brewfile" ]]; then
      echo -n "Run 'brew bundle' based on $name? [y/N] "
      read ans
      if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        brew bundle
      fi
    fi
  fi
}

for file in "${dotfiles[@]}"
do
  name=${file##*/}
  name=${name#.}

  if [ ! -f "$name" ]; then
    echo "Error: $name doesn't exist"
    continue
  fi

  if [ -f "$file" ]; then
    confirm_and_copy "Override $file with $name?" "$file" "$name"
  else
    confirm_and_copy "Copy $name to $file?" "$file" "$name"
  fi
done

# Read uv.tool on file descriptor 3 instead of stdin
# This way `read ans` would not be affected by the content in the file
while IFS= read -r line <&3; do
  if [[ $line =~ ^([a-z-]+)\ v[0-9]+ ]]; then
    uv_tool=${BASH_REMATCH[1]}
    echo -n "Install the uv tool: $uv_tool? [y/N] "
    read ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
      uv tool install $uv_tool
    fi
  fi
done 3< uv.tool

