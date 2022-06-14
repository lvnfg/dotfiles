#!/bin/bash
set -euo pipefail

script_name=$0
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

sudo apt update && sudo apt upgrade -y
sudo apt install -y jq
sudo apt install -y wget
sudo apt install -y unzip
sudo apt install -y curl
sudo apt install -y fzf
sudo apt install -y rsync
sudo apt install -y ripgrep     # Required for fzf.vim search all files

# Use -H option to keep $HOME as user
sudo -H bash "$path/top/install-top.sh"
sudo -H bash "$path/bash/install-bash.sh"
sudo -H bash "$path/tmux/install-tmux.sh"
sudo -H bash "$path/install-git.sh"
sudo -H bash "$path/install-bat.sh"
sudo -H bash "$path/vim/install-neovim.sh"
sudo -H bash "$path/ranger/install-ranger.sh"

echo "-------------------------------------"
echo "DEBIAN SETUP SUCCESFUL"
echo "-------------------------------------"

# Allow calling functions by name from command line
"$@"
