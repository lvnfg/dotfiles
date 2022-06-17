#!/bin/bash
set -euox pipefail

# Required package for pyodbc on Debian and Ubuntu
apt-get install unixodbc-dev -y
# Install pyodbc
pip3 install pyodbc
