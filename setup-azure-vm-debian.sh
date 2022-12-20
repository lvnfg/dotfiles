#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Install utilities
sudo apt update && sudo apt upgrade -y
sudo apt install -y jq
sudo apt install -y wget
sudo apt install -y unzip
sudo apt install -y curl
sudo apt install -y fzf
sudo apt install -y rsync
sudo apt install -y ripgrep     # Required for fzf.vim search all files
# sudo apt install -y build-essential

# Use -H option to keep $HOME as user
bash "$path/install-top.sh"
bash "$path/install-bash.sh"
bash "$path/install-tmux.sh"
bash "$path/install-git.sh"
bash "$path/install-bat.sh"
bash "$path/install-ranger.sh"
bash "$path/install-nvim.sh"

#-------- # Install docker
#-------- bash "$path/install-docker.sh"
#-------- # Set docker data location to temporary drive
#-------- sudo systemctl stop docker
#-------- sudo systemctl stop docker.socket
#-------- sudo systemctl stop containerd
#-------- mkdir /mnt/docker
#-------- sudo mv /var/lib/docker /mnt/docker
#-------- sudo cp -f "$path/docker/daemon.json" /etc/docker
#-------- sudo systemctl start docker
#-------- sudo docker info -f '{{ .DockerRootDir}}'
