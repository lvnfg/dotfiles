#!/bin/bash

script_name=$0
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source .bashrc to get core directories' location
source ~/repos/dotfiles/.bashrc

source "$path/install-dotfiles-symlinks.sh"

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

source "$path/install-git.sh"
source "$path/install-neovim.sh"
source "$path/install-bat.sh"

# Allow calling functions by name from command line
"$@"
