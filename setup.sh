#!/bin/bash

# Arguments handling
task=( $1 $2 $3 $4 $5 $6 $7 $8 $9 )

# Get hosttype and default directories from .bashrc
source ./.bashrc 2> /dev/null

# set -e		    # exit if error
  set -u		    # error on undeclared variable
# set -o pipefail	# fail pipeline if any part fails
# set -euo pipefail

reminder="Remember to source .bashrc, exec bash -l, and gcloud init (if this is the first time run)"
# Disable all ssh password login, including root
# sudo vim /etc/ssh/sshd_config
# change the following lines to no 
#   ChallengeResponseAuthentication no
#   PasswordAuthentication no
#   UsePAM no
#   PermitRootLogin no
# sudo systemctl restart ssh

function createDirectories() {
    mkdir -pv $desktop
    mkdir -pv $downloads
}

function cloneDotfiles() {
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
    git clone git@github.com:lvnfg/dotfiles	    $dotfiles
}

function configureGit() {
    git config --global core.editor     "vim"
    git config --global user.name       "van"
    git config --global user.email      "-"
}

function linkDotfiles() {
    wdir="$desktop/dotfiles"
    rm -f ~/.bashrc     && ln -s $dotfiles/.bashrc	        ~/.bashrc
    rm -f ~/.profile    && ln -s $dotfiles/.bashrc          ~/.profile
    rm -f ~/.inputrc    && ln -s $dotfiles/.inputrc	        ~/.inputrc
    rm -f ~/.tmux.conf  && ln -s $dotfiles/.tmux.conf	    ~/.tmux.conf
    rm -f ~/.vimrc      && ln -s $dotfiles/.vimrc	        ~/.vimrc
    rm -f ~/.ssh/config && ln -s $dotfiles/.ssh/config	    ~/.ssh/config
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

function installNeovim() {
    vimpath=""
    if [[ "$hosttype" = mac ]]; then
        brew install --HEAD neovim
    elif [[ "$hosttype" = linux ]]; then
        sudo apt install neovim
    fi
    wdir="$HOME/.config/nvim"   
    mkdir -pv $wdir
    rm -f $wdir/init.vim && ln -s $dotfiles/init.vim $wdir/init.vim
}

function build() {
    docker build -t dev:latest .
}


# --------------------------------
# Actual setup scripts
# --------------------------------
function vm() {
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
    cloneDotfiles
    linkDotfiles
    echo $reminder
}

function upgradeBash() {
    # For macos only
    # Require homebrew
    brew install bash
    # Add to list of available shells
    sudo echo "/usr/local/bin/bash" >> /etc/shells
    # Set default shells
    chsh -s /usr/local/bin/bash
}

function mac() {
    xcode-select --install
    cloneDotfiles
    linkDotfiles
    homebrewurl="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
    /bin/bash -c "$(curl -fsSL $homebrewurl)" 
    brew doctor
    installNeovim
    brew install fzf
    brew install mas
    mas install 1107421413  # 1Blocker
    mas install 1333542190  # 1Password
    mas install 1295203466  # Microsoft remote desktop
    mas install 1153157709  # Speedtest
    mas install 425424353   # The Unarchiver
    mas install 1480933944  # Vimari
    brew cask install iterm2
    brew cask install visual-studio-code
    echo $reminder
}

# Allow calling functions by name from command line
"$@"
