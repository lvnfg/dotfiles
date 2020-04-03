#!/bin/sh

# update ubuntu to the latest version
sudo apt update && sudo apt upgrade

# set vim as default editor
sudo update-alternatives --config editor

# setup git
git config --global credential.helper store
git pull # run this after config to save credential
git config --global user.name "van"
git config --global user.email van@fagaceae.com

# apply dotfiles settings
git clone https://github.com/lvnfg/dot
ln -s ~/dot/.vimrc ~/.vimrc

# install odbc driver
sudo su
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
#Ubuntu 19.10 package
curl https://packages.microsoft.com/config/ubuntu/19.10/prod.list > /etc/apt/sources.list.d/mssql-release.list;

exit
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql17

# setup python
sudo apt install python3-pip
sudo apt install unixodbc-dev
pip3 install --user pyodbc
