#!/bin/bash

# Arguments handling
task=( $1 $2 $3 $4 $5 $6 $7 $8 $9 )

# set -e		    # exit if error
  set -u		    # error on undeclared variable
# set -o pipefail	# fail pipeline if any part fails
# set -euo pipefail

# Disable all ssh password login, including root
# sudo vim /etc/ssh/sshd_config
# change the following lines to no 
#   ChallengeResponseAuthentication no
#   PasswordAuthentication no
#   UsePAM no
#   PermitRootLogin no
# sudo systemctl restart ssh

desktop="$HOME/Desktop"
downloads="$HOME/Downloads"

function createDirectories() {
    mkdir -p $desktop
    mkdir -p $downloads
}

function cloneDotfilesRepo() {
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
    git clone git@github.com:lvnfg/dotfiles		$desktop/dotfiles
    git config --global core.editor     "vim"
    git config --global user.name       "van"
    git config --global user.email      "-"
}

function linkDotfiles() {
    sourceDir="$desktop/dotfiles"
    rm ~/.bashrc
    rm ~/.profile
    rm ~/.inputrc
    rm ~/.tmux.conf
    rm ~/.vimrc
    rm ~/.ssh/config
    rm -f ~/.bashrc     && ln -s sourceDir/.bashrc	    ~/.bashrc
    rm -f ~/.profile    && ln -s sourceDir/.bashrc      ~/.profile
    rm -f ~/.inputrc    && ln -s sourceDir/.inputrc	    ~/.inputrc
    rm -f ~/.tmux.conf  && ln -s sourceDir/.tmux.conf	~/.tmux.conf
    rm -f ~/.vimrc      && ln -s sourceDir/.vimrc	    ~/.vimrc
}

function linkSSH() {
    ln -s ~/repos/dotfiles/.ssh/config	~/.ssh/config
    chmod 600 ~/.ssh/config
}

function installDocker() {
    # Uninstall old versions
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo apt-get install -y \
        apt-transport-https \
        ca-certificates     \
        curl                \
        gnupg-agent         \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88   # Verify key downloaded with correct fingerprint
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    # Use docker cli without sudo
    sudo groupadd -f docker
    sudo usermod -aG docker $USER
    newgrp docker
}

function build() {
    docker build -t dev:latest .
}

# --------------------------------
# Actual setup scripts
# --------------------------------
if [[ ${task[0]} =~ vm ]]; then
	createDirectories
	sudo apt update 
	sudo apt upgrade -y
	sudo apt install -y \
	    vim     \
	    tmux    \
	    fzf     \
	    git     \
	    wget    \
	    unzip   \
	    curl
    cloneDotfilesRepo
    linkDotfiles
    echo 'Done. Remember to source .bashrc, exec bash -l, and gcloud init (if this is the first time run)'
fi

# Allow calling functions by name from command line
"$@"
