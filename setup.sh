#!/bin/bash

# Arguments handling
task=( $1 $2 $3 $4 $5 $6 $7 $8 $9 )

# set -e		# exit if error
# set -u		# error on undeclared variable
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
if [[ ${task[0]} =~ mac ]]; then
    echo Brew install here   
elif [[ ${task[0]} =~ vm ]]; then
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y openssh-client
    sudo apt install -y tmux
    sudo apt install -y fzf
    sudo apt install -y git
    sudo apt install -y wget
    sudo apt install -y unzip
    sudo apt install -y curl
elif [[ ${task[0]} =~ dev ]]; then
    sudo apt install -y python3-pip
fi

# Dotfiles and environment setup
# ----------------------------------------------------------------
if [[ ${task[*]} =~ dot ]]; then
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
    git clone git@github.com:lvnfg/dotfiles		~/repos/dotfiles
    git config --global core.editor     "vim"
    git config --global user.name       "van"
    git config --global user.email      "-"
    rm  ~/.bashrc
    ln -s ~/repos/dotfiles/.bashrc		~/.bashrc
    ln -s ~/repos/dotfiles/.inputrc		~/.inputrc
    ln -s ~/repos/dotfiles/.tmux.conf	~/.tmux.conf
    ln -s ~/repos/dotfiles/.vimrc		~/.vimrc
    if [[ ${task[0]} =~ mac ]]; then
        ln -s ~/repos/dotfiles/.ssh/config		~/.ssh/config
        sudo chmod 600 ~/.ssh/config
    fi
fi

# Neovim
# ----------------------------------------------------------------
if [[ ${task[*]} =~ nvim ]]; then
    sudo apt install -y fuse
    wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
    chmod u+x nvim.appimage
    sudo mv nvim.appimage /usr/bin/
    echo Setting nvim as default and alternatives
    nvimPath="/usr/bin/nvim.appimage"
    set -u
    sudo update-alternatives --install /usr/bin/ex		    ex		    "$nvimPath" 110
    sudo update-alternatives --install /usr/bin/vi		    vi		    "$nvimPath" 110
    sudo update-alternatives --install /usr/bin/view	    view	    "$nvimPath" 110
    sudo update-alternatives --install /usr/bin/vim		    vim		    "$nvimPath" 110
    sudo update-alternatives --install /usr/bin/vimdiff 	vim diff	"$nvimPath" 110
    mkdir -p ~/.config/nvim/lua/
    ln -s ~/repos/dotfiles/init.vim 	~/.config/nvim/init.vim
    echo Installing plug.vim
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
	       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    nvim.appimage --headless -c 'PlugInstall' +qall
    ln -s ~/repos/dotfiles/init.lua		~/.config/nvim/lua/
fi

# Docker
# ----------------------------------------------------------------
if [[ ${task[*]} =~ docker ]]; then
    sudo apt-get update
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88   # Verify key downloaded with correct fingerprint
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/debian \
       $(lsb_release -cs) \
       stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io
    sudo docker run hello-world         # Verify installation successful
fi

echo 'Done. Remember to source .bashrc, exec bash -l, and gcloud init (if this is the first time run)'
