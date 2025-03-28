#!/bin/bash

# Change this path to the directory where your init.vim is located
VIM_DIR="$HOME/.config/nvim"

# Change to the directory
cd "$VIM_DIR" || { echo "Directory not found"; exit 1; }

# Open init.vim with nvim
nvim init.vim

