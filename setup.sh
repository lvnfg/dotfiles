#!/bin/bash

# Arguments handling
task=( $1 $2 $3 $4 $5 $6 $7 $8 $9 )

# Define base environment variables
hosttype=""
unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     hosttype=linux;;
    Darwin*)    hosttype=mac;;
    CYGWIN*)    hosttype=cygwin;;
    MINGW*)     hosttype=MinGw;;
    *)          hosttype="UNKNOWN:${unameOut}"
esac
desktop="$HOME/Desktop"
documents="$HOME/Documents"
downloads="$HOME/Downloads"
repos="$HOME/repos"
core="$repos/core"
dotfiles="$core/dotfiles"
defaultEditor="vim"
if [[ "$hosttype" = mac ]]; then
    defaultEditor="nvim"
fi

# DO NOT ENABLE ANY OF THESE FLAGS IN MAIN BODY
# TO AVOID ERRORS WHEN SOURCING FROM .bashrc
# set -e		    # exit if error
# set -u		    # error on undeclared variable
# set -o pipefail	# fail pipeline if any part fails
# set -euo pipefail

reminder="Remember to source .bashrc, exec bash -l, and az login / gcloud init (if this is the first time run)"
# Disable all ssh password login, including root
# sudo vim /etc/ssh/sshd_config
# change the following lines to no 
#   ChallengeResponseAuthentication no
#   PasswordAuthentication no
#   UsePAM no
#   PermitRootLogin no
# sudo systemctl restart ssh

function createDirectories() {
    mkdir -pv $repos
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
    git config --global format.graph
    gitFormatFull="%C(auto)%h %d%Creset %s - %Cgreen%ad%Creset %aN <%aE>"
    gitFormatShort="%C(auto)%h %d%Creset %s>"
    gitFormatString="$gitFormatShort"
    git config --global format.pretty format:"$gitFormatString"
}

function linkDotfiles() {

    wdir="$desktop/dotfiles"
    rm -f ~/.bashrc     && ln -s $dotfiles/.bashrc	        ~/.bashrc
    rm -f ~/.profile    && ln -s $dotfiles/.bashrc          ~/.profile
    rm -f ~/.inputrc    && ln -s $dotfiles/.inputrc	        ~/.inputrc
    rm -f ~/.tmux.conf  && ln -s $dotfiles/.tmux.conf	    ~/.tmux.conf
    rm -f ~/.vimrc      && ln -s $dotfiles/.vimrc	        ~/.vimrc
	
	# install vim-plug
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	# run PlugInstall in the background
    vim -es -u vimrc -i NONE -c "PlugInstall" -c "qa"
    
    # nvim config
    wdir="$HOME/.config/nvim"   
    mkdir -pv $wdir
    rm -f $wdir/init.vim && ln -s $dotfiles/init.vim $wdir/init.vim

    # host files config
    if [[ "$hosttype" = mac ]]; then
        rm -f ~/.ssh/config && ln -s $dotfiles/.ssh/config	    ~/.ssh/config
        chmod 600 ~/.ssh/config
    fi
}

function installNeovim() {
    vimpath=""
    if [[ "$hosttype" = mac ]]; then
        brew install --HEAD neovim
    elif [[ "$hosttype" = linux ]]; then
        sudo apt install neovim
    fi
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

function buildDevImage() {
    docker build -t dev:latest .
}


# --------------------------------
# Actual setup scripts
# DO NOT INSTALL AZ CLI IN VM
# Infra should be managed in core
# --------------------------------
function setupVM() {
	createDirectories
	sudo apt update 
	sudo apt upgrade -y
	sudo apt install -y jq
	sudo apt install -y vim
	sudo apt install -y tmux
	sudo apt install -y fzf
	sudo apt install -y git
	sudo apt install -y wget
	sudo apt install -y unzip
	sudo apt install -y curl
	sudo apt install -y bash-completion
    cloneDotfiles
    linkDotfiles
    configureGit
    buildDevImage
    echo $reminder
}

function setupMac() {
    xcode-select --install
    configureGit
    cloneDotfiles
    linkDotfiles
    homebrewurl="https://raw.githubusercontent.com/Homebrew/install/master/install.sh"
    /bin/bash -c "$(curl -fsSL $homebrewurl)" 
    brew doctor
    installNeovim
    brew install jq
    brew install fzf
    brew install mas
    brew install azure-cli
    brew install coreutils
    brew install bash-completion
    mas install 1107421413  # 1Blocker
    mas install 1333542190  # 1Password
    mas install 405399194   # Kindle
    mas install 1295203466  # Microsoft remote desktop
    mas install 1153157709  # Speedtest
    mas install 425424353   # The Unarchiver
    mas install 1480933944  # Vimari
    brew cask install iterm2
    brew cask install visual-studio-code
    # vscode & azure data studio vim key repeat
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false 
    defaults write com.azuredatastudio.oss ApplePressAndHoldEnabled -bool false
    echo $reminder
}

# Allow calling functions by name from command line
"$@"
