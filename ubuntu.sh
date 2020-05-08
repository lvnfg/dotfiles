#!/bin/sh

# update ubuntu to the latest version
sudo apt update && sudo apt upgrade

# set vim as default editor
sudo update-alternatives --config editor

# setup git
git config --global credential.helper store
git config --global core.editor "vim"
git config --global user.name "van@vmDev"
git config --global user.email "-"
git clone https://github.com/lvnfg/dot

# apply dotfiles settings
ln -s ~/dot/.vimrc ~/.vimrc
rm ~/.bashrc
ln -s ~/dot/.bashrc ~/.bashrc

-------------------------------------------
# install vscode 
# TODO
# point vscode settings to do
# Remove VS Code setting files and snippets
rm ~/.config/Code/User/settings.json
rm ~/.config/Code/User/keybindings.json
rm -r ~/.config/Code/User/snippets
# Create symlinks to VS Code setting files in repos
ln -s ~/dot/code/settings.json ~/.config/Code/User/settings.json
ln -s ~/dot/code/keybindings.json ~/.config/Code/User/keybindings.json
ln -s ~/dot/code/snippets ~/.config/Code/User/snippets
# install vscode theme
