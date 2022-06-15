#!/bin/bash
set -euo pipefail
echo 🚸 $0

# Required package for pyodbc on Debian and Ubuntu
apt-get install unixodbc-dev -y

# Install pyodbc
pip3 install pyodbc

echo "✅ $0"
