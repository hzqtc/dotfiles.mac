#!/usr/bin/env bash

PARALLEL="/opt/homebrew/bin/parallel"
BREW_DUMP=false

# Parse arguments
for arg in "$@"; do
  case $arg in
  --brew-dump)
    BREW_DUMP=true
    ;;
  esac
done

# Export BREW_DUMP so it's available in the subshell started by parallel
export BREW_DUMP

process_entry() {
  remote_file_raw="$1"
  # Expand tilde and variables
  remote_file=$(eval echo "$remote_file_raw")

  if [ -f "$remote_file" ]; then
    if [[ "$remote_file" =~ \.Brewfile$ && "$BREW_DUMP" == true ]]; then
      brew bundle dump --global --describe --force 2>/dev/null
    fi
    local_file=${remote_file##*/}
    local_file=${local_file#.}
    echo "$remote_file_raw => $local_file"
    cp "$remote_file" "$local_file"
  elif [ -d "$remote_file" ]; then
    local_dir=${remote_file##*/}
    local_dir=${local_dir#.}
    echo "Copying content of $remote_file_raw => $local_dir/"
    mkdir -p "$local_dir"
    # Loop over items in directory. This is safer than parsing `ls`.
    for f_path in "$remote_file"/*; do
      f_name=$(basename "$f_path")
      echo "$f_path => $local_dir/$f_name"
      cp -R "$f_path" "$local_dir/"
    done
  else
    echo "Error: $remote_file_raw ($remote_file) does not exist!" >&2
  fi
}

# Export the function so parallel can use it
export -f process_entry

# Use GNU Parallel to run the processing function on each line of .dotfiles
# --line-buffer ensures that output from different jobs is not interleaved in the middle of a line
# --jobs 0 means as many jobs as CPU cores
$PARALLEL --line-buffer --jobs 0 process_entry {} <.dotfiles

