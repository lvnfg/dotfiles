#!/bin/bash

function setup-passwordless-auth-for-linux-vm() {
    sudo vim /etc/ssh/sshd_config       # Disable password login. All this should be default on Azure VM Debian 10 Gen 1 image.
    echo "
    To disable password authenticaion, run:
    sudo vim /etc/ssh/sshd_config           
    Then edit the following:
        PubkeyAuthentication yes            # Default commented out. Important, will not be able to log back in if not enabled
        UsePAM yes                          # Default. May disable pubkey authen if set to no, keep yes for the moment
        PasswordAuthentication no           # Default
        PermitEmptyPasswords no             # Default 
        PermitRootLogin no                  # Not found in Azure Debian 10 Gen 1 image's sshd
        ChallengeResponseAuthentication no  
    sudo service sshd restart
    All this should be default on Azure VM Debian 10 Gen 1 image.
    "
}

function setup-linux-vm() {
    # DO NOT INSTALL AZ CLI IN VM. Infra should be managed in core
	sudo apt update 
	sudo apt upgrade -y
	sudo apt install -y jq
	sudo apt install -y tmux
	sudo apt install -y git
	sudo apt install -y wget
	sudo apt install -y unzip
	sudo apt install -y curl
	sudo apt install -y bash-completion
	setup-dotfiles
	setup-git-configs
	setup-neovim
	# scripts with install or make must be run 
	# at end of to avoid messing with home repos
	setup-python
	setup-nodejs        # Required for coc.nvim
	setup-fzf
	setup-azure-cli
	setup-net-core
	setup-azure-function-core-tools
	setup-mssql-cli
}

function setup-neovim() {
    cd ~
    wget --no-check-certificate --content-disposition https://github.com/neovim/neovim/releases/download/stable/nvim.appimage
    chmod u+x nvim.appimage && ./nvim.appimage --appimage-extract
    rm nvim.appimage && rm -rf ~/neovim-nightly 
    mv squashfs-root ~/neovim-nightly
    # remove preinstalled neovim if any
    echo "removing neovim"
    sudo apt remove neovim
    sudo rm -f /usr/bin/nvim
    # Must use /usr/local/bin for macos compatibility
    echo "creating neovim symlink"
    sudo ln -s -f ~/neovim-nightly/usr/bin/nvim  /usr/local/bin/nvim
	# install vim-plug
	echo "installing vim plug"
	curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    # symlink nvim config
    echo "creating neovim config symlinks"
    wdir="$HOME/.config/nvim" && mkdir -pv $wdir
    ln -s -f $DOTFILES/init.vim $wdir/init.vim
    ln -s -f ~/repos/dotfiles/coc-settings.json ~/.config/nvim/coc-settings.json
}

function setup-dotfiles() {
    ln -s -f $DOTFILES/.bashrc	    ~/.bashrc
    ln -s -f $DOTFILES/.bashrc	    ~/.profile
    ln -s -f $DOTFILES/.inputrc	    ~/.inputrc
    ln -s -f $DOTFILES/.tmux.conf   ~/.tmux.conf
    ln -s -f $DOTFILES/.vimrc	    ~/.vimrc
}

function setup-nodejs() {
	curl -sL install-node.now.sh/lts | sudo bash
}

function setup-fzf() {
    rm -rf ~/.fzf
    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
    ~/.fzf/install
    sudo ln -s -f ~/.fzf/bin/fzf  /usr/local/bin/fzf
}

function setup-python() {
    # Install python
    version="3.9.5"
    echo "Installing Python $version"
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
    # Required to fix error when importing pandas after building Python from source
    sudo apt-get install -y lzma 
    sudo apt-get install -y liblzma-dev
    sudo configure
    # Build python
    sudo make -j 4
    sudo make install    # will overwrite system's python3. To install side by side: sudo make altinstall
    cd ..
    sudo rm -rf $dir
	sudo apt install -y python3-pip
}

function setup-linux-desktop-environment() {
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

function setup-git-configs() {
    git config --global core.editor     "vim"
    git config --global user.name       "van"
    git config --global user.email      "-"
    git config --global format.graph
    gitFormatFull="%C(auto)%h %d%Creset %s - %Cgreen%ad%Creset %aN <%aE>"
    gitFormatShort="%C(auto)%h %d%Creset %s>"
    gitFormatString="$gitFormatShort"
    git config --global format.pretty format:"$gitFormatString"
}

function setup-net-core() {
    wget https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    sudo apt-get update; \
        sudo apt-get install -y apt-transport-https && \
        sudo apt-get update && \
        sudo apt-get install -y dotnet-sdk-5.0
    rm packages-microsoft-prod.deb
}

function setup-azure-cli() {
    # Get packages needed for the install process
    sudo apt-get update
    sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg
    # Download and install the Microsoft signing key
    curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null
    # Add the Azure CLI software repository
    AZ_REPO=$(lsb_release -cs)
    echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
    # Update repository information and install the azure-cli package
    sudo apt-get update
    sudo apt-get install azure-cli -y
}

function setup-azure-function-core-tools() {
    # Installing az func core tools on Debian 10 will fail if az-cli is not installed
    setup-azure-cli
    # Install the Microsoft package repository GPG key, to validate package integrity
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
    sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
    # Set up the APT source list before doing an APT update
    sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/debian/$(lsb_release -rs | cut -d'.' -f 1)/prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'
    # Install the Core Tools package
    sudo apt-get update
    sudo apt-get install azure-functions-core-tools-3 -y
}

function setup-mssql-cli() {
    # The official doc is outdated and installing with apt doesn't work
    # https://docs.microsoft.com/en-us/sql/tools/mssql-cli?view=sql-server-ver15
    pip3 install mssql-cli
    sudo ln -s -f ~/.local/bin/mssql-cli  /usr/local/bin/mssql-cli
}

# Allow calling functions by name from command line
"$@"
