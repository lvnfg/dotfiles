#!/bin/sh

# update ubuntu to the latest version
sudo apt update && sudo apt upgrade

# setup git
# brew install git
git config --global credential.helper store
git pull # run this after config to save credential
git config --global user.name "van"
git config --global user.email van@fagaceae.com
sudo apt install python3-pip

