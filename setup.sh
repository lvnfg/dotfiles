#!/bin/bash
# Get hosttype and base locations from .bashrc
source "$PWD/.bashrc" # 2> /dev/null

function freshSetup() {
    # Skip this part if restoring from a snapshot marked as -fresh.
    # These are the steps that must be done manually when setting up a new mac or creating a new VM and login for the first time.
    mkdir -pv ~/repos && cd ~/repos
    sudo apt install git -y
    git clone git@github.com:lvnfg/dotfiles
    cd ~/repos/dotfiles && bash setup.sh linkDotfiles   # Must be execute in directory
    source ~/.bashrc
    sudo vim /etc/ssh/sshd_config       # Disable password login. All this should be default on Azure VM Debian 10 Gen 1 image.
    "
        PubkeyAuthentication yes            # Default commented out. Important, will not be able to log back in if not enabled
        UsePAM yes                          # Default. May disable pubkey authen if set to no, keep yes for the moment
        PasswordAuthentication no           # Default
        PermitEmptyPasswords no             # Default 
        PermitRootLogin no                  # Not found in Azure Debian 10 Gen 1 image's sshd
        ChallengeResponseAuthentication no  # Default
    "
    sudo service sshd restart
}

function installDesktop() {
    # Skip this part if restoring from a snapshot marked as -fresh-desktop
    # Install a desktop environment and configure remote desktop access. https://docs.microsoft.com/en-us/azure/virtual-machines/linux/use-remote-desktop
    sudo apt install -y xfce4                                          # Install XFCE desktop environment
    sudo apt-get -y install xrdp                                       # Install Remote desktop server
    sudo systemctl enable xrdp                                         # Enable xrdp for use
    echo xfce4-session >~/.xsession                                    # Use XFCE for remote desktop session
    sudo passwd van                                                    # Create a password for the current user to login to xrdp
    sudo apt install firefox-esr                                       # Install firefox ESR (Extended Support Release)
    xfconf-query -c xfwm4 -p /general/use_compositing -t bool -s false # Disable compositing for rdp performance. Must be run in desktop env. True to activate again.
}

function restoreFromFresh() {
    # If restoring from a fresh snapshot:
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
    brew install bash                               # Must install homebrew first
    sudo echo "/usr/local/bin/bash" >> /etc/shells  # Add to list of available shells
    chsh -s /usr/local/bin/bash                     # Set new bash as default shell
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
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
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

function installPython() {
    # Install python
    version="3.9.5"
    dir="Python-$version"
    tarball="$dir.tar.xz"
    url="https://www.python.org/ftp/python/$version/$tarball"
    sudo apt update
    sudo apt install build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev
    curl -O $url
    #curl -O https://www.python.org/ftp/python/3.8.2/Python-3.8.2.tar.xz
    tar -xf $tarball
    rm $tarball
    cd $dir
    ./configure --enable-optimizations --enable-loadable-sqlite-extensions
    sudo make -j 4
    sudo make install    # will overwrite system's python3. To install side by side: sudo make altinstall
    cd ..
    sudo rm -rf $dir
}

# --------------------------------
# Actual setup scripts
# DO NOT INSTALL AZ CLI IN VM
# Infra should be managed in core
# --------------------------------
function linux() {
	sudo apt update 
	sudo apt upgrade -y
	sudo apt install -y python3-pip
	sudo apt install -y jq
	sudo apt install -y vim
	sudo apt install -y tmux
	sudo apt install -y fzf
	sudo apt install -y git
	sudo apt install -y wget
	sudo apt install -y unzip
	sudo apt install -y curl
	sudo apt install -y bash-completion
    linkDotfiles
    configureGit
}

function mac() {
    xcode-select --install
    linkDotfiles
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

function wsl() {
    # 1. Choose a vm size that supports nested virtualization (marked ***): https://docs.microsoft.com/en-us/azure/virtual-machines/acu
    # 2. Install WSL on windows: https://docs.microsoft.com/en-us/windows/wsl/install-win10
    # 3. Disable sudo password
        sudo visudo 
        "
            Add to END OF FILE: 
            [username] ALL=(ALL) NOPASSWD:ALL   # Aside from convenience, also used to start ssh on startup without sudo password prompt.
        "
    # 4. Enable SSH direcly into WSL with agent forwarding without going through Windows host first
        sudo apt update -y && sudo apt upgrade -y
        sudo apt install openssh-server
        sudo vim /etc/ssh/sshd_config 
        "
            Port 2222               # In case Windows host is listening to 22. Any other number is fine.
            #AddressFamily any
            ListenAddress 0.0.0.0
            #ListenAddress ::
            PubkeyAuthentication    yes
            PasswordAuthentication  no
            PermitEmptyPasswords    no
        "
        sudo service ssh --full-restart
        sudo service ssh start
        vim ~/.ssh/authorized_keys  # Add pubkey here
    # 5. Copy enable-ssh-to-wsl.ps1 and enable-ssh-to-wsl.cmd to C:\Users\van\Desktop\Apps\wsl and a task scheduler job with the following:
    '
        Name:             enable-ssh-to-wsl
        Trigger:          At system startup
        Security options: Run whether the user is logged on or not
        Action:           Start a program
        Program/script:   powershell
        Argument:         -File "C:\Users\van\OneDrive - Phuong Phat Group\Desktop\Apps\wsl\enable-ssh-to-wsl.ps1"
    '
    # 6. Install git and clone repos. At this point ssh agent forwarding should work.
        sudo apt install git
        git clone git@github.com:lvnfg/dotfiles
    # 7. Run setupVM()
    # 8. Any project requiring Windows should be cloned in host and symlink entire repo directory to repos.
        ln -s /mnt/c/Users/van/repos/ppg-bi-as-semantic/ $repos/ppg-bi-as-semantic
}

# Allow calling functions by name from command line
"$@"
