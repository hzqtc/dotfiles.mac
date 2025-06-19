#!/usr/bin/env bash

copy_to_destination() {
  local remote_file="$1"
  local local_file="$2"

  echo "Copy '$local_file' => '$remote_file'"
  if [ -d "$local_file" ]; then
    # Append '/' when copying directories
    [[ "$local_file" != */ ]] && local_file="$local_file/"
    cp -R "$local_file" "$remote_file"
  else
    cp "$local_file" "$remote_file"

    if [[ "$local_file" == "Brewfile" ]]; then
      echo -n "Run 'brew bundle' based on $local_file? [y/N] "
      read ans
      if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
        brew bundle
      fi
    fi
  fi
}

# Read file on descriptor 3 instead of stdin
# This way 'read ans' would not be affected by the content from the file
while IFS= read -r remote_file <&3; do
  remote_file=$(eval echo $remote_file)
  local_file=${remote_file##*/}
  local_file=${local_file#.}

  if [ ! -e "$local_file" ]; then
    echo "Error: local backup of $remote_file not found"
    continue
  fi

  if [ -e "$remote_file" ]; then
    echo -n "Override '$remote_file' with '$local_file'? [y/N] "
    read ans
    if [[ "$ans" == "y" || "$ans" == "Y" ]]; then
      copy_to_destination "$remote_file" "$local_file"
    fi
  else
    copy_to_destination "$remote_file" "$local_file"
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

