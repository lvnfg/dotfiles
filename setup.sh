#!/bin/bash
# Get hosttype and base locations from .bashrc
source "$PWD/.bashrc" # 2> /dev/null

# Skip this part if restoring from a snapshot marked as -fresh.
# These are the steps that must be done manually when:
#   - Setting up a new mac
#   - Creating a new VM and login for the first time
#  When the steps are done, create a snapshot and mark -fres.
function freshSetup() {
    mkdir -pv ~/repos && cd ~/repos
    sudo apt install git -y
    git clone git@github.com:lvnfg/dotfiles
    cd ~/repos/dotfiles && bash setup.sh linkDotfiles   # Must be execute in directory
    source ~/.bashrc
    # Password login should be disabled by default on Azure Debian 10 Gen 1 image.
    # If not, disable password root login by editing sshd_config:
    # sudo vim /etc/ssh/sshd_config
    # change the following lines to:
    #   PubkeyAuthentication yes            # Default commented out. Important, will not be able to log back in if not enabled
    #   UsePAM yes                          # Default. May disable pubkey authen if set to no, keep yes for the moment
    #   PasswordAuthentication no           # Default
    #   PermitEmptyPasswords no             # Default 
    #   PermitRootLogin no                  # Not found in Azure Debian 10 Gen 1 image's sshd
    #   ChallengeResponseAuthentication no  # Default
    # Restart ssh services to put the new settings into effect:
    # sudo service sshd restart
}

# Skip this part if restoring from a snapshot marked as -fresh-desktop
function installDesktop() {
    # Install a desktop environment and configure remote desktop access
    # https://docs.microsoft.com/en-us/azure/virtual-machines/linux/use-remote-desktop
    # XFCE desktop environment
    sudo apt install -y xfce4
    # Remote desktop server
    sudo apt-get -y install xrdp
    sudo systemctl enable xrdp
    # Use XFCE for remote desktop session
    echo xfce4-session >~/.xsession
    # Create a password for the current user to login to xrdp
    sudo passwd van
    # Install firefox ESR (Extended Support Release)
    sudo apt install firefox-esr 
    # Remember to open port 3389 on network security group.
    # Peformance improvements for remote desktop:
    #   Set wallpaper style to none
    #   Turn off compositing to improve rdp performance
    #   xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s false      # Must be run in desktop env. True to activate agin
}

# If restoring from a fresh snapshot:
function restoreFromFresh() {
    cd $dotfiles
    git pull
    bash setup.sh linkDotfiles
    source ~/.bashrc
    exec bash -l
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
    linkDotfiles
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
    configureGit
}

function setupMac() {
    linkDotfiles
    xcode-select --install
    configureGit
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
    mas install 425424353   # The Unarchiver
    brew cask install iterm2
    brew cask install visual-studio-code
    # vscode & azure data studio vim key repeat
    defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false 
    defaults write com.azuredatastudio.oss ApplePressAndHoldEnabled -bool false
}

# Allow calling functions by name from command line
"$@"
