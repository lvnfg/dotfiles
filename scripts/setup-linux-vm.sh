#!/bin/bash

script_name=$0
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source .bashrc to get core directories' location
source ~/repos/dotfiles/.bashrc

# Install apps from packages managers
sudo apt update && sudo apt upgrade -y
sudo apt install -y jq
sudo apt install -y tmux
sudo apt install -y wget
sudo apt install -y unzip
sudo apt install -y curl
sudo apt install -y bash-completion
sudo apt install -y tree

# Symlink dotfiles
ln -s -f $DOTFILES/.bashrc	    ~/.bashrc
ln -s -f $DOTFILES/.bashrc	    ~/.profile
ln -s -f $DOTFILES/.inputrc	    ~/.inputrc
ln -s -f $DOTFILES/.tmux.conf   ~/.tmux.conf
ln -s -f $DOTFILES/.vimrc	    ~/.vimrc
ln -s -f $DOTFILES/rc.conf	    ~/.config/ranger/rc.conf
ln -s -f $DOTFILES/scope.sh	    ~/.config/ranger/scope.sh

# Make scope.sh executable for ranger
chmod $DOTFILES/scope.sh

# Install apps not available from apt
# Use source to use the same bash process and share variables
source "$path/install-git.sh"
source "$path/install-fzf.sh"
source "$path/install-bat.sh"       # Switch to using apt when available for Debian
source "$path/install-neovim.sh"
source "$path/install-nodejs.sh"
source "$path/install-python.sh"
source "$path/install-netcore.sh"
source "$path/install-azure-cli.sh"
source "$path/install-azure-functions.sh"

# Allow calling functions by name from command line
"$@"
