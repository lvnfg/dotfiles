#!/bin/bash

# NOT WORKING IN DEBIAN 11!

set -euo pipefail

# Install additional packages required for Debian
sudo su
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
exit
sudo apt-get update
sudo ACCEPT_EULA=Y apt-get install msodbcsql17 -y
sudo apt-get install unixodbc-dev   # required to install pyodbc on Debian and Ubuntu

# Install pyodbc
pip3 install pyodbc
