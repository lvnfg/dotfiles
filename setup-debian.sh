#!/bin/bash
set -euo pipefail
echo 🚸 $0
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
sudo -E bash "$path/install-top.sh"
sudo -E bash "$path/install-bash.sh"
sudo -E bash "$path/install-tmux.sh"
sudo -E bash "$path/install-git.sh"
sudo -E bash "$path/install-bat.sh"
sudo -E bash "$path/install-ranger.sh"
sudo -E bash "$path/install-neovim.sh"

echo "✅ $0"
