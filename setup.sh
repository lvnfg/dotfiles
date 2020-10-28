#!/bin/bash

# Arguments handling
task=( $1 $2 $3 $4 $5 $6 $7 $8 $9 )

# set -e		    # exit if error
# set -u		    # error on undeclared variable
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

function linkDotfiles() {
    mkdir -p ~/repos
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
    git clone git@github.com:lvnfg/dotfiles		~/repos/dotfiles
    git config --global core.editor     "vim"
    git config --global user.name       "van"
    git config --global user.email      "-"
    rm ~/.bashrc
    rm ~/.inputrc
    rm ~/.tmux.conf
    rm ~/.vimrc
    rm ~/.ssh/config
    ln -s ~/repos/dotfiles/.bashrc	    ~/.bashrc
    ln -s ~/repos/dotfiles/.inputrc	    ~/.inputrc
    ln -s ~/repos/dotfiles/.tmux.conf	~/.tmux.conf
    ln -s ~/repos/dotfiles/.vimrc	    ~/.vimrc
    ln -s ~/repos/dotfiles/.ssh/config	~/.ssh/config
    chmod 600 ~/.ssh/config
}

function installDocker() {
        sudo apt-get update
        sudo apt-get install -y \
            apt-transport-https \
            ca-certificates     \
            curl                \
            gnupg-agent         \
            software-properties-common
        sudo curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
        sudo apt-key fingerprint 0EBFCD88   # Verify key downloaded with correct fingerprint
        sudo add-apt-repository \
           "deb [arch=amd64] https://download.docker.com/linux/debian \
           $(lsb_release -cs) \
           stable"
        sudo apt-get update
        sudo apt-get install -y \
            docker-ce       \
            docker-ce-cli   \ 
            containerd.io   \
        # Use docker cli without sudo
        sudo groupadd docker
        sudo usermod -aG docker $USER
        sudo newgrp docker
        # Verify successful installation
        docker run hello-world         # Verify installation successful
}

function installDevTools() {
    sudo apt install -y python3-pip
	# Microsoft python language server
	echo Installing .Net core SDK
	url="https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb"
	fileName="dotnet.deb"
	wget -O $fileName $url
	dpkg -i $fileName
	sudo apt-get update
	sudo apt-get install -y apt-transport-https
	sudo apt-get update
	sudo apt-get install -y dotnet-sdk-3.1
	rm $fileName
	echo Add python interpreter to nvim
	nvim.appimage --headless -c 'LspInstall pyls_ms' +qall
	pip3 install pynvim
}

# --------------------------------
# Actual setup scripts
# --------------------------------
if [[ ${task[0]} =~ vm ]]; then
	sudo apt update 
	sudo apt upgrade -y
	sudo apt install -y \
	    tmux    \
	    fzf     \
	    git     \
	    wget    \
	    unzip   \
	    curl
    linkDotfiles
    echo 'Done. Remember to source .bashrc, exec bash -l, and gcloud init (if this is the first time run)'
fi
if [[ ${task[*]} =~ docker ]]; then
    installDocker
fi
