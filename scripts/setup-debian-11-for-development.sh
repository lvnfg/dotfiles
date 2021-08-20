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
sudo apt install -y ranger
sudo apt install -y bat

# Symlink dotfiles
ln -s -f $DOTFILES/.bashrc	    ~/.bashrc
ln -s -f $DOTFILES/.bashrc	    ~/.profile
ln -s -f $DOTFILES/.inputrc	    ~/.inputrc
ln -s -f $DOTFILES/.tmux.conf   ~/.tmux.conf
ln -s -f $DOTFILES/.vimrc	    ~/.vimrc

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

# Install python
# source "$path/install-python.sh"
# Install ipython
# To enable vim mode, create profile with
#   ipython profile create
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
# pip3 install ipython
# Install other pip packages
# pip3 install mssql-cli

# Install apps not available from apt or pip
# Use source to use the same bash process and share variables
# source "$path/install-git.sh"
# source "$path/install-fzf.sh"
# source "$path/install-bat.sh"       # Switch to using apt when available for Debian
# source "$path/install-nodejs.sh"
# source "$path/install-ranger.sh"
# source "$path/install-netcore.sh"
# source "$path/install-azure-cli.sh"
# source "$path/install-azure-functions.sh"


# Allow calling functions by name from command line
"$@"
