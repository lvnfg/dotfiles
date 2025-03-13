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
bash "$path/link-top-config.sh"
bash "$path/link-bash-config.sh"

# Tmux
sudo apt-get install tmux -y
bash "$path/link-tmux-config.sh"

# Git
sudo apt-get install git -y
bash "$path/link-git-config.sh"

# Bat
# sudo apt-get install bat -y
# bash "$path/install-bat-config.sh"

# Ranger
sudo apt-get install ranger -y
bash "$path/link-ranger-config.sh"

# Nvim
sudo apt-get install neovim -y
bash "$path/link-nvim-config.sh"
echo "Installing nvim plugins"
PLUGDIR="$HOME/.local/share/nvim/site/pack/plugins/start"
mkdir -p $PLUGDIR
cd $PLUGDIR
git clone --depth 1 https://github.com/lvnfg/fzf            || true && cd fzf            && git pull && git checkout d7daf5f
git clone --depth 1 https://github.com/lvnfg/fzf.vim        || true && cd fzf.vim        && git pull && git checkout dc71692
git clone --depth 1 https://github.com/lvnfg/vim-gitgutter  || true && cd vim-gitgutter  && git pull && git checkout ded1194
git clone --depth 1 https://github.com/lvnfg/vim-easy-align || true && cd vim-easy-align && git pull && git checkout 9815a55

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
