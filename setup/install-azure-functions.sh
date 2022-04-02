#!/bin/bash

# https://docs.microsoft.com/en-us/azure/azure-functions/functions-run-local?tabs=linux%2Ccsharp%2Cbash

# NOTE: require azure cli on Debian 10
# https://docs.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# Install the Microsoft package repository GPG key, to validate package integrity
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo mv microsoft.gpg /etc/apt/trusted.gpg.d/microsoft.gpg
# Set up the APT source list before doing an APT update
sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/debian/$(lsb_release -rs | cut -d'.' -f 1)/prod $(lsb_release -cs) main" > /etc/apt/sources.list.d/dotnetdev.list'
# Install the Core Tools package
sudo apt-get update
sudo apt-get install azure-functions-core-tools-3 -y
