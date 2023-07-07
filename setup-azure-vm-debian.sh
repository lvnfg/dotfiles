#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install utilities
sudo apt update && sudo apt upgrade -y
sudo apt install -y wget
sudo apt install -y unzip
sudo apt install -y curl
sudo apt install -y fzf
sudo apt install -y ripgrep     # Required for fzf.vim search all files
sudo apt install -y rsync       # Sync files with mac

# Use -H option to keep $HOME as user
bash "$path/install-top-config.sh"
bash "$path/install-bash-config.sh"

# Tmux
sudo apt-get install tmux -y
bash "$path/install-tmux-config.sh"

# Git
sudo apt-get install git -y
bash "$path/install-git-config.sh"

# Bat
# sudo apt-get install bat -y
# bash "$path/install-bat-config.sh"

# Ranger
sudo apt-get install ranger -y 
bash "$path/install-ranger-config.sh"

# Nvim
sudo apt-get install neovim -y
bash "$path/install-nvim-config-and-plugins.sh"

# Disable password login. This should be default on Azure VM Debian 10 Gen 1 image.
# Open sshd_config for edit:
#   sudo vim /etc/ssh/sshd_config
#
# Set the following:
#     PubkeyAuthentication yes            # Default commented out. Important, will not be able to log back in if not enabled
#     UsePAM yes                          # Default. May disable pubkey authen if set to no, keep yes for the moment
#     PasswordAuthentication no           # Default
#     PermitEmptyPasswords no             # Default
#     PermitRootLogin no                  # Not found in Azure Debian 10 Gen 1 image's sshd
#     ChallengeResponseAuthentication no
#
# Restart ssh service
#   sudo service sshd restart
