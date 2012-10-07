#!/bin/bash

dotfiles=( ~/.vimrc ~/.zshrc ~/.aliasrc ~/.gitconfig ~/.vimperatorrc )

for file in ${dotfiles[*]}
do
    if [ -f $file ]
    then
        name=${file##*/}
        name=${name#.}
        echo "$file => $name"
        cp "$file" "$name"
    fi
done

