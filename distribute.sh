#!/bin/bash

dotfiles=( \
~/.vimrc \
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
    name=${file##*/}
    name=${name#.}

    if [ -f $file ]
    then
        echo -n "Do you wish to copy $name to $file? [y/N]"
        read ans
        if [ "$ans" == "y" -o "$ans" == "Y" ]
        then
            echo "$name => $file"
            cp "$name" "$file"
        fi
    else
        echo "$name => $file"
        cp "$name" "$file"
    fi
done

