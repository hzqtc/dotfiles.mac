#!/bin/bash

# Shorten a path by replace $HOME with '~'
echo "$1" | sed "s|^$HOME|~|"
