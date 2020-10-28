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

# Basic utilities
# ----------------------------------------------------------------
if [[ ${task[*]} =~ utils ]] || [[ ${task[1]} =~ all ]]; then
    if [[ ${task[0]} =~ mac ]]; then
        echo Brew install here   
    elif [[ ${task[0]} =~ vm ]] || [[ ${task[0]} =~ container ]] ; then
        apt update && apt upgrade -y
        apt install -y openssh-client
        apt install -y tmux
        apt install -y fzf
        apt install -y git
        apt install -y wget
        apt install -y unzip
        apt install -y curl
    fi
fi

# Dotfiles and environment setup
# ----------------------------------------------------------------
if [[ ${task[*]} =~ dot ]] || [[ ${task[1]} =~ all ]]; then
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
fi

# Neovim
# ----------------------------------------------------------------
if [[ ${task[*]} =~ vim ]] || [[ ${task[1]} =~ all ]]; then
    mkdir -p ~/apps/nvim && cd ~/apps/nvim
    wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    chmod u+x nvim.appimage
    ./nvim.appimage --appimage-extract
    ln -s ~/apps/nvim/squashfs-root/usr/bin/nvim /usr/bin/nvim
    nvimPath="/usr/bin/nvim"
fi
if [[ ${task[*]} =~ vimold ]]; then
    apt install -y fuse
    mv nvim.appimage /usr/bin/
    echo Setting nvim as default and alternatives
    nvimPath="/usr/bin/nvim.appimage"
    set -u
    update-alternatives --install /usr/bin/ex		ex		    "$nvimPath" 110
    update-alternatives --install /usr/bin/vi		vi		    "$nvimPath" 110
    update-alternatives --install /usr/bin/view	    view	    "$nvimPath" 110
    update-alternatives --install /usr/bin/vim		vim		    "$nvimPath" 110
    update-alternatives --install /usr/bin/vimdiff 	vim diff	"$nvimPath" 110
    mkdir -p ~/.config/nvim/lua/
    rm ~/.config/nvim/init.vim 
    rm ~/.config/nvim/lua/init.lua
    ln -s ~/repos/dotfiles/init.vim 	~/.config/nvim/init.vim
    echo Installing plug.vim
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    nvim.appimage --headless -c 'PlugInstall' +qall
    ln -s ~/repos/dotfiles/init.lua	~/.config/nvim/lua/init.lua
fi

# Dev tools
# ----------------------------------------------------------------
if [[ ${task[1]} =~ devtools ]] || [[ ${task[1]} =~ all ]]; then
    if [[ ${task[0]} =~ container ]]; then
        apt install -y python3-pip
	    # Microsoft python language server
	    echo Installing .Net core SDK
	    url="https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb"
	    fileName="dotnet.deb"
	    wget -O $fileName $url
	    dpkg -i $fileName
	    apt-get update
	    apt-get install -y apt-transport-https
	    apt-get update
	    apt-get install -y dotnet-sdk-3.1
	    rm $fileName
	    echo Add python interpreter to nvim
	    nvim.appimage --headless -c 'LspInstall pyls_ms' +qall
	    pip3 install pynvim
    fi
fi

# Docker
# ----------------------------------------------------------------
if [[ ${task[*]} =~ docker ]] || [[ ${task[1]} =~ all ]]; then
    if [[ ${task[0]} =~ vm ]]; then
        apt-get update
        apt-get install \
            apt-transport-https \
            ca-certificates \
            curl \
            gnupg-agent \
            software-properties-common
        curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
        apt-key fingerprint 0EBFCD88   # Verify key downloaded with correct fingerprint
        add-apt-repository \
           "deb [arch=amd64] https://download.docker.com/linux/debian \
           $(lsb_release -cs) \
           stable"
        apt-get update
        apt-get install docker-ce docker-ce-cli containerd.io
        # Use docker cli without sudo
        groupadd docker
        usermod -aG docker $USER
        newgrp docker
        # Verify successful installation
        docker run hello-world         # Verify installation successful
    fi
fi

echo 'Done. Remember to source .bashrc, exec bash -l, and gcloud init (if this is the first time run)'
