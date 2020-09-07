#!/bin/bash

# Disable all ssh password login, including root
# sudo vim /etc/ssh/sshd_config
# change the following lines to no 
#   ChallengeResponseAuthentication no
#   PasswordAuthentication no
#   UsePAM no
#   PermitRootLogin no
# sudo systemctl restart ssh

# ssh-keygen -t ed25519 -C "van@$HOSTNAME"

hostType=vm
if [[ "$HOSTNAME" = DESKTOP ]] || [[ "$HOSTNAME" = origin ]]; then
	hostType=wsl	
[[ "$HOSTNAME" = DESKTOP ]]; then
    hostType=macbook
fi

if [[ $hostType = macbook ]]; then
    ln -s ~/dotfiles/.ssh/config		~/.ssh/config
    sudo chmod 600 ~/.ssh/config
else
    # Basic utilities
    # ----------------------------------------------------------------
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y openssh-client
    sudo apt install -y tmux
    sudo apt install -y fzf
    sudo apt install -y git
    sudo apt install -y wget
    sudo apt install -y unzip
    sudo apt install -y curl
    sudo apt install -y python3-pip

    # Dotfiles and environment setup
    # ----------------------------------------------------------------
    ssh-keyscan -H github.com >> ~/.ssh/known_hosts
    git clone git@github.com:lvnfg/dotfiles		~/dotfiles
    git config --global core.editor "vim"
    git config --global user.name "van"
    git config --global user.email "-"
    rm      	~/.bashrc
    ln -s ~/dotfiles/.bashrc		~/.bashrc
    ln -s ~/dotfiles/.inputrc		~/.inputrc
    ln -s ~/dotfiles/.tmux.conf		~/.tmux.conf
    ln -s ~/dotfiles/.vimrc			~/.vimrc

    if [[ $1 = nvim ]]; then
	    # Neovim
	    # ----------------------------------------------------------------
	    sudo apt install -y fuse
	    wget https://github.com/neovim/neovim/releases/download/nightly/nvim.appimage
	    chmod u+x nvim.appimage
	    sudo mv nvim.appimage /usr/bin/
	    sudo apt purge -y vim
	    sudo apt autoremove -y
	    echo Setting nvim as default and alternatives
	    nvimPath="/usr/bin/nvim.appimage"
	    set -u
	    sudo update-alternatives --install /usr/bin/ex		ex			"$nvimPath" 110
	    sudo update-alternatives --install /usr/bin/vi		vi			"$nvimPath" 110
	    sudo update-alternatives --install /usr/bin/view	view		"$nvimPath" 110
	    sudo update-alternatives --install /usr/bin/vim		vim			"$nvimPath" 110
	    sudo update-alternatives --install /usr/bin/vimdiff vim diff	"$nvimPath" 110
	    echo Installing plug.vim
	    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
		       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
	    echo Creating vim symlinks
	    mkdir -p	~/.config/nvim/lua
	    touch		~/.config/nvim/lua/init.lua
	    ln -s ~/dotfiles/.vimrc 		~/.config/nvim/
	    nvim.appimage --headless -c 'PlugInstall' +qall
	    echo Creating init.lua symlink
	    rm ~/.config/nvim/lua/init.lua
	    ln -s ~/dotfiles/init.lua		~/.config/nvim/lua/

	    # Language servers
	    # ----------------------------------------------------------------
	    if [[ $hostType = wsl ]]; then
		    # Skip
		    echo Language server setup skipped for $hostType
	    else
		    # Microsoft python language server
		    echo Installing .Net core SDK
		    url="https://packages.microsoft.com/config/debian/10/packages-microsoft-prod.deb"
		    fileName="dotnet.deb"
		    wget -O $fileName $url
		    sudo dpkg -i $fileName
		    sudo apt-get update
		    sudo apt-get install -y apt-transport-https
		    sudo apt-get update
		    sudo apt-get install -y dotnet-sdk-3.1
		    rm $fileName
		    echo Add python interpreter to nvim
		    nvim.appimage --headless -c 'LspInstall pyls_ms' +qall
		    pip3 install pynvim
	    fi
    fi
fi
echo 'Done. Remember to source .bashrc, exec bash -l, and gcloud init (if this is the first time run)'
