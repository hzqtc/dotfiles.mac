#!/bin/bash

dotfiles=(~/.vimrc \
~/.zshrc \
~/.aliasrc \
~/.gitconfig \
~/.gitignore \
~/.config/fish/config.fish \
~/.tmux.conf \
~/.sysinfo.sh \
~/.Brewfile)

for file in ${dotfiles[*]}
do
    if [ -f $file ]
    then
      if [[ $file =~ ".Brewfile" ]]; then
        echo "Updating $file"
        brew bundle dump --global --describe --force
      fi
        name=${file##*/}
        name=${name#.}
        echo "$file => $name"
        cp "$file" "$name"
    fi
done

