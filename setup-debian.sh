#!/bin/bash
echo 🚸 $0
set -euo pipefail
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
bash "$path/install-top.sh"
bash "$path/install-bash.sh"
bash "$path/install-tmux.sh"
bash "$path/install-git.sh"
bash "$path/install-bat.sh"
bash "$path/install-ranger.sh"
bash "$path/install-nvim.sh"
bash "$path/install-nvim-core-plugins.sh"
bash "$path/install-docker.sh"

echo "✅ $0"
