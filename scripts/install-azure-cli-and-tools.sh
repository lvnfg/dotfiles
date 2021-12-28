#!/bin/bash

# Install Azure tools and services
bash "$path/install-netcore.sh"
sudo apt install azure-cli

# Debian 11 required this specific keyvault package from pip
# and cannot use the version included in the azure-cli apt
pip3 install azure-keyvault==1.1.0

bash "$path/install-azure-functions.sh"
