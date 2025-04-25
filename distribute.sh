#!/bin/bash

dotfiles=( ~/.vimrc ~/.zshrc ~/.aliasrc ~/.gitconfig ~/.config/fish/config.fish )

for file in ${dotfiles[*]}
do
    name=${file##*/}
    name=${name#.}

    if [ -f $file ]
    then
        echo "$name => $file"
        cp "$name" "$file"
    else
        echo -n "Do you wish to copy $name to $file? [y/N]"
        read ans
        if [ "$ans" == "y" -o "$ans" == "Y" ]
        then
            echo "$name => $file"
            cp "$name" "$file"
        fi
    fi
done

