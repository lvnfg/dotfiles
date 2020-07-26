#!/bin/bash

# starting up
cd downloads
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"   # install homebrew
brew update && brew upgrade
ssh-keygen -t rsa -b 4096 -C "van@mac"    # generate a new key pair
open ~/.ssh/config      # check if file exists
touch  ~/.ssh/config    # create if not exists
# add the following to config to store the ssh key in os keychain:
#   Host *
#   AddKeysToAgent yes
#   UseKeychain yes
#   IdentityFile ~/.ssh/id_rsa
eval "$(ssh-agent -s)"      # start ssh-agent in background
ssh-add -K ~/.ssh/id_rsa    # add ssh key to agent

# git
brew install git
# TODO: install github cli
# TODO: copy ssh key to github
ssh -T git@github.com   # test ssh connection to git
git config --global core.editor "vim"
git config --global user.name "van"
git config --global user.email "-"
git clone git@github.com:lvnfg/dotfiles.git     ~/repos/dotfiles
rm ~/.bashrc && ln -s ~/repos/dotfiles/.bashrc ~/.bashrc && source .bashrc