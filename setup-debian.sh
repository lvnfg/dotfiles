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

bash "$path/top/install-top.sh"
bash "$path/top/install-bash.sh"
bash "$path/tmux/install-tmux.sh"
bash "$path/setup/install-git.sh"
bash "$path/setup/install-bat.sh"
bash "$path/vim/install-neovim.sh"

echo "Setup successful"
# Allow calling functions by name from command line
"$@"
