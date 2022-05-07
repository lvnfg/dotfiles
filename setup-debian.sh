#!/bin/bash

script_name=$0
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ln -s -f $path/bash/.bashrc       ~/.bashrc
ln -s -f $path/bash/.inputrc      ~/.inputrc
ln -s -f $path/bash/.bash_profile ~/.bash_profile
# ln -s -f $path/bash/.bashrc     ~/.profile       # .profile is reserved for env var, do not use
ln -s -f $path/bash/toprc         ~/.config/procps/toprc

# ----------------------------------------------
# PACKAGED UTILITIES
# ----------------------------------------------
sudo apt update && sudo apt upgrade -y
sudo apt install -y jq
sudo apt install -y wget
sudo apt install -y unzip
sudo apt install -y curl
sudo apt install -y fzf
sudo apt install -y rsync

source "$path/setup/install-git.sh"
source "$path/setup/install-bat.sh"
source "$path/vim/install-neovim.sh"
source "$path/tmux/install-tmux.sh"

# Allow calling functions by name from command line
"$@"
