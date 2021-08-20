#!/bin/bash

script_name=$0
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source .bashrc to get core directories' location
source ~/repos/dotfiles/.bashrc

# Install apps from packages managers
sudo apt update && sudo apt upgrade -y
sudo apt install -y jq
sudo apt install -y tmux
sudo apt install -y wget
sudo apt install -y unzip
sudo apt install -y curl
sudo apt install -y bash-completion
sudo apt install -y tree
sudo apt install -y fzf

# Symlink dotfiles
ln -s -f $DOTFILES/.bashrc	    ~/.bashrc
ln -s -f $DOTFILES/.bashrc	    ~/.profile
ln -s -f $DOTFILES/.inputrc	    ~/.inputrc
ln -s -f $DOTFILES/.tmux.conf   ~/.tmux.conf
ln -s -f $DOTFILES/.vimrc	    ~/.vimrc

# Install & setup git
source "$path/install-git.sh"

# Install neovim
source "$path/install-neovim.sh"

# Install ranger
sudo apt install ranger
# Symlink ranger config
mkdir ~/.config/ranger
ln -s -f $DOTFILES/rc.conf	    ~/.config/ranger/rc.conf
ln -s -f $DOTFILES/scope.sh	    ~/.config/ranger/scope.sh
# Make scope.sh executable for ranger
chmod +x $DOTFILES/scope.sh

# Install bat for syntax highlighting. Last version is 0.18.2 
# while Debian only has 0.12.1 even in testing. Switch to apt 
# later when available.
source "$path/install-bat.sh"

# Install python and dependent packages
source "$path/install-python.sh"
# IPython
pip3 install ipython
ipython profile create
# To enable vim mode, create profile with
# Then open ~/.ipython/profile_default/ipython_config.py and set
#   c.TerminalInteractiveShell.editing_mode = 'vi'  <-- Set to vi
# To enable case-insensitive tab completion in ipython shell,
# open IPython/core/completer.py:
# try:
#    import jedi
#    jedi.settings.case_insensitive_completion = True <-- Set to True
#    import jedi.api.helpers
#    import jedi.api.classes
#    JEDI_INSTALLED = True
# pip3 install mssql-cli

# Install apps not available from apt or pip
# Use source to use the same bash process and share variables
# source "$path/install-nodejs.sh"
# source "$path/install-netcore.sh"
# source "$path/install-azure-cli.sh"
# source "$path/install-azure-functions.sh"


# Allow calling functions by name from command line
"$@"
