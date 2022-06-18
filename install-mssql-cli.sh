#!/bin/bash
set -euox pipefail
path="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

pip3 install mssql-cli
mkdir -pv $HOME/.config/mssqlcli
ln -s -f $path/mssqlcli/config   $HOME/.config/mssqlcli/config

# Fix cannot import collections.Iterables in python 3.10 +
pyver="$(python3 --version | grep 3.10)"
if [[ "$pyver" != "" ]]; then
    echo "Fixing collections import"
    ln -s -f $path/mssqlcli/collections__init__.py  /usr/local/lib/python3.10/collections/__init__.py
fi
