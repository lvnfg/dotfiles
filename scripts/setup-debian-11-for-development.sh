#!/bin/bash

script_name=$0
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source .bashrc to get core directories' location
source ~/repos/dotfiles/.bashrc

# ----------------------------------------------
# PACKAGED UTILITIES
# ----------------------------------------------
sudo apt update && sudo apt upgrade -y
sudo apt install -y jq
sudo apt install -y tmux
sudo apt install -y wget
sudo apt install -y unzip
sudo apt install -y curl
sudo apt install -y bash-completion
sudo apt install -y tree
sudo apt install -y fzf

# ----------------------------------------------
# DOTFILES SYMLINKS
# ----------------------------------------------
bash "$path/install-dotfiles-symlinks.sh"

# ----------------------------------------------
# GIT
# ----------------------------------------------
bash "$path/install-git.sh"

# ----------------------------------------------
# NEOVIM
# ----------------------------------------------
bash "$path/install-neovim.sh"
# bash "$path/install-nodejs.sh"

# ----------------------------------------------
# RANGER
# ----------------------------------------------
sudo apt install ranger
# Symlink ranger config
mkdir ~/.config/ranger
ln -s -f $DOTFILES/rc.conf	    ~/.config/ranger/rc.conf
ln -s -f $DOTFILES/scope.sh	    ~/.config/ranger/scope.sh
# Make scope.sh executable for ranger
chmod +x $DOTFILES/scope.sh

# Install bat for syntax highlighting. Last version is 0.18.2
# while Debian only has 0.12.1 even in testing. Switch to apt
# later when available.
bash "$path/install-bat.sh"

# ----------------------------------------------
# PYTHON AND DEPENDENT PACKAGES
# ----------------------------------------------
# Install python and dependent packages
bash "$path/install-python.sh"
sudo ln -s -f /usr/local/bin/python3 /usr/bin/python

# Pynvim for nvim's python plugins
# pip3 install pynvim

# Allow calling functions by name from command line
"$@"
