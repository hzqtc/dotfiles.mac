#!/usr/bin/env bash

if [ -z "$1" ]; then
  echo "Usage: $0 <path>" >&2
  exit 1
fi

input_path="$1"

# Replace $HOME with ~
if [[ "$input_path" == "$HOME"* ]]; then
  home_replaced="~${input_path#$HOME}"
else
  home_replaced="$input_path"
fi

IFS='/' read -ra parts <<< "$home_replaced"
shortened_path=""
last_index=$((${#parts[@]} - 1))

for i in "${!parts[@]}"; do
  part="${parts[i]}"

  if [[ -z "$part" ]]; then
    # Empty part means just a '/' (root or double slash)
    shortened_path+="/"
  elif [[ "$part" == "~" ]]; then
    shortened_path+="~/"
  elif [[ $i -eq $last_index ]]; then
    # Last part unchanged
    shortened_path+="$part"
  else
    # If starts with '.', take first 2 letters, else first letter + '/'
    if [[ "$part" == .* ]]; then
      shortened_path+="${part:0:2}/"
    else
      shortened_path+="${part:0:1}/"
    fi
  fi
done

# Remove trailing slash if it's not the root
[[ "$shortened_path" != "/" ]] && shortened_path="${shortened_path%/}"

echo "$shortened_path"
